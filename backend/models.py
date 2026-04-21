from pydantic import BaseModel
from datetime import date
from typing import Optional


class LabRecommendation(BaseModel):
    rule_code: str
    rule_name: str
    trigger_type: str        # "DISEASE" | "DRUG"
    trigger_name: str        # e.g. "Dyslipidemia" | "Carbamazepine"
    lab_code: str
    lab_name: str
    check_every_days: int
    last_done_date: Optional[date]
    due_date: Optional[date]
    days_overdue: int
    status: str              # "OVERDUE" | "DUE_SOON" | "OK" | "NEVER_DONE"


class PatientRecommendationResponse(BaseModel):
    hn: str
    patient_name: Optional[str]
    recommendations: list[LabRecommendation]
    total_overdue: int
    total_due_soon: int


class RuleSummary(BaseModel):
    rule_code: str
    rule_name: str
    disease_group_code: str
    lab_code: str
    lab_name: str
    check_every_days: int
    is_active: str
