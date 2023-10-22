terraform {
  cloud {
    organization = "mtc-terrans"

    workspaces {
      name = "terrans"
    }
  }
}