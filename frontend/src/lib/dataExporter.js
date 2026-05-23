/**
 * Convierte el dump de datos del usuario (devuelto por /users/me/export) en
 * descargas JSON / Excel / PDF. Las librerías pesadas (xlsx, jspdf) se cargan
 * dinámicamente solo cuando se usan, para no hinchar el bundle principal.
 */

const today = () => new Date().toISOString().slice(0, 10)
const fileBase = () => `zenfit-export-${today()}`

const triggerDownload = (blob, filename) => {
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = filename
  document.body.appendChild(a)
  a.click()
  a.remove()
  URL.revokeObjectURL(url)
}

// ---------- JSON ----------

export const downloadJson = (data) => {
  const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' })
  triggerDownload(blob, `${fileBase()}.json`)
}

// ---------- Excel (.xlsx, una hoja por sección) ----------

export const downloadExcel = async (data) => {
  const XLSX = await import('xlsx')

  const wb = XLSX.utils.book_new()

  // --- Mi cuenta ---
  const user = data.user || {}
  const profile = data.wellnessProfile || {}
  const accountRows = [
    ['Campo', 'Valor'],
    ['Nombre', user.fullName || ''],
    ['Email', user.email || ''],
    ['Plan', user.plan || ''],
    ['Email verificado', user.emailVerified ? 'Sí' : 'No'],
    ['Cuenta creada', user.createdAt || ''],
    [],
    ['Perfil de bienestar', ''],
    ['Fecha nacimiento', profile.dateOfBirth || ''],
    ['Género', profile.gender || ''],
    ['Altura (cm)', profile.heightCm ?? ''],
    ['Peso (kg)', profile.weightKg ?? ''],
    ['Objetivo fitness', profile.fitnessGoal || ''],
    ['Nivel de actividad', profile.activityLevel || ''],
    ['Notas médicas', profile.medicalNotes || ''],
    [],
    ['Exportado', data.exportedAt || new Date().toISOString()],
  ]
  XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(accountRows), 'Mi cuenta')

  // --- Hábitos ---
  const habits = (data.habits || []).map((h) => ({
    Nombre: h.name,
    Descripción: h.description || '',
    Frecuencia: h.frequency,
    Objetivo: h.targetPerPeriod ?? '',
    Color: h.color || '',
    Icono: h.icon || '',
    Activo: h.active ? 'Sí' : 'No',
    Creado: h.createdAt || '',
  }))
  XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(habits), 'Hábitos')

  // --- Registros de sueño ---
  const sleep = (data.sleepLogs || []).map((s) => ({
    Fecha: s.sleepDate,
    'Horas dormidas': s.durationMinutes != null ? (s.durationMinutes / 60).toFixed(2) : '',
    Calidad: s.quality ?? '',
    Notas: s.notes || '',
  }))
  XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(sleep), 'Sueño')

  // --- Sesiones de entrenamiento ---
  const sessions = (data.workoutSessions || []).map((w) => ({
    Rutina: w.workoutName,
    Inicio: w.startedAt || '',
    Final: w.completedAt || '',
    'Duración (min)': w.durationSeconds != null ? Math.round(w.durationSeconds / 60) : '',
    'Calorías quemadas': w.caloriesBurned ?? '',
    'Esfuerzo percibido': w.perceivedEffort ?? '',
    Notas: w.notes || '',
  }))
  XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(sessions), 'Entrenamientos')

  // --- Dietas personalizadas (resumen + items) ---
  const dietRows = []
  for (const d of (data.customDiets || [])) {
    dietRows.push({
      Dieta: d.name,
      Descripción: d.description || '',
      'Total kcal': d.totalKcal,
      Alimento: '',
      'Gramos': '',
      'Kcal item': '',
    })
    for (const i of (d.items || [])) {
      dietRows.push({
        Dieta: '',
        Descripción: '',
        'Total kcal': '',
        Alimento: i.foodName || '',
        'Gramos': i.grams,
        'Kcal item': i.kcal,
      })
    }
    dietRows.push({})
  }
  XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(dietRows), 'Mis dietas')

  XLSX.writeFile(wb, `${fileBase()}.xlsx`)
}

// ---------- PDF (informe formateado) ----------

export const downloadPdf = async (data) => {
  const { jsPDF } = await import('jspdf')
  const autoTableMod = await import('jspdf-autotable')
  const autoTable = autoTableMod.default || autoTableMod.autoTable

  const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' })
  const margin = 14
  let y = margin

  // Portada / encabezado
  doc.setFillColor(30, 58, 138) // azul marca
  doc.rect(0, 0, 210, 32, 'F')
  doc.setTextColor(255, 255, 255)
  doc.setFontSize(22)
  doc.setFont('helvetica', 'bold')
  doc.text('ZenFit · Tus datos', margin, 14)
  doc.setFontSize(10)
  doc.setFont('helvetica', 'normal')
  doc.text(`Exportado: ${data.exportedAt || new Date().toISOString()}`, margin, 22)
  doc.text(`Usuario: ${data.user?.fullName || ''} (${data.user?.email || ''})`, margin, 28)

  y = 42
  doc.setTextColor(17, 24, 39) // texto oscuro

  const section = (title) => {
    if (y > 270) { doc.addPage(); y = margin }
    doc.setFillColor(242, 230, 56) // amarillo marca
    doc.setTextColor(30, 58, 138)
    doc.rect(margin, y - 5, 182, 8, 'F')
    doc.setFontSize(12)
    doc.setFont('helvetica', 'bold')
    doc.text(title, margin + 3, y)
    y += 6
    doc.setTextColor(17, 24, 39)
    doc.setFont('helvetica', 'normal')
  }

  // ----- Perfil -----
  section('Perfil de bienestar')
  const p = data.wellnessProfile || {}
  autoTable(doc, {
    startY: y,
    margin: { left: margin, right: margin },
    head: [['Campo', 'Valor']],
    body: [
      ['Fecha nacimiento', p.dateOfBirth || '—'],
      ['Género', p.gender || '—'],
      ['Altura', p.heightCm ? `${p.heightCm} cm` : '—'],
      ['Peso', p.weightKg ? `${p.weightKg} kg` : '—'],
      ['Objetivo fitness', p.fitnessGoal || '—'],
      ['Nivel de actividad', p.activityLevel || '—'],
      ['Notas médicas', p.medicalNotes || '—'],
    ],
    headStyles: { fillColor: [30, 58, 138], textColor: 255 },
    styles: { fontSize: 9 },
  })
  y = doc.lastAutoTable.finalY + 10

  // ----- Hábitos -----
  if (y > 250) { doc.addPage(); y = margin }
  section(`Hábitos (${(data.habits || []).length})`)
  if (data.habits?.length) {
    autoTable(doc, {
      startY: y,
      margin: { left: margin, right: margin },
      head: [['Nombre', 'Frecuencia', 'Objetivo', 'Activo']],
      body: data.habits.map((h) => [
        h.name,
        h.frequency || '',
        h.targetPerPeriod ?? '',
        h.active ? 'Sí' : 'No',
      ]),
      headStyles: { fillColor: [30, 58, 138], textColor: 255 },
      styles: { fontSize: 9 },
    })
    y = doc.lastAutoTable.finalY + 10
  } else {
    doc.setFontSize(9); doc.text('Sin hábitos registrados.', margin, y); y += 8
  }

  // ----- Sueño -----
  if (y > 250) { doc.addPage(); y = margin }
  section(`Registros de sueño (${(data.sleepLogs || []).length})`)
  if (data.sleepLogs?.length) {
    autoTable(doc, {
      startY: y,
      margin: { left: margin, right: margin },
      head: [['Fecha', 'Horas', 'Calidad', 'Notas']],
      body: data.sleepLogs.map((s) => [
        s.sleepDate,
        s.durationMinutes != null ? (s.durationMinutes / 60).toFixed(1) + ' h' : '—',
        s.quality ?? '—',
        s.notes || '',
      ]),
      headStyles: { fillColor: [30, 58, 138], textColor: 255 },
      styles: { fontSize: 9 },
    })
    y = doc.lastAutoTable.finalY + 10
  } else {
    doc.setFontSize(9); doc.text('Sin registros de sueño.', margin, y); y += 8
  }

  // ----- Entrenamientos -----
  if (y > 250) { doc.addPage(); y = margin }
  section(`Sesiones de entrenamiento (${(data.workoutSessions || []).length})`)
  if (data.workoutSessions?.length) {
    autoTable(doc, {
      startY: y,
      margin: { left: margin, right: margin },
      head: [['Rutina', 'Inicio', 'Duración', 'Kcal']],
      body: data.workoutSessions.map((w) => [
        w.workoutName || '',
        w.startedAt ? w.startedAt.slice(0, 16).replace('T', ' ') : '',
        w.durationSeconds != null ? Math.round(w.durationSeconds / 60) + ' min' : '—',
        w.caloriesBurned ?? '—',
      ]),
      headStyles: { fillColor: [30, 58, 138], textColor: 255 },
      styles: { fontSize: 9 },
    })
    y = doc.lastAutoTable.finalY + 10
  } else {
    doc.setFontSize(9); doc.text('Sin sesiones de entrenamiento.', margin, y); y += 8
  }

  // ----- Dietas personalizadas -----
  if (y > 250) { doc.addPage(); y = margin }
  section(`Mis dietas personalizadas (${(data.customDiets || []).length})`)
  if (data.customDiets?.length) {
    for (const d of data.customDiets) {
      if (y > 250) { doc.addPage(); y = margin }
      doc.setFont('helvetica', 'bold')
      doc.setFontSize(11)
      doc.text(`${d.name}  ·  ${Math.round(d.totalKcal)} kcal`, margin, y)
      y += 5
      if (d.description) {
        doc.setFont('helvetica', 'normal')
        doc.setFontSize(9)
        doc.text(d.description, margin, y, { maxWidth: 182 })
        y += 5
      }
      autoTable(doc, {
        startY: y,
        margin: { left: margin, right: margin },
        head: [['Alimento', 'Gramos', 'Kcal']],
        body: (d.items || []).map((i) => [i.foodName || '', Number(i.grams), Math.round(Number(i.kcal))]),
        headStyles: { fillColor: [30, 58, 138], textColor: 255 },
        styles: { fontSize: 9 },
      })
      y = doc.lastAutoTable.finalY + 8
    }
  } else {
    doc.setFontSize(9); doc.text('Sin dietas personalizadas.', margin, y); y += 8
  }

  // Pie con paginación
  const total = doc.getNumberOfPages()
  for (let i = 1; i <= total; i++) {
    doc.setPage(i)
    doc.setFontSize(8)
    doc.setTextColor(120, 120, 120)
    doc.text(`ZenFit · Página ${i} de ${total}`, margin, 290)
  }

  doc.save(`${fileBase()}.pdf`)
}
