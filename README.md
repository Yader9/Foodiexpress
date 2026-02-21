# FoodiExpress (Flutter) — Proyecto Completo

Proyecto de laboratorio basado en la guía del **Grupo A: FoodieExpress** (Menú + Detalle) con:
- **Home Page (Menú):** `GridView` con tarjetas (`Card`) mostrando imagen, nombre y precio.
- **Detail Page (Detalle):** imagen expandida, descripción, ingredientes, precio y botón **"Añadir al carrito"**.
- **Navegación:** Rutas nombradas + `arguments` (se envía un `FoodModel`).
- **Clean Architecture (simplificada):** organización dentro de `lib/`.

✅ Este repositorio/ZIP **ya incluye** carpetas de plataforma (`android/`, `ios/`, `web/`), por lo que **NO necesitas ejecutar** `flutter create`.

---

## Estructura requerida (lib/)

```
lib/
├── core/
│  └── app_theme.dart
├── features/
│  └── food_menu/
│     ├── data/
│     │  └── food_model.dart
│     └── presentation/
│        ├── pages/
│        │  ├── home_page.dart
│        │  └── detail_page.dart
│        └── widgets/
│           └── food_card.dart
└── main.dart
```

---

## Cómo ejecutarlo

1) Instala dependencias:
```bash
flutter pub get
```

2) Ejecuta en un dispositivo/emulador:
```bash
flutter run
```

---

## Nota sobre imágenes

La app usa imágenes con `Image.network()` (URLs públicas).
