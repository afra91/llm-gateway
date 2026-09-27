ephemeral "random_password" "pw" {
  length = 32
}

resource "aws_secretsmanager_secret" "test_secret" {
  name                    = "test-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "test_secret" {
  secret_id                = aws_secretsmanager_secret.test_secret.id
  secret_string_wo         = ephemeral.random_password.pw.result
  secret_string_wo_version = 1
}
