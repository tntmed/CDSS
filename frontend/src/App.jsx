import { useState } from 'react'
import PatientSearch from './components/PatientSearch'
import PatientSummary from './components/PatientSummary'
import RecommendationTable from './components/RecommendationTable'

export default function App() {
  const [loading, setLoading]         = useState(false)
  const [data, setData]               = useState(null)
  const [patientInfo, setPatientInfo] = useState(null)
  const [error, setError]             = useState(null)

  const handleSearch = async (hn) => {
    const parts = hn.trim().split('/')
    if (parts.length !== 2 || !parts[0] || !parts[1]) {
      setError('กรุณากรอก HN ในรูปแบบ run/year เช่น 7334/51')
      return
    }
    const [run, year] = parts
    setLoading(true)
    setError(null)
    setData(null)
    setPatientInfo(null)
    try {
      const [recRes, infoRes] = await Promise.all([
        fetch(`/cdss-api/patients/${run}/${year}/recommendations`),
        fetch(`/cdss-api/patients/${run}/${year}/info`).catch(() => null),
      ])
      if (!recRes.ok) {
        const body = await recRes.json().catch(() => ({}))
        throw new Error(body.detail || `HTTP ${recRes.status}`)
      }
      setData(await recRes.json())
      if (infoRes && infoRes.ok) {
        setPatientInfo(await infoRes.json().catch(() => null))
      }
    } catch (e) {
      setError(e.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ maxWidth: 960, margin: '0 auto', padding: '32px 16px' }}>
      <div style={{ marginBottom: 28 }}>
        <div style={{ fontSize: 11, color: '#38bdf8', letterSpacing: 2, marginBottom: 4 }}>
          NEUROSURGERY · TK
        </div>
        <h1 style={{ fontSize: 24, fontWeight: 800, color: '#f1f5f9' }}>
          CDSS — Lab Monitoring
        </h1>
        <p style={{ color: '#64748b', marginTop: 4, fontSize: 13 }}>
          ระบบแนะนำการเจาะเลือด ตามวินิจฉัยและยาของผู้ป่วย
        </p>
      </div>

      <PatientSearch onSearch={handleSearch} loading={loading} />

      <div style={{ marginTop: 32 }}>
        {loading && (
          <div style={{ color: '#64748b', textAlign: 'center', padding: 40 }}>
            กำลังวิเคราะห์…
          </div>
        )}
        {error && (
          <div style={{
            background: '#450a0a', color: '#fca5a5',
            borderRadius: 8, padding: 16,
          }}>
            เกิดข้อผิดพลาด: {error}
          </div>
        )}
        <PatientSummary info={patientInfo} />
        <RecommendationTable data={data} />
      </div>
    </div>
  )
}
