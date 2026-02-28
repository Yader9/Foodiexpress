# FoodiExpress (Flutter) — Proyecto Completo

Proyecto de laboratorio basado en la guía del **Grupo A: FoodieExpress** con:

## Laboratorio 1 (UI + Navegación)
- **Home Page (Menú):** `GridView` con tarjetas (`Card`) mostrando imagen, nombre y precio.
- **Detail Page (Detalle):** imagen expandida, descripción, ingredientes, precio y botón **"Añadir al carrito"**.
- **Navegación:** Rutas nombradas + `arguments` (se envía un `FoodModel`).
- **Clean Architecture (simplificada):** organización dentro de `lib/`.

## Laboratorio 2 (SQLite + Favoritos + CRUD)
- **Persistencia con SQLite:** el catálogo y los favoritos **se guardan localmente** y **no se pierden** al cerrar la app.
- **Favoritos persistentes:** se puede **marcar/desmarcar** platillos como favoritos y se guardan en SQLite.
- **CRUD demostrable:**
  - **Menú (foods):** agregar, listar, editar, eliminar y **eliminar todo** el catálogo.
  - **Favoritos (favorites):** agregar/quitar favoritos y **vaciar favoritos**.
- **Manejo de errores:** operaciones de base de datos con `try-catch`.
- **UI Feedback:** `SnackBar` y `CircularProgressIndicator` mientras la BD procesa o cargan imágenes.

✅ Este repositorio/ZIP **ya incluye** carpetas de plataforma (`android/`, `ios/`, `web/`), por lo que **NO necesitas ejecutar** `flutter create`.

---

## Estructura requerida (lib/)

```text
lib/
├── core/
│  ├── app_theme.dart
│  └── database/
│     └── database_helper.dart
├── features/
│  └── food_menu/
│     ├── data/
│     │  ├── food_model.dart
│     │  └── datasources/
│     │     ├── food_local_datasource.dart
│     │     └── favorites_local_datasource.dart
│     └── presentation/
│        ├── pages/
│        │  ├── MainTab_page.dart
│        │  ├── home_page.dart
│        │  ├── favorites_page.dart
│        │  ├── detail_page.dart
│        │  └── food_form_page.dart
│        └── widgets/
│           └── food_card.dart
└── main.dart
```

---

## Cómo ejecutarlo

1) Instala dependencias:
```bash
flutter pub get

2) Ejecuta en un dispositivo/emulador:
```bash
flutter run
```

---

## Nota sobre imágenes

La app usa imágenes con Image.network() (URLs públicas) y muestra un CircularProgressIndicator mientras cargan.
