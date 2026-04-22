import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/cdss/',
  server: {
    proxy: {
      '/cdss-api': 'http://localhost:8000',
    },
  },
})
