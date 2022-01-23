create table if not exists public.db_migrations
(
  file text not null,
  created_at timestamp with time zone not null default now(),
  constraint db_migrations_unique_file unique (file)
)
with
(
  OIDS = false
);
