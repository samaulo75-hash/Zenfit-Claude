-- =====================================================================
-- ZenFit — Módulo de Dietas / Nutrición
-- Planes de alimentación según objetivo + sus comidas
-- =====================================================================

CREATE TYPE diet_goal AS ENUM ('LOSE_WEIGHT', 'GAIN_MUSCLE', 'MAINTAIN', 'BALANCED', 'VEGETARIAN', 'VEGAN');
CREATE TYPE meal_type AS ENUM ('BREAKFAST', 'LUNCH', 'DINNER', 'SNACK');

CREATE TABLE diet_plans (
    id                UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name              VARCHAR(150) NOT NULL,
    description       TEXT,
    goal              diet_goal    NOT NULL,
    calories_per_day  INTEGER      CHECK (calories_per_day > 0),
    image_url         VARCHAR(500),
    is_premium        BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_diet_plans_goal ON diet_plans (goal);

CREATE TRIGGER trg_diet_plans_updated_at
    BEFORE UPDATE ON diet_plans
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE diet_meals (
    id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    diet_plan_id  UUID         NOT NULL REFERENCES diet_plans(id) ON DELETE CASCADE,
    meal_type     meal_type    NOT NULL,
    name          VARCHAR(200) NOT NULL,
    description   TEXT,
    calories      INTEGER      CHECK (calories >= 0),
    position      INTEGER      NOT NULL CHECK (position >= 0),
    UNIQUE (diet_plan_id, position)
);

CREATE INDEX idx_diet_meals_plan ON diet_meals (diet_plan_id);

-- =====================================================================
-- SEED: planes de dieta predefinidos
-- =====================================================================

INSERT INTO diet_plans (id, name, description, goal, calories_per_day, is_premium) VALUES
 ('e0000000-0000-0000-0000-000000000001', 'Pérdida de peso',          'Plan hipocalórico equilibrado para perder grasa de forma saludable y sostenible.', 'LOSE_WEIGHT', 1600, FALSE),
 ('e0000000-0000-0000-0000-000000000002', 'Volumen muscular',         'Plan alto en proteína y calorías para ganar masa muscular.',                       'GAIN_MUSCLE', 2800, FALSE),
 ('e0000000-0000-0000-0000-000000000003', 'Mantenimiento equilibrado','Plan balanceado para mantener tu peso y energía estable.',                         'MAINTAIN',    2200, FALSE),
 ('e0000000-0000-0000-0000-000000000004', 'Mediterránea balanceada',  'Dieta mediterránea rica en vegetales, pescado y aceite de oliva.',                 'BALANCED',    2100, FALSE),
 ('e0000000-0000-0000-0000-000000000005', 'Vegetariana',              'Plan vegetariano completo y equilibrado en proteína vegetal.',                     'VEGETARIAN',  2000, FALSE);

-- Comidas: Pérdida de peso
INSERT INTO diet_meals (diet_plan_id, meal_type, name, description, calories, position) VALUES
 ('e0000000-0000-0000-0000-000000000001', 'BREAKFAST', 'Avena con frutos rojos', 'Avena cocida con leche desnatada, arándanos y una cucharada de semillas.', 350, 0),
 ('e0000000-0000-0000-0000-000000000001', 'LUNCH',     'Pollo a la plancha con ensalada', 'Pechuga de pollo, ensalada variada y quinoa.', 500, 1),
 ('e0000000-0000-0000-0000-000000000001', 'SNACK',     'Yogur natural con nueces', 'Yogur desnatado con un puñado de nueces.', 180, 2),
 ('e0000000-0000-0000-0000-000000000001', 'DINNER',    'Salmón al horno con verduras', 'Salmón con brócoli y calabacín al horno.', 470, 3);

-- Comidas: Volumen muscular
INSERT INTO diet_meals (diet_plan_id, meal_type, name, description, calories, position) VALUES
 ('e0000000-0000-0000-0000-000000000002', 'BREAKFAST', 'Tortilla de claras y avena', 'Tortilla de 4 claras y 2 huevos con avena y plátano.', 650, 0),
 ('e0000000-0000-0000-0000-000000000002', 'LUNCH',     'Arroz con ternera y aguacate', 'Arroz integral, ternera magra y medio aguacate.', 850, 1),
 ('e0000000-0000-0000-0000-000000000002', 'SNACK',     'Batido de proteína y frutos secos', 'Batido con proteína whey, leche y almendras.', 450, 2),
 ('e0000000-0000-0000-0000-000000000002', 'DINNER',    'Pasta integral con pavo', 'Pasta integral con pavo picado y salsa de tomate natural.', 850, 3);

-- Comidas: Mantenimiento equilibrado
INSERT INTO diet_meals (diet_plan_id, meal_type, name, description, calories, position) VALUES
 ('e0000000-0000-0000-0000-000000000003', 'BREAKFAST', 'Tostadas integrales con huevo', 'Pan integral, huevo revuelto y aguacate.', 450, 0),
 ('e0000000-0000-0000-0000-000000000003', 'LUNCH',     'Lentejas con verduras', 'Guiso de lentejas con verduras y arroz.', 700, 1),
 ('e0000000-0000-0000-0000-000000000003', 'SNACK',     'Fruta y un puñado de almendras', 'Una pieza de fruta de temporada y almendras.', 250, 2),
 ('e0000000-0000-0000-0000-000000000003', 'DINNER',    'Merluza con patata y ensalada', 'Merluza al vapor con patata cocida y ensalada.', 800, 3);

-- Comidas: Mediterránea balanceada
INSERT INTO diet_meals (diet_plan_id, meal_type, name, description, calories, position) VALUES
 ('e0000000-0000-0000-0000-000000000004', 'BREAKFAST', 'Tostada de tomate y aceite de oliva', 'Pan integral con tomate, aceite de oliva virgen y jamón.', 400, 0),
 ('e0000000-0000-0000-0000-000000000004', 'LUNCH',     'Ensalada de garbanzos y atún', 'Garbanzos, atún, tomate, cebolla y aceite de oliva.', 650, 1),
 ('e0000000-0000-0000-0000-000000000004', 'SNACK',     'Yogur griego con miel y nueces', 'Yogur griego natural con miel y nueces.', 250, 2),
 ('e0000000-0000-0000-0000-000000000004', 'DINNER',    'Dorada al horno con verduras', 'Dorada con pimientos, cebolla y patata al horno.', 800, 3);

-- Comidas: Vegetariana
INSERT INTO diet_meals (diet_plan_id, meal_type, name, description, calories, position) VALUES
 ('e0000000-0000-0000-0000-000000000005', 'BREAKFAST', 'Porridge con plátano y semillas', 'Avena con bebida vegetal, plátano y semillas de chía.', 420, 0),
 ('e0000000-0000-0000-0000-000000000005', 'LUNCH',     'Bowl de quinoa y tofu', 'Quinoa, tofu salteado, verduras y aguacate.', 680, 1),
 ('e0000000-0000-0000-0000-000000000005', 'SNACK',     'Hummus con crudités', 'Hummus casero con zanahoria y pepino.', 220, 2),
 ('e0000000-0000-0000-0000-000000000005', 'DINNER',    'Lentejas estofadas con verduras', 'Estofado de lentejas con verduras variadas.', 680, 3);
