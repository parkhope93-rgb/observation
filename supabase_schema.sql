-- Run this in Supabase SQL Editor.
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
  name text not null, color text not null default '0xFF83D0C6', created_at timestamptz not null default now(),
  unique(user_id, name)
);
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid not null references public.categories(id) on delete cascade,
  name text not null, description text, progress integer not null default 0 check(progress between 0 and 100),
  due_date date, archived boolean not null default false, created_at timestamptz not null default now()
);
create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid not null references public.categories(id) on delete cascade,
  project_id uuid references public.projects(id) on delete cascade,
  title text not null, status text not null default 'todo' check(status in ('todo','in_progress','on_hold','done')),
  due_date date, created_at timestamptz not null default now()
);
create table if not exists public.events (
  id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid not null references public.categories(id) on delete cascade,
  title text not null, starts_at timestamptz not null, created_at timestamptz not null default now()
);

alter table public.categories enable row level security;
alter table public.projects enable row level security;
alter table public.tasks enable row level security;
alter table public.events enable row level security;

do $$ declare t text; begin
 foreach t in array array['categories','projects','tasks','events'] loop
  execute format('drop policy if exists "Users manage own %I" on public.%I', t, t);
  execute format('create policy "Users manage own %I" on public.%I for all using (auth.uid() = user_id) with check (auth.uid() = user_id)', t, t);
 end loop;
end $$;

-- Keep project/task category relationships consistent. Tasks with a project
-- inherit its category and must belong to the same user.
create or replace function public.sync_task_category() returns trigger language plpgsql as $$
begin
 if new.project_id is not null then
   select category_id into new.category_id from public.projects where id=new.project_id and user_id=new.user_id;
   if new.category_id is null then raise exception 'Project not found for this user'; end if;
 end if;
 return new;
end $$;
drop trigger if exists task_category_sync on public.tasks;
create trigger task_category_sync before insert or update of project_id, category_id on public.tasks for each row execute function public.sync_task_category();
