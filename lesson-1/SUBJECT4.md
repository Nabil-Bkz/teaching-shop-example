# Subject 4: Site Settings

## Objective
Add site settings managed via Django admin, starting with an "orders enabled" toggle. Display a message on the frontend when orders are disabled.

**Git skills practiced:** branching, committing, pushing, creating a Pull Request

---

## Setup

1. Clone the repository (if not already done)
2. Create your feature branch from `main` called `feature/site-settings`
3. Start the development servers with `./start-dev.sh`

---

## Tasks

### Task 1: Frontend - Mark Feature in API

**File to modify:** `frontend/src/api/products.ts`

Add a feature marker at the top of the file:

```diff
+// Feature: Site Settings
+export const API_VERSION = "2.0-settings";
+
 export interface Product {
```

**Git:** Commit your changes

---

### Task 2: Backend - Create SiteSettings Model

**File to modify:** `backend/core/api/models.py`

Add a `SiteSettings` model with an `orders_enabled` field:

```diff
 class Product(models.Model):
     ...

+
+class SiteSettings(models.Model):
+    orders_enabled = models.BooleanField(default=True)
+
+    class Meta:
+        verbose_name_plural = "Site Settings"
+
+    def __str__(self):
+        return "Site Settings"
```

**Git:** Commit your changes

---

### Task 3: Backend - Register in Django Admin

**File to modify:** `backend/core/api/admin.py`

```diff
-from .models import Product
+from .models import Product, SiteSettings

 admin.site.register(Product)
+
+@admin.register(SiteSettings)
+class SiteSettingsAdmin(admin.ModelAdmin):
+    list_display = ('orders_enabled',)
```

**Git:** Commit your changes

---

### Task 4: Backend - Create and Modify Migration

Create the migration:

```bash
cd backend/core
uv run python manage.py makemigrations
```

Then modify the generated migration file to create a default row with orders disabled:

**File to modify:** `backend/core/api/migrations/0003_sitesettings.py`

```diff
 from django.db import migrations, models


+def create_default_settings(apps, schema_editor):
+    SiteSettings = apps.get_model('api', 'SiteSettings')
+    SiteSettings.objects.create(orders_enabled=False)
+
+
 class Migration(migrations.Migration):
     ...
     operations = [
         migrations.CreateModel(
             name='SiteSettings',
             ...
         ),
+        migrations.RunPython(create_default_settings),
     ]
```

Then apply the migration:

```bash
uv run python manage.py migrate
```

**Git:** Commit the migration file

---

### Task 5: Backend - Add Settings API Endpoint

**File to modify:** `backend/core/api/urls.py`

```diff
-from .models import Product
+from .models import Product, SiteSettings
+from rest_framework.decorators import api_view
+from rest_framework.response import Response


 class ProductSerializer(serializers.ModelSerializer):
     ...


+@api_view(['GET'])
+def site_settings(request):
+    settings = SiteSettings.objects.first()
+    if not settings:
+        return Response({'orders_enabled': True})
+    return Response({'orders_enabled': settings.orders_enabled})
+
+
 router = routers.DefaultRouter()
 router.register(r'products', ProductViewSet)


 urlpatterns = [
     path('admin/', admin.site.urls),
     path('api/', include(router.urls)),
+    path('api/settings/', site_settings),
 ]
```

**Git:** Commit your changes

---

### Task 6: Frontend - Create Settings Type and API

**File to create:** `frontend/src/api/settings.ts`

```tsx
export interface SiteSettings {
  orders_enabled: boolean;
}

export async function fetchSettings(): Promise<SiteSettings> {
  const response = await fetch("http://localhost:8000/api/settings/");
  return response.json();
}
```

**Git:** Commit your changes

---

### Task 7: Frontend - Create OrdersDisabledBanner Component

**File to create:** `frontend/src/components/OrdersDisabledBanner.tsx`

```tsx
import { useState, useEffect } from 'react';
import { SiteSettings, fetchSettings } from '../api/settings';

export default function OrdersDisabledBanner() {
  const [settings, setSettings] = useState<SiteSettings | null>(null);

  useEffect(() => {
    fetchSettings().then(setSettings);
  }, []);

  if (!settings || settings.orders_enabled) return null;

  return (
    <div className="bg-red-100 text-red-800 text-center py-4 mb-8">
      <p className="font-semibold">Les commandes sont actuellement désactivées</p>
    </div>
  );
}
```

**Git:** Commit your changes

---

### Task 8: Frontend - Add Banner to App.tsx

**File to modify:** `frontend/src/App.tsx`

```diff
 import { useProducts } from './contexts/ProductsContext';
+import OrdersDisabledBanner from './components/OrdersDisabledBanner';
 import Spinner from "./Spinner";
```

Add the banner at the start of main:

```diff
       </header>
       <main id="main">
+        <OrdersDisabledBanner />
         <div className="text-center text-lg text-gray-600 mb-8">
```

**Git:** Commit your changes

---

## Push and Create Pull Request

1. Push your branch to the remote repository
2. Create a Pull Request on GitHub:
   - Base: `main`
   - Compare: your feature branch
   - Write a clear title and description
3. Request a review from a teammate

---

## Checklist

- [ ] Created feature branch from `main`
- [ ] Added feature marker in `products.ts`
- [ ] Added `SiteSettings` model
- [ ] Registered SiteSettings in Django admin
- [ ] Created migration with default data (orders disabled)
- [ ] Added settings API endpoint
- [ ] Created `SiteSettings` type and fetch function
- [ ] Created `OrdersDisabledBanner` component
- [ ] Updated `App.tsx` to display the banner
- [ ] Made atomic commits with clear messages
- [ ] Pushed branch and created PR
