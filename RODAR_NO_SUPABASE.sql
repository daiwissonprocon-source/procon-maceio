-- ============================================================
-- PROCON Maceió — RODAR ESTE ARQUIVO INTEIRO NO SUPABASE
--
-- Como usar:
--   1. Acesse https://supabase.com e abra seu projeto
--   2. Menu lateral: SQL Editor  >  botão "New query"
--   3. Cole TODO o conteúdo deste arquivo
--   4. Clique em RUN (canto inferior direito)
--   5. Deve aparecer "Success. No rows returned" — pronto!
--
-- Pode rodar de novo sem problema (é seguro reexecutar).
-- ============================================================


-- ████ PARTE 1 — Libera o envio de arquivos (corrige o erro de upload) ████████

-- Garante que o bucket existe e é público (leitura dos arquivos)
insert into storage.buckets (id, name, public)
values ('anexos-processos', 'anexos-processos', true)
on conflict (id) do update set public = true;

-- Remove políticas antigas com estes nomes (evita erro ao reexecutar)
drop policy if exists "anexos_leitura_publica" on storage.objects;
drop policy if exists "anexos_envio_publico"   on storage.objects;
drop policy if exists "anexos_update_publico"  on storage.objects;
drop policy if exists "anexos_delete_publico"  on storage.objects;

-- Cria as permissões públicas do bucket
create policy "anexos_leitura_publica" on storage.objects
  for select using (bucket_id = 'anexos-processos');

create policy "anexos_envio_publico" on storage.objects
  for insert with check (bucket_id = 'anexos-processos');

create policy "anexos_update_publico" on storage.objects
  for update using (bucket_id = 'anexos-processos')
  with check (bucket_id = 'anexos-processos');

create policy "anexos_delete_publico" on storage.objects
  for delete using (bucket_id = 'anexos-processos');


-- ████ PARTE 2 — Colunas dos 2 documentos do julgamento ██████████████████████
--      (Decisão e Dosimetria)

ALTER TABLE processos
  ADD COLUMN IF NOT EXISTS anexo_decisao_url     TEXT,
  ADD COLUMN IF NOT EXISTS anexo_decisao_nome    TEXT,
  ADD COLUMN IF NOT EXISTS anexo_decisao_tipo    TEXT,
  ADD COLUMN IF NOT EXISTS anexo_dosimetria_url  TEXT,
  ADD COLUMN IF NOT EXISTS anexo_dosimetria_nome TEXT,
  ADD COLUMN IF NOT EXISTS anexo_dosimetria_tipo TEXT;


-- ████ PARTE 3 — Tabela do Histórico (andamentos, atos e pedidos) █████████████

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

GRANT ALL ON andamentos TO anon;
GRANT ALL ON andamentos TO authenticated;

-- Libera acesso público (o portal usa a chave anônima).
-- Em vez de desativar o RLS (que pode não persistir em alguns projetos),
-- criamos uma política que permite todas as operações.
ALTER TABLE andamentos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "andamentos_acesso_total" ON andamentos;
CREATE POLICY "andamentos_acesso_total" ON andamentos
  FOR ALL USING (true) WITH CHECK (true);
