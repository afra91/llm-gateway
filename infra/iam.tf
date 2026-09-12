resource "aws_iam_role" "test" {
  name = "pod_identity_test"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy" "test" {
  name = "pod_identity_test-policy"
  role = aws_iam_role.test.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:GetCallerIdentity"
      Resource = "*"
    }]
  })
}

resource "aws_eks_pod_identity_association" "test" {
  cluster_name    = module.eks.cluster_name
  namespace       = "default"
  service_account = "test-sa"
  role_arn        = aws_iam_role.test.arn
}
