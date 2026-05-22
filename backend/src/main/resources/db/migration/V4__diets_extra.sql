-- =====================================================================
-- ZenFit — Dietas: enlace de recetas, guardado por usuario y más planes
-- =====================================================================

-- Enlace externo (vídeo / recetas de preparación)
ALTER TABLE diet_plans ADD COLUMN recipe_url VARCHAR(500);

-- Dietas guardadas por el usuario (favoritos)
CREATE TABLE saved_diets (
    user_id       UUID         NOT NULL REFERENCES users(id)      ON DELETE CASCADE,
    diet_plan_id  UUID         NOT NULL REFERENCES diet_plans(id) ON DELETE CASCADE,
    saved_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, diet_plan_id)
);

CREATE INDEX idx_saved_diets_user ON saved_diets (user_id);

-- ---------- Enlace de recetas para los planes existentes (V3) ----------
UPDATE diet_plans SET recipe_url = 'https://www.youtube.com/results?search_query=recetas+saludables+perder+peso' WHERE id = 'e0000000-0000-0000-0000-000000000001';
UPDATE diet_plans SET recipe_url = 'https://www.youtube.com/results?search_query=recetas+volumen+ganar+masa+muscular' WHERE id = 'e0000000-0000-0000-0000-000000000002';
UPDATE diet_plans SET recipe_url = 'https://www.youtube.com/results?search_query=recetas+saludables+faciles+diarias' WHERE id = 'e0000000-0000-0000-0000-000000000003';
UPDATE diet_plans SET recipe_url = 'https://www.youtube.com/results?search_query=recetas+dieta+mediterranea' WHERE id = 'e0000000-0000-0000-0000-000000000004';
UPDATE diet_plans SET recipe_url = 'https://www.youtube.com/results?search_query=recetas+vegetarianas+faciles' WHERE id = 'e0000000-0000-0000-0000-000000000005';

-- ---------- PLANES NUEVOS ----------
INSERT INTO diet_plans (id, name, description, goal, calories_per_day, is_premium, recipe_url) VALUES
 -- Perder peso
 ('e1000000-0000-0000-0000-000000000001', 'Déficit suave 1800 kcal',     'Déficit calórico moderado, fácil de mantener en el día a día.',          'LOSE_WEIGHT', 1800, FALSE, 'https://www.youtube.com/results?search_query=recetas+deficit+calorico+1800'),
 ('e1000000-0000-0000-0000-000000000002', 'Alto en proteína, baja grasa','Prioriza la proteína para conservar músculo mientras pierdes grasa.',    'LOSE_WEIGHT', 1700, FALSE, 'https://www.youtube.com/results?search_query=recetas+altas+en+proteina+bajas+en+grasa'),
 ('e1000000-0000-0000-0000-000000000003', 'Detox de verduras',           'Plan ligero rico en vegetales y fibra para depurar y adelgazar.',        'LOSE_WEIGHT', 1500, FALSE, 'https://www.youtube.com/results?search_query=recetas+detox+verduras'),
 -- Ganar músculo
 ('e1000000-0000-0000-0000-000000000004', 'Volumen limpio 3000 kcal',    'Superávit calórico controlado para ganar músculo con poca grasa.',       'GAIN_MUSCLE', 3000, FALSE, 'https://www.youtube.com/results?search_query=recetas+volumen+limpio+masa+muscular'),
 ('e1000000-0000-0000-0000-000000000005', 'Masa magra 2600 kcal',        'Enfoque en proteína de calidad y carbohidratos alrededor del entreno.',  'GAIN_MUSCLE', 2600, FALSE, 'https://www.youtube.com/results?search_query=recetas+masa+magra+proteina'),
 ('e1000000-0000-0000-0000-000000000006', 'Post-entreno proteico',       'Comidas pensadas para maximizar la recuperación tras entrenar.',         'GAIN_MUSCLE', 2900, FALSE, 'https://www.youtube.com/results?search_query=recetas+post+entreno+proteicas'),
 -- Mantenimiento
 ('e1000000-0000-0000-0000-000000000007', 'Mantenimiento activo 2400',   'Para personas activas que quieren mantener su peso y energía.',          'MAINTAIN',    2400, FALSE, 'https://www.youtube.com/results?search_query=recetas+saludables+mantenimiento'),
 ('e1000000-0000-0000-0000-000000000008', 'Flexible 80/20',              'Come sano el 80% del tiempo y disfruta con flexibilidad el 20%.',        'MAINTAIN',    2200, FALSE, 'https://www.youtube.com/results?search_query=recetas+dieta+flexible+80+20'),
 ('e1000000-0000-0000-0000-000000000009', 'Mantenimiento ligero 2000',   'Plan equilibrado y ligero para mantener la línea sin esfuerzo.',         'MAINTAIN',    2000, FALSE, 'https://www.youtube.com/results?search_query=recetas+ligeras+saludables'),
 -- Equilibrada
 ('e1000000-0000-0000-0000-00000000000a', 'Plato equilibrado clásico',   'La regla del plato: mitad verduras, un cuarto proteína, un cuarto carbo.','BALANCED',    2100, FALSE, 'https://www.youtube.com/results?search_query=recetas+plato+equilibrado'),
 ('e1000000-0000-0000-0000-00000000000b', 'Equilibrada sin gluten',      'Plan completo y balanceado apto para celíacos.',                         'BALANCED',    2100, FALSE, 'https://www.youtube.com/results?search_query=recetas+sin+gluten+saludables'),
 ('e1000000-0000-0000-0000-00000000000c', 'Bowl equilibrado',            'Comidas tipo bowl variadas, completas y fáciles de preparar.',           'BALANCED',    2000, FALSE, 'https://www.youtube.com/results?search_query=recetas+bowls+saludables'),
 -- Vegetariana
 ('e1000000-0000-0000-0000-00000000000d', 'Vegetariana alta en proteína','Proteína vegetal abundante: legumbres, tofu, huevo y lácteos.',          'VEGETARIAN',  2100, FALSE, 'https://www.youtube.com/results?search_query=recetas+vegetarianas+altas+en+proteina'),
 ('e1000000-0000-0000-0000-00000000000e', 'Vegetariana mediterránea',    'Lo mejor de la dieta mediterránea en versión vegetariana.',              'VEGETARIAN',  2000, FALSE, 'https://www.youtube.com/results?search_query=recetas+vegetarianas+mediterraneas'),
 ('e1000000-0000-0000-0000-00000000000f', 'Vegetariana ligera',          'Plan vegetariano ligero, ideal para perder peso sin carne.',             'VEGETARIAN',  1700, FALSE, 'https://www.youtube.com/results?search_query=recetas+vegetarianas+ligeras');

-- ---------- COMIDAS DE LOS PLANES NUEVOS ----------
INSERT INTO diet_meals (diet_plan_id, meal_type, name, description, calories, position) VALUES
 -- Déficit suave 1800
 ('e1000000-0000-0000-0000-000000000001','BREAKFAST','Tostadas integrales con aguacate','Pan integral, aguacate y huevo poché.',420,0),
 ('e1000000-0000-0000-0000-000000000001','LUNCH','Pollo al curry con arroz integral','Pollo, verduras al curry y arroz integral.',560,1),
 ('e1000000-0000-0000-0000-000000000001','SNACK','Fruta y yogur','Yogur natural con una pieza de fruta.',200,2),
 ('e1000000-0000-0000-0000-000000000001','DINNER','Crema de calabaza y tortilla','Crema de calabaza y tortilla francesa.',620,3),
 -- Alto en proteína baja grasa
 ('e1000000-0000-0000-0000-000000000002','BREAKFAST','Claras revueltas con avena','Claras de huevo, avena y canela.',380,0),
 ('e1000000-0000-0000-0000-000000000002','LUNCH','Pavo a la plancha con boniato','Filete de pavo y boniato asado.',520,1),
 ('e1000000-0000-0000-0000-000000000002','SNACK','Requesón con frutos rojos','Requesón desnatado con arándanos.',180,2),
 ('e1000000-0000-0000-0000-000000000002','DINNER','Lubina al horno con espárragos','Lubina y espárragos verdes al horno.',620,3),
 -- Detox de verduras
 ('e1000000-0000-0000-0000-000000000003','BREAKFAST','Bol de fruta y semillas','Fruta fresca variada con semillas de chía.',300,0),
 ('e1000000-0000-0000-0000-000000000003','LUNCH','Ensalada templada de quinoa','Quinoa, verduras asadas y hojas verdes.',480,1),
 ('e1000000-0000-0000-0000-000000000003','SNACK','Crudités con hummus','Zanahoria y pepino con hummus.',180,2),
 ('e1000000-0000-0000-0000-000000000003','DINNER','Crema de verduras y huevo','Crema de verduras de temporada con huevo cocido.',540,3),
 -- Volumen limpio 3000
 ('e1000000-0000-0000-0000-000000000004','BREAKFAST','Tortitas de avena y plátano','Tortitas de avena, plátano y huevo con miel.',700,0),
 ('e1000000-0000-0000-0000-000000000004','LUNCH','Ternera con arroz y aguacate','Ternera magra, arroz blanco y aguacate.',950,1),
 ('e1000000-0000-0000-0000-000000000004','SNACK','Sándwich de pavo y batido','Sándwich integral de pavo y batido de leche.',500,2),
 ('e1000000-0000-0000-0000-000000000004','DINNER','Salmón con pasta integral','Salmón a la plancha con pasta integral.',850,3),
 -- Masa magra 2600
 ('e1000000-0000-0000-0000-000000000005','BREAKFAST','Yogur griego con granola y nueces','Yogur griego, granola casera y nueces.',550,0),
 ('e1000000-0000-0000-0000-000000000005','LUNCH','Pechuga de pollo con quinoa','Pollo, quinoa y verduras salteadas.',780,1),
 ('e1000000-0000-0000-0000-000000000005','SNACK','Batido de proteína y avena','Batido con proteína, leche y avena.',420,2),
 ('e1000000-0000-0000-0000-000000000005','DINNER','Merluza con patata y verduras','Merluza al horno con patata y judías.',850,3),
 -- Post-entreno proteico
 ('e1000000-0000-0000-0000-000000000006','BREAKFAST','Huevos revueltos con pan integral','Huevos revueltos, pan integral y tomate.',600,0),
 ('e1000000-0000-0000-0000-000000000006','LUNCH','Arroz con pollo y verduras','Arroz, pollo desmenuzado y pimientos.',850,1),
 ('e1000000-0000-0000-0000-000000000006','SNACK','Batido post-entreno','Batido de proteína con plátano (justo tras entrenar).',400,2),
 ('e1000000-0000-0000-0000-000000000006','DINNER','Tortilla de patata y atún','Tortilla de patata con ensalada de atún.',850,3),
 -- Mantenimiento activo 2400
 ('e1000000-0000-0000-0000-000000000007','BREAKFAST','Café, tostadas y fruta','Tostadas integrales con tomate, aceite y fruta.',500,0),
 ('e1000000-0000-0000-0000-000000000007','LUNCH','Garbanzos con verduras','Guiso de garbanzos con verduras y arroz.',750,1),
 ('e1000000-0000-0000-0000-000000000007','SNACK','Frutos secos y fruta','Un puñado de frutos secos y una pieza de fruta.',300,2),
 ('e1000000-0000-0000-0000-000000000007','DINNER','Pollo asado con patata','Pollo asado con patata y ensalada.',850,3),
 -- Flexible 80/20
 ('e1000000-0000-0000-0000-000000000008','BREAKFAST','Bol de yogur, fruta y avena','Yogur, fruta y avena con miel.',450,0),
 ('e1000000-0000-0000-0000-000000000008','LUNCH','Wrap de pollo y verduras','Wrap integral de pollo, lechuga y tomate.',650,1),
 ('e1000000-0000-0000-0000-000000000008','SNACK','Onza de chocolate negro y fruta','Capricho controlado: chocolate negro y fruta.',250,2),
 ('e1000000-0000-0000-0000-000000000008','DINNER','Pescado con verduras al horno','Pescado blanco con verduras variadas.',850,3),
 -- Mantenimiento ligero 2000
 ('e1000000-0000-0000-0000-000000000009','BREAKFAST','Tostada integral con queso fresco','Pan integral con queso fresco y tomate.',400,0),
 ('e1000000-0000-0000-0000-000000000009','LUNCH','Ensalada completa con huevo','Hojas, huevo, atún, maíz y aceite de oliva.',600,1),
 ('e1000000-0000-0000-0000-000000000009','SNACK','Yogur con nueces','Yogur natural con nueces.',200,2),
 ('e1000000-0000-0000-0000-000000000009','DINNER','Sopa y revuelto de champiñones','Sopa de verduras y revuelto de champiñones.',800,3),
 -- Plato equilibrado clásico
 ('e1000000-0000-0000-0000-00000000000a','BREAKFAST','Avena con fruta y frutos secos','Avena cocida con fruta y un puñado de nueces.',430,0),
 ('e1000000-0000-0000-0000-00000000000a','LUNCH','Plato equilibrado de pollo','Mitad verduras, pollo y arroz integral.',680,1),
 ('e1000000-0000-0000-0000-00000000000a','SNACK','Fruta de temporada','Una o dos piezas de fruta de temporada.',180,2),
 ('e1000000-0000-0000-0000-00000000000a','DINNER','Plato equilibrado de pescado','Mitad verduras, pescado y patata.',810,3),
 -- Equilibrada sin gluten
 ('e1000000-0000-0000-0000-00000000000b','BREAKFAST','Tortitas de trigo sarraceno','Tortitas sin gluten con fruta.',420,0),
 ('e1000000-0000-0000-0000-00000000000b','LUNCH','Arroz con verduras y pollo','Arroz, verduras y pollo (sin gluten).',680,1),
 ('e1000000-0000-0000-0000-00000000000b','SNACK','Yogur con fruta','Yogur natural con fruta troceada.',200,2),
 ('e1000000-0000-0000-0000-00000000000b','DINNER','Tortilla con ensalada','Tortilla de patata con ensalada verde.',800,3),
 -- Bowl equilibrado
 ('e1000000-0000-0000-0000-00000000000c','BREAKFAST','Bowl de yogur y granola','Yogur, granola, fruta y semillas.',420,0),
 ('e1000000-0000-0000-0000-00000000000c','LUNCH','Poke bowl de salmón','Arroz, salmón, edamame, aguacate y verduras.',680,1),
 ('e1000000-0000-0000-0000-00000000000c','SNACK','Bowl de fruta','Macedonia de fruta fresca.',170,2),
 ('e1000000-0000-0000-0000-00000000000c','DINNER','Bowl de quinoa y pollo','Quinoa, pollo, verduras y hummus.',730,3),
 -- Vegetariana alta en proteína
 ('e1000000-0000-0000-0000-00000000000d','BREAKFAST','Revuelto de tofu','Tofu revuelto con verduras y pan integral.',450,0),
 ('e1000000-0000-0000-0000-00000000000d','LUNCH','Lentejas con huevo','Guiso de lentejas con huevo cocido y arroz.',700,1),
 ('e1000000-0000-0000-0000-00000000000d','SNACK','Yogur griego con semillas','Yogur griego con semillas de calabaza.',230,2),
 ('e1000000-0000-0000-0000-00000000000d','DINNER','Garbanzos especiados con queso','Garbanzos especiados con queso feta.',720,3),
 -- Vegetariana mediterránea
 ('e1000000-0000-0000-0000-00000000000e','BREAKFAST','Tostada de tomate y queso','Pan integral con tomate, aceite y queso fresco.',400,0),
 ('e1000000-0000-0000-0000-00000000000e','LUNCH','Ensalada griega con garbanzos','Tomate, pepino, feta, aceitunas y garbanzos.',620,1),
 ('e1000000-0000-0000-0000-00000000000e','SNACK','Hummus con pan de pita','Hummus casero con pan de pita integral.',250,2),
 ('e1000000-0000-0000-0000-00000000000e','DINNER','Verduras al horno con feta','Verduras mediterráneas asadas con queso feta.',730,3),
 -- Vegetariana ligera
 ('e1000000-0000-0000-0000-00000000000f','BREAKFAST','Porridge ligero de avena','Avena con bebida vegetal y fruta.',350,0),
 ('e1000000-0000-0000-0000-00000000000f','LUNCH','Ensalada de lentejas','Lentejas, verduras frescas y vinagreta.',520,1),
 ('e1000000-0000-0000-0000-00000000000f','SNACK','Crudités con yogur','Bastones de verdura con salsa de yogur.',150,2),
 ('e1000000-0000-0000-0000-00000000000f','DINNER','Crema de verduras y tofu','Crema de verduras con dados de tofu.',680,3);
