-- =====================================================================
-- ZenFit — Más objetivos fitness en el perfil de bienestar
-- =====================================================================

ALTER TYPE fitness_goal ADD VALUE IF NOT EXISTS 'TONE_BODY';
ALTER TYPE fitness_goal ADD VALUE IF NOT EXISTS 'INCREASE_STRENGTH';
ALTER TYPE fitness_goal ADD VALUE IF NOT EXISTS 'INCREASE_FLEXIBILITY';
ALTER TYPE fitness_goal ADD VALUE IF NOT EXISTS 'IMPROVE_POSTURE';
ALTER TYPE fitness_goal ADD VALUE IF NOT EXISTS 'INCREASE_ENERGY';
ALTER TYPE fitness_goal ADD VALUE IF NOT EXISTS 'BUILD_HABITS';
