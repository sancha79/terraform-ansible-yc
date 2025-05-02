terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "y0__xDY4qcDGMHdEyDVq5bzEqhMqX_kBmXgCq5-x-WtOjXqTN5O"
  cloud_id  = "b1gujqdsupce1bfof2c6"
  folder_id = "b1gtugrpv2b6d8d5lmbp"
  zone      = "ru-central1-a"
}
