// Artículos del blog de ZenFit: cómo usar la app, para qué sirve y cómo te ayuda.
// Cada artículo tiene secciones con título y párrafos.

export const blogPosts = [
  {
    slug: 'primeros-pasos',
    tag: 'Guía',
    title: 'Tus primeros pasos en ZenFit',
    excerpt: 'Crea tu cuenta, completa tu perfil de bienestar y deja todo listo para empezar a mejorar tu salud.',
    readTime: '4 min',
    featured: true,
    sections: [
      {
        heading: '¿Qué es ZenFit?',
        paragraphs: [
          'ZenFit es una plataforma de bienestar integral que reúne en un solo sitio tu entrenamiento físico, tus hábitos saludables, tu descanso y tu progreso. La idea es sencilla: en lugar de usar cinco apps distintas, lo tienes todo conectado y trabajando junto.',
          'No necesitas ser un experto ni tener material. ZenFit está pensado para acompañarte desde el primer día con rutinas adaptadas y un seguimiento que de verdad te dice cómo vas.',
        ],
      },
      {
        heading: 'Paso 1: Crea tu cuenta',
        paragraphs: [
          'Pulsa en "Empieza gratis" y regístrate con tu nombre, correo y una contraseña de al menos 8 caracteres. No se pide tarjeta ni datos de pago: la cuenta es gratuita.',
          'En cuanto te registras, ya estás dentro y te llevamos directo a tu Dashboard personal.',
        ],
      },
      {
        heading: 'Paso 2: Completa tu perfil de bienestar',
        paragraphs: [
          'Ve a la sección "Perfil" desde el menú superior. Ahí puedes indicar tu altura, peso, fecha de nacimiento, objetivo (perder peso, ganar músculo, dormir mejor…) y tu nivel de actividad.',
          'Estos datos son la base que ZenFit usa para personalizar tu experiencia. Cuanto más completo esté tu perfil, más útil será todo lo demás.',
        ],
      },
      {
        heading: 'Paso 3: Explora tu Dashboard',
        paragraphs: [
          'El Dashboard es tu centro de control. Al principio estará vacío porque aún no tienes actividad registrada — es normal. A medida que entrenes, registres sueño y completes hábitos, se irá llenando de datos reales calculados al momento.',
        ],
      },
    ],
  },
  {
    slug: 'crear-habitos',
    tag: 'Hábitos',
    title: 'Cómo crear hábitos que de verdad se mantienen',
    excerpt: 'La constancia es la clave del bienestar. Te enseñamos a usar el módulo de hábitos para construir rachas.',
    readTime: '5 min',
    featured: false,
    sections: [
      {
        heading: 'Por qué los hábitos importan más que la motivación',
        paragraphs: [
          'La motivación sube y baja; los hábitos permanecen. Un pequeño gesto repetido cada día (beber agua, estirar, meditar 5 minutos) tiene un impacto enorme a largo plazo. ZenFit está diseñado para que ese "cada día" sea fácil de cumplir y de visualizar.',
        ],
      },
      {
        heading: 'Crea tu primer hábito',
        paragraphs: [
          'Entra en la sección "Hábitos" y pulsa "+ Nuevo hábito". Ponle un nombre claro ("Beber 2L de agua"), elige un emoji y un color para identificarlo de un vistazo, y guárdalo.',
          'Consejo: empieza con 1 o 2 hábitos como máximo. Es mejor cumplir dos hábitos pequeños que fallar en diez.',
        ],
      },
      {
        heading: 'Marca cada día y construye tu racha',
        paragraphs: [
          'Cada día que cumplas un hábito, pulsa el círculo de la izquierda: se pondrá verde. ZenFit cuenta automáticamente tu racha (días consecutivos) y el total de veces que lo has completado.',
          'Ver crecer la racha 🔥 es uno de los mayores motivadores: no querrás romperla. Si un día no marcas, la racha se reinicia, así que la app te empuja suavemente a la constancia.',
        ],
      },
    ],
  },
  {
    slug: 'registro-sueno',
    tag: 'Descanso',
    title: 'Saca partido al registro de sueño',
    excerpt: 'Dormir bien es el pilar más infravalorado de la salud. Aprende a registrarlo y entender tu descanso.',
    readTime: '3 min',
    featured: false,
    sections: [
      {
        heading: 'El sueño condiciona todo lo demás',
        paragraphs: [
          'Puedes entrenar perfecto y comer bien, pero si duermes mal tu cuerpo no se recupera, rindes peor y te cuesta mantener hábitos. Por eso ZenFit le da al descanso la importancia que merece.',
        ],
      },
      {
        heading: 'Cómo registrar tu sueño',
        paragraphs: [
          'En la sección "Sueño" indica la fecha, cuántas horas dormiste y valora la calidad del 1 al 5. Puedes añadir una nota ("me desperté varias veces"). Si registras dos veces el mismo día, se actualiza el registro existente.',
          'El historial te muestra la evolución de tus últimas noches para que detectes patrones: quizá duermes peor los domingos, o mejor cuando entrenas.',
        ],
      },
      {
        heading: 'El sueño en tu Dashboard',
        paragraphs: [
          'Tu último registro de sueño aparece resumido en el Dashboard, junto al resto de tu actividad, para que tengas una foto completa de tu bienestar de un vistazo.',
        ],
      },
    ],
  },
  {
    slug: 'primer-entrenamiento',
    tag: 'Fitness',
    title: 'Tu primer entrenamiento en ZenFit',
    excerpt: 'Elige una rutina del catálogo, complétala y regístrala. Así de simple es empezar a moverte.',
    readTime: '4 min',
    featured: false,
    sections: [
      {
        heading: 'Un catálogo para todos los niveles',
        paragraphs: [
          'En la sección "Entrenar" tienes rutinas listas para usar: Full Body para principiantes, HIIT para quemar grasa, Cardio Express, Yoga & Movilidad y más. Cada rutina indica su duración, dificultad y los ejercicios que incluye.',
        ],
      },
      {
        heading: 'Completa y registra tu sesión',
        paragraphs: [
          'Elige la rutina que encaje con tu día y tu energía. Cuando termines de hacerla, pulsa "Marcar como completado": ZenFit registra la sesión con su duración y calorías estimadas.',
          'No pasa nada si empiezas por la rutina más corta. Lo importante no es la intensidad de un día, sino la suma de muchos días.',
        ],
      },
      {
        heading: 'Tu historial de entrenamientos',
        paragraphs: [
          'Cada sesión completada queda guardada en tu historial y suma en tus estadísticas del Dashboard: total de entrenos y entrenos de la semana. Verás tu constancia reflejada en números reales.',
        ],
      },
    ],
  },
  {
    slug: 'dashboard-progreso',
    tag: 'Seguimiento',
    title: 'Cómo el Dashboard te ayuda a ver tu progreso',
    excerpt: 'Todos tus datos, en un solo sitio y en tiempo real. Te explicamos cómo leer tu panel.',
    readTime: '3 min',
    featured: false,
    sections: [
      {
        heading: 'Una foto completa de tu bienestar',
        paragraphs: [
          'El Dashboard reúne lo que haces en todos los módulos: entrenamientos, hábitos, sueño y tu mejor racha. No son números inventados: se calculan en tiempo real a partir de tu actividad real.',
        ],
      },
      {
        heading: 'Qué te muestra',
        paragraphs: [
          'Verás tus entrenos totales y los de esta semana, cuántos hábitos has completado hoy, tu mejor racha y tu último registro de sueño. Además, accesos rápidos para seguir sumando actividad.',
          'La idea es que en 5 segundos sepas cómo va tu semana y qué te falta por hacer hoy.',
        ],
      },
    ],
  },
  {
    slug: 'para-que-sirve-zenfit',
    tag: 'Concepto',
    title: '¿Para qué sirve ZenFit y cómo te ayuda?',
    excerpt: 'Fitness, descanso, hábitos y salud mental conectados. Esta es la filosofía detrás de la app.',
    readTime: '5 min',
    featured: false,
    sections: [
      {
        heading: 'El bienestar es la suma de varias piezas',
        paragraphs: [
          'Muchas apps se centran solo en el entrenamiento. Pero tu bienestar real depende también de cómo descansas, de tus hábitos diarios y de tu estado mental. ZenFit conecta todas esas piezas porque, en la práctica, se influyen entre sí.',
          'Dormir mejor te hace entrenar mejor. Entrenar te ayuda a reducir el estrés. Los hábitos sostienen todo lo demás. Esa es la idea central de ZenFit.',
        ],
      },
      {
        heading: 'Cómo te ayuda en el día a día',
        paragraphs: [
          'ZenFit te quita la fricción: no tienes que pensar qué entrenar (hay rutinas listas), ni llevar las cuentas a mano (el Dashboard lo hace), ni recordar tus rachas (la app las cuenta). Tú solo tienes que aparecer y hacer.',
          'El objetivo final no es que uses mucho la app, sino que la app te ayude a construir una versión más sana de ti con el mínimo esfuerzo mental posible.',
        ],
      },
    ],
  },
]

export const findPost = (slug) => blogPosts.find((p) => p.slug === slug)
