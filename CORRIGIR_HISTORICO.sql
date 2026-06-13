-- ============================================================
-- PROCON Maceió — Correção: libera gravação no Histórico
-- Cole no Supabase > SQL Editor > New query > RUN
-- ============================================================

GRANT ALL ON andamentos TO anon;
GRANT ALL ON andamentos TO authenticated;

ALTER TABLE andamentos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "andamentos_acesso_total" ON andamentos;
CREATE POLICY "andamentos_acesso_total" ON andamentos
  FOR ALL USING (true) WITH CHECK (true);
