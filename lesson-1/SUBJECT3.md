# Subject 3: Shipping Carriers

## Objective
Add shipping carriers with delivery delays, managed via Django admin, and display them on the frontend.

**Git skills practiced:** branching, committing, pushing, creating a Pull Request

---

## Setup

1. Clone the repository (if not already done)
2. Create your feature branch from `main` called `feature/shipping-carriers`
3. Start the development servers with `./start-dev.sh`

---

## Tasks

### Task 1: Frontend - Mark Feature in API

**File to modify:** `frontend/src/api/products.ts`

Add a feature marker at the top of the file:

```diff
+// Feature: Shipping Carriers
+export const API_VERSION = "2.0-shipping";
+
 export interface Product {
```

**Git:** Commit your changes

---

### Task 2: Backend - Create Carrier Model

**File to modify:** `backend/core/api/models.py`

Add a `Carrier` model with name and delivery delay:

```diff
 class Product(models.Model):
     ...

+
+class Carrier(models.Model):
+    name = models.CharField(max_length=100)
+    delay_days = models.IntegerField()
+
+    def __str__(self):
+        return self.name
```

**Git:** Commit your changes

---

### Task 3: Backend - Register in Django Admin

**File to modify:** `backend/core/api/admin.py`

```diff
-from .models import Product
+from .models import Product, Carrier

 admin.site.register(Product)
+
+@admin.register(Carrier)
+class CarrierAdmin(admin.ModelAdmin):
+    list_display = ('name', 'delay_days')
```

**Git:** Commit your changes

---

### Task 4: Backend - Run Database Migration

Create and apply the migration:

```bash
cd backend/core
uv run python manage.py makemigrations
uv run python manage.py migrate
```

**Git:** Commit the generated migration file

---

### Task 5: Backend - Add Carriers API Endpoint

**File to modify:** `backend/core/api/urls.py`

```diff
-from .models import Product
+from .models import Product, Carrier


 class ProductSerializer(serializers.ModelSerializer):
     class Meta:
         model = Product
         fields = '__all__'


+class CarrierSerializer(serializers.ModelSerializer):
+    class Meta:
+        model = Carrier
+        fields = '__all__'
+
+
 class ProductViewSet(viewsets.ModelViewSet):
     queryset = Product.objects.all()
     serializer_class = ProductSerializer


+class CarrierViewSet(viewsets.ModelViewSet):
+    queryset = Carrier.objects.all()
+    serializer_class = CarrierSerializer
+
+
 router = routers.DefaultRouter()
 router.register(r'products', ProductViewSet)
+router.register(r'carriers', CarrierViewSet)
```

**Git:** Commit your changes

---

### Task 6: Backend - Create Carriers via Admin

1. Go to http://localhost:8000/admin/
2. Login with your superuser account
3. Add carriers, for example:
   - Colissimo - 3 jours
   - Chronopost - 1 jour
   - Mondial Relay - 5 jours

---

### Task 7: Frontend - Create Carrier Type and API

**File to create:** `frontend/src/api/carriers.ts`

```tsx
export interface Carrier {
  id: number;
  name: string;
  delay_days: number;
}

export async function fetchCarriers(): Promise<Carrier[]> {
  const response = await fetch("http://localhost:8000/api/carriers/");
  return response.json();
}
```

**Git:** Commit your changes

---

### Task 8: Frontend - Create ShippingSection Component

**File to create:** `frontend/src/components/ShippingSection.tsx`

```tsx
import { useState, useEffect } from 'react';
import { Carrier, fetchCarriers } from '../api/carriers';

export default function ShippingSection() {
  const [carriers, setCarriers] = useState<Carrier[]>([]);

  useEffect(() => {
    fetchCarriers().then(setCarriers);
  }, []);

  if (carriers.length === 0) return null;

  return (
    <div className="bg-green-100 text-green-800 py-6 mb-8">
      <div className="max-w-4xl mx-auto px-8">
        <h2 className="text-lg font-semibold mb-4">Livraison</h2>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          {carriers.map((carrier) => (
            <div key={carrier.id} className="bg-white rounded-lg p-4 shadow-sm">
              <p className="font-semibold">{carrier.name}</p>
              <p className="text-sm">{carrier.delay_days} jours ouvrés</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
```

**Git:** Commit your changes

---

### Task 9: Frontend - Add ShippingSection to App.tsx

**File to modify:** `frontend/src/App.tsx`

```diff
 import { useProducts } from './contexts/ProductsContext';
+import ShippingSection from './components/ShippingSection';
 import Spinner from "./Spinner";
```

Add the section after the hero, at the start of main:

```diff
       </header>
       <main id="main">
+        <ShippingSection />
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
- [ ] Added `Carrier` model
- [ ] Registered Carrier in Django admin
- [ ] Created and applied migration
- [ ] Added carriers API endpoint
- [ ] Created carriers via admin
- [ ] Created `Carrier` type and fetch function
- [ ] Created `ShippingSection` component
- [ ] Updated `App.tsx` to display the section
- [ ] Made atomic commits with clear messages
- [ ] Pushed branch and created PR
