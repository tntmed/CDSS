const STATUS_LABEL = {
  OVERDUE:    'เลยกำหนด',
  DUE_SOON:   'ใกล้ถึงกำหนด',
  OK:         'ปกติ',
  NEVER_DONE: 'ยังไม่เคยตรวจ',
}

function Badge({ status }) {
  return (
    <span className={`badge badge-${status.toLowerCase()}`}>
      {STATUS_LABEL[status] ?? status}
    </span>
  )
}

function groupBy(arr, key) {
  return arr.reduce((acc, item) => {
    const k = item[key]
    if (!acc[k]) acc[k] = []
    acc[k].push(item)
    return acc
  }, {})
}

function RuleTable({ rows }) {
  return (
    <table style={{ width: '100%', borderCollapse: 'collapse', marginBottom: 8 }}>
      <thead>
        <tr style={{ background: '#1e293b', color: '#94a3b8', fontSize: 12 }}>
          {['Lab', 'ตรวจล่าสุด', 'กำหนดตรวจ', 'ทุก (วัน)', 'สถานะ'].map(h => (
            <th key={h} style={{ padding: '8px 12px', textAlign: 'left' }}>{h}</th>
          ))}
        </tr>
      </thead>
      <tbody>
        {rows.map(r => (
          <tr key={r.rule_code} style={{
            borderBottom: '1px solid #1e293b',
            background: r.status === 'OVERDUE'   ? '#1c0a0a' :
                        r.status === 'DUE_SOON'  ? '#1c1400' : 'transparent',
          }}>
            <td style={{ padding: '10px 12px', fontWeight: 600 }}>
              {r.lab_name}
              <br /><span style={{ fontSize: 11, color: '#64748b' }}>{r.lab_code}</span>
            </td>
            <td style={{ padding: '10px 12px', color: '#94a3b8' }}>{r.last_done_date ?? '—'}</td>
            <td style={{ padding: '10px 12px', color: '#94a3b8' }}>{r.due_date ?? '—'}</td>
            <td style={{ padding: '10px 12px', color: '#94a3b8' }}>{r.check_every_days}</td>
            <td style={{ padding: '10px 12px' }}><Badge status={r.status} /></td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}

function SectionHeader({ label, type }) {
  const isDrug = type === 'DRUG'
  return (
    <div style={{
      fontWeight: 700, fontSize: 13, letterSpacing: 1, textTransform: 'uppercase',
      marginBottom: 8, marginTop: 4, display: 'flex', alignItems: 'center', gap: 8,
      color: isDrug ? '#f59e0b' : '#38bdf8',
    }}>
      <span style={{
        fontSize: 10, padding: '2px 7px', borderRadius: 4, fontWeight: 700,
        background: isDrug ? '#78350f' : '#0c4a6e', color: isDrug ? '#fcd34d' : '#7dd3fc',
      }}>
        {isDrug ? 'DRUG' : 'DX'}
      </span>
      {label}
    </div>
  )
}

export default function RecommendationTable({ data }) {
  if (!data) return null
  const { hn, patient_name, recommendations, total_overdue, total_due_soon } = data

  const diseaseRecs = recommendations.filter(r => r.trigger_type === 'DISEASE')
  const drugRecs    = recommendations.filter(r => r.trigger_type === 'DRUG')
  const byDisease   = groupBy(diseaseRecs, 'trigger_name')
  const byDrug      = groupBy(drugRecs,    'trigger_name')

  return (
    <div>
      {/* Patient header */}
      <div style={{
        background: '#1e293b', borderRadius: 10, padding: '16px 20px',
        marginBottom: 24, display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      }}>
        <div>
          <div style={{ fontSize: 12, color: '#94a3b8' }}>HN</div>
          <div style={{ fontSize: 22, fontWeight: 800 }}>{hn}</div>
          {patient_name && <div style={{ color: '#cbd5e1', marginTop: 2 }}>{patient_name}</div>}
        </div>
        <div style={{ display: 'flex', gap: 20 }}>
          <SummaryBadge count={total_overdue}  label="เลยกำหนด"  color="#ef4444" />
          <SummaryBadge count={total_due_soon} label="ใกล้กำหนด" color="#f59e0b" />
        </div>
      </div>

      {recommendations.length === 0 && (
        <div style={{ color: '#64748b', textAlign: 'center', padding: 40 }}>
          ไม่พบ rule ที่ตรงกับวินิจฉัยหรือยาของผู้ป่วยรายนี้
        </div>
      )}

      {/* Disease-based */}
      {Object.entries(byDisease).map(([disease, rows]) => (
        <div key={disease} style={{ marginBottom: 20 }}>
          <SectionHeader label={disease} type="DISEASE" />
          <RuleTable rows={rows} />
        </div>
      ))}

      {/* Drug-based */}
      {Object.entries(byDrug).map(([drug, rows]) => (
        <div key={drug} style={{ marginBottom: 20 }}>
          <SectionHeader label={drug} type="DRUG" />
          <RuleTable rows={rows} />
        </div>
      ))}
    </div>
  )
}

function SummaryBadge({ count, label, color }) {
  return (
    <div style={{ textAlign: 'center' }}>
      <div style={{ fontSize: 28, fontWeight: 800, color }}>{count}</div>
      <div style={{ fontSize: 11, color: '#64748b' }}>{label}</div>
    </div>
  )
}
