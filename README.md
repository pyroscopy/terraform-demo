# 🚀 Terraform 실습 가이드

## 📋 목차
- [1. 인프라 관리 자동화란?](#1-인프라-관리-자동화란)
- [2. 수작업 vs 자동화의 차이](#2-수작업-vs-자동화의-차이)
- [3. Terraform 소개 및 설치](#3-terraform-소개-및-설치)
- [4. Terraform 구성요소](#4-terraform-구성요소)
- [5. 주요 명령어](#5-주요-명령어)
- [6. AWS 자격 증명 설정](#6-aws-자격-증명-설정)
- [7. EC2 + S3 예제 구성](#7-ec2--s3-예제-구성)
- [8. 모듈화 실습](#8-모듈화-실습)
- [9. 마무리 요약](#9-마무리-요약)
- [10. 참고 자료](#10-참고-자료)

## 1. 인프라 관리 자동화란?

### 정의
- 인프라를 코드로 관리하고 자동화된 방식으로 리소스를 생성, 수정, 삭제

### 목적
- 수작업 제거
- 재현 가능한 인프라
- 형상 관리(Git 등) 가능

## 2. 수작업 vs 자동화의 차이

| 항목 | 수작업 인프라 | 자동화 인프라 (Terraform) |
|------|--------------|-------------------------|
| 관리 방식 | 클릭, 콘솔 작업 | 코드 기반 선언 |
| 변경 추적 | 어려움 | Git 등으로 추적 가능 |
| 실수 가능성 | 높음 | 검증, 시뮬레이션 가능 |
| 일관성 | 사람마다 다름 | 코드로 일관성 유지 |

## 3. Terraform 소개 및 설치

### Terraform이란?
- HashiCorp에서 만든 오픈소스 IaC 도구
- AWS, GCP, Azure 등 멀티클라우드 지원

### 설치
```bash
# Ubuntu Linux 기준
# 1. HashiCorp GPG 키 추가
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# 2. HashiCorp APT 저장소 등록
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# 3. 패키지 목록 업데이트
sudo apt update

# 4. Terraform 설치
sudo apt install terraform

# 5. 설치 확인
terraform -version
```

## 4. Terraform 구성요소

- **.tf 파일**: 선언형 인프라 코드
- **Provider**: 사용할 클라우드 정의 (aws, google, azurerm)
- **Resource**: 실제 생성할 인프라
- **Variable**: 동적 파라미터 설정
- **Output**: 실행 결과 출력
- **Module**: 재사용 가능한 코드 단위

## 5. 주요 명령어

```bash
terraform init       # 초기화
terraform plan       # 실행 계획 미리보기
terraform apply      # 인프라 생성
terraform destroy    # 인프라 제거
```

## 6. AWS 자격 증명 설정

```bash
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=yyy
export AWS_DEFAULT_REGION=ap-northeast-2
```

## 7. EC2 + S3 예제 구성

### main.tf
```hcl
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0c9c942bd7bf113a2"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-tf-demo-bucket-2025"
}
```

### 실행
```bash
terraform init
terraform plan
terraform apply
terraform apply -auto-approve
terraform plan -destroy
terraform destroy
terraform destroy -target
```

## 8. 모듈화 실습

### 모듈 구조 예시
```
terraform-demo/
├── main.tf
├── modules/
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── s3/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

### 모듈 내부 예시

#### modules/ec2/main.tf
```hcl
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
}
```

#### modules/ec2/variables.tf
```hcl
variable "ami" {}
variable "instance_type" {}
```

#### modules/ec2/outputs.tf
```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```

### 메인에서 모듈 사용하기

#### main.tf
```hcl
module "my_ec2" {
  source         = "./modules/ec2"
  ami            = "ami-0c9c942bd7bf113a2"
  instance_type  = "t2.micro"
}
```

```bash
terraform init
terraform apply
```

## 9. 마무리 요약

| 핵심 개념 | 설명 |
|----------|------|
| init | 초기화 (모듈, provider 다운로드) |
| plan | 실행 계획 확인 |
| apply | 선언한 인프라 생성 |
| destroy | 리소스 정리 |
| 모듈 | 재사용 가능한 코드 단위, 협업 및 확장성 강화 |

## 10. 참고 자료

- [Terraform 공식 문서](https://www.terraform.io/docs)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
