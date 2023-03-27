# 실습 1

## 1.0 준비
terraform 설치
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
> [설치경로이동(Terraform)](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)


## 1.1 기본명령어
설치된 terraform 버전확인
```
terraform version
```

help옵션을 통한 사용법 확인
```
terraform --help
```

## 1.2 실습 프로젝트 시작

작업할 폴더 생성 및 실습용 TF파일 복사
```
mkdir project
cp lecture01/main.tf ./project/main.tf
cd project
```

> 실습용 TF파일 확인 [main.tf](../main.tf)

## 1.3 Terraform 실행
```
terraform init
terraform plan -out exec01.tfplan
terraform apply exec01.tfplan
```


