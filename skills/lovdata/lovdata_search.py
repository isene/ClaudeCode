#!/usr/bin/env python3
"""
Lovdata Search - Download and search Norwegian law archives
"""

import asyncio
import sys
import re
import tarfile
import io
from pathlib import Path
from typing import Optional, List, Dict
import httpx
import json
from xml.etree import ElementTree as ET


class LovdataSearch:
    """Download and search Norwegian law archives"""

    def __init__(self, cache_dir: str = "./cache", api_key: Optional[str] = None):
        self.base_url = "https://api.lovdata.no"
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(exist_ok=True)
        self.headers = {}
        if api_key:
            self.headers["Authorization"] = f"Bearer {api_key}"
        self.timeout = 60.0

    async def download_archive(self, filename: str) -> Path:
        """Download archive and cache locally"""
        cache_file = self.cache_dir / filename

        if cache_file.exists():
            print(f"Using cached: {filename}")
            return cache_file

        print(f"Downloading: {filename}...")
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            response = await client.get(
                f"{self.base_url}/v1/publicData/get/{filename}",
                headers=self.headers
            )
            response.raise_for_status()

            cache_file.write_bytes(response.content)
            print(f"Cached to: {cache_file}")
            return cache_file

    def extract_text_from_xml(self, xml_content: str) -> str:
        """Extract readable text from XML law document"""
        try:
            root = ET.fromstring(xml_content)
            # Get all text content, stripping XML tags
            return ' '.join(root.itertext())
        except Exception:
            # Fallback to simple tag stripping
            return re.sub(r'<[^>]+>', ' ', xml_content)

    def search_in_archive(
        self,
        archive_path: Path,
        query: str,
        max_results: int = 10,
        case_sensitive: bool = False
    ) -> List[Dict]:
        """Search for query in tar.bz2 archive"""
        results = []
        flags = 0 if case_sensitive else re.IGNORECASE

        try:
            pattern = re.compile(query, flags)
        except re.error:
            # Treat as literal string if not valid regex
            pattern = re.compile(re.escape(query), flags)

        print(f"Searching in {archive_path.name}...")

        with tarfile.open(archive_path, 'r:bz2') as tar:
            for member in tar.getmembers():
                if not member.isfile():
                    continue

                if member.name.endswith('.xml'):
                    try:
                        file_obj = tar.extractfile(member)
                        if file_obj:
                            content = file_obj.read().decode('utf-8', errors='ignore')
                            text = self.extract_text_from_xml(content)

                            matches = list(pattern.finditer(text))
                            if matches:
                                # Get title from XML if possible
                                title = member.name
                                try:
                                    root = ET.fromstring(content)
                                    title_elem = root.find('.//{*}tittel') or root.find('.//tittel')
                                    if title_elem is not None and title_elem.text:
                                        title = title_elem.text
                                except Exception:
                                    pass

                                # Get context around first match
                                match = matches[0]
                                start = max(0, match.start() - 150)
                                end = min(len(text), match.end() + 150)
                                context = text[start:end].strip()

                                results.append({
                                    'title': title,
                                    'file': member.name,
                                    'archive': archive_path.name,
                                    'matches': len(matches),
                                    'context': context
                                })

                                if len(results) >= max_results:
                                    return results

                    except Exception as e:
                        print(f"Error processing {member.name}: {e}")
                        continue

        return results

    async def search(
        self,
        query: str,
        archives: Optional[List[str]] = None,
        max_results: int = 10,
        case_sensitive: bool = False
    ) -> List[Dict]:
        """Search for query across law archives"""

        # Default to current laws if no archives specified
        if not archives:
            archives = ["gjeldende-lover.tar.bz2"]

        all_results = []

        for archive_name in archives:
            archive_path = await self.download_archive(archive_name)
            results = self.search_in_archive(
                archive_path,
                query,
                max_results - len(all_results),
                case_sensitive
            )
            all_results.extend(results)

            if len(all_results) >= max_results:
                break

        return all_results


async def main():
    """CLI for searching Norwegian law"""

    if len(sys.argv) < 2:
        print("Usage: python lovdata_search.py <query> [max_results]")
        print("\nExamples:")
        print("  python lovdata_search.py personvern")
        print("  python lovdata_search.py 'straffeloven.*185' 20")
        print("  python lovdata_search.py arbeidsmiljø 5")
        sys.exit(1)

    query = sys.argv[1]
    max_results = int(sys.argv[2]) if len(sys.argv) > 2 else 10

    # Check for API key
    api_key = None
    env_file = Path.home() / ".claude" / ".env"
    if env_file.exists():
        for line in env_file.read_text().splitlines():
            if line.startswith("LOVDATA_API_KEY="):
                api_key = line.split("=", 1)[1].strip()

    searcher = LovdataSearch(api_key=api_key)

    print(f"\nSearching Norwegian law for: '{query}'")
    print(f"Max results: {max_results}\n")
    print("=" * 80)

    try:
        results = await searcher.search(query, max_results=max_results)

        if not results:
            print("\nNo results found.")
            return

        print(f"\nFound {len(results)} result(s):\n")

        for i, result in enumerate(results, 1):
            print(f"[{i}] {result['title']}")
            print(f"    File: {result['file']}")
            print(f"    Archive: {result['archive']}")
            print(f"    Matches: {result['matches']}")
            print(f"    Context: ...{result['context']}...")
            print("-" * 80)

        # Save results
        output_file = Path("lovdata_search_results.json")
        output_file.write_text(json.dumps(results, indent=2, ensure_ascii=False))
        print(f"\nResults saved to: {output_file.absolute()}")

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
