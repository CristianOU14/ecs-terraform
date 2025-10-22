Intención del repositorio 🚀

Este repositorio aprovisiona una demo pequeña basada en ECS en AWS usando Terraform.
Compone varios módulos locales (VPC, seguridad, ALB, cluster ECS, grupo de autoescalado, IAM, ECR, definición de tareas y servicio ECS).
El punto de entrada principal es main.tf, que conecta entradas y salidas de los módulos.

Arquitectura general 🏗️

VPC y redes: modules/vpc/* crea una sola VPC con dos subredes públicas (public_subnets output).

Seguridad: modules/security/* expone tres grupos de seguridad: ecs_sg_id, ssh_sg_id, alb_sg_id (referenciados por otros módulos).

Balanceo de carga: modules/alb/* crea un Application Load Balancer, un grupo objetivo (target_type = "ip") y un listener HTTP. Salidas clave: alb_dns, target_group_arn.

Plano de control de ECS y capacidad: modules/ecs-cluster/* crea el cluster ECS. modules/auto-scaling/* crea un Launch Template + AutoScalingGroup que configura el agente ECS escribiendo ECS_CLUSTER en /etc/ecs/ecs.config.

IAM y políticas de ejecución: modules/iam/* crea roles de instancia y ejecución de tareas, y un instance profile. Salidas: iam_profile_arn, ecs_task_execution_role.

Artefactos de contenedores: modules/ecr/* crea el repositorio ECR usado por la definición de tarea.

Tareas y servicio: modules/task-definition/* define una tarea compatible con EC2 que referencia una imagen ECR (iue-rep:latest). modules/ecs-service/* crea un aws_ecs_service con launch_type = "EC2" y lo conecta al grupo objetivo del ALB.

Notas prácticas y patrones ⚡

Configuración de lanzamiento: El ASG usa un launch template con user_data que establece ECS_CLUSTER en /etc/ecs/ecs.config, para que las instancias se unan automáticamente al cluster ECS (modules/auto-scaling/main.tf).

Redes: se esperan subredes públicas y asignación de IP pública para las instancias (module.vpc.public_subnets).

ALB y servicios ECS: el grupo objetivo usa target_type = "ip" y el servicio ECS usa network_configuration (red awsvpc) y load_balancer { target_group_arn ... }. Si modificas puertos de contenedores, actualiza tanto modules/task-definition/main.tf como modules/ecs-service/main.tf.

Roles IAM: explícitos para que EC2 pueda comunicarse con ECS y obtener imágenes de ECR. Si cambias ECR o agregas registries privados, actualiza modules/iam/*.

Valores fijos importantes: filtro de AMI específico de región en modules/ami/main.tf (nombre con fecha y versión del kernel). Si falla la búsqueda de AMI, actualiza el filtro o usa una variable.

Dependencias en root main.tf: el orden se maneja con outputs de módulos y algunos depends_on explícitos para el servicio ECS (module.autoscaling y module.alb). Mantén esto al refactorizar para evitar condiciones de carrera.

Flujos de trabajo del desarrollador & comandos útiles 🛠️

Ciclo típico de Terraform:

terraform init          # primera vez / después de cambios en providers
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars


El repo depende de los módulos locales en modules/*, asegúrate de ejecutar desde la raíz del proyecto.

Tips de depuración:

Revisar terraform state y terraform show para inspeccionar recursos creados.

Usar la consola AWS (ECS / EC2 / ALB) para revisar user-data, registros de grupos objetivo y health checks.

Si las instancias ECS no se unen al cluster, verifica user_data en modules/auto-scaling/main.tf y el rol/perfil IAM de la instancia (modules/iam/*).

Convenciones del proyecto 📚

Módulos pequeños y de responsabilidad única bajo modules/ referenciados desde main.tf con source = "./modules/<nombre>".

Outputs se usan para conectar módulos (module.vpc.public_subnets, module.iam.ecs_task_execution_role, module.alb.target_group_arn). Al agregar nuevos módulos, expón solo los outputs necesarios.

Muchos valores están codificados (filtro AMI, tipos de instancia, desired_count). Prefiere cambios pequeños y explícitos; usa variables solo si se necesitan múltiples entornos.

Archivos importantes al cambiar comportamientos 🔍

Cambiar cómo se unen las instancias a ECS: modules/auto-scaling/main.tf (user_data + launch template).

Modificar imagen de contenedor/puertos: modules/task-definition/main.tf y modules/ecs-service/main.tf.

Ajustar redes / subredes: modules/vpc/* y modules/security/*.

Agregar políticas/roles: modules/iam/*.

Seguridad & restricciones para ediciones de IA 🛡️

No cambiar configuración remota/backend/state (no hay backend configurado). Evita introducir remotos de state sin revisión humana.

No actualizar versiones de providers o herramientas sin terraform init y verificación local: cambios pueden ser destructivos.

Al modificar IAM o bootstrap de instancias, usa variables y preserva valores por defecto.

Cuando necesites aclaraciones ❓

Pregunta al mantenedor sobre la región AWS esperada, familia de AMI deseada o restricciones de producción antes de modificar filtros AMI, tipos de instancia o diseño de subredes públicas.