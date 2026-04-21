import httpx
import os
from dotenv import load_dotenv

load_dotenv()

_BASE = os.getenv("ORDS_BASE_URL", "https://wba.pmk.ac.th/ords/kasom").rstrip("/")

_client: httpx.AsyncClient | None = None


def get_client() -> httpx.AsyncClient:
    global _client
    if _client is None or _client.is_closed:
        _client = httpx.AsyncClient(base_url=_BASE, timeout=30.0, verify=False)
    return _client


async def close_client():
    if _client and not _client.is_closed:
        await _client.aclose()


async def ords_get(path: str) -> dict:
    r = await get_client().get(path)
    r.raise_for_status()
    return r.json()
