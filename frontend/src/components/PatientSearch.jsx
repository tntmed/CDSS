import { useState } from 'react'

export default function PatientSearch({ onSearch, loading }) {
  const [hn, setHn] = useState('')

  const submit = (e) => {
    e.preventDefault()
    if (hn.trim()) onSearch(hn.trim())
  }

  return (
    <form onSubmit={submit} style={{ display: 'flex', gap: 10 }}>
      <input
        value={hn}
        onChange={e => setHn(e.target.value)}
        placeholder="HN เช่น 0012345"
        style={{ width: 200 }}
      />
      <button
        type="submit"
        disabled={loading}
        style={{ background: '#0ea5e9', color: '#fff' }}
      >
        {loading ? 'กำลังโหลด…' : 'ค้นหา'}
      </button>
    </form>
  )
}
