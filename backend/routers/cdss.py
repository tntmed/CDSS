from fastapi import APIRouter, HTTPException
from models import PatientRecommendationResponse, PatientInfoResponse
from services.decision_engine import get_recommendations, get_patient_name, get_patient_info, parse_hn
from ords_client import ords_get

router = APIRouter(prefix="/api", tags=["CDSS"])


@router.get("/patients/{run}/{year}/recommendations", response_model=PatientRecommendationResponse)
async def patient_recommendations(run: str, year: str):
    hn = f"{run}/{year}"
    try:
        parse_hn(hn)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    recs         = await get_recommendations(hn)
    patient_name = await get_patient_name(hn)

    return PatientRecommendationResponse(
        hn=hn,
        patient_name=patient_name,
        recommendations=recs,
        total_overdue=sum(1 for r in recs if r.status == "OVERDUE"),
        total_due_soon=sum(1 for r in recs if r.status == "DUE_SOON"),
    )


@router.get("/patients/{run}/{year}/info", response_model=PatientInfoResponse)
async def patient_info(run: str, year: str):
    hn = f"{run}/{year}"
    try:
        parse_hn(hn)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    try:
        return await get_patient_info(hn)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/rules")
async def list_rules():
    return await ords_get("/cdss/rules")


@router.get("/labs")
async def list_labs():
    return await ords_get("/cdss/labs_master")
