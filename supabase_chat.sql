-- ============================================================
-- PROCON Maceió — Migração: Chat e Anexos por Processo
-- Execute no Supabase > SQL Editor > New query
-- ============================================================

-- Tabela de mensagens do chat por processo
CREATE TABLE IF NOT EXISTS mensagens (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  processo_id TEXT NOT NULL REFERENCES processos(id) ON DELETE CASCADE,
  autor_id    TEXT NOT NULL,          -- 'admin' ou id do analista
  autor_nome  TEXT NOT NULL,
  autor_role  TEXT NOT NULL CHECK (autor_role IN ('admin','analista')),
  texto       TEXT,
  arquivo_nome TEXT,                  -- nome original do arquivo
  arquivo_url  TEXT,                  -- URL pública no Supabase Storage
  arquivo_tipo TEXT,                  -- 'pdf', 'doc', 'docx', etc
  lida_admin  BOOLEAN DEFAULT false,
  lida_analista BOOLEAN DEFAULT false,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Índice para buscar mensagens por processo rapidamente
CREATE INDEX IF NOT EXISTS idx_mensagens_processo ON mensagens(processo_id, created_at);

-- Permissões
GRANT ALL ON mensagens TO anon;
GRANT ALL ON mensagens TO authenticated;
ALTER TABLE mensagens DISABLE ROW LEVEL SECURITY;

-- Storage bucket para anexos (execute separado se necessário)
-- No painel do Supabase: Storage > New bucket > Nome: "anexos-processos" > Public: true
