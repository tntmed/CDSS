import { useState } from 'react'

export default function Login({ onLogin }) {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError]       = useState(null)
  const [loading, setLoading]   = useState(false)

  const submit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError(null)
    try {
      const res = await fetch('/cdss-api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password }),
      })
      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.detail || 'เข้าสู่ระบบไม่สำเร็จ')
      }
      sessionStorage.setItem('cdss_auth', '1')
      onLogin()
    } catch (e) {
      setError(e.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
    }}>
      <div style={{
        background: '#1e293b',
        borderRadius: 12,
        padding: '40px 36px',
        width: 340,
        boxShadow: '0 8px 32px rgba(0,0,0,0.5)',
      }}>
        <div style={{ textAlign: 'center', marginBottom: 28 }}>
          <div style={{ fontSize: 11, color: '#38bdf8', letterSpacing: 2, marginBottom: 6 }}>
            NEUROSURGERY · TK
          </div>
          <h1 style={{ fontSize: 22, fontWeight: 800, color: '#f1f5f9' }}>
            CDSS — Lab Monitoring
          </h1>
          <p style={{ color: '#64748b', marginTop: 6, fontSize: 13 }}>
            กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ
          </p>
        </div>

        <form onSubmit={submit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          <div>
            <label style={{ fontSize: 12, color: '#94a3b8', display: 'block', marginBottom: 6 }}>
              ชื่อผู้ใช้
            </label>
            <input
              value={username}
              onChange={e => setUsername(e.target.value)}
              placeholder="Username"
              autoComplete="username"
              style={{ width: '100%' }}
              required
            />
          </div>
          <div>
            <label style={{ fontSize: 12, color: '#94a3b8', display: 'block', marginBottom: 6 }}>
              รหัสผ่าน
            </label>
            <input
              type="password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              placeholder="Password"
              autoComplete="current-password"
              style={{ width: '100%' }}
              required
            />
          </div>

          {error && (
            <div style={{
              background: '#450a0a', color: '#fca5a5',
              borderRadius: 6, padding: '10px 14px', fontSize: 13,
            }}>
              {error}
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            style={{
              background: loading ? '#0369a1' : '#0ea5e9',
              color: '#fff',
              marginTop: 4,
              padding: '10px 0',
              fontSize: 15,
            }}
          >
            {loading ? 'กำลังตรวจสอบ…' : 'เข้าสู่ระบบ'}
          </button>
        </form>
      </div>
    </div>
  )
}
