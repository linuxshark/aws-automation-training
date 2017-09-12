# REPOSITORIO PARA SCRIPTS DE AUTOMATIZACION DE INFRAESTRUCTURA DE ENTRENAMIENTO DE TAC-EMPRESARIAL

El presente repositorio contiene todos los scripts (shell y ansible) para el despliegue automatizado de elementos de infraestructura CLOUD para la plataforma de entrenamiento de TAC-empresarial en Amazon Web Services.


## Pre-requisitos:

* Cliente amazon (aws cli) previamente instalado y configurado (preferiblemente via "pip"):

```bash
pip install awscli
aws configure
```

**NOTA: La region utilizada es: us-west-2**

* Ansible instalado y operativo (con modulos de python para AWS).
* Git instalado y operativo.

## Componentes del repositorio:

Los directorios en el repositorio se describen a continuación:

* **keys**: Keys utilizados en produccion.
* **playbooks**: Playbooks de ansible para creación de instancias y grupos de autoscaling.
* **scripts**: Scripts para creación de keys, vpc's, grupos de seguridad, roles y cualquier otro elemento básico que no requiera ser creado vía ansible.
* **aws-roles**: Archivos "json" requeridos por scripts de creación de roles.

## Modo de uso:

Los scripts del directorio "scripts" se deben ejecutar primero (y en orden númerico, indicado por el propio nombre del script) para la creación de los elementos básicos de la nube.

Los playbooks de ansible son ejecutados luego de finalizar la ejecución de los scripts.

Cada script y playbook tiene una sección inicial de variables que debe ser adaptada a las condiciones reales de la nube (region, cidr, etc.).

## Orden de ejecución:

Desde el directorio raiz del repositorio, se deben ejecutar los scripts y playbooks en el siguiente orden:

```bash
./scripts/00-bucket-creation.sh
./scripts/01-ssh-key-MASTER-creation.sh
./scripts/02-new-vpc-creation.sh
./scripts/03-security-groups-creation.sh
./scripts/04-roles-s3-creation.sh
ansible-playbook ./playbooks/00-instance-prod-frontend.yaml
```

**NOTA IMPORTANTE: Se deben revisar tanto los scripts como los playboos antes de ejecutarlos, porque muchos tienen variables que dependen de elementos creados previamente. Especialmente los playbooks requieren variables que son creadas por algunos de los scripts que se ejecutan (desde el 00 al 04)**

