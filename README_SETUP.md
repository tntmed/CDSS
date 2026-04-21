# CDSS — Neuro Lab Monitoring

## Architecture

```
React (Vite :5173)
  └─ /api/*  →  proxy  →  FastAPI (:8000)
                              └─ oracledb (thin)
                                    ├─ KASOM schema   (CDSS_* tables)
                                    └─ @pmk DB link   (HIS tables)
```

## HIS Tables Used

| Table | ใช้ทำอะไร |
|---|---|
| `opddiags@pmk` | ICD codes ของ patient |
| `OPD_FINANCE_HEADERS@pmk` | แปลง HN → opd_finance_no |
| `labresult@pmk` | ผล lab + วันที่ |
| `patient@pmk` | ชื่อ patient (optional) |

**HN format**: `pat_run_hn/pat_year_hn`  เช่น `12345/67`

## Quick Start

### 1. Backend

```bash
cd backend
copy .env.example .env
# แก้ .env: DB_PASSWORD, DB_DSN

pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

### 2. Frontend

```bash
cd frontend
npm install
npm run dev
# เปิด http://localhost:5173
```

## API Endpoints

| Method | Path | ผลลัพธ์ |
|---|---|---|
| GET | `/api/patients/{hn}/recommendations` | Lab recommendations ของ patient |
| GET | `/api/rules` | ทุก rules ใน CDSS_RULE_LAB |
| GET | `/api/labs` | ทุก labs ใน CDSS_LAB_MASTER |
| GET | `/health` | health check |

## Status Logic

| Status | ความหมาย |
|---|---|
| `OVERDUE` | เลยกำหนดแล้ว (`today > last_date + check_every_days`) |
| `DUE_SOON` | ถึงกำหนดใน 30 วัน |
| `OK` | ยังไม่ถึงกำหนด |
| `NEVER_DONE` | ไม่เคยมีผลใน 3 ปีที่ผ่านมา |
