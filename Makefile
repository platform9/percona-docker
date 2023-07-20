BUILDDIR=$(CURDIR)/percona-xtradb-cluster-5.7-backup
registry_url ?= quay.io
image_name = ${registry_url}/platform9/percona-xtradb-cluster-operator
DOCKERFILE?=$(BUILDDIR)/Dockerfile
image_tag = v1.13.0-pf9-ipv6-pxc5.7-backup
PF9_TAG=$(image_name):${image_tag}
DOCKERARGS=
ifdef HTTP_PROXY
	DOCKERARGS += --build-arg http_proxy=$(HTTP_PROXY)
endif
ifdef HTTPS_PROXY
	DOCKERARGS += --build-arg https_proxy=$(HTTPS_PROXY)
endif

pf9-image: | $(BUILDDIR) ; $(info Building Docker image for pf9 Repo...) @ ## Build percona operator backup image
	@docker build -t $(PF9_TAG) -f $(DOCKERFILE)  $(CURDIR) $(DOCKERARGS)
	echo ${PF9_TAG} > $(BUILDDIR)/container-tag

pf9-push: 
	docker login
	docker push $(PF9_TAG)\
	&& docker rmi $(PF9_TAG)