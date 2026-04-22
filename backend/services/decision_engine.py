"""
Decision Engine — disease-based + drug-based (AED) lab monitoring
"""
import re
from datetime import date, timedelta
from ords_client import ords_get
from models import LabRecommendation, DiagnosisItem, DrugItem, PatientInfoResponse

_HN_RE = re.compile(r'^(\d+)/(\d+)$')


def parse_hn(hn: str) -> tuple[str, str]:
    m = _HN_RE.match(hn.strip())
    if not m:
        raise ValueError(f"HN ต้องอยู่ในรูป run/year เช่น 7334/51  (ได้รับ: {hn!r})")
    return m.group(1), m.group(2)


def _calc_status(last_done: date | None, every_days: int) -> tuple[date | None, int, str]:
    today = date.today()
    if last_done:
        due   = last_done + timedelta(days=every_days)
        overdue = (today - due).days
        status = ("OVERDUE"  if overdue > 0  else
                  "DUE_SOON" if overdue >= -30 else "OK")
        return due, overdue, status
    return None, every_days, "NEVER_DONE"


async def _last_labs(run: str, year: str) -> dict[str, date]:
    data = await ords_get(f"/cdss/labs/{run}/{year}")
    result: dict[str, date] = {}
    for item in data.get("labs", []):
        if item.get("last_date"):
            result[item["lab_code"]] = date.fromisoformat(item["last_date"])
    return result


async def get_recommendations(hn: str) -> list[LabRecommendation]:
    run, year = parse_hn(hn)

    # ── fetch in parallel concept (sequential here, fast enough via ORDS) ──
    dx_data   = await ords_get(f"/cdss/dx/{run}/{year}")
    drug_data = await ords_get(f"/cdss/drugs/{run}/{year}")
    rules_all = (await ords_get("/cdss/rules")).get("items", [])
    last_labs = await _last_labs(run, year)

    dx_groups   = set(dx_data.get("dx_groups", []))
    drug_groups = set(drug_data.get("drug_groups", []))

    seen: set[str] = set()
    recommendations: list[LabRecommendation] = []

    for r in rules_all:
        scope      = r.get("rule_scope", "DISEASE_ONLY")
        dx_group   = r.get("disease_group_code", "-")
        drug_group = r.get("drug_group_code", "-")

        # check if rule applies to this patient
        if scope == "DISEASE_ONLY" and dx_group not in dx_groups:
            continue
        if scope == "DRUG_ONLY" and drug_group not in drug_groups:
            continue
        if scope == "BOTH" and dx_group not in dx_groups and drug_group not in drug_groups:
            continue

        rule_code = r["rule_code"]
        if rule_code in seen:
            continue
        seen.add(rule_code)

        # trigger label for UI grouping
        if scope == "DRUG_ONLY":
            trigger_type = "DRUG"
            trigger_name = drug_group
        else:
            trigger_type = "DISEASE"
            trigger_name = dx_group

        lab_code   = r["lab_code"]
        every_days = int(r["check_every_days"])
        last_done  = last_labs.get(lab_code)
        due_date, days_overdue, status = _calc_status(last_done, every_days)

        recommendations.append(LabRecommendation(
            rule_code=rule_code,
            rule_name=r["rule_name"],
            trigger_type=trigger_type,
            trigger_name=trigger_name,
            lab_code=lab_code,
            lab_name=r["lab_name"],
            check_every_days=every_days,
            last_done_date=last_done,
            due_date=due_date,
            days_overdue=days_overdue,
            status=status,
        ))

    return recommendations


async def get_patient_name(hn: str) -> str | None:
    try:
        run, year = parse_hn(hn)
        data = await ords_get(f"/cdss/patient/{run}/{year}")
        return data.get("patient_name") or None
    except Exception:
        return None


async def get_patient_info(hn: str) -> PatientInfoResponse:
    run, year = parse_hn(hn)
    data = await ords_get(f"/cdss/patient_info/{run}/{year}")
    return PatientInfoResponse(
        hn=hn,
        patient_name=data.get("patient_name"),
        age=data.get("age"),
        gender=data.get("gender"),
        diagnoses=[
            DiagnosisItem(
                icd_code=d["icd_code"],
                icd_group=d.get("icd_group", d["icd_code"]),
                icd_name=d.get("icd_name"),
                last_date=d.get("last_date"),
            )
            for d in data.get("diagnoses", [])
        ],
        drugs=[
            DrugItem(
                drug_code=d["drug_code"],
                drug_name=d.get("drug_name", d["drug_code"]),
                last_date=d.get("last_date"),
            )
            for d in data.get("drugs", [])
        ],
    )
