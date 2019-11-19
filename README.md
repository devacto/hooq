# Deploys microservices using Terraform

Terraform scripts to deploy an API and frontend microservices.

### 1. Architecture

#### 1.1. Architecture Option 1

The picture below shows 

![Arch Option 1](./docs/images/hooq_arch_op_1.png)

#### 1.2. Architecture Option 2


#### 1.3. Not Deployed

Some elements of the architecture are not reflected in the Terraform script
because of lack of time.

These elements are: Route53, AWS WAF, and AWS Elasticache.

### 2. Deployment

#### 2.1. Code Organisation

Code used in this project is organised into modules. For example, the code for
deploying the API can be found here. Front-end, database, and reverse proxy
Terraform codes are also stored in their respective folders.



#### 2.2. Deployment Environments

### 3. Integration with BuildKite

BuildKite is a continuous integration and deployment runner similar to Jenkins.

#### 3.1. Pipeline-as-code



#### 3.2. Secure secrets
