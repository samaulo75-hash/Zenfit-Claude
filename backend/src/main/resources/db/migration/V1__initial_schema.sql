-- =====================================================================
-- ZenFit — Esquema inicial PostgreSQL
-- Plataforma híbrida Fitness + Wellness + Salud Mental
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================================
-- ENUMS
-- =====================================================================

CREATE TYPE user_role          AS ENUM ('USER', 'ADMIN');
CREATE TYPE plan_type          AS ENUM ('FREE', 'PREMIUM');
CREATE TYPE gender_type        AS ENUM ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY');
CREATE TYPE fitness_goal       AS ENUM ('LOSE_WEIGHT', 'GAIN_MUSCLE', 'IMPROVE_ENDURANCE', 'MAINTAIN', 'REDUCE_STRESS', 'BETTER_SLEEP');
CREATE TYPE activity_level     AS ENUM ('SEDENTARY', 'LIGHT', 'MODERATE', 'ACTIVE', 'VERY_ACTIVE');
CREATE TYPE difficulty_level   AS ENUM ('BEGINNER', 'INTERMEDIATE', 'ADVANCED');
CREATE TYPE workout_type       AS ENUM ('STRENGTH', 'CARDIO', 'HIIT', 'YOGA', 'MOBILITY', 'STRETCHING', 'RECOVERY');
CREATE TYPE meditation_type    AS ENUM ('GUIDED', 'BREATHING', 'MINDFULNESS', 'RELAXATION', 'SLEEP');
CREATE TYPE mood_type          AS ENUM ('VERY_BAD', 'BAD', 'NEUTRAL', 'GOOD', 'VERY_GOOD');
CREATE TYPE habit_frequency    AS ENUM ('DAILY', 'WEEKLY', 'CUSTOM');
CREATE TYPE ai_reco_type       AS ENUM ('WORKOUT', 'MEDITATION', 'REST', 'HABIT', 'NUTRITION');
CREATE TYPE notification_type  AS ENUM ('REMINDER', 'ACHIEVEMENT', 'RECOMMENDATION', 'SYSTEM', 'CHALLENGE');

-- =====================================================================
-- FUNCIÓN AUXILIAR: updated_at automático
-- =====================================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- USUARIOS Y AUTENTICACIÓN
-- =====================================================================

CREATE TABLE users (
    id              UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    full_name       VARCHAR(150) NOT NULL,
    avatar_url      VARCHAR(500),
    role            user_role    NOT NULL DEFAULT 'USER',
    plan            plan_type    NOT NULL DEFAULT 'FREE',
    active          BOOLEAN      NOT NULL DEFAULT TRUE,
    email_verified  BOOLEAN      NOT NULL DEFAULT FALSE,
    last_login_at   TIMESTAMPTZ,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_email  ON users (email);
CREATE INDEX idx_users_active ON users (active);

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Tokens de refresco JWT
CREATE TABLE refresh_tokens (
    id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token       VARCHAR(500) NOT NULL UNIQUE,
    expires_at  TIMESTAMPTZ  NOT NULL,
    revoked     BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens (user_id);
CREATE INDEX idx_refresh_tokens_token   ON refresh_tokens (token);

-- =====================================================================
-- PERFIL DE BIENESTAR (1:1 con users)
-- =====================================================================

CREATE TABLE wellness_profiles (
    user_id          UUID            PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    date_of_birth    DATE,
    gender           gender_type,
    height_cm        NUMERIC(5,2)    CHECK (height_cm > 0 AND height_cm < 300),
    weight_kg        NUMERIC(5,2)    CHECK (weight_kg > 0 AND weight_kg < 500),
    fitness_goal     fitness_goal,
    activity_level   activity_level  NOT NULL DEFAULT 'MODERATE',
    medical_notes    TEXT,
    preferences      JSONB           NOT NULL DEFAULT '{}'::jsonb,
    created_at       TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_wellness_profiles_updated_at
    BEFORE UPDATE ON wellness_profiles
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- =====================================================================
-- FITNESS — EJERCICIOS, RUTINAS Y SESIONES
-- =====================================================================

CREATE TABLE exercises (
    id                  UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(150)      NOT NULL,
    description         TEXT,
    video_url           VARCHAR(500),
    image_url           VARCHAR(500),
    difficulty          difficulty_level  NOT NULL DEFAULT 'BEGINNER',
    estimated_seconds   INTEGER           CHECK (estimated_seconds > 0),
    muscle_groups       TEXT[]            NOT NULL DEFAULT '{}',
    equipment           TEXT[]            NOT NULL DEFAULT '{}',
    is_premium          BOOLEAN           NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_exercises_difficulty    ON exercises (difficulty);
CREATE INDEX idx_exercises_muscle_groups ON exercises USING GIN (muscle_groups);

CREATE TRIGGER trg_exercises_updated_at
    BEFORE UPDATE ON exercises
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE workouts (
    id                          UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
    name                        VARCHAR(150)      NOT NULL,
    description                 TEXT,
    type                        workout_type      NOT NULL,
    difficulty                  difficulty_level  NOT NULL DEFAULT 'BEGINNER',
    estimated_duration_minutes  INTEGER           CHECK (estimated_duration_minutes > 0),
    image_url                   VARCHAR(500),
    is_premium                  BOOLEAN           NOT NULL DEFAULT FALSE,
    created_by                  UUID              REFERENCES users(id) ON DELETE SET NULL,
    created_at                  TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_workouts_type       ON workouts (type);
CREATE INDEX idx_workouts_difficulty ON workouts (difficulty);

CREATE TRIGGER trg_workouts_updated_at
    BEFORE UPDATE ON workouts
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Relación N:M con metadata (orden, series, reps...)
CREATE TABLE workout_exercises (
    id            UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    workout_id    UUID    NOT NULL REFERENCES workouts(id)  ON DELETE CASCADE,
    exercise_id   UUID    NOT NULL REFERENCES exercises(id) ON DELETE RESTRICT,
    position      INTEGER NOT NULL CHECK (position >= 0),
    sets          INTEGER CHECK (sets > 0),
    reps          INTEGER CHECK (reps > 0),
    duration_seconds INTEGER CHECK (duration_seconds > 0),
    rest_seconds  INTEGER CHECK (rest_seconds >= 0),
    notes         TEXT,
    UNIQUE (workout_id, position)
);

CREATE INDEX idx_workout_exercises_workout_id  ON workout_exercises (workout_id);
CREATE INDEX idx_workout_exercises_exercise_id ON workout_exercises (exercise_id);

-- Sesión: cuando un usuario realiza un workout
CREATE TABLE workout_sessions (
    id                UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID         NOT NULL REFERENCES users(id)    ON DELETE CASCADE,
    workout_id        UUID         REFERENCES workouts(id)          ON DELETE SET NULL,
    started_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    completed_at      TIMESTAMPTZ,
    duration_seconds  INTEGER      CHECK (duration_seconds >= 0),
    calories_burned   INTEGER      CHECK (calories_burned >= 0),
    perceived_effort  SMALLINT     CHECK (perceived_effort BETWEEN 1 AND 10),
    notes             TEXT,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_workout_sessions_user_id    ON workout_sessions (user_id);
CREATE INDEX idx_workout_sessions_started_at ON workout_sessions (started_at DESC);

-- Detalle de cada ejercicio realizado dentro de la sesión
CREATE TABLE workout_session_exercises (
    id                UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id        UUID    NOT NULL REFERENCES workout_sessions(id) ON DELETE CASCADE,
    exercise_id       UUID    NOT NULL REFERENCES exercises(id)        ON DELETE RESTRICT,
    position          INTEGER NOT NULL CHECK (position >= 0),
    sets_completed    INTEGER CHECK (sets_completed >= 0),
    reps_completed    INTEGER CHECK (reps_completed >= 0),
    weight_kg         NUMERIC(6,2) CHECK (weight_kg >= 0),
    duration_seconds  INTEGER CHECK (duration_seconds >= 0)
);

CREATE INDEX idx_wse_session_id ON workout_session_exercises (session_id);

-- =====================================================================
-- WELLNESS — MEDITACIONES
-- =====================================================================

CREATE TABLE meditations (
    id                UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    title             VARCHAR(150)    NOT NULL,
    description       TEXT,
    type              meditation_type NOT NULL,
    duration_minutes  INTEGER         NOT NULL CHECK (duration_minutes > 0),
    audio_url         VARCHAR(500),
    image_url         VARCHAR(500),
    is_premium        BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_meditations_type ON meditations (type);

CREATE TRIGGER trg_meditations_updated_at
    BEFORE UPDATE ON meditations
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE meditation_sessions (
    id              UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID         NOT NULL REFERENCES users(id)       ON DELETE CASCADE,
    meditation_id   UUID         REFERENCES meditations(id)          ON DELETE SET NULL,
    started_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    completed_at    TIMESTAMPTZ,
    duration_seconds INTEGER     CHECK (duration_seconds >= 0),
    mood_before     mood_type,
    mood_after      mood_type,
    notes           TEXT,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_meditation_sessions_user_id    ON meditation_sessions (user_id);
CREATE INDEX idx_meditation_sessions_started_at ON meditation_sessions (started_at DESC);

-- =====================================================================
-- SUEÑO Y DESCANSO
-- =====================================================================

CREATE TABLE sleep_logs (
    id                UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sleep_date        DATE         NOT NULL,
    bedtime           TIMESTAMPTZ,
    wake_time         TIMESTAMPTZ,
    duration_minutes  INTEGER      CHECK (duration_minutes >= 0),
    quality           SMALLINT     CHECK (quality BETWEEN 1 AND 5),
    notes             TEXT,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, sleep_date)
);

CREATE INDEX idx_sleep_logs_user_date ON sleep_logs (user_id, sleep_date DESC);

-- =====================================================================
-- HÁBITOS
-- =====================================================================

CREATE TABLE habits (
    id                  UUID             PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID             NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name                VARCHAR(150)     NOT NULL,
    description         TEXT,
    frequency           habit_frequency  NOT NULL DEFAULT 'DAILY',
    target_per_period   INTEGER          NOT NULL DEFAULT 1 CHECK (target_per_period > 0),
    color               VARCHAR(20),
    icon                VARCHAR(50),
    active              BOOLEAN          NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_habits_user_id ON habits (user_id);

CREATE TRIGGER trg_habits_updated_at
    BEFORE UPDATE ON habits
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE habit_logs (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    habit_id    UUID        NOT NULL REFERENCES habits(id) ON DELETE CASCADE,
    log_date    DATE        NOT NULL,
    completed   BOOLEAN     NOT NULL DEFAULT TRUE,
    notes       TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (habit_id, log_date)
);

CREATE INDEX idx_habit_logs_habit_date ON habit_logs (habit_id, log_date DESC);

-- =====================================================================
-- IA — Recomendaciones y configuración
-- =====================================================================

CREATE TABLE ai_user_config (
    user_id      UUID         PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    preferences  JSONB        NOT NULL DEFAULT '{}'::jsonb,
    last_run_at  TIMESTAMPTZ,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_ai_user_config_updated_at
    BEFORE UPDATE ON ai_user_config
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE ai_recommendations (
    id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID          NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type          ai_reco_type  NOT NULL,
    title         VARCHAR(200)  NOT NULL,
    body          TEXT,
    payload       JSONB         NOT NULL DEFAULT '{}'::jsonb,
    generated_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    viewed_at     TIMESTAMPTZ,
    acted_upon    BOOLEAN       NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_ai_recos_user_id      ON ai_recommendations (user_id);
CREATE INDEX idx_ai_recos_generated_at ON ai_recommendations (generated_at DESC);

-- =====================================================================
-- NOTIFICACIONES
-- =====================================================================

CREATE TABLE notifications (
    id          UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID              NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type        notification_type NOT NULL DEFAULT 'SYSTEM',
    title       VARCHAR(200)      NOT NULL,
    body        TEXT,
    data        JSONB             NOT NULL DEFAULT '{}'::jsonb,
    read        BOOLEAN           NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    read_at     TIMESTAMPTZ
);

CREATE INDEX idx_notifications_user_unread ON notifications (user_id, read, created_at DESC);

-- =====================================================================
-- GAMIFICACIÓN — Logros, retos y estadísticas
-- =====================================================================

CREATE TABLE achievements (
    id           UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    code         VARCHAR(50)   NOT NULL UNIQUE,
    name         VARCHAR(150)  NOT NULL,
    description  TEXT,
    icon         VARCHAR(100),
    points       INTEGER       NOT NULL DEFAULT 10 CHECK (points >= 0),
    criteria     JSONB         NOT NULL DEFAULT '{}'::jsonb,
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE user_achievements (
    user_id         UUID         NOT NULL REFERENCES users(id)        ON DELETE CASCADE,
    achievement_id  UUID         NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
    unlocked_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, achievement_id)
);

CREATE TABLE challenges (
    id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name         VARCHAR(150) NOT NULL,
    description  TEXT,
    start_date   DATE         NOT NULL,
    end_date     DATE         NOT NULL,
    target_type  VARCHAR(50)  NOT NULL,
    target_value INTEGER      NOT NULL CHECK (target_value > 0),
    points       INTEGER      NOT NULL DEFAULT 50,
    is_active    BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CHECK (end_date >= start_date)
);

CREATE TABLE user_challenges (
    user_id      UUID         NOT NULL REFERENCES users(id)      ON DELETE CASCADE,
    challenge_id UUID         NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    progress     INTEGER      NOT NULL DEFAULT 0 CHECK (progress >= 0),
    completed    BOOLEAN      NOT NULL DEFAULT FALSE,
    completed_at TIMESTAMPTZ,
    joined_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, challenge_id)
);

CREATE TABLE user_stats (
    user_id              UUID         PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_points         INTEGER      NOT NULL DEFAULT 0,
    current_streak_days  INTEGER      NOT NULL DEFAULT 0,
    longest_streak_days  INTEGER      NOT NULL DEFAULT 0,
    total_workouts       INTEGER      NOT NULL DEFAULT 0,
    total_meditations    INTEGER      NOT NULL DEFAULT 0,
    total_minutes_active INTEGER      NOT NULL DEFAULT 0,
    last_activity_date   DATE,
    updated_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_user_stats_updated_at
    BEFORE UPDATE ON user_stats
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
