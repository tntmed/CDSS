export default function PatientSummary({ info }) {
  if (!info) return null

  return (
    <div style={{
      background: '#0f172a', border: '1px solid #1e293b',
      borderRadius: 12, padding: '20px 24px', marginBottom: 24,
    }}>
      {/* Header row */}
      <div style={{ display: 'flex', gap: 32, flexWrap: 'wrap', marginBottom: 20 }}>
        <InfoBox label="ชื่อ-นามสกุล" value={info.patient_name ?? '—'} wide />
        <InfoBox label="HN"     value={info.hn} />
        <InfoBox label="อายุ"   value={info.age != null ? `${info.age} ปี` : '—'} />
        <InfoBox label="เพศ"    value={info.gender ?? '—'} />
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 20 }}>
        {/* Diagnoses */}
        <Section title="วินิจฉัย (12 เดือนล่าสุด)" color="#38bdf8">
          {info.diagnoses.length === 0
            ? <EmptyRow />
            : info.diagnoses.map(d => (
                <Row key={d.icd_code}
                  left={<>
                    <span style={{ color: '#64748b', fontSize: 11, marginRight: 6 }}>{d.icd_code}</span>
                    <span style={{ fontWeight: 600 }}>{d.icd_name || d.icd_group}</span>
                  </>}
                  right={d.last_date}
                />
              ))
          }
        </Section>

        {/* Drugs */}
        <Section title="ยาที่ได้รับ (12 เดือนล่าสุด)" color="#f59e0b">
          {info.drugs.length === 0
            ? <EmptyRow />
            : info.drugs.map(d => (
                <Row key={d.drug_code}
                  left={<>
                    <span style={{ color: '#64748b', fontSize: 11, marginRight: 6 }}>{d.drug_code}</span>
                    <span style={{ fontWeight: 600 }}>{d.drug_name}</span>
                  </>}
                  right={d.last_date}
                />
              ))
          }
        </Section>
      </div>
    </div>
  )
}

function InfoBox({ label, value, wide }) {
  return (
    <div style={{ minWidth: wide ? 200 : 90 }}>
      <div style={{ fontSize: 11, color: '#64748b', marginBottom: 2 }}>{label}</div>
      <div style={{ fontSize: wide ? 18 : 15, fontWeight: 700, color: '#f1f5f9' }}>{value}</div>
    </div>
  )
}

function Section({ title, color, children }) {
  return (
    <div>
      <div style={{
        fontSize: 11, fontWeight: 700, letterSpacing: 1, textTransform: 'uppercase',
        color, marginBottom: 8, paddingBottom: 6, borderBottom: `1px solid #1e293b`,
      }}>
        {title}
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
        {children}
      </div>
    </div>
  )
}

function Row({ left, right }) {
  return (
    <div style={{
      display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      padding: '5px 0', borderBottom: '1px solid #1e293b22', fontSize: 13,
    }}>
      <div>{left}</div>
      <div style={{ color: '#64748b', fontSize: 12 }}>{right}</div>
    </div>
  )
}

function EmptyRow() {
  return <div style={{ color: '#475569', fontSize: 12, padding: '4px 0' }}>ไม่พบข้อมูล</div>
}
