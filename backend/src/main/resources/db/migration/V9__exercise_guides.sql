-- =====================================================================
-- ZenFit — Guías paso a paso por ejercicio
-- Cada ejercicio recibe instrucciones detalladas, un tip de técnica y
-- un enlace de búsqueda en YouTube en español para apoyo visual.
-- =====================================================================

ALTER TABLE exercises
    ADD COLUMN IF NOT EXISTS instructions TEXT,
    ADD COLUMN IF NOT EXISTS tips TEXT;

-- =====================================================================
-- V2 — Ejercicios originales
-- =====================================================================

UPDATE exercises SET
  instructions = '1. Colócate boca abajo, manos a la anchura de los hombros y cuerpo en línea recta desde la cabeza hasta los talones.
2. Baja flexionando los codos a unos 45 grados hasta que el pecho casi toque el suelo.
3. Empuja con fuerza contra el suelo para volver a la posición inicial sin bloquear los codos.
4. Repite manteniendo el core activado durante todo el movimiento.',
  tips = 'No dejes caer la cadera ni levantes el glúteo. Si te cuesta, apoya las rodillas.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+flexiones+correctamente')
WHERE id = 'a0000000-0000-0000-0000-000000000001';

UPDATE exercises SET
  instructions = '1. De pie, pies a la anchura de las caderas y puntas ligeramente hacia fuera.
2. Baja la cadera hacia atrás y abajo, como si te sentaras en una silla invisible.
3. Mantén el pecho arriba y baja hasta que tus muslos estén paralelos al suelo.
4. Empuja con los talones para volver a la posición inicial.',
  tips = 'Las rodillas deben ir en la dirección de los pies. No las hundas hacia dentro.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+sentadillas+correctamente')
WHERE id = 'a0000000-0000-0000-0000-000000000002';

UPDATE exercises SET
  instructions = '1. Apóyate sobre los antebrazos y las puntas de los pies con el cuerpo formando una línea recta.
2. Coloca los codos justo debajo de los hombros y mira al suelo unos centímetros delante de ti.
3. Aprieta glúteos y abdominales con fuerza para evitar que la cadera caiga.
4. Mantén la posición respirando con calma durante el tiempo objetivo.',
  tips = 'Evita levantar el glúteo o hundir la cadera. La cabeza alineada con la columna.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+plancha+abdominal')
WHERE id = 'a0000000-0000-0000-0000-000000000003';

UPDATE exercises SET
  instructions = '1. Da un paso amplio hacia adelante con una pierna manteniendo el torso recto.
2. Baja la rodilla trasera hasta casi tocar el suelo, ambas rodillas a 90 grados.
3. Empuja con el talón delantero para volver al centro.
4. Alterna piernas en cada repetición.',
  tips = 'La rodilla delantera no debe sobrepasar la punta del pie. Da pasos amplios.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+zancadas+lunges')
WHERE id = 'a0000000-0000-0000-0000-000000000004';

UPDATE exercises SET
  instructions = '1. Desde de pie, baja a sentadilla y apoya las manos en el suelo.
2. Lanza las piernas atrás de un salto y haz una flexión (opcional).
3. Vuelve con un salto a la posición de sentadilla.
4. Salta verticalmente con los brazos arriba y aterriza con control.',
  tips = 'Es muy intenso. Si eres principiante, omite la flexión o el salto final.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+burpees+correctamente')
WHERE id = 'a0000000-0000-0000-0000-000000000005';

UPDATE exercises SET
  instructions = '1. Colócate en posición de plancha alta, brazos rectos.
2. Lleva una rodilla hacia el pecho rápidamente.
3. Cámbiala por la otra alternando como si corrieras.
4. Mantén la cadera baja y el core activado en todo momento.',
  tips = 'La cadera no debe rebotar hacia arriba. Mira al suelo entre tus manos.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+mountain+climbers')
WHERE id = 'a0000000-0000-0000-0000-000000000006';

UPDATE exercises SET
  instructions = '1. De pie con los brazos a los lados y los pies juntos.
2. Salta abriendo las piernas a la anchura de los hombros mientras subes los brazos por encima de la cabeza.
3. Vuelve con otro salto a la posición inicial.
4. Mantén un ritmo constante.',
  tips = 'Aterriza con suavidad sobre la planta del pie, no con los talones de golpe.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+jumping+jacks')
WHERE id = 'a0000000-0000-0000-0000-000000000007';

UPDATE exercises SET
  instructions = '1. Pies a la anchura de las caderas con la barra cerca de las espinillas.
2. Flexiona caderas y rodillas para agarrar la barra con la espalda recta.
3. Levanta empujando el suelo con los talones, extendiendo cadera y rodillas a la vez.
4. Baja la barra controlando el descenso, manteniendo la espalda neutra.',
  tips = 'La espalda nunca debe curvarse. Empieza con poco peso hasta dominar la técnica.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+peso+muerto+correctamente')
WHERE id = 'a0000000-0000-0000-0000-000000000008';

UPDATE exercises SET
  instructions = '1. Sentado o de pie con espalda recta, mancuernas a la altura de los hombros con las palmas hacia adelante.
2. Empuja las mancuernas hacia arriba hasta extender los brazos sin bloquearlos.
3. Baja lentamente las mancuernas a la posición inicial.
4. Mantén el core activado y no arquees la espalda.',
  tips = 'No bloquees los codos arriba. Si haces sentado, apoya bien la espalda en el respaldo.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+press+militar+hombros')
WHERE id = 'a0000000-0000-0000-0000-000000000009';

UPDATE exercises SET
  instructions = '1. Desde cuadrupedia, mete los dedos de los pies y eleva la cadera hacia arriba.
2. Forma una V invertida con tu cuerpo, manos y pies bien apoyados.
3. Empuja el suelo con las manos para alargar la columna.
4. Relaja el cuello dejando caer la cabeza entre los brazos.',
  tips = 'Si tienes isquios cortos, puedes flexionar ligeramente las rodillas.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=postura+del+perro+yoga')
WHERE id = 'a0000000-0000-0000-0000-00000000000a';

UPDATE exercises SET
  instructions = '1. Posición de cuadrupedia: manos bajo hombros, rodillas bajo caderas.
2. Inhalando, arquea la espalda hacia abajo y mira al techo (vaca).
3. Exhalando, redondea la espalda hacia arriba metiendo la barbilla al pecho (gato).
4. Alterna ambos movimientos con la respiración de forma fluida.',
  tips = 'Movimiento lento. Acompasa cada fase con la respiración.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=ejercicio+gato+vaca+columna')
WHERE id = 'a0000000-0000-0000-0000-00000000000b';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con las rodillas flexionadas y los pies apoyados en el suelo.
2. Cruza las manos sobre el pecho o tras la nuca sin tirar del cuello.
3. Eleva el tronco contrayendo el abdomen unos 30-40 cm del suelo.
4. Baja con control sin que el tronco descanse del todo en el suelo.',
  tips = 'No tires del cuello con las manos. El movimiento viene del abdomen.',
  video_url = COALESCE(video_url, 'https://www.youtube.com/results?search_query=como+hacer+abdominales+crunch')
WHERE id = 'a0000000-0000-0000-0000-00000000000c';

-- =====================================================================
-- V8 — Pierna / glúteo
-- =====================================================================

UPDATE exercises SET
  instructions = '1. Coloca el empeine de la pierna trasera sobre un banco a la altura de la rodilla.
2. La pierna delantera firme en el suelo, dando un paso adelante para tener espacio.
3. Baja la rodilla trasera hacia el suelo flexionando la pierna delantera.
4. Empuja con el talón delantero para volver arriba.',
  tips = 'La rodilla delantera no se mete hacia dentro. Mantén el torso ligeramente inclinado.',
  video_url = 'https://www.youtube.com/results?search_query=sentadilla+bulgara'
WHERE id = 'a1000000-0000-0000-0000-000000000001';

UPDATE exercises SET
  instructions = '1. Baja a sentadilla profunda con el peso corporal.
2. Desde abajo, explosivamente salta verticalmente extendiendo cadera y rodillas.
3. Aterriza con suavidad sobre la planta del pie en posición de sentadilla.
4. Encadena la siguiente repetición sin parar.',
  tips = 'Aterriza absorbiendo el impacto con las piernas flexionadas, no con los talones.',
  video_url = 'https://www.youtube.com/results?search_query=sentadilla+con+salto+jump+squat'
WHERE id = 'a1000000-0000-0000-0000-000000000002';

UPDATE exercises SET
  instructions = '1. Pies muy abiertos (más anchos que los hombros) y puntas claramente hacia fuera.
2. Baja la cadera recta hacia el suelo manteniendo el torso vertical.
3. Empuja con los talones para volver arriba contrayendo glúteos.
4. Las rodillas deben empujar hacia fuera siguiendo la línea de los pies.',
  tips = 'Trabaja muy bien aductores y glúteo medio. Mantén el torso erguido.',
  video_url = 'https://www.youtube.com/results?search_query=sentadilla+sumo'
WHERE id = 'a1000000-0000-0000-0000-000000000003';

UPDATE exercises SET
  instructions = '1. De pie con mancuernas o barra, pies a la anchura de las caderas.
2. Con piernas casi rectas (rodillas suaves), bisagra la cadera hacia atrás.
3. Baja el peso pegado a las piernas hasta sentir tensión en los isquios.
4. Vuelve a la posición inicial empujando la cadera hacia adelante.',
  tips = 'Es bisagra de cadera, NO sentadilla. La espalda siempre recta.',
  video_url = 'https://www.youtube.com/results?search_query=peso+muerto+rumano+RDL'
WHERE id = 'a1000000-0000-0000-0000-000000000004';

UPDATE exercises SET
  instructions = '1. Apoya la parte alta de la espalda en un banco, rodillas flexionadas y pies firmes en el suelo.
2. La cadera al principio queda colgando entre el banco y los pies.
3. Empuja con los talones para elevar la cadera hasta formar línea de hombros a rodillas.
4. Contrae glúteos arriba y baja lentamente.',
  tips = 'Mete la pelvis al final del movimiento para activar bien los glúteos.',
  video_url = 'https://www.youtube.com/results?search_query=hip+thrust+gluteos'
WHERE id = 'a1000000-0000-0000-0000-000000000005';

UPDATE exercises SET
  instructions = '1. De pie frente a un banco o escalón firme.
2. Sube apoyando toda la planta del pie en el banco y empujando con ese talón.
3. Sube hasta extender la pierna arriba sin apoyar la otra encima.
4. Baja con control y alterna piernas.',
  tips = 'No te impulses con la pierna que queda abajo. El trabajo lo hace la pierna que sube.',
  video_url = 'https://www.youtube.com/results?search_query=step+up+escalon'
WHERE id = 'a1000000-0000-0000-0000-000000000006';

UPDATE exercises SET
  instructions = '1. Sostén una mancuerna en vertical pegada al pecho con ambas manos.
2. Pies a la anchura de los hombros, puntas ligeramente hacia fuera.
3. Baja a sentadilla profunda manteniendo el torso erguido y los codos por dentro de las rodillas.
4. Empuja con los talones para volver arriba.',
  tips = 'Excelente para aprender técnica de sentadilla profunda. Codos dentro de las rodillas en la bajada.',
  video_url = 'https://www.youtube.com/results?search_query=sentadilla+goblet+squat'
WHERE id = 'a1000000-0000-0000-0000-000000000007';

UPDATE exercises SET
  instructions = '1. Apoya toda la espalda contra la pared.
2. Camina los pies hacia adelante y baja hasta que rodillas y cadera estén a 90 grados.
3. Las rodillas justo sobre los tobillos, no por delante.
4. Mantén la posición respirando con calma durante el tiempo objetivo.',
  tips = 'Si te tiemblan las piernas, sube un poco para ajustar el ángulo.',
  video_url = 'https://www.youtube.com/results?search_query=sentadilla+en+pared+wall+sit'
WHERE id = 'a1000000-0000-0000-0000-000000000008';

UPDATE exercises SET
  instructions = '1. En cuadrupedia, con la espalda neutra y el core activado.
2. Eleva una pierna hacia atrás manteniendo la rodilla flexionada a 90 grados.
3. Sube hasta que el muslo esté en línea con el torso y aprieta el glúteo.
4. Baja con control y alterna piernas (o haz todas las repeticiones primero por un lado).',
  tips = 'No arquees la espalda al subir. El movimiento sale de la cadera.',
  video_url = 'https://www.youtube.com/results?search_query=patada+gluteo+donkey+kick'
WHERE id = 'a1000000-0000-0000-0000-000000000009';

UPDATE exercises SET
  instructions = '1. De pie con los pies a la anchura de las caderas.
2. Eleva los talones lo más alto posible apoyando en las puntas.
3. Mantén un segundo arriba contrayendo los gemelos.
4. Baja con control sin tocar el suelo del todo.',
  tips = 'Hazlo en un escalón para conseguir más rango de movimiento.',
  video_url = 'https://www.youtube.com/results?search_query=elevacion+gemelos+calf+raises'
WHERE id = 'a1000000-0000-0000-0000-00000000000a';

-- =====================================================================
-- V8 — Pecho / tríceps
-- =====================================================================

UPDATE exercises SET
  instructions = '1. En posición de flexión, junta las manos formando un triángulo con índices y pulgares.
2. Mantén el cuerpo recto desde cabeza a talones.
3. Baja flexionando los codos pegados al cuerpo hasta casi tocar las manos con el pecho.
4. Empuja hacia arriba contrayendo los tríceps.',
  tips = 'Es más difícil que la flexión normal. Si te cuesta, hazlo con las rodillas apoyadas.',
  video_url = 'https://www.youtube.com/results?search_query=flexiones+diamante+triceps'
WHERE id = 'a1000000-0000-0000-0000-000000000010';

UPDATE exercises SET
  instructions = '1. Apoya las manos en un banco, mesa o pared a una altura cómoda.
2. Cuerpo recto e inclinado, pies juntos en el suelo.
3. Baja el pecho hacia la superficie flexionando los codos.
4. Empuja para volver a la posición inicial.',
  tips = 'Cuanto más alta sea la superficie, más fácil. Excelente para principiantes.',
  video_url = 'https://www.youtube.com/results?search_query=flexiones+inclinadas+principiantes'
WHERE id = 'a1000000-0000-0000-0000-000000000011';

UPDATE exercises SET
  instructions = '1. Siéntate al borde de un banco y agárrate con las manos a ambos lados.
2. Apoya los talones por delante con las piernas extendidas.
3. Sostén el peso con los brazos y baja flexionando los codos hacia atrás.
4. Empuja con los tríceps para volver arriba sin bloquear los codos.',
  tips = 'Los codos deben mirar hacia atrás, no abrirse. No bajes más de 90 grados si tienes hombros sensibles.',
  video_url = 'https://www.youtube.com/results?search_query=fondos+triceps+en+banco'
WHERE id = 'a1000000-0000-0000-0000-000000000012';

UPDATE exercises SET
  instructions = '1. Túmbate en banco con las mancuernas a la altura del pecho, codos en 45-90 grados.
2. Pies firmes en el suelo y zona lumbar ligeramente arqueada.
3. Empuja las mancuernas hacia arriba juntándolas ligeramente al final del recorrido.
4. Baja con control hasta sentir estiramiento en el pecho.',
  tips = 'No bajes en exceso si no tienes movilidad de hombro. Controla el descenso 2-3 segundos.',
  video_url = 'https://www.youtube.com/results?search_query=press+de+banca+mancuernas'
WHERE id = 'a1000000-0000-0000-0000-000000000013';

UPDATE exercises SET
  instructions = '1. Túmbate en banco con mancuernas extendidas sobre el pecho, palmas enfrentadas.
2. Mantén codos ligeramente flexionados durante todo el ejercicio.
3. Abre los brazos en arco hasta sentir estiramiento en el pecho.
4. Cierra juntando las mancuernas arriba contrayendo el pecho.',
  tips = 'No bajes demasiado para no comprometer el hombro. Movimiento en arco.',
  video_url = 'https://www.youtube.com/results?search_query=aperturas+con+mancuernas+pecho'
WHERE id = 'a1000000-0000-0000-0000-000000000014';

-- =====================================================================
-- V8 — Espalda / bíceps
-- =====================================================================

UPDATE exercises SET
  instructions = '1. Cuélgate de una barra con agarre prono (palmas hacia adelante), manos a la anchura de los hombros.
2. Activa los dorsales tirando de los hombros hacia abajo.
3. Tira del cuerpo hacia arriba hasta que la barbilla supere la barra.
4. Baja con control hasta extender los brazos.',
  tips = 'Si no llegas, usa una banda elástica o haz dominadas negativas (bajadas controladas).',
  video_url = 'https://www.youtube.com/results?search_query=como+hacer+dominadas+pull+up'
WHERE id = 'a1000000-0000-0000-0000-000000000020';

UPDATE exercises SET
  instructions = '1. Apoya una rodilla y la mano del mismo lado en un banco, espalda paralela al suelo.
2. Sostén la mancuerna con el otro brazo extendido hacia el suelo.
3. Tira de la mancuerna hacia la cadera, llevando el codo cerca del cuerpo.
4. Baja lentamente sintiendo cómo se estira el dorsal.',
  tips = 'El torso no se mueve. Lleva el codo atrás, no hacia fuera.',
  video_url = 'https://www.youtube.com/results?search_query=remo+con+mancuerna+espalda'
WHERE id = 'a1000000-0000-0000-0000-000000000021';

UPDATE exercises SET
  instructions = '1. Pasa una barra a una altura media (mesa estable, barra de dominadas baja, etc.).
2. Cuélgate debajo con cuerpo recto y talones apoyados en el suelo.
3. Tira del pecho hacia la barra apretando los omóplatos.
4. Baja con control hasta extender los brazos.',
  tips = 'Cuanto más horizontal estés, más difícil. Empieza con un ángulo cómodo.',
  video_url = 'https://www.youtube.com/results?search_query=remo+invertido+inverted+row'
WHERE id = 'a1000000-0000-0000-0000-000000000022';

UPDATE exercises SET
  instructions = '1. Túmbate boca abajo con brazos extendidos delante y piernas estiradas.
2. Eleva simultáneamente brazos, pecho y piernas del suelo contrayendo lumbares y glúteos.
3. Mantén 1-2 segundos arriba sin tensionar el cuello.
4. Baja con control y repite.',
  tips = 'No tires la cabeza hacia atrás. Mira al suelo durante todo el movimiento.',
  video_url = 'https://www.youtube.com/results?search_query=superman+ejercicio+lumbar'
WHERE id = 'a1000000-0000-0000-0000-000000000023';

UPDATE exercises SET
  instructions = '1. De pie con una mancuerna en cada mano, palmas hacia adelante.
2. Codos pegados al torso y brazos extendidos.
3. Flexiona los codos llevando las mancuernas hacia los hombros sin mover los codos.
4. Baja con control hasta extender completamente.',
  tips = 'Los codos no se mueven hacia adelante. El movimiento es aislado en el codo.',
  video_url = 'https://www.youtube.com/results?search_query=curl+biceps+mancuernas'
WHERE id = 'a1000000-0000-0000-0000-000000000024';

UPDATE exercises SET
  instructions = '1. De pie con mancuernas, palmas enfrentadas (agarre neutro tipo martillo).
2. Codos pegados al cuerpo, brazos extendidos.
3. Sube las mancuernas a los hombros sin rotar las muñecas.
4. Baja lentamente manteniendo el agarre neutro.',
  tips = 'Trabaja más el braquial y el antebrazo que el curl tradicional. Codos quietos.',
  video_url = 'https://www.youtube.com/results?search_query=curl+martillo+hammer+curl'
WHERE id = 'a1000000-0000-0000-0000-000000000025';

-- =====================================================================
-- V8 — Hombros
-- =====================================================================

UPDATE exercises SET
  instructions = '1. De pie con una mancuerna en cada mano a los lados del cuerpo.
2. Eleva los brazos lateralmente hasta la altura de los hombros, codos ligeramente flexionados.
3. Mantén 1 segundo arriba sin levantar los hombros hacia las orejas.
4. Baja con control hasta los lados.',
  tips = 'Las muñecas algo más bajas que los codos. Pesos ligeros, mucha técnica.',
  video_url = 'https://www.youtube.com/results?search_query=elevaciones+laterales+hombros'
WHERE id = 'a1000000-0000-0000-0000-000000000030';

UPDATE exercises SET
  instructions = '1. Inclínate hacia adelante con la espalda neutra, mancuernas colgando.
2. Codos ligeramente flexionados durante todo el movimiento.
3. Abre los brazos hacia atrás como mariposa, apretando los omóplatos.
4. Baja con control sin perder la postura inclinada.',
  tips = 'Aísla el deltoide posterior. No uses impulso, mejor menos peso y más técnica.',
  video_url = 'https://www.youtube.com/results?search_query=pajaros+rear+delt+fly'
WHERE id = 'a1000000-0000-0000-0000-000000000031';

UPDATE exercises SET
  instructions = '1. De pie con mancuernas a los lados, brazos extendidos.
2. Sube los hombros hacia las orejas todo lo que puedas.
3. Mantén 1 segundo arriba contrayendo el trapecio.
4. Baja con control hasta la posición inicial.',
  tips = 'Movimiento puro de subida y bajada, sin rotar los hombros.',
  video_url = 'https://www.youtube.com/results?search_query=encogimientos+hombros+shrugs'
WHERE id = 'a1000000-0000-0000-0000-000000000032';

-- =====================================================================
-- V8 — Core
-- =====================================================================

UPDATE exercises SET
  instructions = '1. Túmbate de lado apoyado sobre un antebrazo, codo bajo el hombro.
2. Apila las piernas y eleva la cadera para formar línea recta de cabeza a pies.
3. El brazo libre puede ir extendido hacia el techo o apoyado en la cadera.
4. Mantén la posición respirando con calma durante el tiempo objetivo.',
  tips = 'La cadera no debe caer. Si te cuesta, apoya la rodilla de abajo en el suelo.',
  video_url = 'https://www.youtube.com/results?search_query=plancha+lateral+side+plank'
WHERE id = 'a1000000-0000-0000-0000-000000000040';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con brazos extendidos por encima de la cabeza y piernas rectas.
2. Eleva simultáneamente brazos y piernas formando una V.
3. Toca las puntas de los pies o llega lo más cerca posible.
4. Baja con control sin que brazos ni talones toquen el suelo.',
  tips = 'Mantén la espalda baja pegada al suelo durante todo el movimiento.',
  video_url = 'https://www.youtube.com/results?search_query=v+ups+abdominales'
WHERE id = 'a1000000-0000-0000-0000-000000000041';

UPDATE exercises SET
  instructions = '1. Sentado con las rodillas flexionadas y el tronco inclinado unos 45 grados hacia atrás.
2. Junta las manos delante (o sostén una pesa) con los pies levantados o apoyados.
3. Rota el torso de lado a lado tocando el suelo con las manos en cada lado.
4. Mantén el abdomen contraído todo el tiempo.',
  tips = 'El movimiento es desde el torso, no desde los brazos. Espalda recta inclinada.',
  video_url = 'https://www.youtube.com/results?search_query=russian+twists+abdominales+oblicuos'
WHERE id = 'a1000000-0000-0000-0000-000000000042';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con las manos detrás de la cabeza y las piernas elevadas.
2. Pedalea trayendo una rodilla al pecho mientras la otra se estira.
3. Toca el codo opuesto con la rodilla que sube en cada repetición.
4. Mantén el movimiento controlado y constante.',
  tips = 'No tires del cuello con las manos. El movimiento es del abdomen.',
  video_url = 'https://www.youtube.com/results?search_query=bicicleta+abdominal+ejercicio'
WHERE id = 'a1000000-0000-0000-0000-000000000043';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba y eleva brazos rectos por detrás de la cabeza y piernas estiradas un poco del suelo.
2. La zona lumbar pegada al suelo todo el tiempo.
3. El cuerpo forma una pequeña cuna o hueco entre la cabeza y los pies.
4. Mantén respirando con calma durante el tiempo objetivo.',
  tips = 'Si la lumbar se despega, sube los brazos o las piernas para acomodarte.',
  video_url = 'https://www.youtube.com/results?search_query=hollow+body+hold+core'
WHERE id = 'a1000000-0000-0000-0000-000000000044';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con brazos extendidos al techo y piernas a 90 grados (cadera y rodilla).
2. Extiende un brazo hacia atrás y la pierna contraria hacia adelante a la vez.
3. La zona lumbar siempre pegada al suelo.
4. Vuelve al centro y alterna lados.',
  tips = 'Si la espalda se arquea, no llegues tan lejos. Movimiento lento y controlado.',
  video_url = 'https://www.youtube.com/results?search_query=dead+bug+abdominales'
WHERE id = 'a1000000-0000-0000-0000-000000000045';

UPDATE exercises SET
  instructions = '1. En cuadrupedia, manos bajo hombros y rodillas bajo caderas.
2. Extiende un brazo hacia adelante y la pierna contraria hacia atrás simultáneamente.
3. Mantén la cadera estable, sin rotar.
4. Vuelve al centro y alterna lados.',
  tips = 'Imagina que tienes un vaso de agua sobre la zona lumbar y no debe caerse.',
  video_url = 'https://www.youtube.com/results?search_query=bird+dog+ejercicio+core'
WHERE id = 'a1000000-0000-0000-0000-000000000046';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con piernas rectas y manos a los lados o bajo las caderas.
2. Eleva las piernas hasta formar 90 grados con el torso.
3. Baja con control sin que los talones toquen el suelo.
4. Mantén la lumbar pegada al suelo todo el tiempo.',
  tips = 'Si la lumbar se levanta, no bajes tanto. Empieza con las rodillas flexionadas si te cuesta.',
  video_url = 'https://www.youtube.com/results?search_query=elevacion+piernas+leg+raises'
WHERE id = 'a1000000-0000-0000-0000-000000000047';

-- =====================================================================
-- V8 — Pliométricos / HIIT
-- =====================================================================

UPDATE exercises SET
  instructions = '1. Colócate frente a una caja o cajón estable a la altura adecuada para tu nivel.
2. Baja a media sentadilla y lanza los brazos hacia atrás.
3. Salta explosivamente hacia la caja aterrizando con ambos pies en sentadilla.
4. Bájate caminando o salta hacia atrás con control.',
  tips = 'Empieza con una caja baja. Aterriza con piernas flexionadas para absorber el impacto.',
  video_url = 'https://www.youtube.com/results?search_query=box+jumps+ejercicio'
WHERE id = 'a1000000-0000-0000-0000-000000000050';

UPDATE exercises SET
  instructions = '1. De pie con la kettlebell entre los pies, agárrala con las dos manos.
2. Bisagra desde la cadera llevando la kettlebell hacia atrás entre las piernas.
3. Empuja la cadera adelante explosivamente lanzando la kettlebell a la altura de los hombros.
4. Deja que vuelva entre las piernas y encadena la siguiente.',
  tips = 'Es un movimiento de cadera, NO de hombro. Los brazos solo guían la kettlebell.',
  video_url = 'https://www.youtube.com/results?search_query=kettlebell+swing+tecnica'
WHERE id = 'a1000000-0000-0000-0000-000000000051';

UPDATE exercises SET
  instructions = '1. De pie con el cuerpo ligeramente inclinado hacia adelante.
2. Corre en el sitio a la máxima velocidad que puedas mantener.
3. Bombea los brazos para ayudar al ritmo.
4. Mantén el ritmo durante el tiempo objetivo sin parar.',
  tips = 'No saltes alto. Lo importante es la frecuencia de pasos, no la altura.',
  video_url = 'https://www.youtube.com/results?search_query=sprint+en+sitio+ejercicio'
WHERE id = 'a1000000-0000-0000-0000-000000000052';

UPDATE exercises SET
  instructions = '1. Empieza en posición de zancada con una rodilla doblada delante y otra detrás.
2. Salta verticalmente cambiando la posición de las piernas en el aire.
3. Aterriza en zancada con la pierna opuesta delante.
4. Encadena los saltos sin parar.',
  tips = 'Aterriza con suavidad. Si pesas el impacto, hazlo a menor altura.',
  video_url = 'https://www.youtube.com/results?search_query=jumping+lunges+zancadas+saltadas'
WHERE id = 'a1000000-0000-0000-0000-000000000053';

UPDATE exercises SET
  instructions = '1. Empieza en plancha de antebrazos con el cuerpo recto.
2. Apoya una mano y luego la otra para subir a plancha alta.
3. Baja una mano y luego la otra para volver a plancha de antebrazos.
4. Alterna el brazo que sube primero en cada repetición.',
  tips = 'Mantén la cadera estable, sin rotar al subir y bajar.',
  video_url = 'https://www.youtube.com/results?search_query=plank+to+push+up'
WHERE id = 'a1000000-0000-0000-0000-000000000054';

-- =====================================================================
-- V8 — Cardio
-- =====================================================================

UPDATE exercises SET
  instructions = '1. De pie con el cuerpo ligeramente inclinado.
2. Trota en el sitio elevando las rodillas hasta la altura de la cadera.
3. Bombea los brazos coordinando con las piernas.
4. Mantén un ritmo constante durante el tiempo objetivo.',
  tips = 'La rodilla debe llegar al menos a la altura de la cadera para que cuente.',
  video_url = 'https://www.youtube.com/results?search_query=rodillas+altas+high+knees'
WHERE id = 'a1000000-0000-0000-0000-000000000060';

UPDATE exercises SET
  instructions = '1. De pie con el torso recto.
2. Trota en el sitio llevando los talones hacia los glúteos en cada paso.
3. Bombea los brazos al ritmo.
4. Mantén el ritmo durante el tiempo objetivo.',
  tips = 'Trabaja isquios y mejora la zancada de carrera. Buen calentamiento.',
  video_url = 'https://www.youtube.com/results?search_query=skipping+talones+gluteo'
WHERE id = 'a1000000-0000-0000-0000-000000000061';

UPDATE exercises SET
  instructions = '1. Sostén la comba con un extremo en cada mano, codos cerca del cuerpo.
2. Gira la comba con las muñecas, no con los brazos.
3. Salta sobre las puntas de los pies con saltos pequeños.
4. Encuentra tu ritmo y mantenlo.',
  tips = 'Saltos bajos y rápidos. Si no tienes comba, simula el movimiento.',
  video_url = 'https://www.youtube.com/results?search_query=saltar+a+la+comba+tecnica'
WHERE id = 'a1000000-0000-0000-0000-000000000062';

UPDATE exercises SET
  instructions = '1. Postura de boxeo: pierna no dominante adelante, manos arriba protegiendo la cara.
2. Lanza un jab (mano adelantada) recto al aire.
3. Sigue con un cross (mano trasera) rotando la cadera.
4. Vuelve a guardia y repite la combinación al ritmo.',
  tips = 'No bloquees los codos. Rota la cadera para sacar potencia al cross.',
  video_url = 'https://www.youtube.com/results?search_query=shadow+boxing+basico'
WHERE id = 'a1000000-0000-0000-0000-000000000063';

UPDATE exercises SET
  instructions = '1. De pie con un pie apoyado y el otro un poco levantado.
2. Salta lateralmente sobre el otro pie cubriendo una distancia cómoda.
3. Aterriza con suavidad y rebota inmediatamente al otro lado.
4. Mantén el ritmo lado a lado.',
  tips = 'Aterriza con la pierna ligeramente flexionada para amortiguar.',
  video_url = 'https://www.youtube.com/results?search_query=lateral+bounds+saltos+laterales'
WHERE id = 'a1000000-0000-0000-0000-000000000064';

-- =====================================================================
-- V8 — Yoga
-- =====================================================================

UPDATE exercises SET
  instructions = '1. Da un gran paso atrás con una pierna, gira ese pie 45-60 grados hacia fuera.
2. Flexiona la rodilla delantera a 90 grados sobre el tobillo.
3. Eleva los brazos hacia el techo, palmas enfrentadas o juntas.
4. Mantén la cadera centrada hacia adelante y respira con calma.',
  tips = 'La rodilla delantera nunca debe sobrepasar el tobillo. Hombros relajados.',
  video_url = 'https://www.youtube.com/results?search_query=postura+guerrero+1+yoga'
WHERE id = 'a1000000-0000-0000-0000-000000000070';

UPDATE exercises SET
  instructions = '1. Desde guerrero I, abre las caderas hacia el lateral.
2. Extiende los brazos en cruz a la altura de los hombros.
3. Mira hacia los dedos de la mano delantera.
4. Mantén la rodilla delantera flexionada y la trasera firme.',
  tips = 'La rodilla delantera debe seguir la dirección del pie. Hombros bajos.',
  video_url = 'https://www.youtube.com/results?search_query=postura+guerrero+2+yoga'
WHERE id = 'a1000000-0000-0000-0000-000000000071';

UPDATE exercises SET
  instructions = '1. De pie con el peso en una pierna, planta firme en el suelo.
2. Apoya la planta del otro pie en el muslo interno (nunca en la rodilla).
3. Junta las palmas frente al pecho o sube los brazos.
4. Fija la mirada en un punto delante para mantener el equilibrio.',
  tips = 'Si el equilibrio falla, apoya el pie en la pantorrilla o en el tobillo.',
  video_url = 'https://www.youtube.com/results?search_query=postura+arbol+yoga+vrksasana'
WHERE id = 'a1000000-0000-0000-0000-000000000072';

UPDATE exercises SET
  instructions = '1. Arrodíllate con los dedos gordos juntos y las rodillas separadas.
2. Siéntate sobre los talones.
3. Inclínate hacia adelante apoyando el torso entre las rodillas y la frente al suelo.
4. Brazos extendidos hacia adelante o relajados a los lados.',
  tips = 'Postura de descanso. Respira profundo sintiendo la espalda alargarse.',
  video_url = 'https://www.youtube.com/results?search_query=postura+nino+yoga+balasana'
WHERE id = 'a1000000-0000-0000-0000-000000000073';

UPDATE exercises SET
  instructions = '1. Túmbate boca abajo con las manos bajo los hombros.
2. Activa los glúteos y empuja con las manos para elevar el pecho.
3. Mantén los codos cerca del cuerpo y la cadera apoyada.
4. Mira al frente o ligeramente arriba sin tensionar el cuello.',
  tips = 'Empuja desde la espalda, no solo desde los brazos. Hombros lejos de las orejas.',
  video_url = 'https://www.youtube.com/results?search_query=postura+cobra+yoga'
WHERE id = 'a1000000-0000-0000-0000-000000000074';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con las rodillas flexionadas y los pies cerca de los glúteos.
2. Brazos extendidos a los lados con las palmas hacia abajo.
3. Empuja con los pies y eleva la cadera hasta formar línea recta.
4. Mantén glúteos activos y baja con control.',
  tips = 'No arquees la espalda en exceso. La fuerza viene de los glúteos.',
  video_url = 'https://www.youtube.com/results?search_query=postura+puente+yoga+setu+bandha'
WHERE id = 'a1000000-0000-0000-0000-000000000075';

UPDATE exercises SET
  instructions = '1. De pie con las piernas muy abiertas, pie derecho hacia fuera 90 grados.
2. Extiende los brazos en cruz.
3. Lateraliza el torso hacia la derecha bajando la mano hacia el tobillo o la espinilla.
4. Eleva el otro brazo al techo y mira la mano de arriba.',
  tips = 'No te encojas. Imagina que estás entre dos cristales paralelos.',
  video_url = 'https://www.youtube.com/results?search_query=postura+triangulo+yoga+trikonasana'
WHERE id = 'a1000000-0000-0000-0000-000000000076';

UPDATE exercises SET
  instructions = '1. De pie con las manos juntas en el pecho. Inhala subiendo brazos al techo.
2. Exhala bajando hasta tocar el suelo, salto atrás a plancha.
3. Baja a chaturanga, sube a cobra (inhalando).
4. Exhala al perro boca abajo, salta adelante y vuelve a estar de pie.',
  tips = 'Es una secuencia, no un ejercicio único. Acompasa con la respiración.',
  video_url = 'https://www.youtube.com/results?search_query=saludo+al+sol+yoga+surya+namaskara'
WHERE id = 'a1000000-0000-0000-0000-000000000077';

UPDATE exercises SET
  instructions = '1. De pie con los pies juntos.
2. Flexiona las rodillas como si te sentaras hacia atrás.
3. Eleva los brazos por encima de la cabeza, palmas enfrentadas.
4. Mantén el peso en los talones y respira.',
  tips = 'No metas las rodillas, deben estar alineadas con los pies.',
  video_url = 'https://www.youtube.com/results?search_query=postura+silla+yoga+utkatasana'
WHERE id = 'a1000000-0000-0000-0000-000000000078';

UPDATE exercises SET
  instructions = '1. Desde cuadrupedia, lleva una rodilla hacia adelante y apóyala a 90 grados.
2. La otra pierna queda extendida hacia atrás con el empeine apoyado.
3. Si la cadera no llega al suelo, apóyate sobre una manta o cojín.
4. Inclínate hacia adelante con el torso para profundizar la apertura.',
  tips = 'Postura intensa. Si duele la rodilla delantera, deshaz un poco.',
  video_url = 'https://www.youtube.com/results?search_query=postura+paloma+yoga+pigeon+pose'
WHERE id = 'a1000000-0000-0000-0000-000000000079';

-- =====================================================================
-- V8 — Movilidad
-- =====================================================================

UPDATE exercises SET
  instructions = '1. De pie con las manos en la cadera y los pies a la anchura de las caderas.
2. Realiza círculos amplios con la cadera en una dirección.
3. Hazlo lento sintiendo el rango completo.
4. Cambia la dirección a la mitad del tiempo.',
  tips = 'Círculos amplios y lentos, sin forzar.',
  video_url = 'https://www.youtube.com/results?search_query=circulos+cadera+movilidad'
WHERE id = 'a1000000-0000-0000-0000-000000000080';

UPDATE exercises SET
  instructions = '1. De pie con los brazos extendidos a los lados.
2. Realiza círculos amplios con los brazos hacia adelante.
3. Aumenta progresivamente el tamaño del círculo.
4. Cambia la dirección a la mitad del tiempo.',
  tips = 'Movimiento continuo y controlado. Buen calentamiento de hombros.',
  video_url = 'https://www.youtube.com/results?search_query=circulos+hombros+movilidad'
WHERE id = 'a1000000-0000-0000-0000-000000000081';

UPDATE exercises SET
  instructions = '1. Baja a sentadilla profunda con los pies algo más anchos que los hombros.
2. Apoya los codos por dentro de las rodillas y empuja suavemente hacia fuera.
3. Mantén la espalda erguida y el peso en los talones.
4. Respira con calma en la posición durante el tiempo objetivo.',
  tips = 'Si no llegas, coloca peso bajo los talones (libro, disco). Buena para tobillos.',
  video_url = 'https://www.youtube.com/results?search_query=sentadilla+profunda+squat+mobility'
WHERE id = 'a1000000-0000-0000-0000-000000000082';

UPDATE exercises SET
  instructions = '1. Desde plancha alta, da un paso amplio hasta poner el pie junto a la mano.
2. Apoya el codo del mismo lado dentro del pie y rota el torso hacia arriba.
3. Extiende el brazo libre al techo siguiendo con la mirada.
4. Vuelve al centro y cambia de lado.',
  tips = 'Movimiento muy completo. Combina movilidad de cadera, espalda y hombros.',
  video_url = 'https://www.youtube.com/results?search_query=worlds+greatest+stretch'
WHERE id = 'a1000000-0000-0000-0000-000000000083';

UPDATE exercises SET
  instructions = '1. En cuadrupedia, coloca una mano detrás de la cabeza.
2. Lleva el codo hacia el suelo cruzando el cuerpo (rotación cerrada).
3. Abre el codo hacia el techo siguiendo con la mirada (rotación abierta).
4. Repite varias veces y cambia de lado.',
  tips = 'Muy buena para liberar la zona dorsal de la espalda.',
  video_url = 'https://www.youtube.com/results?search_query=rotacion+toracica+thoracic+rotation'
WHERE id = 'a1000000-0000-0000-0000-000000000084';

UPDATE exercises SET
  instructions = '1. Sentado en el suelo, una pierna delante en 90 grados (cadera y rodilla).
2. La otra pierna a 90 grados al lateral.
3. Inclínate hacia adelante por encima de la pierna delantera.
4. Vuelve y repite hacia el otro lado.',
  tips = 'Postura intensa para caderas. Mantén la espalda recta.',
  video_url = 'https://www.youtube.com/results?search_query=90+90+hip+stretch'
WHERE id = 'a1000000-0000-0000-0000-000000000085';

UPDATE exercises SET
  instructions = '1. De pie con la espalda contra una pared, brazos en posición de portería (90 grados).
2. Manos, codos y muñecas en contacto con la pared.
3. Desliza los brazos hacia arriba intentando mantener el contacto.
4. Baja con control hasta volver a la posición inicial.',
  tips = 'Si los codos o las manos se despegan, no subas tan alto. Es normal.',
  video_url = 'https://www.youtube.com/results?search_query=scapular+wall+slides'
WHERE id = 'a1000000-0000-0000-0000-000000000086';

UPDATE exercises SET
  instructions = '1. De pie, inclínate hacia adelante y apoya las manos en el suelo.
2. Camina con las manos hacia adelante hasta llegar a plancha alta.
3. Camina los pies hacia las manos manteniendo las piernas casi rectas.
4. Vuelve a la posición inicial.',
  tips = 'Si las piernas no llegan rectas, flexiona ligeramente las rodillas. Excelente calentamiento.',
  video_url = 'https://www.youtube.com/results?search_query=inchworm+exercise'
WHERE id = 'a1000000-0000-0000-0000-000000000087';

-- =====================================================================
-- V8 — Estiramientos
-- =====================================================================

UPDATE exercises SET
  instructions = '1. Sentado en el suelo con una pierna extendida y la otra flexionada hacia dentro.
2. Inclínate hacia adelante sobre la pierna extendida.
3. Intenta alcanzar el pie o la espinilla.
4. Mantén el estiramiento respirando con calma.',
  tips = 'No fuerces ni rebotes. Si llegas a la espinilla, ya es estiramiento útil.',
  video_url = 'https://www.youtube.com/results?search_query=estiramiento+isquios+sentado'
WHERE id = 'a1000000-0000-0000-0000-000000000090';

UPDATE exercises SET
  instructions = '1. De pie, agarra el empeine de un pie y lleva el talón hacia el glúteo.
2. Mantén las rodillas juntas y el pecho arriba.
3. Empuja la cadera ligeramente hacia adelante para profundizar.
4. Apóyate en una pared si necesitas equilibrio.',
  tips = 'No saques la rodilla hacia adelante. Mantén las dos rodillas alineadas.',
  video_url = 'https://www.youtube.com/results?search_query=estiramiento+cuadriceps+pie'
WHERE id = 'a1000000-0000-0000-0000-000000000091';

UPDATE exercises SET
  instructions = '1. Sentado en el suelo, junta las plantas de los pies.
2. Sostén los pies con las manos y deja que las rodillas caigan hacia los lados.
3. Mantén la espalda erguida.
4. Inclínate hacia adelante para profundizar el estiramiento.',
  tips = 'Si las rodillas quedan muy altas, apoya cojines debajo.',
  video_url = 'https://www.youtube.com/results?search_query=estiramiento+mariposa+aductores'
WHERE id = 'a1000000-0000-0000-0000-000000000092';

UPDATE exercises SET
  instructions = '1. Sentado con las piernas extendidas.
2. Flexiona una rodilla y cruza el pie por encima de la otra pierna.
3. Gira el torso hacia el lado de la pierna flexionada.
4. Apoya el codo opuesto sobre la rodilla para profundizar.',
  tips = 'Movimiento lento. Respira profundo en la rotación.',
  video_url = 'https://www.youtube.com/results?search_query=torsion+espinal+sentado'
WHERE id = 'a1000000-0000-0000-0000-000000000093';

UPDATE exercises SET
  instructions = '1. Apoya las manos en una pared o objeto fijo.
2. Da un paso atrás con una pierna manteniendo el talón en el suelo.
3. La rodilla trasera extendida y la delantera flexionada.
4. Empuja la cadera hacia adelante sintiendo el estiramiento.',
  tips = 'Mantén el talón trasero pegado al suelo todo el tiempo.',
  video_url = 'https://www.youtube.com/results?search_query=estiramiento+gemelos+pared'
WHERE id = 'a1000000-0000-0000-0000-000000000094';

UPDATE exercises SET
  instructions = '1. De pie o sentado, junta las manos detrás de la espalda.
2. Estira los brazos hacia abajo y atrás.
3. Saca el pecho hacia adelante y aleja los hombros de las orejas.
4. Respira profundo y mantén la posición.',
  tips = 'Excelente para contrarrestar muchas horas sentado.',
  video_url = 'https://www.youtube.com/results?search_query=apertura+pecho+postura'
WHERE id = 'a1000000-0000-0000-0000-000000000095';

UPDATE exercises SET
  instructions = '1. De pie o sentado con la espalda recta.
2. Inclina la cabeza lentamente hacia un hombro.
3. Mantén unos segundos y vuelve al centro.
4. Repite hacia el otro lado, luego adelante y atrás.',
  tips = 'Movimientos lentos. No hagas círculos completos rápidos.',
  video_url = 'https://www.youtube.com/results?search_query=estiramiento+cuello+suave'
WHERE id = 'a1000000-0000-0000-0000-000000000096';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con las rodillas flexionadas.
2. Cruza el tobillo de una pierna sobre la rodilla contraria.
3. Toma la pierna de abajo y tira de ella hacia tu pecho.
4. Mantén el estiramiento respirando con calma.',
  tips = 'Si te cuesta llegar a la pierna, pasa una toalla por detrás de la rodilla.',
  video_url = 'https://www.youtube.com/results?search_query=estiramiento+piriforme+ciatico'
WHERE id = 'a1000000-0000-0000-0000-000000000097';

-- =====================================================================
-- V8 — Recuperación
-- =====================================================================

UPDATE exercises SET
  instructions = '1. Coloca el foam roller bajo los cuádriceps boca abajo.
2. Apóyate sobre los antebrazos y mantén el core activado.
3. Rueda lentamente desde la cadera hasta justo encima de la rodilla.
4. Detente unos segundos en los puntos más sensibles respirando profundo.',
  tips = 'No ruedes sobre la rodilla. Movimiento lento, no rápido.',
  video_url = 'https://www.youtube.com/results?search_query=foam+roller+cuadriceps'
WHERE id = 'a1000000-0000-0000-0000-0000000000a0';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con el foam roller bajo la zona dorsal (media espalda).
2. Cruza las manos sobre el pecho y eleva la cadera ligeramente.
3. Rueda suavemente desde la parte alta a la media de la espalda.
4. Evita rodar sobre la zona lumbar.',
  tips = 'NUNCA pases el roller por la zona lumbar. Solo dorsal y trapecio.',
  video_url = 'https://www.youtube.com/results?search_query=foam+roller+espalda'
WHERE id = 'a1000000-0000-0000-0000-0000000000a1';

UPDATE exercises SET
  instructions = '1. Sentado con las piernas extendidas, coloca el foam roller bajo los gemelos.
2. Apóyate en las manos por detrás y levanta la cadera ligeramente.
3. Rueda desde justo debajo de la rodilla hasta el tobillo.
4. Cruza una pierna sobre la otra para más presión si lo necesitas.',
  tips = 'Para más intensidad, cruza una pierna sobre la otra.',
  video_url = 'https://www.youtube.com/results?search_query=foam+roller+gemelos'
WHERE id = 'a1000000-0000-0000-0000-0000000000a2';

UPDATE exercises SET
  instructions = '1. Sentado o tumbado en posición cómoda.
2. Inhala lentamente por la nariz dirigiendo el aire al abdomen (4-5 segundos).
3. Exhala lentamente por la boca o nariz (5-6 segundos).
4. Repite manteniendo el ritmo consciente durante el tiempo objetivo.',
  tips = 'El abdomen sube y baja, no el pecho. Activa el parasimpático.',
  video_url = 'https://www.youtube.com/results?search_query=respiracion+diafragmatica+como+hacer'
WHERE id = 'a1000000-0000-0000-0000-0000000000a3';

UPDATE exercises SET
  instructions = '1. Túmbate boca arriba con las piernas y los brazos extendidos.
2. Palmas hacia arriba, pies relajados cayendo hacia los lados.
3. Cierra los ojos y suelta toda tensión muscular.
4. Respira de forma natural durante toda la postura.',
  tips = 'La postura más importante del yoga. No te duermas, mantente consciente.',
  video_url = 'https://www.youtube.com/results?search_query=savasana+yoga+relajacion'
WHERE id = 'a1000000-0000-0000-0000-0000000000a4';

UPDATE exercises SET
  instructions = '1. Acércate a una pared y túmbate boca arriba.
2. Sube las piernas apoyando los talones en la pared, glúteos cerca o pegados.
3. Brazos relajados a los lados.
4. Permanece respirando con calma durante el tiempo objetivo.',
  tips = 'Ayuda a la circulación de retorno. Si la lumbar molesta, separa más los glúteos de la pared.',
  video_url = 'https://www.youtube.com/results?search_query=piernas+en+la+pared+yoga'
WHERE id = 'a1000000-0000-0000-0000-0000000000a5';

UPDATE exercises SET
  instructions = '1. Túmbate cómodo y cierra los ojos.
2. Imagina un lugar tranquilo en detalle (playa, bosque, etc.).
3. Recórrelo mentalmente notando sonidos, olores, sensaciones.
4. Mantén la respiración lenta y profunda durante toda la práctica.',
  tips = 'Si te distraes con pensamientos, vuelve suavemente a la imagen del lugar.',
  video_url = 'https://www.youtube.com/results?search_query=visualizacion+guiada+relajacion'
WHERE id = 'a1000000-0000-0000-0000-0000000000a6';
