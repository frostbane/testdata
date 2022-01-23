do
$$
    declare
        filename text := '001-user.sql';
    begin
        if not (select exists(select 1 from db_migrations where file = filename))
        then
            begin
                alter table "user" rename column ident to email;
                -- addming a new column during migration
                -- name is required (not null) but since we are adding it
                -- we need to add a default value for the existing records
                alter table "user" add column name text not null default 'empty';
            exception
                when duplicate_column then raise notice 'duplicate column "name" and "email" in table "user"';
            end;
            insert into "db_migrations" values (filename);
        else
            raise notice 'already executed, skipping', filename;
        end if;
    end
$$
