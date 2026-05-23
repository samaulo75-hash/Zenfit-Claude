-- =====================================================================
-- ZenFit — Ampliación del catálogo de entrenamiento
-- ~50 ejercicios nuevos + ~14 rutinas en cada tipo (STRENGTH, CARDIO,
-- HIIT, YOGA, MOBILITY, STRETCHING, RECOVERY) para llegar a ~15 por tipo.
-- =====================================================================

-- =====================================================================
-- EJERCICIOS NUEVOS
-- Convención de IDs: a1000000-0000-0000-0000-NNNNNNNN
-- =====================================================================

INSERT INTO exercises (id, name, description, difficulty, estimated_seconds, muscle_groups, equipment, is_premium) VALUES
 -- ----- Pierna / glúteo -----
 ('a1000000-0000-0000-0000-000000000001', 'Sentadilla búlgara',           'Sentadilla a una pierna con el pie trasero elevado.',         'INTERMEDIATE', 50, ARRAY['cuádriceps','glúteos'], ARRAY['banco'], FALSE),
 ('a1000000-0000-0000-0000-000000000002', 'Sentadilla con salto',          'Sentadilla explosiva con salto en cada repetición.',         'INTERMEDIATE', 45, ARRAY['cuádriceps','glúteos','cardio'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000003', 'Sentadilla sumo',               'Sentadilla con piernas muy abiertas y puntas hacia fuera.', 'BEGINNER',     45, ARRAY['cuádriceps','aductores','glúteos'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000004', 'Peso muerto rumano',            'Peso muerto con piernas casi rectas.',                       'INTERMEDIATE', 60, ARRAY['isquios','glúteos','espalda'], ARRAY['mancuernas'], FALSE),
 ('a1000000-0000-0000-0000-000000000005', 'Hip thrust',                    'Empuje de cadera apoyado en banco.',                         'INTERMEDIATE', 50, ARRAY['glúteos','isquios'], ARRAY['banco'], FALSE),
 ('a1000000-0000-0000-0000-000000000006', 'Step-up',                       'Subir a un banco alternando piernas.',                       'BEGINNER',     45, ARRAY['cuádriceps','glúteos'], ARRAY['banco'], FALSE),
 ('a1000000-0000-0000-0000-000000000007', 'Sentadilla goblet',             'Sentadilla sosteniendo una mancuerna en el pecho.',          'BEGINNER',     50, ARRAY['cuádriceps','glúteos','core'], ARRAY['mancuernas'], FALSE),
 ('a1000000-0000-0000-0000-000000000008', 'Sentadilla en pared',           'Posición isométrica con la espalda contra la pared.',        'BEGINNER',     60, ARRAY['cuádriceps','glúteos'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000009', 'Patada de glúteo',              'Extensión de cadera en cuadrupedia.',                        'BEGINNER',     45, ARRAY['glúteos','isquios'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-00000000000a', 'Elevación de gemelos',          'Subir y bajar sobre las puntas de los pies.',                'BEGINNER',     35, ARRAY['gemelos'], ARRAY[]::text[], FALSE),

 -- ----- Pecho / tríceps -----
 ('a1000000-0000-0000-0000-000000000010', 'Flexiones diamante',            'Flexiones con las manos formando un triángulo.',             'INTERMEDIATE', 40, ARRAY['tríceps','pecho'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000011', 'Flexiones inclinadas',          'Flexiones con las manos en superficie elevada.',             'BEGINNER',     40, ARRAY['pecho','tríceps'], ARRAY['banco'], FALSE),
 ('a1000000-0000-0000-0000-000000000012', 'Fondos en banco',               'Fondos de tríceps apoyado en banco.',                        'INTERMEDIATE', 45, ARRAY['tríceps','hombros'], ARRAY['banco'], FALSE),
 ('a1000000-0000-0000-0000-000000000013', 'Press de banca',                'Press horizontal con barra o mancuernas.',                   'INTERMEDIATE', 60, ARRAY['pecho','tríceps','hombros'], ARRAY['mancuernas'], FALSE),
 ('a1000000-0000-0000-0000-000000000014', 'Aperturas con mancuernas',      'Aperturas en banco para pecho.',                             'INTERMEDIATE', 50, ARRAY['pecho'], ARRAY['mancuernas','banco'], FALSE),

 -- ----- Espalda / bíceps -----
 ('a1000000-0000-0000-0000-000000000020', 'Dominadas',                     'Tracción vertical sosteniendo todo el peso del cuerpo.',     'ADVANCED',     45, ARRAY['espalda','bíceps'], ARRAY['barra'], FALSE),
 ('a1000000-0000-0000-0000-000000000021', 'Remo con mancuerna',            'Remo a una mano apoyado en banco.',                          'INTERMEDIATE', 50, ARRAY['espalda','bíceps'], ARRAY['mancuernas','banco'], FALSE),
 ('a1000000-0000-0000-0000-000000000022', 'Remo invertido',                'Remo horizontal colgando bajo una barra fija.',              'BEGINNER',     45, ARRAY['espalda','bíceps'], ARRAY['barra'], FALSE),
 ('a1000000-0000-0000-0000-000000000023', 'Superman',                      'Tumbado boca abajo, eleva brazos y piernas.',                'BEGINNER',     40, ARRAY['espalda','glúteos'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000024', 'Curl bíceps con mancuernas',    'Flexión de codo aislando bíceps.',                           'BEGINNER',     45, ARRAY['bíceps'], ARRAY['mancuernas'], FALSE),
 ('a1000000-0000-0000-0000-000000000025', 'Curl martillo',                 'Curl con agarre neutro (palmas enfrentadas).',               'BEGINNER',     45, ARRAY['bíceps','antebrazo'], ARRAY['mancuernas'], FALSE),

 -- ----- Hombros -----
 ('a1000000-0000-0000-0000-000000000030', 'Elevaciones laterales',         'Elevación lateral con mancuernas.',                          'BEGINNER',     40, ARRAY['hombros'], ARRAY['mancuernas'], FALSE),
 ('a1000000-0000-0000-0000-000000000031', 'Pájaros',                       'Elevación posterior para deltoides posterior.',              'BEGINNER',     40, ARRAY['hombros','espalda'], ARRAY['mancuernas'], FALSE),
 ('a1000000-0000-0000-0000-000000000032', 'Encogimientos de hombros',      'Trapecio: subir y bajar los hombros.',                       'BEGINNER',     40, ARRAY['trapecio','cuello'], ARRAY['mancuernas'], FALSE),

 -- ----- Core -----
 ('a1000000-0000-0000-0000-000000000040', 'Plancha lateral',               'Plancha apoyado en un antebrazo lateralmente.',              'INTERMEDIATE', 45, ARRAY['core','oblicuos'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000041', 'V-ups',                         'Encogimiento completo formando una V.',                      'INTERMEDIATE', 40, ARRAY['core'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000042', 'Russian twists',                'Rotación con torso elevado, sentado.',                       'BEGINNER',     40, ARRAY['oblicuos','core'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000043', 'Bicicleta abdominal',           'Movimiento de pedaleo tocando codo opuesto.',                'BEGINNER',     40, ARRAY['core','oblicuos'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000044', 'Hollow body hold',              'Mantener cuerpo en forma de cuna boca arriba.',              'INTERMEDIATE', 45, ARRAY['core'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000045', 'Dead bug',                      'Coordinación brazo-pierna contralateral en suelo.',          'BEGINNER',     45, ARRAY['core'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000046', 'Bird dog',                      'Equilibrio en cuadrupedia con brazo y pierna opuestos.',     'BEGINNER',     45, ARRAY['core','espalda'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000047', 'Elevación de piernas',          'Tumbado boca arriba, subir y bajar piernas rectas.',         'INTERMEDIATE', 40, ARRAY['core'], ARRAY[]::text[], FALSE),

 -- ----- Explosivos / HIIT -----
 ('a1000000-0000-0000-0000-000000000050', 'Box jumps',                     'Saltos pliométricos a una caja.',                            'INTERMEDIATE', 40, ARRAY['cuádriceps','glúteos','cardio'], ARRAY['caja'], FALSE),
 ('a1000000-0000-0000-0000-000000000051', 'Kettlebell swing',              'Balanceo de kettlebell desde la cadera.',                    'INTERMEDIATE', 40, ARRAY['glúteos','core','cardio'], ARRAY['kettlebell'], FALSE),
 ('a1000000-0000-0000-0000-000000000052', 'Sprint en sitio',               'Carrera a máxima velocidad sin desplazarse.',                'BEGINNER',     30, ARRAY['cardio','piernas'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000053', 'Jumping lunges',                'Zancadas con salto alternando piernas en el aire.',          'ADVANCED',     40, ARRAY['cuádriceps','glúteos','cardio'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000054', 'Plank to push-up',              'Pasar de plancha de antebrazos a plancha de manos.',         'INTERMEDIATE', 45, ARRAY['core','pecho','hombros'], ARRAY[]::text[], FALSE),

 -- ----- Cardio -----
 ('a1000000-0000-0000-0000-000000000060', 'Rodillas altas',                'Trotar en el sitio elevando las rodillas al pecho.',         'BEGINNER',     40, ARRAY['cardio','core'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000061', 'Skipping',                      'Carrera en el sitio llevando los talones a glúteo.',         'BEGINNER',     40, ARRAY['cardio','isquios'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000062', 'Saltar a la comba',             'Saltos de cuerda al ritmo.',                                 'BEGINNER',     45, ARRAY['cardio','gemelos'], ARRAY['comba'], FALSE),
 ('a1000000-0000-0000-0000-000000000063', 'Shadow boxing',                 'Boxeo al aire combinando jab y cross.',                      'BEGINNER',     45, ARRAY['cardio','hombros'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000064', 'Bounds laterales',              'Saltos laterales de pierna a pierna.',                       'INTERMEDIATE', 35, ARRAY['cardio','glúteos'], ARRAY[]::text[], FALSE),

 -- ----- Yoga -----
 ('a1000000-0000-0000-0000-000000000070', 'Postura del guerrero I',        'Pierna delantera flexionada, brazos arriba.',                'BEGINNER',     45, ARRAY['piernas','core'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000071', 'Postura del guerrero II',       'Brazos abiertos en cruz, mirada al frente.',                 'INTERMEDIATE', 50, ARRAY['piernas','hombros'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000072', 'Postura del árbol',             'Equilibrio sobre una pierna, planta apoyada en muslo.',      'BEGINNER',     45, ARRAY['equilibrio','core'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000073', 'Postura del niño',              'Sentado sobre talones con torso al suelo.',                  'BEGINNER',     60, ARRAY['relajación','espalda'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000074', 'Postura de la cobra',           'Tumbado boca abajo, eleva el pecho con los brazos.',         'BEGINNER',     40, ARRAY['espalda','pecho'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000075', 'Postura del puente',            'Tumbado boca arriba, eleva la cadera.',                      'BEGINNER',     45, ARRAY['glúteos','espalda'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000076', 'Postura del triángulo',         'Lateralización profunda alcanzando el tobillo.',             'INTERMEDIATE', 50, ARRAY['flexibilidad','piernas'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000077', 'Saludo al sol',                 'Secuencia clásica vinyasa de 12 movimientos.',               'INTERMEDIATE', 90, ARRAY['cuerpo completo','movilidad'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000078', 'Postura de la silla',           'Sentadilla profunda con brazos arriba.',                     'BEGINNER',     45, ARRAY['cuádriceps','core'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000079', 'Postura de la paloma',          'Apertura profunda de cadera.',                               'INTERMEDIATE', 60, ARRAY['flexibilidad','cadera'], ARRAY['esterilla'], FALSE),

 -- ----- Movilidad -----
 ('a1000000-0000-0000-0000-000000000080', 'Círculos de cadera',            'Movilidad articular de cadera en pie.',                      'BEGINNER',     40, ARRAY['movilidad','cadera'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000081', 'Círculos de hombro',            'Rotaciones grandes de los brazos.',                          'BEGINNER',     30, ARRAY['movilidad','hombros'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000082', 'Sentadilla profunda mantenida', 'Mantén la sentadilla más baja posible.',                     'INTERMEDIATE', 60, ARRAY['movilidad','cadera','tobillos'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000083', 'World''s greatest stretch',     'Estiramiento dinámico que abre todo el cuerpo.',             'INTERMEDIATE', 60, ARRAY['movilidad','cuerpo completo'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000084', 'Rotación torácica',             'Rotaciones de columna en cuadrupedia.',                      'BEGINNER',     45, ARRAY['movilidad','espalda'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000085', '90/90 hip stretch',             'Estiramiento de cadera 90 grados.',                          'INTERMEDIATE', 60, ARRAY['movilidad','cadera'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000086', 'Scapular wall slides',          'Deslizamiento de escápulas contra pared.',                   'BEGINNER',     40, ARRAY['movilidad','hombros'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000087', 'Inchworm',                      'Caminar con las manos hasta plancha y volver.',              'INTERMEDIATE', 50, ARRAY['movilidad','isquios','core'], ARRAY['esterilla'], FALSE),

 -- ----- Estiramientos -----
 ('a1000000-0000-0000-0000-000000000090', 'Estiramiento de isquios',       'Sentado, alcanzar las puntas de los pies.',                  'BEGINNER',     45, ARRAY['isquios'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000091', 'Cuádriceps de pie',             'De pie, llevar talón al glúteo.',                            'BEGINNER',     40, ARRAY['cuádriceps'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000092', 'Mariposa',                      'Sentado con plantas de los pies juntas.',                    'BEGINNER',     50, ARRAY['aductores','cadera'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000093', 'Torsión espinal sentado',       'Rotación de la columna sentado.',                            'BEGINNER',     45, ARRAY['espalda'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-000000000094', 'Estiramiento de gemelos',       'Pierna atrás con talón al suelo.',                           'BEGINNER',     40, ARRAY['gemelos'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000095', 'Apertura de pecho',             'Manos detrás, llevar pecho hacia delante.',                  'BEGINNER',     40, ARRAY['pecho','hombros'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000096', 'Estiramiento de cuello',        'Inclinar y rotar la cabeza con suavidad.',                   'BEGINNER',     40, ARRAY['cuello'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-000000000097', 'Estiramiento del piriforme',    'Tumbado, cruza tobillo sobre la rodilla.',                   'BEGINNER',     45, ARRAY['glúteos','cadera'], ARRAY['esterilla'], FALSE),

 -- ----- Recuperación -----
 ('a1000000-0000-0000-0000-0000000000a0', 'Foam rolling cuádriceps',       'Auto-masaje miofascial del cuádriceps.',                     'BEGINNER',     60, ARRAY['recuperación','cuádriceps'], ARRAY['foam roller'], FALSE),
 ('a1000000-0000-0000-0000-0000000000a1', 'Foam rolling espalda',          'Auto-masaje de la espalda alta.',                            'BEGINNER',     60, ARRAY['recuperación','espalda'], ARRAY['foam roller'], FALSE),
 ('a1000000-0000-0000-0000-0000000000a2', 'Foam rolling gemelos',          'Auto-masaje miofascial de gemelos.',                         'BEGINNER',     60, ARRAY['recuperación','gemelos'], ARRAY['foam roller'], FALSE),
 ('a1000000-0000-0000-0000-0000000000a3', 'Respiración diafragmática',     'Respiración lenta y profunda con el abdomen.',               'BEGINNER',     60, ARRAY['recuperación','respiración'], ARRAY[]::text[], FALSE),
 ('a1000000-0000-0000-0000-0000000000a4', 'Savasana',                      'Postura de descanso final tumbado.',                         'BEGINNER',     90, ARRAY['recuperación','relajación'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-0000000000a5', 'Piernas en la pared',           'Tumbado boca arriba, piernas verticales en la pared.',       'BEGINNER',     90, ARRAY['recuperación','circulación'], ARRAY['esterilla'], FALSE),
 ('a1000000-0000-0000-0000-0000000000a6', 'Visualización guiada',          'Imágenes mentales relajantes con respiración lenta.',        'BEGINNER',     90, ARRAY['recuperación','mental'], ARRAY[]::text[], FALSE);

-- =====================================================================
-- RUTINAS NUEVAS — STRENGTH (fuerza)
-- =====================================================================
INSERT INTO workouts (id, name, description, type, difficulty, estimated_duration_minutes, is_premium) VALUES
 ('b1000000-0000-0000-0000-000000000001', 'Tren inferior básico',           'Pierna sin material para principiantes.',                'STRENGTH', 'BEGINNER',     22, FALSE),
 ('b1000000-0000-0000-0000-000000000002', 'Push Day',                       'Día de empuje: pecho, hombros, tríceps.',                'STRENGTH', 'INTERMEDIATE', 35, FALSE),
 ('b1000000-0000-0000-0000-000000000003', 'Pull Day',                       'Día de tirón: espalda y bíceps.',                        'STRENGTH', 'INTERMEDIATE', 35, FALSE),
 ('b1000000-0000-0000-0000-000000000004', 'Leg Day',                        'Día completo de piernas y glúteos.',                     'STRENGTH', 'INTERMEDIATE', 40, FALSE),
 ('b1000000-0000-0000-0000-000000000005', 'Glúteos al rojo vivo',           'Sesión enfocada al desarrollo de glúteos.',              'STRENGTH', 'INTERMEDIATE', 30, FALSE),
 ('b1000000-0000-0000-0000-000000000006', 'Brazos definidos',               'Bíceps y tríceps con mancuernas.',                       'STRENGTH', 'BEGINNER',     25, FALSE),
 ('b1000000-0000-0000-0000-000000000007', 'Espalda fuerte',                 'Rutina para una espalda potente y postura sana.',        'STRENGTH', 'INTERMEDIATE', 30, FALSE),
 ('b1000000-0000-0000-0000-000000000008', 'Full body sin material',         'Cuerpo completo solo con peso corporal.',                'STRENGTH', 'BEGINNER',     28, FALSE),
 ('b1000000-0000-0000-0000-000000000009', 'Full body con mancuernas',       'Cuerpo completo con par de mancuernas.',                 'STRENGTH', 'INTERMEDIATE', 35, FALSE),
 ('b1000000-0000-0000-0000-00000000000a', 'Tren superior express',          'Pecho, espalda y hombros en 20 minutos.',                'STRENGTH', 'INTERMEDIATE', 22, FALSE),
 ('b1000000-0000-0000-0000-00000000000b', 'Sentadillas a fondo',            'Variantes de sentadilla para piernas potentes.',         'STRENGTH', 'INTERMEDIATE', 25, FALSE),
 ('b1000000-0000-0000-0000-00000000000c', 'Powerbuilding casero',           'Mezcla fuerza + hipertrofia sin gimnasio.',              'STRENGTH', 'ADVANCED',     45, FALSE),
 ('b1000000-0000-0000-0000-00000000000d', 'Hombros 3D',                     'Trabajo de los tres haces del deltoides.',               'STRENGTH', 'INTERMEDIATE', 22, FALSE);

-- workout_exercises STRENGTH
INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, duration_seconds, rest_seconds) VALUES
 -- Tren inferior básico
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 0, 3, 15, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000003', 1, 3, 12, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000004', 2, 3, 12, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000009', 3, 3, 12, NULL, 30),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-00000000000a', 4, 3, 20, NULL, 30),

 -- Push Day
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 0, 4, 12, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000013', 1, 4, 10, NULL, 60),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000009', 2, 4, 10, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000030', 3, 3, 12, NULL, 30),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000012', 4, 3, 12, NULL, 30),

 -- Pull Day
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000020', 0, 4, 6, NULL, 90),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000021', 1, 4, 10, NULL, 60),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000022', 2, 3, 10, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000024', 3, 3, 12, NULL, 30),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000025', 4, 3, 12, NULL, 30),

 -- Leg Day
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000007', 0, 4, 12, NULL, 60),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 1, 3, 10, NULL, 50),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000004', 2, 4, 10, NULL, 60),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000005', 3, 4, 12, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-00000000000a', 4, 4, 20, NULL, 30),

 -- Glúteos al rojo vivo
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000005', 0, 4, 12, NULL, 50),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000003', 1, 4, 15, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000009', 2, 4, 15, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000001', 3, 3, 10, NULL, 40),

 -- Brazos definidos
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000024', 0, 4, 12, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000025', 1, 4, 12, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000012', 2, 4, 12, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000010', 3, 3, 10, NULL, 40),

 -- Espalda fuerte
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000022', 0, 4, 10, NULL, 60),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000021', 1, 4, 10, NULL, 60),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000023', 2, 3, 15, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000046', 3, 3, 12, NULL, 30),

 -- Full body sin material
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000002', 0, 3, 15, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000001', 1, 3, 10, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000004', 2, 3, 12, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-00000000000c', 3, 3, 15, NULL, 30),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000003', 4, 3, NULL, 30, 30),

 -- Full body con mancuernas
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000007', 0, 4, 12, NULL, 50),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000021', 1, 4, 10, NULL, 50),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000009', 2, 4, 10, NULL, 50),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000024', 3, 3, 12, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000045', 4, 3, 12, NULL, 30),

 -- Tren superior express
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-000000000001', 0, 4, 12, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000022', 1, 4, 10, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-000000000009', 2, 3, 10, NULL, 40),

 -- Sentadillas a fondo
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000b', 'a0000000-0000-0000-0000-000000000002', 0, 4, 15, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000003', 1, 4, 12, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000001', 2, 3, 10, NULL, 50),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000008', 3, 3, NULL, 60, 30),

 -- Powerbuilding casero
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000020', 0, 4, 6, NULL, 90),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000013', 1, 4, 8, NULL, 90),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000004', 2, 4, 8, NULL, 90),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000c', 'a0000000-0000-0000-0000-000000000005', 3, 3, 10, NULL, 45),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000041', 4, 3, 12, NULL, 30),

 -- Hombros 3D
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000d', 'a0000000-0000-0000-0000-000000000009', 0, 4, 10, NULL, 50),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000030', 1, 4, 12, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000031', 2, 4, 12, NULL, 40),
 (gen_random_uuid(), 'b1000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000032', 3, 3, 15, NULL, 30);

-- =====================================================================
-- RUTINAS NUEVAS — CARDIO
-- =====================================================================
INSERT INTO workouts (id, name, description, type, difficulty, estimated_duration_minutes, is_premium) VALUES
 ('b2000000-0000-0000-0000-000000000001', 'Cardio matutino 10 min',         'Despierta el cuerpo con cardio ligero.',                  'CARDIO', 'BEGINNER',     10, FALSE),
 ('b2000000-0000-0000-0000-000000000002', 'Carrera en el sitio',            'Trote intenso sin desplazarte.',                          'CARDIO', 'BEGINNER',     15, FALSE),
 ('b2000000-0000-0000-0000-000000000003', 'Comba a máxima velocidad',       'Saltos de comba en intervalos.',                          'CARDIO', 'INTERMEDIATE', 18, FALSE),
 ('b2000000-0000-0000-0000-000000000004', 'Boxeo en casa',                  'Combinaciones de boxeo al aire.',                         'CARDIO', 'INTERMEDIATE', 20, FALSE),
 ('b2000000-0000-0000-0000-000000000005', 'Cardio quema grasa',             'Mezcla intensa para quemar calorías.',                    'CARDIO', 'INTERMEDIATE', 22, FALSE),
 ('b2000000-0000-0000-0000-000000000006', 'Resistencia 30 min',             'Cardio sostenido para mejorar el fondo.',                 'CARDIO', 'INTERMEDIATE', 30, FALSE),
 ('b2000000-0000-0000-0000-000000000007', 'Cardio explosivo',               'Trabajo pliométrico para potencia.',                      'CARDIO', 'ADVANCED',     20, FALSE),
 ('b2000000-0000-0000-0000-000000000008', 'Cardio + Core',                  'Alterna cardio con abdominales.',                         'CARDIO', 'INTERMEDIATE', 25, FALSE),
 ('b2000000-0000-0000-0000-000000000009', 'Cardio lateral',                 'Trabaja el plano lateral con saltos.',                    'CARDIO', 'INTERMEDIATE', 18, FALSE),
 ('b2000000-0000-0000-0000-00000000000a', 'Tabata cardio',                  '20s todo y 10s descanso, 8 rondas.',                      'CARDIO', 'ADVANCED',     15, FALSE),
 ('b2000000-0000-0000-0000-00000000000b', 'Cardio para principiantes',      'Inicio suave para empezar.',                              'CARDIO', 'BEGINNER',     12, FALSE),
 ('b2000000-0000-0000-0000-00000000000c', 'Cardio sin saltos',              'Cardio low-impact para articulaciones sensibles.',        'CARDIO', 'BEGINNER',     20, FALSE),
 ('b2000000-0000-0000-0000-00000000000d', 'Sprint intervals',               'Sprints intensos con descansos cortos.',                  'CARDIO', 'ADVANCED',     16, FALSE),
 ('b2000000-0000-0000-0000-00000000000e', 'Cardio funcional',               'Movimientos atléticos para quemar grasa.',                'CARDIO', 'INTERMEDIATE', 25, FALSE);

INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, duration_seconds, rest_seconds) VALUES
 -- Cardio matutino 10 min
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000007', 0, 3, NULL, 40, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000060', 1, 3, NULL, 30, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000061', 2, 3, NULL, 30, 20),

 -- Carrera en el sitio
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000060', 0, 4, NULL, 45, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000061', 1, 4, NULL, 45, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000052', 2, 3, NULL, 20, 30),

 -- Comba a máxima velocidad
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000062', 0, 5, NULL, 60, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000062', 1, 3, NULL, 30, 20),

 -- Boxeo en casa
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000063', 0, 5, NULL, 60, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000007', 1, 3, NULL, 40, 20),

 -- Cardio quema grasa
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000005', 0, 4, NULL, 30, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000006', 1, 4, NULL, 30, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000060', 2, 4, NULL, 30, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000007', 3, 4, NULL, 30, 20),

 -- Resistencia 30 min
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000060', 0, 5, NULL, 60, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000061', 1, 5, NULL, 60, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000007', 2, 4, NULL, 60, 30),

 -- Cardio explosivo
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000050', 0, 4, 10, NULL, 40),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000053', 1, 4, NULL, 30, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000002', 2, 4, 12, NULL, 30),

 -- Cardio + Core
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000007', 0, 4, NULL, 40, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-00000000000c', 1, 4, 20, NULL, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000060', 2, 4, NULL, 40, 20),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000043', 3, 4, 20, NULL, 30),

 -- Cardio lateral
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000064', 0, 4, NULL, 30, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000004', 1, 4, 16, NULL, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000007', 2, 3, NULL, 30, 30),

 -- Tabata cardio
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-000000000005', 0, 4, NULL, 20, 10),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-000000000006', 1, 4, NULL, 20, 10),

 -- Cardio para principiantes
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000b', 'a0000000-0000-0000-0000-000000000007', 0, 3, NULL, 30, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000060', 1, 3, NULL, 30, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000061', 2, 3, NULL, 30, 30),

 -- Cardio sin saltos
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000063', 0, 4, NULL, 60, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000087', 1, 3, NULL, 45, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000c', 'a0000000-0000-0000-0000-000000000004', 2, 3, 12, NULL, 30),

 -- Sprint intervals
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000052', 0, 6, NULL, 30, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000060', 1, 4, NULL, 30, 30),

 -- Cardio funcional
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000e', 'a0000000-0000-0000-0000-000000000005', 0, 4, 10, NULL, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000051', 1, 4, 15, NULL, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000050', 2, 4, 10, NULL, 30),
 (gen_random_uuid(), 'b2000000-0000-0000-0000-00000000000e', 'a0000000-0000-0000-0000-000000000007', 3, 3, NULL, 30, 20);

-- =====================================================================
-- RUTINAS NUEVAS — HIIT
-- =====================================================================
INSERT INTO workouts (id, name, description, type, difficulty, estimated_duration_minutes, is_premium) VALUES
 ('b3000000-0000-0000-0000-000000000001', 'HIIT Express 10 min',            'Sesión cortita pero brutal.',                             'HIIT', 'INTERMEDIATE', 10, FALSE),
 ('b3000000-0000-0000-0000-000000000002', 'HIIT Tabata clásico',            '8 rondas de 20s/10s en cada ejercicio.',                 'HIIT', 'INTERMEDIATE', 16, FALSE),
 ('b3000000-0000-0000-0000-000000000003', 'HIIT cuerpo entero',             'Movimientos compuestos para todo el cuerpo.',             'HIIT', 'INTERMEDIATE', 20, FALSE),
 ('b3000000-0000-0000-0000-000000000004', 'HIIT inferior',                  'Tren inferior a alta intensidad.',                        'HIIT', 'INTERMEDIATE', 18, FALSE),
 ('b3000000-0000-0000-0000-000000000005', 'HIIT superior',                  'Tren superior y core con intensidad.',                    'HIIT', 'INTERMEDIATE', 18, FALSE),
 ('b3000000-0000-0000-0000-000000000006', 'HIIT principiante',              'Iniciación a HIIT con descansos generosos.',              'HIIT', 'BEGINNER',     15, FALSE),
 ('b3000000-0000-0000-0000-000000000007', 'HIIT avanzado',                  'Para los que ya tienen base.',                            'HIIT', 'ADVANCED',     25, FALSE),
 ('b3000000-0000-0000-0000-000000000008', 'HIIT sin saltos',                'Alta intensidad cuidando las articulaciones.',            'HIIT', 'BEGINNER',     18, FALSE),
 ('b3000000-0000-0000-0000-000000000009', 'EMOM 12 minutos',                'Every Minute On the Minute: 12 rondas.',                  'HIIT', 'INTERMEDIATE', 12, FALSE),
 ('b3000000-0000-0000-0000-00000000000a', 'AMRAP 15',                       'Tantas rondas como puedas en 15 minutos.',                'HIIT', 'INTERMEDIATE', 15, FALSE),
 ('b3000000-0000-0000-0000-00000000000b', 'HIIT con mancuernas',            'Alta intensidad con par de mancuernas.',                  'HIIT', 'INTERMEDIATE', 22, FALSE),
 ('b3000000-0000-0000-0000-00000000000c', 'HIIT kettlebell',                'Sesión basada en kettlebell swings.',                     'HIIT', 'INTERMEDIATE', 20, FALSE),
 ('b3000000-0000-0000-0000-00000000000d', 'HIIT abdominal',                 'Core a alta intensidad.',                                 'HIIT', 'INTERMEDIATE', 12, FALSE),
 ('b3000000-0000-0000-0000-00000000000e', 'HIIT funcional',                 'Movimientos atléticos a tope.',                           'HIIT', 'ADVANCED',     22, FALSE);

INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, duration_seconds, rest_seconds) VALUES
 -- HIIT Express 10 min
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000005', 0, 4, NULL, 30, 15),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000006', 1, 4, NULL, 30, 15),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000007', 2, 4, NULL, 30, 15),

 -- HIIT Tabata clásico
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000005', 0, 8, NULL, 20, 10),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002', 1, 8, NULL, 20, 10),

 -- HIIT cuerpo entero
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000005', 0, 4, NULL, 40, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000054', 1, 4, NULL, 40, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000051', 2, 4, 15, NULL, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000006', 3, 4, NULL, 40, 20),

 -- HIIT inferior
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000002', 0, 4, NULL, 30, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000053', 1, 4, NULL, 30, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000004', 2, 4, 12, NULL, 20),

 -- HIIT superior
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000001', 0, 4, NULL, 30, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000054', 1, 4, NULL, 30, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000006', 2, 4, NULL, 30, 20),

 -- HIIT principiante
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000007', 0, 3, NULL, 30, 30),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000002', 1, 3, 12, NULL, 30),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000060', 2, 3, NULL, 30, 30),

 -- HIIT avanzado
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000005', 0, 5, NULL, 45, 15),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000053', 1, 5, NULL, 45, 15),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000050', 2, 5, 10, NULL, 15),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000054', 3, 5, NULL, 45, 15),

 -- HIIT sin saltos
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000002', 0, 4, 15, NULL, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000001', 1, 4, 12, NULL, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000063', 2, 4, NULL, 45, 20),

 -- EMOM 12 minutos
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000005', 0, 4, 8, NULL, 30),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000001', 1, 4, 12, NULL, 30),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000041', 2, 4, 10, NULL, 30),

 -- AMRAP 15
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-000000000005', 0, 5, 8, NULL, 0),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-000000000002', 1, 5, 12, NULL, 0),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-000000000001', 2, 5, 10, NULL, 30),

 -- HIIT con mancuernas
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000007', 0, 4, 12, NULL, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000b', 'a0000000-0000-0000-0000-000000000009', 1, 4, 10, NULL, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000021', 2, 4, 10, NULL, 20),

 -- HIIT kettlebell
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000051', 0, 5, 15, NULL, 30),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000007', 1, 4, 12, NULL, 30),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000005', 2, 4, 12, NULL, 30),

 -- HIIT abdominal
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000d', 'a0000000-0000-0000-0000-000000000006', 0, 4, NULL, 30, 15),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000041', 1, 4, 12, NULL, 15),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000043', 2, 4, NULL, 30, 15),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000d', 'a0000000-0000-0000-0000-000000000003', 3, 4, NULL, 30, 15),

 -- HIIT funcional
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000e', 'a0000000-0000-0000-0000-000000000005', 0, 5, NULL, 40, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000050', 1, 5, 8, NULL, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000054', 2, 5, NULL, 40, 20),
 (gen_random_uuid(), 'b3000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000087', 3, 5, NULL, 40, 20);

-- =====================================================================
-- RUTINAS NUEVAS — YOGA
-- =====================================================================
INSERT INTO workouts (id, name, description, type, difficulty, estimated_duration_minutes, is_premium) VALUES
 ('b4000000-0000-0000-0000-000000000001', 'Yoga matutino',                  'Despierta tu cuerpo con secuencias suaves.',              'YOGA', 'BEGINNER',     20, FALSE),
 ('b4000000-0000-0000-0000-000000000002', 'Saludos al sol',                 'Series de saludos al sol clásicos.',                      'YOGA', 'INTERMEDIATE', 20, FALSE),
 ('b4000000-0000-0000-0000-000000000003', 'Yoga para flexibilidad',         'Apertura profunda de cadera y espalda.',                  'YOGA', 'INTERMEDIATE', 25, FALSE),
 ('b4000000-0000-0000-0000-000000000004', 'Yoga para deportistas',          'Posturas centradas en piernas y cadera.',                 'YOGA', 'INTERMEDIATE', 22, FALSE),
 ('b4000000-0000-0000-0000-000000000005', 'Yoga restaurativo',              'Sesión pasiva para relajar el sistema nervioso.',         'YOGA', 'BEGINNER',     30, FALSE),
 ('b4000000-0000-0000-0000-000000000006', 'Yoga power',                     'Versión potente y dinámica del yoga.',                    'YOGA', 'ADVANCED',     30, FALSE),
 ('b4000000-0000-0000-0000-000000000007', 'Yoga para la espalda',           'Alivia tensión y mejora postura.',                        'YOGA', 'BEGINNER',     20, FALSE),
 ('b4000000-0000-0000-0000-000000000008', 'Yoga de equilibrio',             'Mejora propiocepción y concentración.',                   'YOGA', 'INTERMEDIATE', 18, FALSE),
 ('b4000000-0000-0000-0000-000000000009', 'Yoga para dormir',               'Secuencia relajante antes de la cama.',                   'YOGA', 'BEGINNER',     15, FALSE),
 ('b4000000-0000-0000-0000-00000000000a', 'Yoga vinyasa',                   'Flujo continuo de posturas con respiración.',             'YOGA', 'INTERMEDIATE', 25, FALSE),
 ('b4000000-0000-0000-0000-00000000000b', 'Yoga hatha',                     'Posturas estáticas con énfasis en alineación.',           'YOGA', 'BEGINNER',     25, FALSE),
 ('b4000000-0000-0000-0000-00000000000c', 'Yoga para la oficina',           'Sesión corta para escritorio.',                           'YOGA', 'BEGINNER',     12, FALSE),
 ('b4000000-0000-0000-0000-00000000000d', 'Yoga abridor de caderas',        'Posturas profundas para abrir caderas.',                  'YOGA', 'INTERMEDIATE', 22, FALSE),
 ('b4000000-0000-0000-0000-00000000000e', 'Yoga full body',                 'Trabajo equilibrado de todo el cuerpo.',                  'YOGA', 'INTERMEDIATE', 25, FALSE);

INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, duration_seconds, rest_seconds) VALUES
 -- Yoga matutino
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-00000000000a', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-00000000000b', 1, 2, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000074', 2, 2, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000073', 3, 1, NULL, 60, 0),

 -- Saludos al sol
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000077', 0, 5, NULL, 90, 30),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000073', 1, 1, NULL, 60, 0),

 -- Yoga para flexibilidad
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000079', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000076', 1, 2, NULL, 50, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000092', 2, 1, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000093', 3, 2, NULL, 45, 15),

 -- Yoga para deportistas
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000070', 0, 2, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000071', 1, 2, NULL, 50, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000079', 2, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000075', 3, 2, NULL, 45, 15),

 -- Yoga restaurativo
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000073', 0, 2, NULL, 90, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-0000000000a5', 1, 1, NULL, 120, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-0000000000a4', 2, 1, NULL, 180, 0),

 -- Yoga power
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000077', 0, 5, NULL, 90, 20),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000071', 1, 3, NULL, 60, 20),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000078', 2, 3, NULL, 60, 20),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000076', 3, 2, NULL, 60, 20),

 -- Yoga para la espalda
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-00000000000b', 0, 3, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000074', 1, 2, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000073', 2, 1, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000093', 3, 2, NULL, 45, 15),

 -- Yoga de equilibrio
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000072', 0, 3, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000070', 1, 2, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000078', 2, 2, NULL, 60, 15),

 -- Yoga para dormir
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000073', 0, 1, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-0000000000a5', 1, 1, NULL, 120, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-0000000000a4', 2, 1, NULL, 180, 0),

 -- Yoga vinyasa
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000077', 0, 4, NULL, 90, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000071', 1, 2, NULL, 50, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-00000000000a', 2, 2, NULL, 60, 15),

 -- Yoga hatha
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000070', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000071', 1, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000072', 2, 2, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000076', 3, 2, NULL, 50, 15),

 -- Yoga para la oficina
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000093', 0, 2, NULL, 30, 10),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000095', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000096', 2, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000c', 'a0000000-0000-0000-0000-00000000000b', 3, 2, NULL, 45, 10),

 -- Yoga abridor de caderas
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000079', 0, 2, NULL, 90, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000085', 1, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000092', 2, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000097', 3, 2, NULL, 50, 15),

 -- Yoga full body
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000077', 0, 3, NULL, 90, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000070', 1, 2, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000076', 2, 2, NULL, 50, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000075', 3, 2, NULL, 45, 15),
 (gen_random_uuid(), 'b4000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000073', 4, 1, NULL, 60, 0);

-- =====================================================================
-- RUTINAS NUEVAS — MOBILITY
-- =====================================================================
INSERT INTO workouts (id, name, description, type, difficulty, estimated_duration_minutes, is_premium) VALUES
 ('b5000000-0000-0000-0000-000000000001', 'Movilidad articular completa',   'Despierta todas las articulaciones del cuerpo.',          'MOBILITY', 'BEGINNER',     15, FALSE),
 ('b5000000-0000-0000-0000-000000000002', 'Movilidad de cadera',            'Apertura y rango completo de cadera.',                    'MOBILITY', 'INTERMEDIATE', 18, FALSE),
 ('b5000000-0000-0000-0000-000000000003', 'Movilidad de hombro',            'Para hombros sanos y libres de molestias.',               'MOBILITY', 'BEGINNER',     12, FALSE),
 ('b5000000-0000-0000-0000-000000000004', 'Movilidad de columna',           'Trabaja la espalda en todos sus planos.',                 'MOBILITY', 'BEGINNER',     15, FALSE),
 ('b5000000-0000-0000-0000-000000000005', 'Movilidad pre-entreno',          'Calentamiento dinámico antes de entrenar.',               'MOBILITY', 'BEGINNER',     10, FALSE),
 ('b5000000-0000-0000-0000-000000000006', 'Movilidad para corredores',      'Caderas, tobillos y core para correr mejor.',             'MOBILITY', 'INTERMEDIATE', 20, FALSE),
 ('b5000000-0000-0000-0000-000000000007', 'Movilidad para sentadilla',      'Ganar profundidad y tobillos móviles.',                   'MOBILITY', 'INTERMEDIATE', 18, FALSE),
 ('b5000000-0000-0000-0000-000000000008', 'Movilidad de muñeca',            'Para teclados y entrenamientos de fuerza.',               'MOBILITY', 'BEGINNER',     8,  FALSE),
 ('b5000000-0000-0000-0000-000000000009', 'Movilidad torácica',             'Mejora rotación y postura de la zona alta.',              'MOBILITY', 'BEGINNER',     12, FALSE),
 ('b5000000-0000-0000-0000-00000000000a', 'Movilidad de tobillos',          'Tobillos fuertes y móviles.',                             'MOBILITY', 'BEGINNER',     10, FALSE),
 ('b5000000-0000-0000-0000-00000000000b', 'Movilidad para escritorio',      'Antídoto contra estar sentado todo el día.',              'MOBILITY', 'BEGINNER',     12, FALSE),
 ('b5000000-0000-0000-0000-00000000000c', 'Movilidad dinámica full body',   'Recorrido completo de cabeza a pies.',                    'MOBILITY', 'INTERMEDIATE', 20, FALSE),
 ('b5000000-0000-0000-0000-00000000000d', 'Movilidad para principiantes',   'Punto de partida si nunca trabajaste movilidad.',         'MOBILITY', 'BEGINNER',     12, FALSE),
 ('b5000000-0000-0000-0000-00000000000e', 'Movilidad avanzada',             'Rangos completos para deportistas.',                      'MOBILITY', 'ADVANCED',     25, FALSE);

INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, duration_seconds, rest_seconds) VALUES
 -- Movilidad articular completa
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000080', 0, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000081', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000084', 2, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000086', 3, 2, NULL, 40, 10),

 -- Movilidad de cadera
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000080', 0, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000085', 1, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000082', 2, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000083', 3, 2, NULL, 60, 15),

 -- Movilidad de hombro
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000081', 0, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000086', 1, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000095', 2, 2, NULL, 40, 10),

 -- Movilidad de columna
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-00000000000b', 0, 3, NULL, 45, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000084', 1, 3, NULL, 45, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000093', 2, 2, NULL, 45, 10),

 -- Movilidad pre-entreno
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000087', 0, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000083', 1, 2, NULL, 60, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000080', 2, 2, NULL, 40, 10),

 -- Movilidad para corredores
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000085', 0, 2, NULL, 50, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000094', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000091', 2, 2, NULL, 30, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000079', 3, 2, NULL, 60, 15),

 -- Movilidad para sentadilla
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000082', 0, 3, NULL, 60, 20),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000094', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000079', 2, 2, NULL, 60, 15),

 -- Movilidad de muñeca
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000081', 0, 3, NULL, 30, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000095', 1, 2, NULL, 30, 10),

 -- Movilidad torácica
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000084', 0, 3, NULL, 50, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000086', 1, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000095', 2, 2, NULL, 40, 10),

 -- Movilidad de tobillos
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000094', 0, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000082', 1, 2, NULL, 60, 10),

 -- Movilidad para escritorio
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000093', 0, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000096', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000086', 2, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000095', 3, 2, NULL, 40, 10),

 -- Movilidad dinámica full body
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000083', 0, 3, NULL, 60, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000087', 1, 3, NULL, 50, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000084', 2, 3, NULL, 45, 15),

 -- Movilidad para principiantes
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000080', 0, 2, NULL, 40, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000081', 1, 2, NULL, 40, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000d', 'a0000000-0000-0000-0000-00000000000b', 2, 2, NULL, 45, 15),

 -- Movilidad avanzada
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000083', 0, 3, NULL, 75, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000085', 1, 3, NULL, 60, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000082', 2, 3, NULL, 60, 15),
 (gen_random_uuid(), 'b5000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000087', 3, 3, NULL, 50, 15);

-- =====================================================================
-- RUTINAS NUEVAS — STRETCHING
-- =====================================================================
INSERT INTO workouts (id, name, description, type, difficulty, estimated_duration_minutes, is_premium) VALUES
 ('b6000000-0000-0000-0000-000000000001', 'Estiramiento general',           'Sesión completa de estiramientos.',                       'STRETCHING', 'BEGINNER', 15, FALSE),
 ('b6000000-0000-0000-0000-000000000002', 'Estiramiento post-entreno',      'Recupera mejor tras una sesión intensa.',                 'STRETCHING', 'BEGINNER', 12, FALSE),
 ('b6000000-0000-0000-0000-000000000003', 'Estiramiento de piernas',        'Cuádriceps, isquios, gemelos y aductores.',               'STRETCHING', 'BEGINNER', 15, FALSE),
 ('b6000000-0000-0000-0000-000000000004', 'Estiramiento de espalda',        'Alivio para zona lumbar y dorsal.',                       'STRETCHING', 'BEGINNER', 12, FALSE),
 ('b6000000-0000-0000-0000-000000000005', 'Estiramiento de cadera',         'Para abrir y descargar la zona pélvica.',                 'STRETCHING', 'BEGINNER', 12, FALSE),
 ('b6000000-0000-0000-0000-000000000006', 'Estiramiento de brazos',         'Hombros, bíceps, tríceps y antebrazos.',                  'STRETCHING', 'BEGINNER', 10, FALSE),
 ('b6000000-0000-0000-0000-000000000007', 'Estiramiento de cuello',         'Alivio rápido para el cuello.',                           'STRETCHING', 'BEGINNER', 8,  FALSE),
 ('b6000000-0000-0000-0000-000000000008', 'Estiramiento al despertar',      'Pequeña rutina al levantarse.',                           'STRETCHING', 'BEGINNER', 10, FALSE),
 ('b6000000-0000-0000-0000-000000000009', 'Estiramiento antes de dormir',   'Relaja para conciliar el sueño.',                         'STRETCHING', 'BEGINNER', 12, FALSE),
 ('b6000000-0000-0000-0000-00000000000a', 'Estiramiento profundo',          'Sesión larga buscando flexibilidad.',                     'STRETCHING', 'INTERMEDIATE', 25, FALSE),
 ('b6000000-0000-0000-0000-00000000000b', 'Estiramiento para corredores',   'Tras correr, libera la cadena posterior.',                'STRETCHING', 'BEGINNER', 15, FALSE),
 ('b6000000-0000-0000-0000-00000000000c', 'Estiramiento ciático',           'Alivio para tensión en el piriforme.',                    'STRETCHING', 'BEGINNER', 12, FALSE),
 ('b6000000-0000-0000-0000-00000000000d', 'Estiramiento de pecho',          'Para gente que pasa muchas horas sentada.',               'STRETCHING', 'BEGINNER', 10, FALSE),
 ('b6000000-0000-0000-0000-00000000000e', 'Estiramiento full body',         'Todo el cuerpo en 20 minutos.',                           'STRETCHING', 'BEGINNER', 20, FALSE);

INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, duration_seconds, rest_seconds) VALUES
 -- Estiramiento general
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000090', 0, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000091', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000092', 2, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000093', 3, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000095', 4, 2, NULL, 40, 10),

 -- Estiramiento post-entreno
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000091', 0, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000090', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000097', 2, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000094', 3, 2, NULL, 40, 10),

 -- Estiramiento de piernas
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000090', 0, 3, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000091', 1, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000094', 2, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000092', 3, 2, NULL, 45, 10),

 -- Estiramiento de espalda
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000093', 0, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-00000000000b', 1, 3, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000073', 2, 2, NULL, 60, 10),

 -- Estiramiento de cadera
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000079', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000092', 1, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000097', 2, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000085', 3, 2, NULL, 50, 10),

 -- Estiramiento de brazos
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000095', 0, 3, NULL, 30, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000081', 1, 2, NULL, 30, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000086', 2, 2, NULL, 30, 10),

 -- Estiramiento de cuello
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000096', 0, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000095', 1, 2, NULL, 30, 10),

 -- Estiramiento al despertar
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000095', 0, 2, NULL, 30, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000093', 1, 2, NULL, 30, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-00000000000b', 2, 2, NULL, 40, 10),

 -- Estiramiento antes de dormir
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000073', 0, 1, NULL, 60, 15),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000092', 1, 1, NULL, 60, 15),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-0000000000a5', 2, 1, NULL, 90, 0),

 -- Estiramiento profundo
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000090', 0, 3, NULL, 60, 15),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000079', 1, 3, NULL, 60, 15),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000076', 2, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-000000000093', 3, 2, NULL, 60, 15),

 -- Estiramiento para corredores
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000094', 0, 3, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000090', 1, 3, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000091', 2, 3, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000097', 3, 2, NULL, 45, 10),

 -- Estiramiento ciático
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000097', 0, 3, NULL, 60, 15),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000079', 1, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000093', 2, 2, NULL, 45, 10),

 -- Estiramiento de pecho
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000095', 0, 4, NULL, 30, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000074', 1, 2, NULL, 40, 10),

 -- Estiramiento full body
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000095', 0, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000090', 1, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000091', 2, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000092', 3, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000093', 4, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b6000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000096', 5, 2, NULL, 30, 10);

-- =====================================================================
-- RUTINAS NUEVAS — RECOVERY
-- =====================================================================
INSERT INTO workouts (id, name, description, type, difficulty, estimated_duration_minutes, is_premium) VALUES
 ('b7000000-0000-0000-0000-000000000001', 'Recuperación post-entreno',      'Reducir DOMS y acelerar recuperación.',                   'RECOVERY', 'BEGINNER',     15, FALSE),
 ('b7000000-0000-0000-0000-000000000002', 'Foam rolling completo',          'Auto-masaje miofascial por todo el cuerpo.',              'RECOVERY', 'BEGINNER',     20, FALSE),
 ('b7000000-0000-0000-0000-000000000003', 'Día de descanso activo',         'Movimiento muy ligero para el día off.',                  'RECOVERY', 'BEGINNER',     20, FALSE),
 ('b7000000-0000-0000-0000-000000000004', 'Recuperación sistema nervioso',  'Respiraciones y relajación profunda.',                    'RECOVERY', 'BEGINNER',     18, FALSE),
 ('b7000000-0000-0000-0000-000000000005', 'Recuperación para piernas',      'Tras leg day intenso.',                                   'RECOVERY', 'BEGINNER',     15, FALSE),
 ('b7000000-0000-0000-0000-000000000006', 'Recuperación para espalda',      'Tras una rutina pesada de espalda.',                      'RECOVERY', 'BEGINNER',     12, FALSE),
 ('b7000000-0000-0000-0000-000000000007', 'Recuperación contra estrés',     'Combinar respiración y relajación corporal.',             'RECOVERY', 'BEGINNER',     20, FALSE),
 ('b7000000-0000-0000-0000-000000000008', 'Recuperación express',           'Sesión muy corta cuando no tienes tiempo.',               'RECOVERY', 'BEGINNER',     8,  FALSE),
 ('b7000000-0000-0000-0000-000000000009', 'Drenaje linfático casero',       'Estimular la circulación y reducir hinchazón.',           'RECOVERY', 'BEGINNER',     15, FALSE),
 ('b7000000-0000-0000-0000-00000000000a', 'Recuperación con respiración',   'Práctica de pranayama suave.',                            'RECOVERY', 'BEGINNER',     12, FALSE),
 ('b7000000-0000-0000-0000-00000000000b', 'Recuperación al final del día',  'Para soltar todo antes de dormir.',                       'RECOVERY', 'BEGINNER',     18, FALSE),
 ('b7000000-0000-0000-0000-00000000000c', 'Recuperación para corredores',   'Foam rolling + estiramiento de cadena posterior.',        'RECOVERY', 'BEGINNER',     20, FALSE),
 ('b7000000-0000-0000-0000-00000000000d', 'Recuperación de hombros',        'Tras día pesado de empuje o tirón.',                      'RECOVERY', 'BEGINNER',     12, FALSE),
 ('b7000000-0000-0000-0000-00000000000e', 'Recuperación de viaje',          'Para descargar tras estar muchas horas sentado.',         'RECOVERY', 'BEGINNER',     15, FALSE);

INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, duration_seconds, rest_seconds) VALUES
 -- Recuperación post-entreno
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-0000000000a0', 0, 2, NULL, 60, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-0000000000a1', 1, 2, NULL, 60, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000090', 2, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-0000000000a3', 3, 1, NULL, 90, 0),

 -- Foam rolling completo
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-0000000000a0', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-0000000000a1', 1, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-0000000000a2', 2, 2, NULL, 60, 15),

 -- Día de descanso activo
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000080', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000084', 1, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000087', 2, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-0000000000a5', 3, 1, NULL, 120, 0),

 -- Recuperación sistema nervioso
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-0000000000a3', 0, 3, NULL, 120, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-0000000000a6', 1, 1, NULL, 180, 0),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-0000000000a4', 2, 1, NULL, 180, 0),

 -- Recuperación para piernas
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-0000000000a0', 0, 2, NULL, 60, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-0000000000a2', 1, 2, NULL, 60, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-0000000000a5', 2, 1, NULL, 120, 0),

 -- Recuperación para espalda
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-0000000000a1', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000084', 1, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000073', 2, 1, NULL, 90, 0),

 -- Recuperación contra estrés
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-0000000000a3', 0, 3, NULL, 90, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000073', 1, 1, NULL, 90, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-0000000000a4', 2, 1, NULL, 240, 0),

 -- Recuperación express
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-0000000000a3', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-0000000000a5', 1, 1, NULL, 90, 0),

 -- Drenaje linfático casero
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-0000000000a5', 0, 1, NULL, 240, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000080', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-0000000000a3', 2, 2, NULL, 60, 0),

 -- Recuperación con respiración
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-0000000000a3', 0, 5, NULL, 90, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000a', 'a1000000-0000-0000-0000-0000000000a4', 1, 1, NULL, 120, 0),

 -- Recuperación al final del día
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000095', 0, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-000000000073', 1, 1, NULL, 90, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-0000000000a5', 2, 1, NULL, 120, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000b', 'a1000000-0000-0000-0000-0000000000a4', 3, 1, NULL, 180, 0),

 -- Recuperación para corredores
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-0000000000a0', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-0000000000a2', 1, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000090', 2, 2, NULL, 60, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000c', 'a1000000-0000-0000-0000-000000000094', 3, 2, NULL, 45, 10),

 -- Recuperación de hombros
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-0000000000a1', 0, 2, NULL, 60, 15),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000086', 1, 2, NULL, 40, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000d', 'a1000000-0000-0000-0000-000000000095', 2, 2, NULL, 40, 10),

 -- Recuperación de viaje
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000094', 0, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000097', 1, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-000000000093', 2, 2, NULL, 45, 10),
 (gen_random_uuid(), 'b7000000-0000-0000-0000-00000000000e', 'a1000000-0000-0000-0000-0000000000a5', 3, 1, NULL, 120, 0);
