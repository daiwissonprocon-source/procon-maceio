-- ============================================================
-- PROCON Maceió — Migração: Correção e Julgados
-- Execute no Supabase > SQL Editor > New query
-- ============================================================

-- Novas colunas na tabela processos
ALTER TABLE processos
  ADD COLUMN IF NOT EXISTS resultado_analista TEXT CHECK (resultado_analista IN ('multa','arquivado')),
  ADD COLUMN IF NOT EXISTS data_correcao DATE,
  ADD COLUMN IF NOT EXISTS obs_correcao TEXT;

-- Atualiza o CHECK de situacao para incluir os novos estados
ALTER TABLE processos DROP CONSTRAINT IF EXISTS processos_situacao_check;
ALTER TABLE processos ADD CONSTRAINT processos_situacao_check
  CHECK (situacao IN ('pendente','em_julgamento','multa','arquivado','aguardando_correcao','julgado'));

-- Garante permissões
GRANT ALL ON processos TO anon;
GRANT ALL ON analistas TO anon;
GRANT ALL ON processos TO authenticated;
GRANT ALL ON analistas TO authenticated;

ALTER TABLE processos DISABLE ROW LEVEL SECURITY;
ALTER TABLE analistas DISABLE ROW LEVEL SECURITY;

-- ── Colunas para anexo do julgamento de multa ────────────────────────────────
ALTER TABLE processos
  ADD COLUMN IF NOT EXISTS anexo_multa_url   TEXT,
  ADD COLUMN IF NOT EXISTS anexo_multa_nome  TEXT,
  ADD COLUMN IF NOT EXISTS anexo_multa_tipo  TEXT;
