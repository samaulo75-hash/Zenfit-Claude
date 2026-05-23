-- =====================================================================
-- ZenFit — Catálogo de alimentos + dietas personalizadas del usuario
-- =====================================================================

-- ---------- Catálogo de alimentos ----------
-- Valores por 100 g de alimento (estándar para todas las tablas nutricionales).
CREATE TABLE foods (
    id              UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(150) NOT NULL,
    category        VARCHAR(60)  NOT NULL,    -- proteinas, carbohidratos, frutas, verduras, lacteos, grasas, otros
    kcal_per_100g   NUMERIC(6,2) NOT NULL CHECK (kcal_per_100g >= 0),
    protein_per_100g NUMERIC(6,2) NOT NULL DEFAULT 0,
    carbs_per_100g   NUMERIC(6,2) NOT NULL DEFAULT 0,
    fat_per_100g     NUMERIC(6,2) NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_foods_name_lower ON foods (LOWER(name));
CREATE INDEX idx_foods_category   ON foods (category);

-- ---------- Dietas personalizadas (por usuario) ----------
CREATE TABLE custom_diets (
    id              UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name            VARCHAR(120) NOT NULL,
    description     TEXT,
    total_kcal      NUMERIC(8,2) NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_custom_diets_user ON custom_diets (user_id);

CREATE TRIGGER trg_custom_diets_updated_at
    BEFORE UPDATE ON custom_diets
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ---------- Items de cada dieta personalizada ----------
-- food_id es opcional: el usuario puede introducir un alimento libre que no
-- esté en el catálogo (food_name_freetext + kcal a mano). Si food_id está
-- presente, recalculamos kcal = grams * food.kcal_per_100g / 100.
CREATE TABLE custom_diet_items (
    id                 UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    custom_diet_id     UUID         NOT NULL REFERENCES custom_diets(id) ON DELETE CASCADE,
    food_id            UUID         REFERENCES foods(id) ON DELETE SET NULL,
    food_name_freetext VARCHAR(150),
    grams              NUMERIC(7,2) NOT NULL CHECK (grams >= 0),
    kcal               NUMERIC(7,2) NOT NULL CHECK (kcal >= 0),
    position           INT          NOT NULL DEFAULT 0,
    CHECK (food_id IS NOT NULL OR food_name_freetext IS NOT NULL)
);

CREATE INDEX idx_custom_diet_items_diet ON custom_diet_items (custom_diet_id);

-- =====================================================================
-- Seed del catálogo de alimentos (valores aproximados, por 100 g)
-- Fuentes: tablas nutricionales BEDCA / USDA. Cubre los alimentos más
-- comunes en una dieta española estándar.
-- =====================================================================
INSERT INTO foods (name, category, kcal_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g) VALUES
-- Proteínas animales
 ('Pechuga de pollo a la plancha', 'proteinas', 165, 31.0,  0.0,  3.6),
 ('Filete de ternera',             'proteinas', 250, 26.0,  0.0, 17.0),
 ('Lomo de cerdo',                 'proteinas', 195, 27.0,  0.0,  9.5),
 ('Pavo (pechuga)',                'proteinas', 135, 30.0,  0.0,  1.0),
 ('Salmón',                        'proteinas', 208, 20.0,  0.0, 13.0),
 ('Atún en lata al natural',       'proteinas', 116, 26.0,  0.0,  1.0),
 ('Merluza',                       'proteinas',  90, 17.0,  0.0,  2.5),
 ('Bacalao fresco',                'proteinas',  82, 18.0,  0.0,  0.7),
 ('Huevo entero',                  'proteinas', 155, 13.0,  1.1, 11.0),
 ('Clara de huevo',                'proteinas',  52, 11.0,  0.7,  0.2),
 ('Gambas',                        'proteinas',  85, 20.0,  0.2,  0.5),
 ('Jamón serrano',                 'proteinas', 235, 31.0,  0.5, 12.0),
 ('Jamón cocido',                  'proteinas', 145, 19.0,  1.5,  7.0),

-- Lácteos
 ('Leche entera',                  'lacteos',    62,  3.2,  4.8,  3.5),
 ('Leche semidesnatada',           'lacteos',    46,  3.2,  4.7,  1.6),
 ('Leche desnatada',               'lacteos',    34,  3.4,  5.0,  0.1),
 ('Yogur natural',                 'lacteos',    61,  3.5,  4.7,  3.3),
 ('Yogur griego',                  'lacteos',    97,  9.0,  3.6,  5.0),
 ('Queso fresco',                  'lacteos',   174, 11.0,  4.0, 13.0),
 ('Queso manchego curado',         'lacteos',   390, 28.0,  0.5, 31.0),
 ('Queso mozzarella',              'lacteos',   280, 22.0,  2.2, 22.0),

-- Carbohidratos / cereales
 ('Arroz blanco cocido',           'carbohidratos', 130, 2.7, 28.0, 0.3),
 ('Arroz integral cocido',         'carbohidratos', 111, 2.6, 23.0, 0.9),
 ('Pasta cocida',                  'carbohidratos', 131, 5.0, 25.0, 1.1),
 ('Pan blanco',                    'carbohidratos', 265, 9.0, 49.0, 3.2),
 ('Pan integral',                  'carbohidratos', 247, 13.0,41.0, 3.4),
 ('Avena en copos',                'carbohidratos', 380,13.0, 67.0, 7.0),
 ('Patata cocida',                 'carbohidratos',  86, 1.7, 20.0, 0.1),
 ('Boniato cocido',                'carbohidratos',  76, 1.4, 17.7, 0.1),
 ('Quinoa cocida',                 'carbohidratos', 120, 4.4, 21.0, 1.9),
 ('Lentejas cocidas',              'carbohidratos', 116, 9.0, 20.0, 0.4),
 ('Garbanzos cocidos',             'carbohidratos', 164, 8.9, 27.0, 2.6),
 ('Judías blancas cocidas',        'carbohidratos', 127, 8.7, 22.8, 0.5),

-- Verduras
 ('Tomate',                        'verduras', 18, 0.9, 3.9, 0.2),
 ('Lechuga',                       'verduras', 15, 1.4, 2.9, 0.2),
 ('Espinacas',                     'verduras', 23, 2.9, 3.6, 0.4),
 ('Brócoli',                       'verduras', 34, 2.8, 7.0, 0.4),
 ('Calabacín',                     'verduras', 17, 1.2, 3.1, 0.3),
 ('Pimiento rojo',                 'verduras', 31, 1.0, 6.0, 0.3),
 ('Zanahoria',                     'verduras', 41, 0.9, 9.6, 0.2),
 ('Cebolla',                       'verduras', 40, 1.1, 9.3, 0.1),
 ('Pepino',                        'verduras', 15, 0.7, 3.6, 0.1),
 ('Aguacate',                      'verduras',160, 2.0, 9.0,15.0),

-- Frutas
 ('Manzana',                       'frutas', 52, 0.3, 14.0, 0.2),
 ('Plátano',                       'frutas', 89, 1.1, 23.0, 0.3),
 ('Naranja',                       'frutas', 47, 0.9, 12.0, 0.1),
 ('Fresas',                        'frutas', 32, 0.7,  8.0, 0.3),
 ('Pera',                          'frutas', 57, 0.4, 15.0, 0.1),
 ('Uva',                           'frutas', 69, 0.7, 18.0, 0.2),
 ('Kiwi',                          'frutas', 61, 1.1, 15.0, 0.5),
 ('Sandía',                        'frutas', 30, 0.6,  7.6, 0.2),

-- Grasas saludables / frutos secos
 ('Aceite de oliva virgen extra',  'grasas', 884, 0.0,  0.0,100.0),
 ('Almendras',                     'grasas', 579,21.0, 22.0,50.0),
 ('Nueces',                        'grasas', 654,15.0, 14.0,65.0),
 ('Cacahuetes',                    'grasas', 567,26.0, 16.0,49.0),
 ('Mantequilla',                   'grasas', 717, 0.9,  0.1,81.0),

-- Otros / suplementos comunes
 ('Chocolate negro 70%',           'otros', 600, 7.0, 46.0,42.0),
 ('Miel',                          'otros', 304, 0.3, 82.0, 0.0),
 ('Azúcar',                        'otros', 387, 0.0,100.0, 0.0),
 ('Tofu',                          'proteinas', 76, 8.0, 1.9, 4.8),
 ('Whey protein (suero)',          'proteinas', 380,75.0,10.0, 5.0);
