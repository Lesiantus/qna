# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "158.160.11.203", user: "lesiantus", roles: %w{app db web}, primary: true
set :rails_env, :production
# --------------
set :ssh_options, {
  keys: %w(/home/lesiantus/.ssh/id_ed25519),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 2222
}
