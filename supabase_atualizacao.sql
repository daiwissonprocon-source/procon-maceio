-- ============================================================
-- PROCON Maceió — Atualização: 2 anexos no julgamento + Histórico
-- Execute no Supabase > SQL Editor > New query > Run.
-- ============================================================

-- ── 1) Colunas para os dois documentos do julgamento ─────────────────────────
--    Decisão e Dosimetria (substitui o anexo único de multa)
ALTER TABLE processos
  ADD COLUMN IF NOT EXISTS anexo_decisao_url     TEXT,
  ADD COLUMN IF NOT EXISTS anexo_decisao_nome    TEXT,
  ADD COLUMN IF NOT EXISTS anexo_decisao_tipo    TEXT,
  ADD COLUMN IF NOT EXISTS anexo_dosimetria_url  TEXT,
  ADD COLUMN IF NOT EXISTS anexo_dosimetria_nome TEXT,
  ADD COLUMN IF NOT EXISTS anexo_dosimetria_tipo TEXT;

-- ── 2) Tabela de Histórico (andamentos, atos e pedidos por processo) ─────────
CREATE TABLE IF NOT EXISTS andamentos (
  id              TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  processo_id     TEXT NOT NULL REFERENCES processos(id) ON DELETE CASCADE,
  tipo            TEXT NOT NULL DEFAULT 'andamento'
                    CHECK (tipo IN ('andamento','ato','pedido')),
  texto           TEXT NOT NULL,
  autor_nome      TEXT,
  autor_role      TEXT,
  resposta        TEXT,
  respondido_por  TEXT,
  respondido_em   TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_andamentos_processo ON andamentos(processo_id);

-- Permissões (o portal usa a chave anônima, sem RLS, igual às outras tabelas)
GRANT ALL ON andamentos TO anon;
GRANT ALL ON andamentos TO authenticated;
ALTER TABLE andamentos DISABLE ROW LEVEL SECURITY;
