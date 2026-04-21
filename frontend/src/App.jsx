import { useState } from 'react'
import PatientSearch from './components/PatientSearch'
import RecommendationTable from './components/RecommendationTable'

export default function App() {
  const [loading, setLoading] = useState(false)
  const [data, setData]       = useState(null)
  const [error, setError]     = useState(null)

  const handleSearch = async (hn) => {
    // hn = "7334/51"  →  run=7334, year=51
    const parts = hn.trim().split('/')
    if (parts.length !== 2 || !parts[0] || !parts[1]) {
      setError('กรุณากรอก HN ในรูปแบบ run/year เช่น 7334/51')
      return
    }
    const [run, year] = parts
    setLoading(true)
    setError(null)
    setData(null)
    try {
      const res = await fetch(`/api/patients/${run}/${year}/recommendations`)
      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.detail || `HTTP ${res.status}`)
      }
      setData(await res.json())
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
        <RecommendationTable data={data} />
      </div>
    </div>
  )
}
