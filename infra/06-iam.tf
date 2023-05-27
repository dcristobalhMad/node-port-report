resource "aws_iam_role" "bucket_role" {
  name = "bucket-access-role"

  assume_role_policy = data.aws_iam_policy_document.trust.json
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::986014290352:oidc-provider/${local.oidc_part}"]
    }

    condition {
      test     = "StringLike"
      variable = "${local.oidc_part}:sub"
      values   = ["system:serviceaccount:default:s3-access"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "bucket_policy_attachment" {
  role       = aws_iam_role.bucket_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  # Replace with the desired bucket policy ARN
}