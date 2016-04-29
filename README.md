# PgAssets

This is a way to manage your postgresql assets.  It creates an assets.sql file which contains all of your views, triggers, and functions.  This file is managed alongside your `schema.rb` file.

[![Build Status](https://travis-ci.org/forgottentea/pg_assets.svg?branch=master)](https://travis-ci.org/forgottentea/pg_assets)

## BUT WHY
There are three reasons.

### `structure.sql` is a pain
Sure you can use `structure.sql` and deal with the weird whitespace issues the pg_dump creates.  But this cooler.

### Tracking changes becomes easy
With a discrete `assets.sql` file, you can see changes to your assets through time, without trudging through migrations to piece together a partial history at best.

### Some assets are special
Have you ever had trouble managing a table that is used in a view?  Well now you can use the `touching_view` helper!

## HOW DO I USE IT
Its pretty painless.

0. Make sure your rails project uses postgresql
1. Add the gem to your Gemfile
2. `rake schema:dump`
3. check in your new file, `db/assets.sql`.

### Migrations
You can add assets using SQL statements, like so:
```ruby
class AddDatView < ActiveRecord::Migration

  def up
    sql = <<-SQL
      CREATE OR REPLACE VIEW public.dat_view AS
        SELECT 1;
    SQL

    execute sql
  end

  def down
    sql = <<-SQL
      DROP VIEW public.dat_view;
    SQL

    execute sql
  end
end
```
Once you run your migration, you will see changes to your `assets.sql` file.

### Migrations that effect views
Most migrations that effect a view (by modifying a table) will just result in an updated view.  Postgresql handles this for you and me, and after your migration runs, you will see changes to `assets.sql`

Sometimes, postgresql won't let you make changes to a table because a view depends on it.  `pg_assets` has a helper for that. `PgAssets::ViewsMigrationHelper` provides the `touching_view` method.  You pass a symbol which is the name of the effected view, like this:
```ruby
class BringThePain < ActiveRecord::Migration
 include PgAssets::ViewsMigrationHelper

 def change
   touching_view :a_view do
     change_column :sweet_table, :column_1, :text, :null => false
   end
 end
end
```

You may also want to re-define the view if, for instance, you drop a column

```ruby
class BringThePain < ActiveRecord::Migration
 include PgAssets::ViewsMigrationHelper

 def change
   new_defn = 'SELECT id, column_1, column_3 FROM sweet_table'

   touching_view :a_view, new_defn do
     remove_column :sweet_table, :column_2
   end
 end
end
```

## Configuration

By default all supported kinds of assets will be managed.  To opt out
of managing some kinds configure pg\_assets like this:

```ruby
PgAssets.config.manage_constraints = false
```

For a rails project put this code in an initializer.

## WHAT IT DO
Postgresql provides a lot of information about its assets through the `pg_catalog` schema.  There are views for each type of asset, and functions to get more information about some assets.  This gem is just a wrapper around that stuff to manipulate it and maintain the `assets.sql` file.  Also there is some special sauce.

## FUTURE PLANS
- Allow for some configuration options through initializers
- Support materialized views
- Support `types`, `enums`, and other types of assets
- Refactor models to use more joins and fewer queries
- Allow users to specify a dependency map.  Some dependencies can be read from the pg_catalog
- Port to `sequel` ORM

This project rocks and uses MIT-LICENSE.
