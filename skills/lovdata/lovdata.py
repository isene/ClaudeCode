#!/usr/bin/env python3
"""
Lovdata API Client - Query Norwegian law texts
"""

import asyncio
import sys
from typing import Optional
import httpx
import json
from pathlib import Path


class LovdataClient:
    """Client for accessing Norwegian law via Lovdata API"""

    def __init__(self, api_key: Optional[str] = None):
        self.base_url = "https://api.lovdata.no"
        self.headers = {}
        if api_key:
            self.headers["Authorization"] = f"Bearer {api_key}"
        self.timeout = 30.0

    async def list_archives(self) -> list:
        """List available law archive files"""
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            response = await client.get(
                f"{self.base_url}/v1/publicData/list",
                headers=self.headers
            )
            response.raise_for_status()
            return response.json()

    async def download_archive(self, filename: str) -> bytes:
        """Download a law archive file"""
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            response = await client.get(
                f"{self.base_url}/v1/publicData/get/{filename}",
                headers=self.headers
            )
            response.raise_for_status()
            return response.content

    async def search_local(self, query: str, archives: list = None) -> list:
        """
        Search downloaded archives locally
        Note: This requires downloading and parsing archives first
        """
        raise NotImplementedError("Local search requires archive download/parsing")


async def main():
    """CLI interface for listing Norwegian law archives"""

    if len(sys.argv) > 1 and sys.argv[1] == "list":
        # Check for API key in environment
        api_key = None
        env_file = Path.home() / ".claude" / ".env"
        if env_file.exists():
            for line in env_file.read_text().splitlines():
                if line.startswith("LOVDATA_API_KEY="):
                    api_key = line.split("=", 1)[1].strip()

        client = LovdataClient(api_key=api_key)

        print("Fetching available law archives from Lovdata...\n")

        try:
            archives = await client.list_archives()

            if not archives:
                print("No archives found.")
                return

            print(f"Found {len(archives)} archive(s):\n")
            print("=" * 80)

            for i, archive in enumerate(archives, 1):
                if isinstance(archive, str):
                    print(f"[{i}] {archive}")
                else:
                    print(f"[{i}] {json.dumps(archive, ensure_ascii=False)}")
                print("-" * 80)

            # Save full results to JSON
            output_file = Path("lovdata_archives.json")
            output_file.write_text(json.dumps(archives, indent=2, ensure_ascii=False))
            print(f"\nFull list saved to: {output_file.absolute()}")

        except httpx.HTTPError as e:
            print(f"Error: HTTP request failed - {e}")
            sys.exit(1)
        except Exception as e:
            print(f"Error: {e}")
            sys.exit(1)
    else:
        print("Usage: python lovdata.py list")
        print("\nLists all available Norwegian law archives from Lovdata API")
        print("\nNote: Full search functionality requires downloading/parsing archives")
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
