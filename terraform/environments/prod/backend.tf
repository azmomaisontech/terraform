terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "moses-main"

    workspaces {
      name = "terraform"
    }
  }
}
