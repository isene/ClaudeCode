#!/usr/bin/env python3
"""
Claude Code Post-Tool Verification Hook
Ensures functionality is verified before claiming task completion
"""

import json
import sys
import subprocess
import os
from pathlib import Path

def check_project_type():
    """Detect project type to determine appropriate test commands"""
    cwd = Path.cwd()

    if (cwd / "package.json").exists():
        return "node"
    elif (cwd / "pyproject.toml").exists() or (cwd / "requirements.txt").exists():
        return "python"
    elif (cwd / "Cargo.toml").exists():
        return "rust"
    elif (cwd / "go.mod").exists():
        return "go"
    elif (cwd / "Makefile").exists():
        return "make"
    return "unknown"

def get_test_commands(project_type):
    """Get appropriate test commands for project type"""
    commands = {
        "node": ["npm test", "npm run test", "yarn test"],
        "python": ["python -m pytest", "pytest", "python -m unittest"],
        "rust": ["cargo test"],
        "go": ["go test ./..."],
        "make": ["make test"]
    }
    return commands.get(project_type, [])

def run_verification_checks():
    """Run project-appropriate verification checks"""
    project_type = check_project_type()
    test_commands = get_test_commands(project_type)

    verification_results = []

    # Try to run available test commands
    for cmd in test_commands:
        try:
            result = subprocess.run(
                cmd.split(),
                capture_output=True,
                text=True,
                timeout=300,
                cwd=Path.cwd()
            )
            if result.returncode == 0:
                verification_results.append({
                    "command": cmd,
                    "status": "passed",
                    "output": result.stdout[-500:]  # Last 500 chars
                })
                break  # One successful test run is enough
            else:
                verification_results.append({
                    "command": cmd,
                    "status": "failed",
                    "error": result.stderr[-500:]
                })
        except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError):
            continue

    return verification_results, project_type

def main():
    """Main hook execution"""
    try:
        # Read the tool event data from stdin
        input_data = sys.stdin.read()
        event_data = json.loads(input_data) if input_data.strip() else {}

        tool_name = event_data.get("tool_name", "")
        tool_result = event_data.get("tool_result", "")

        # Only verify after code-related tools
        code_tools = ["Edit", "MultiEdit", "Write", "NotebookEdit"]

        if tool_name not in code_tools:
            # For non-code tools, just pass through
            sys.exit(0)

        # Check if this looks like a completion claim
        completion_indicators = [
            "completed", "finished", "done", "working", "fixed",
            "implemented", "added", "updated", "created"
        ]

        tool_result_lower = str(tool_result).lower()
        if not any(indicator in tool_result_lower for indicator in completion_indicators):
            # Not claiming completion, proceed
            sys.exit(0)

        # Run verification checks
        verification_results, project_type = run_verification_checks()

        # Determine if verification passed
        verification_passed = any(
            result["status"] == "passed" for result in verification_results
        )

        # Generate response
        response = {
            "decision": "approve" if verification_passed else "reject",
            "message": "",
            "metadata": {
                "project_type": project_type,
                "verification_results": verification_results
            }
        }

        if verification_passed:
            response["message"] = "✅ Verification passed - changes work correctly"
        else:
            failed_commands = [r["command"] for r in verification_results if r["status"] == "failed"]
            response["message"] = (
                f"❌ Verification failed. Please fix issues and re-test.\n"
                f"Failed commands: {', '.join(failed_commands) if failed_commands else 'No test commands found'}\n"
                f"Remember: NEVER claim completion without successful verification."
            )

        print(json.dumps(response, indent=2))
        sys.exit(0)

    except Exception as e:
        # On any error, reject with explanation
        error_response = {
            "decision": "reject",
            "message": f"❌ Verification hook error: {str(e)}\nPlease manually verify your changes work before claiming completion.",
            "metadata": {"error": str(e)}
        }
        print(json.dumps(error_response, indent=2))
        sys.exit(1)

if __name__ == "__main__":
    main()