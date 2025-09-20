# Terraform AWS Cloud Project

Este proyecto utiliza Terraform para desplegar una infraestructura básica en AWS que incluye una VPC, subredes públicas y privadas, instancias EC2 y grupos de seguridad.

## Arquitectura

La infraestructura desplegada incluye:

- **VPC** en la región `us-east-1` con CIDR personalizable
- **Subredes**:
  - Subred pública con acceso a Internet
  - Subred privada sin acceso directo a Internet
- **Internet Gateway** para conectividad externa
- **Tabla de rutas** para la subred pública
- **Instancias EC2** con múltiples opciones de despliegue:
  - Usando `count` para crear múltiples instancias
  - Usando `for_each` para mayor flexibilidad
  - Instancia de monitoreo condicional
- **Grupos de seguridad** con reglas dinámicas de ingreso
- **Key Pair** existente para acceso SSH

## Prerrequisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.12.2
- Cuenta de AWS con permisos apropiados
- AWS CLI configurado o credenciales de acceso
- Key pair existente en AWS llamado "mykey"

## Uso Rápido

1. **Clonar el repositorio**

   ```bash
   git clone <repository-url>
   cd terraform-cloud-project
   ```

2. **Configurar variables**

   Crea un archivo `terraform.tfvars` con los siguientes valores:

   ```hcl
   # Configuración de red
   virginia_cidr = "10.0.0.0/16"
   subnets = ["10.0.1.0/24", "10.0.2.0/24"]
   sg_ingress_cidr = "0.0.0.0/0"  # ⚠️ Cambiar por tu IP pública para mayor seguridad
   
   # Configuración EC2
   ec2_specs = {
     ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2
     instance_type = "t2.micro"
   }
   
   # Puertos de ingreso adicionales
   ingress_ports_list = [80, 443, 8080]
   
   # Monitoreo
   enable_monitoring = true
   
   # Credenciales AWS
   access_key = "tu-access-key"
   secret_key = "tu-secret-key"
   
   # Tags
   tags = {
     project = "terraform-cloud"
     env     = "dev"
     region  = "us-east-1"
     owner   = "tu-nombre"
   }
   ```

3. **Inicializar Terraform**

   ```bash
   terraform init
   ```

4. **Planificar el despliegue**

   ```bash
   terraform plan
   ```

5. **Aplicar la configuración**

   ```bash
   terraform apply
   ```

6. **Obtener outputs**

   ```bash
   terraform output
   ```

## Variables de Configuración

| Variable | Tipo | Descripción | Requerida |
|----------|------|-------------|-----------|
| `virginia_cidr` | string | CIDR block para la VPC | ✅ |
| `subnets` | list(string) | Lista de CIDRs para subredes [pública, privada] | ✅ |
| `sg_ingress_cidr` | string | CIDR permitido para acceso SSH | ✅ |
| `ec2_specs` | map(string) | Especificaciones EC2 (ami, instance_type) | ✅ |
| `ingress_ports_list` | list(number) | Lista de puertos de ingreso adicionales | ✅ |
| `enable_monitoring` | bool | Habilitar instancia de monitoreo | ✅ |
| `access_key` | string | AWS Access Key | ✅ |
| `secret_key` | string | AWS Secret Key | ✅ |
| `tags` | map(string) | Tags para recursos | ✅ |

## Configuración Avanzada

### Instancias EC2

El proyecto incluye tres configuraciones diferentes para instancias EC2:

1. **Con Count**: Crea instancias basadas en una lista predefinida
2. **Con For Each**: Mayor flexibilidad para manejo de instancias
3. **Instancia de Monitoreo**: Condicional basada en `enable_monitoring`

### Grupos de Seguridad

- **Puerto 22**: SSH desde el CIDR especificado
- **Puertos dinámicos**: Configurables via `ingress_ports_list`
- **Egreso**: Permitido hacia cualquier destino

### Naming Convention

Los recursos utilizan un sufijo basado en las tags:

```text
${project}-${env}-${region}
```

## Outputs

- `ec2_public_ip`: IP pública de la instancia EC2 principal

## Seguridad

⚠️ **Importante**:

- Cambia `sg_ingress_cidr` por tu IP pública específica en lugar de `0.0.0.0/0`
- No hardcodees las credenciales AWS en el código
- Considera usar AWS IAM roles en lugar de access keys
- Revisa regularmente los grupos de seguridad

## Limpieza

Para destruir toda la infraestructura:

```bash
terraform destroy
```

## Estructura del Proyecto

```text
terraform-cloud-project/
├── providers.tf      # Configuración de providers
├── variables.tf      # Definición de variables
├── locals.tf         # Variables locales
├── data.tf          # Data sources
├── vpc.tf           # Recursos de red (VPC, subredes, etc.)
├── ec2.tf           # Instancias EC2
├── output.tf        # Outputs del proyecto
├── .gitignore       # Archivos ignorados por Git
└── README.md        # Este archivo
```

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## Notas Importantes

- Asegúrate de tener el key pair "mykey" creado en tu cuenta de AWS
- Los costos de AWS son responsabilidad del usuario
- Siempre ejecuta `terraform plan` antes de `terraform apply`
- Mantén tus credenciales seguras y nunca las subas al repositorio
