include crd.Makefile
include gcloud.Makefile
include var.Makefile
include images.Makefile

CHART_NAME := oes-gmp
APP_ID ?= $(CHART_NAME)

VERIFY_WAIT_TIMEOUT = 1800
