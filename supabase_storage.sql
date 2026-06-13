-- ============================================================
-- PROCON Maceió — Storage: libera upload e leitura no bucket
-- "anexos-processos"
--
-- Corrige o erro: "new row violates row-level security policy"
-- que aparece ao tentar enviar arquivos (Decisão, Dosimetria, anexos do chat).
--
-- COMO USAR: Supabase > SQL Editor > New query > cole tudo > Run.
-- ============================================================

-- 1) Garante que o bucket existe e é público (leitura dos arquivos)
insert into storage.buckets (id, name, public)
values ('anexos-processos', 'anexos-processos', true)
on conflict (id) do update set public = true;

-- 2) Remove políticas antigas com estes nomes (evita erro ao reexecutar)
drop policy if exists "anexos_leitura_publica" on storage.objects;
drop policy if exists "anexos_envio_publico"   on storage.objects;
drop policy if exists "anexos_update_publico"  on storage.objects;
drop policy if exists "anexos_delete_publico"  on storage.objects;

-- 3) Cria as permissões públicas para o bucket anexos-processos
--    (o portal usa a chave anônima, então precisa liberar para "anon" e "public")

-- Leitura (ver/baixar arquivos)
create policy "anexos_leitura_publica" on storage.objects
  for select using (bucket_id = 'anexos-processos');

-- Envio (upload de novos arquivos)
create policy "anexos_envio_publico" on storage.objects
  for insert with check (bucket_id = 'anexos-processos');

-- Substituição (upsert/atualizar arquivo existente)
create policy "anexos_update_publico" on storage.objects
  for update using (bucket_id = 'anexos-processos')
  with check (bucket_id = 'anexos-processos');

-- Exclusão
create policy "anexos_delete_publico" on storage.objects
  for delete using (bucket_id = 'anexos-processos');
