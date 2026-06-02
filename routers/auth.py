# =============================================================================
# routers/auth.py  —  Login / Logout
# =============================================================================

from fastapi import APIRouter, Request, Form, Depends
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from database import get_db, fetch_one

router = APIRouter()
templates = Jinja2Templates(directory="templates")


@router.get("/login", response_class=HTMLResponse)
async def login_page(request: Request):
    return templates.TemplateResponse("login.html", {
        "request": request, "error": None
    })


@router.post("/login")
async def login(request: Request,
                username: str = Form(...),
                password: str = Form(...),
                db: Session = Depends(get_db)):

    user = fetch_one(db,
        "SELECT user_id, password, administrator "
        "FROM user_master "
        "WHERE user_id = :u AND password = :p",
        {"u": username, "p": password}
    )

    if not user:
        return templates.TemplateResponse("login.html", {
            "request": request,
            "error": "Invalid username or password."
        })

    request.session["user"]     = user["user_id"]
    request.session["user_id"]  = user["user_id"]
    request.session["is_admin"] = user["administrator"]

    return RedirectResponse(url="/view", status_code=302)


@router.get("/logout")
async def logout(request: Request):
    request.session.clear()
    return RedirectResponse(url="/login", status_code=302)