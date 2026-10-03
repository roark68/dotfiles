ds() {
  ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic \
  ANTHROPIC_AUTH_TOKEN="$(pass show agent/deepseek)" \
  ANTHROPIC_MODEL=deepseek-v4-pro \
  claude "$@"
}
