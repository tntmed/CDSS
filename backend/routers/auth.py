from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter(prefix="/api", tags=["Auth"])

VALID_USER = "Tk"
VALID_PASS = "19"


class LoginRequest(BaseModel):
    username: str
    password: str


@router.post("/login")
async def login(body: LoginRequest):
    if body.username == VALID_USER and body.password == VALID_PASS:
        return {"ok": True}
    raise HTTPException(status_code=401, detail="ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง")
