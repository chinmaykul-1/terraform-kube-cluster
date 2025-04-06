data "aws_vpc" "default" {
    id = "vpc-0532f329c388396eb"
}

data "aws_subnets" "default1" {
    filter {
      name = "tag:default"
      values = ["yes"]
    }
}
