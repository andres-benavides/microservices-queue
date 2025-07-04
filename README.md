# 🧩 Microservicios: Order & Customer

Este proyecto implementa una arquitectura de microservicios utilizando **Ruby on Rails**, **PostgreSQL**, y **RabbitMQ** para gestionar órdenes y clientes de forma desacoplada. Cada servicio se ejecuta en su propio contenedor Docker y se comunica a través de HTTP y eventos asíncronos (mensajería).

---

## 🗂 Estructura del Proyecto

- `order_service`: Maneja la creación y consulta de órdenes.
- `customer_service`: Maneja la creación y administración de clientes.
- Ambos servicios se comunican entre sí vía HTTP y publican/consumen eventos a través de RabbitMQ.

---

## 🚀 Requisitos

- Docker
- Docker Compose

---

## 🔧 Inicialización del Proyecto

Después de clonar el repositorio, ejecuta el siguiente script para construir los contenedores, crear las bases de datos y aplicar las migraciones:

El archivo debe tener permisos de ejecucion

```bash
sudo chmod +x init_project.sh
./init_project.sh
```

---

## ▶️ Iniciar los Servicios

Usa el siguiente script para levantar los servicios y comenzar a consumir mensajes desde RabbitMQ:
El archivo debe tener permisos de ejecucion

```bash
sudo chmod +x start_project.sh
./start_project.sh
```

Esto levantará:

- `order_service` en el puerto **3005**
- `customer_service` en el puerto **3006**
- RabbitMQ accesible vía interfaz de administración en el puerto **15672**

---

## 📮 Comunicación entre Servicios

- `order_service` consulta al `customer_service` vía HTTP para validar clientes.
- Una vez creada la orden, se publica un evento `order.created` al exchange `orders_exchange`.
- `customer_service` escucha este evento y actualiza el `orders_count` del cliente correspondiente.

---

## 📫 Endpoints y Pruebas Manuales

En el repositorio encontrarás archivos de **Postman** (Monokera.postman_collection.json) con las peticiones necesarias para probar:

- Crear un cliente
- Obtener un cliente
- Obtener todos los clientes
- Crear una orden
- Obtener órdenes por cliente

---

## ✅ Pruebas Automatizadas

### 🧪 Pruebas Unitarias (order_service)

Ejecuta:
El archivo debe tener permisos de ejecucion

```bash
sudo chmod +x run_test_order.sh
./run_test_order.sh
```

Este script:

1. Usa `docker-compose.test.yml`
2. Crea y migra las bases de datos de prueba
3. Ejecuta los tests de `order_service` con RSpec

### 🔁 Pruebas de Integración

Ejecuta:
El archivo debe tener permisos de ejecucion

```bash
sudo chmod +x run_integration_test
./run_integration_test.sh
```

Este script:

1. Levanta ambos servicios (`order_service` y `customer_service`) en entorno de test
2. Corre pruebas end-to-end donde se valida la integración entre servicios vía HTTP y RabbitMQ

---

## 🧠 Arquitectura del Sistema

![Arquitectura del Proyecto](https://raw.githubusercontent.com/andres-benavides/microservices-queue/refs/heads/main/monokera.png)

---

## 📁 Scripts disponibles

| Script                    | Descripción                                                 |
| ------------------------- | ----------------------------------------------------------- |
| `init_project.sh`         | Construye los servicios y ejecuta las migraciones iniciales |
| `start_project.sh`        | Inicia los servicios y la escucha de eventos                |
| `run_test_order.sh`       | Ejecuta pruebas unitarias del `order_service`               |
| `run_integration_test.sh` | Ejecuta pruebas de integración entre ambos servicios        |

---

## 🐇 Acceso a RabbitMQ

- URL: [http://localhost:15672](http://localhost:15672)
- Usuario: `guest`
- Contraseña: `guest`

---

## 🛠 Tecnologías Usadas

- Ruby on Rails 7
- PostgreSQL 16
- RabbitMQ 3
- RSpec
- Docker y Docker Compose

---

## 📌 Notas adicionales

- Recuerda que cada servicio es completamente independiente y desacoplado.
- Los contenedores deben ejecutarse en red interna para que puedan resolverse los nombres de host como `order_service` y `customer_service`.
- Asegúrate de que los puertos 3005, 3006 y 15672 estén disponibles en tu máquina local.

---
