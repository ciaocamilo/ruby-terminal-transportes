# Terminal de Transportes

Gestión de ciudades, vehículos, viajes y venta de pasajes. Rails 8.1, Ruby 3.4, SQLite, Hotwire y Tailwind CSS.

## Desarrollo

Abrir la carpeta en VS Code y elegir **Reopen in Container** (requiere Docker). El devcontainer ejecuta `bin/setup`.

```sh
bin/rails db:seed   # usuarios admin@terminal.test y vendedor@terminal.test, clave "password"
bin/dev             # http://localhost:3000
```

Roles: el **administrador** gestiona ciudades, vehículos y viajes; el **vendedor** consulta viajes y vende pasajes.

## Pruebas y calidad

```sh
bin/rails test && bin/rails test:system
bin/rubocop
bin/brakeman
```

## Despliegue (Kamal)

Definir `KAMAL_REGISTRY_USERNAME`, `KAMAL_REGISTRY_PASSWORD`, `KAMAL_SERVER_IP`, `KAMAL_APP_HOST` y `SEED_PASSWORD`, y luego:

```sh
bin/kamal setup
bin/kamal seed
```

La versión Rails 5.1 original está en la etiqueta `legacy-rails5`.
