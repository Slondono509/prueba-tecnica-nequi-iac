# Infraestructura como Código (IaC) - Proyecto Nequi

Este repositorio contiene la infraestructura como código implementada con Terraform para desplegar una aplicación containerizada en AWS.

## 🏗 Arquitectura

La infraestructura está compuesta por los siguientes componentes principales:

### VPC (Virtual Private Cloud)
- Red virtual aislada en AWS
- Subredes públicas y privadas
- Configuración de enrutamiento y seguridad

### IAM (Identity and Access Management)
- Roles y políticas para ECS
- Grupos de seguridad
- Permisos necesarios para los servicios

### ECR (Elastic Container Registry)
- Registro de contenedores para almacenar imágenes Docker
- Configuración de políticas de retención

### RDS (Relational Database Service)
- Base de datos administrada
- Configuración de seguridad y acceso
- Integración con secretos para credenciales

### ECS (Elastic Container Service)
- Servicio de orquestación de contenedores
- Definición de tareas y servicios
- Balanceador de carga (ALB)
- Auto-scaling

### API Gateway
- Punto de entrada para las APIs
- Integración con el balanceador de carga
- Gestión de rutas y endpoints

## 🚀 Requisitos

- Terraform >= 1.0.0
- AWS CLI configurado
- Credenciales de AWS con permisos adecuados

## 📦 Estructura del Proyecto

```
.
├── main.tf              # Archivo principal de Terraform
├── variables.tf         # Definición de variables
├── terraform.tfvars     # Valores de las variables
└── modules/            # Módulos de Terraform
    ├── vpc/            # Configuración de red
    ├── iam/            # Roles y permisos
    ├── ecr/            # Registro de contenedores
    ├── rds/            # Base de datos
    ├── ecs/            # Servicios de contenedores
    └── api_gateway/    # Configuración de API Gateway
```

## 🛠 Uso

1. Inicializar Terraform:
```bash
terraform init
```

2. Revisar el plan de ejecución:
```bash
terraform plan
```

3. Aplicar los cambios:
```bash
terraform apply
```

4. Para destruir la infraestructura:
```bash
terraform destroy
```

## 🔐 Variables Importantes

| Variable | Descripción |
|----------|-------------|
| aws_region | Región de AWS donde se desplegará la infraestructura |
| project_name | Nombre del proyecto |
| environment | Entorno (dev, staging, prod) |
| vpc_cidr | CIDR block para la VPC |
| container_port | Puerto del contenedor |
| db_username | Usuario de la base de datos |
| db_password | Contraseña de la base de datos |

## 🔄 Dependencias entre Módulos

La infraestructura se despliega en el siguiente orden:

1. VPC
2. IAM
3. ECR
4. RDS
5. ECS
6. API Gateway

Cada módulo tiene dependencias explícitas definidas para asegurar un despliegue correcto.

## 🔒 Seguridad

- Todos los secretos se manejan a través de AWS Secrets Manager
- Las subredes están correctamente segmentadas
- Se implementan grupos de seguridad restrictivos
- Se utilizan roles IAM con el principio de mínimo privilegio

## 📝 Notas Importantes

- El backend de Terraform está configurado para almacenamiento local (puede ser migrado a S3)
- Se incluyen tags por defecto para mejor organización de recursos
- La infraestructura está diseñada para alta disponibilidad
- Se implementan mejores prácticas de seguridad de AWS

