require "yaml"

users_info = YAML.load_file("users.yaml")
p users_info.keys