-- ============================================================
-- PROCON Maceió — Setup do banco de dados Supabase
-- Execute este script em: Supabase > SQL Editor > New query
-- ============================================================

-- Tabela de analistas
CREATE TABLE IF NOT EXISTS analistas (
  id          TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  name        TEXT NOT NULL,
  login       TEXT NOT NULL UNIQUE,
  pass        TEXT NOT NULL,
  ativo       BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Tabela de processos
CREATE TABLE IF NOT EXISTS processos (
  id                   TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  numero               TEXT NOT NULL UNIQUE,
  fornecedor           TEXT NOT NULL,
  tema                 TEXT NOT NULL,
  data_abertura        DATE NOT NULL,
  analista_id          TEXT REFERENCES analistas(id) ON DELETE SET NULL,
  situacao             TEXT NOT NULL DEFAULT 'pendente'
                         CHECK (situacao IN ('pendente','em_julgamento','multa','arquivado')),
  valor                NUMERIC(12,2),
  motivo_arquivamento  TEXT,
  data_julgamento      DATE,
  data_atribuicao      DATE,
  created_at           TIMESTAMPTZ DEFAULT now(),
  updated_at           TIMESTAMPTZ DEFAULT now()
);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_processos_updated_at ON processos;
CREATE TRIGGER trg_processos_updated_at
  BEFORE UPDATE ON processos
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- Dados iniciais — analistas de exemplo
-- ============================================================
INSERT INTO analistas (id, name, login, pass, ativo) VALUES
  ('ana1', 'Carlos Silva',   'analista1', 'ana123', true),
  ('ana2', 'Mariana Costa',  'analista2', 'ana456', true)
ON CONFLICT (login) DO NOTHING;

-- ============================================================
-- RLS (Row Level Security) — acesso público via anon key
-- O sistema usa a anon key com RLS desabilitado para simplicidade.
-- Para produção com RLS, configure políticas adequadas.
-- ============================================================
ALTER TABLE analistas DISABLE ROW LEVEL SECURITY;
ALTER TABLE processos DISABLE ROW LEVEL SECURITY;

-- Permissões para a role anon (usada pela anon key)
GRANT SELECT, INSERT, UPDATE, DELETE ON analistas TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON processos TO anon;

