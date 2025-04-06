data "aws_vpc" "default" {
    id = "vpc-0532f329c388396eb"
}

data "aws_subnets" "default1" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
}
