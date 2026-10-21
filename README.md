# 🚀 AWS Infrastructure & Bootstrapping Pipeline

![Terraform_CI_CD](https://img.shields.io/badge/Terraform__CI--CD-passing-brightgreen?style=flat&logo=githubactions)

> **Projeto Prático de Automação e DevOps:** Implementação de uma pipeline de Integração e Entrega Contínua (CI/CD) e Infraestrutura como Código (IaC) que orquestra, valida e provisiona instâncias EC2 na AWS com bootstrapping via Cloud-Init.

---

## 📌 Visão Geral do Projeto

Este repositório contém uma automação completa desenvolvida com **Terraform**, **Cloud-Init** e **GitHub Actions** para o provisionamento e inicialização padronizada de servidores web na nuvem AWS.

A pipeline executa o ciclo de vida completo da infraestrutura:

1. **Validação de Código:** Análise sintática (`terraform validate`) e verificação de formatação (`terraform fmt`).
2. **Planeamento de Infraestrutura:** Geração do plano de execução (`terraform plan`) para pré-visualização das alterações.
3. **Provisionamento Cloud:** Criação automatizada de Security Groups e instâncias EC2 na AWS.
4. **Bootstrapping (Cloud-Init):** Atualização do SO, alteração de hostname e instalação não interativa do Docker e Nginx.
5. **Validação de Aplicação:** Disponibilização imediata do servidor web ativo e responsivo no IP público.
6. **Encerramento Controlado:** Desconstrução simplificada da infraestrutura via `terraform destroy`.

---

## 🛠️ Tecnologias & Componentes Utilizados

Todas as definições de infraestrutura foram parametrizadas utilizando o ecossistema oficial do **HashiCorp Terraform** e **AWS**.

| Componente | Ferramenta / Recurso | Finalidade / Papel no Ecossistema | Recurso Criado |
| :--- | :--- | :--- | :--- |
| **IaC Engine** | `Terraform` | Provisionamento e gestão de estado da infraestrutura | N/A (Local / Runner) |
| **Cloud Provider** | `AWS EC2` | Instância de computação virtual rodando Ubuntu 22.04 LTS | `web_server` |
| **Segurança Cloud** | `AWS Security Group` | Regras de firewall para tráfego de entrada (HTTP/SSH) e saída livre | `web-server-sg` |
| **Bootstrapping** | `Cloud-Init` | Automação do primeiro arranque para instalação do Docker e Nginx | `user-data.yml` |
| **Pipeline CI/CD** | `GitHub Actions` | Execução automatizada dos testes de código e planeamento | `.github/workflows` |

---

## 💻 Comandos e Instruções Empregados

A solução utiliza a CLI nativa do Terraform para gerir todo o ciclo de vida da infraestrutura:

* `terraform init` : Inicializa o diretório de trabalho baixando os provedores da AWS.
* `terraform fmt -check` : Valida se os ficheiros `.tf` seguem os padrões oficiais de formatação.
* `terraform validate` : Confirma a integridade e sintaxe das declarações HCL.
* `terraform plan` : Gera e exibe o plano de execução sem alterar recursos reais.
* `terraform apply` : Aplica as alterações e provisiona os recursos diretamente na AWS.
* `terraform destroy` : Remove completamente todos os recursos provisionados para evitar custos.

---

## ⚙️ Como a Pipeline Valida a Infraestrutura

A validação ocorre de forma automatizada através de etapas sequenciais (*steps*) na *job* de CI/CD:

1. **Checkout Code ( `actions/checkout` )**: Realiza o descarregamento do código-fonte para o ambiente do runner.
2. **Setup Terraform ( `hashicorp/setup-terraform` )**: Configura a versão exata da CLI do Terraform na máquina de execução.
3. **Format Check ( `terraform fmt` )**: Garante a aderência aos padrões de código limpo.
4. **Validation ( `terraform validate` )**: Analisa a consistência lógica entre ficheiros `.tf`, variáveis e referências de módulos.
5. **Dry Run ( `terraform plan` )**: Autentica na AWS via *GitHub Secrets* e simula a criação dos recursos, gerando relatórios nos logs.

---

## 🚀 Passo a Passo para Execução

### 1. Pré-requisitos Locais
* [Terraform](https://www.terraform.io/) instalado (versão 1.5+).
* [AWS CLI](https://aws.amazon.com/cli/) instalado.
* Chaves de acesso da AWS (`AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`).

---

### 2. Execução Local

1. **Clonar o Repositório:**
   ```bash
   git clone https://github.com/SEU_USUARIO/NOME_DO_REPOSITORIO.git
   cd NOME_DO_REPOSITORIO/terraform
   ```

2. **Configurar Credenciais da AWS:**
   ```bash
   aws configure
   ```
   *Insira sua Access Key, Secret Key e a região `sa-east-1`.*

3. **Inicializar e Validar o Ambiente:**
   ```bash
   terraform init
   terraform validate
   ```

4. **Visualizar o Plano de Execução:**
   ```bash
   terraform plan
   ```

5. **Provisionar a Infraestrutura na AWS:**
   ```bash
   terraform apply
   ```
   *Confirme digitando `yes` quando solicitado.*

6. **Validar a Aplicação Web:**
   Copie o IP público exibido no output final e aceda no seu navegador:
   ```text
   http://<SEU_IP_PUBLICO>
   ```

7. **Destruir a Infraestrutura (Limpeza):**
   ```bash
   terraform destroy
   ```
   *Confirme digitando `yes`.*

---

### 3. Configuração do Pipeline de CI/CD (GitHub Actions)

Para que a pipeline funcione automaticamente no GitHub:

1. Vá ao seu repositório no GitHub em **Settings** > **Secrets and variables** > **Actions**.
2. Adicione as seguintes *Repository Secrets*:
   * `AWS_ACCESS_KEY_ID` : Sua chave de acesso pública da AWS.
   * `AWS_SECRET_ACCESS_KEY` : Sua chave de acesso secreta da AWS.
3. Faça um `git push` para a branch `main` para disparar a execução automática do pipeline na aba **Actions**.

---

## 📊 Evidências de Execução

Todas as evidências de execução, status dos *jobs* e relatórios de criação dos recursos podem ser acompanhados diretamente na aba **Actions** deste repositório.

A infraestrutura é parametrizada para ser destruída facilmente após a validação, garantindo a eficiência de custos e o isolamento dos ambientes a cada *commit*.