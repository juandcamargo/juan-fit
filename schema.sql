-- Juan Fit — esquema de Supabase
-- Corre esto completo en: tu proyecto de Supabase → SQL Editor → New query → pegar → Run

create table if not exists app_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table app_state enable row level security;

-- Cada usuario autenticado solo puede leer su propia fila
create policy "select_own_state"
  on app_state for select
  using (auth.uid() = user_id);

-- Cada usuario autenticado solo puede crear su propia fila
create policy "insert_own_state"
  on app_state for insert
  with check (auth.uid() = user_id);

-- Cada usuario autenticado solo puede actualizar su propia fila
create policy "update_own_state"
  on app_state for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Cada usuario autenticado solo puede borrar su propia fila
create policy "delete_own_state"
  on app_state for delete
  using (auth.uid() = user_id);

-- Nota de seguridad: el código de la app es público (repo público en GitHub), así que la llave
-- "anon public" de Supabase también queda visible a cualquiera. Eso es normal y seguro en Supabase
-- SIEMPRE que Row Level Security esté activo con estas políticas: sin haber iniciado sesión con el
-- enlace por correo, auth.uid() es null y ninguna de estas políticas deja pasar nada.
