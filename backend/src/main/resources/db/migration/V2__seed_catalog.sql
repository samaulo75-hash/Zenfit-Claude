-- =====================================================================
-- ZenFit — Datos semilla del catálogo global
-- Ejercicios, rutinas y meditaciones predefinidos (created_by NULL)
-- =====================================================================

-- ---------- EJERCICIOS ----------
INSERT INTO exercises (id, name, description, difficulty, estimated_seconds, muscle_groups, equipment, is_premium) VALUES
 ('a0000000-0000-0000-0000-000000000001', 'Flexiones',          'Flexiones de pecho clásicas en el suelo.',              'BEGINNER',      40, ARRAY['pecho','tríceps','core'], ARRAY[]::text[], FALSE),
 ('a0000000-0000-0000-0000-000000000002', 'Sentadillas',        'Sentadilla con peso corporal.',                          'BEGINNER',      45, ARRAY['cuádriceps','glúteos'], ARRAY[]::text[], FALSE),
 ('a0000000-0000-0000-0000-000000000003', 'Plancha',            'Mantener posición de plancha isométrica.',               'BEGINNER',      60, ARRAY['core','hombros'], ARRAY[]::text[], FALSE),
 ('a0000000-0000-0000-0000-000000000004', 'Zancadas',           'Zancadas alternando piernas.',                           'INTERMEDIATE',  50, ARRAY['cuádriceps','glúteos'], ARRAY[]::text[], FALSE),
 ('a0000000-0000-0000-0000-000000000005', 'Burpees',            'Ejercicio completo de cuerpo entero.',                   'ADVANCED',      40, ARRAY['cuerpo completo'], ARRAY[]::text[], FALSE),
 ('a0000000-0000-0000-0000-000000000006', 'Mountain Climbers',  'Escaladores en posición de plancha.',                    'INTERMEDIATE',  40, ARRAY['core','cardio'], ARRAY[]::text[], FALSE),
 ('a0000000-0000-0000-0000-000000000007', 'Jumping Jacks',      'Saltos abriendo y cerrando piernas y brazos.',           'BEGINNER',      40, ARRAY['cardio'], ARRAY[]::text[], FALSE),
 ('a0000000-0000-0000-0000-000000000008', 'Peso muerto',        'Peso muerto con barra o mancuernas.',                    'ADVANCED',      60, ARRAY['espalda','glúteos','isquios'], ARRAY['barra'], TRUE),
 ('a0000000-0000-0000-0000-000000000009', 'Press de hombros',   'Press militar con mancuernas.',                          'INTERMEDIATE',  50, ARRAY['hombros','tríceps'], ARRAY['mancuernas'], FALSE),
 ('a0000000-0000-0000-0000-00000000000a', 'Postura del perro',  'Perro boca abajo (yoga).',                               'BEGINNER',      60, ARRAY['flexibilidad','core'], ARRAY['esterilla'], FALSE),
 ('a0000000-0000-0000-0000-00000000000b', 'Estiramiento gato',  'Movilidad de columna gato-vaca.',                        'BEGINNER',      45, ARRAY['movilidad','espalda'], ARRAY['esterilla'], FALSE),
 ('a0000000-0000-0000-0000-00000000000c', 'Abdominales',        'Crunch abdominal clásico.',                              'BEGINNER',      40, ARRAY['core'], ARRAY[]::text[], FALSE);

-- ---------- RUTINAS ----------
INSERT INTO workouts (id, name, description, type, difficulty, estimated_duration_minutes, is_premium) VALUES
 ('b0000000-0000-0000-0000-000000000001', 'Full Body Principiante', 'Rutina de cuerpo completo sin material para empezar.', 'STRENGTH',  'BEGINNER',     20, FALSE),
 ('b0000000-0000-0000-0000-000000000002', 'HIIT Quema Grasa',       'Circuito HIIT de alta intensidad.',                   'HIIT',      'ADVANCED',     15, FALSE),
 ('b0000000-0000-0000-0000-000000000003', 'Cardio Express',         'Sesión rápida de cardio para activarte.',             'CARDIO',    'INTERMEDIATE', 12, FALSE),
 ('b0000000-0000-0000-0000-000000000004', 'Yoga & Movilidad',       'Sesión suave de movilidad y estiramiento.',           'YOGA',      'BEGINNER',     18, FALSE),
 ('b0000000-0000-0000-0000-000000000005', 'Core de Acero',          'Rutina centrada en el core.',                          'STRENGTH',  'INTERMEDIATE', 14, TRUE);

-- ---------- RELACIÓN RUTINA <-> EJERCICIOS ----------
-- Full Body Principiante
INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, rest_seconds) VALUES
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 0, 3, 12, 45),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 1, 3, 10, 45),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-00000000000c', 2, 3, 15, 30),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 3, 3, NULL, 30);

-- HIIT Quema Grasa
INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, duration_seconds, rest_seconds) VALUES
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000005', 0, 4, 30, 20),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000006', 1, 4, 30, 20),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000007', 2, 4, 30, 20);

-- Cardio Express
INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, duration_seconds, rest_seconds) VALUES
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000007', 0, 3, 45, 15),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000006', 1, 3, 45, 15);

-- Yoga & Movilidad
INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, duration_seconds, rest_seconds) VALUES
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-00000000000a', 0, 2, 60, 15),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-00000000000b', 1, 2, 45, 15);

-- Core de Acero
INSERT INTO workout_exercises (id, workout_id, exercise_id, position, sets, reps, rest_seconds) VALUES
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-00000000000c', 0, 4, 20, 30),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000003', 1, 4, NULL, 30),
 (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000006', 2, 4, 20, 30);

-- ---------- MEDITACIONES ----------
INSERT INTO meditations (id, title, description, type, duration_minutes, is_premium) VALUES
 ('c0000000-0000-0000-0000-000000000001', 'Respiración 4-7-8',      'Técnica de respiración para calmar la mente.',    'BREATHING',    5,  FALSE),
 ('c0000000-0000-0000-0000-000000000002', 'Mindfulness matutino',   'Empieza el día con atención plena.',              'MINDFULNESS',  10, FALSE),
 ('c0000000-0000-0000-0000-000000000003', 'Relajación profunda',    'Sesión guiada para soltar tensión.',              'RELAXATION',   15, FALSE),
 ('c0000000-0000-0000-0000-000000000004', 'Meditación para dormir', 'Audio guiado para conciliar el sueño.',           'SLEEP',        20, TRUE),
 ('c0000000-0000-0000-0000-000000000005', 'Escaneo corporal',       'Body scan de relajación progresiva.',             'GUIDED',       12, FALSE);

-- ---------- LOGROS ----------
INSERT INTO achievements (id, code, name, description, icon, points) VALUES
 ('d0000000-0000-0000-0000-000000000001', 'FIRST_WORKOUT',  'Primer entrenamiento', 'Completa tu primera sesión de entrenamiento.', '🏋️', 10),
 ('d0000000-0000-0000-0000-000000000002', 'STREAK_7',       'Racha de 7 días',      'Mantén una racha de actividad de 7 días.',     '🔥', 50),
 ('d0000000-0000-0000-0000-000000000003', 'FIRST_MEDITATION','Mente zen',           'Completa tu primera meditación.',              '🧘', 10),
 ('d0000000-0000-0000-0000-000000000004', 'SLEEP_LOGGER',   'Buen descanso',        'Registra el sueño 5 días.',                    '😴', 20),
 ('d0000000-0000-0000-0000-000000000005', 'HABIT_MASTER',   'Maestro de hábitos',   'Completa un hábito 30 veces.',                 '✅', 30);
