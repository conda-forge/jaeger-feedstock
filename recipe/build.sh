#!/usr/bin/env bash
set -ex

module='github.com/jaegertracing/jaeger'

export GO111MODULE=off
export CGO_ENABLED=1
export GOPATH="$( pwd )"

if [ `uname` = "Darwin" ]; then
    export GOOS="darwin"
else
    export GOOS="linux"
fi

# TODO: ppc64le, aarch64
export GOARCH="amd64"

env | grep GO

# TODO: automate this by reading makefile?
go get github.com/wadey/gocovmerge
go get golang.org/x/lint/golint
go get github.com/mjibson/esc
go get github.com/securego/gosec/cmd/gosec
go get honnef.co/go/tools/cmd/staticcheck

make -C "src/${module}" \
  install-tools \
  build-platform-binaries

# ensure staging destination
mkdir bin third-party-licenses

# copy built binaries
cp -v "src/${module}/cmd/agent/agent-${GOOS}-${GOARCH}" "bin/jaeger-agent"
cp -v "src/${module}/cmd/all-in-one/all-in-one-${GOOS}-${GOARCH}" "bin/jaeger-all-in-one"
cp -v "src/${module}/cmd/collector/collector-${GOOS}-${GOARCH}" "bin/jaeger-collector"
cp -v "src/${module}/cmd/ingester/ingester-${GOOS}-${GOARCH}" "bin/jaeger-ingester"
cp -v "src/${module}/cmd/query/query-${GOOS}-${GOARCH}" "bin/jaeger-query"
cp -v "src/${module}/cmd/tracegen/tracegen-${GOOS}-${GOARCH}" "bin/jaeger-tracegen"
cp -v "src/${module}/examples/hotrod/hotrod-${GOOS}-${GOARCH}" "bin/example-hotrod"

# make executable
chmod -v 755 bin/*

cd src
# gather licenses
# go-licenses save "${module}/cmd/agent" \
#   --save_path=../third-party-licenses/jaeger-agent
# go-licenses save "${module}/cmd/all-in-one/all-in-one-${GOOS}-${GOARCH}" \
#   --save_path=../third-party-licenses/jaeger-all-in-one
# go-licenses save "${module}/cmd/collector/collector-${GOOS}-${GOARCH}" \
#   --save_path=../third-party-licenses/jaeger-collector
# go-licenses save "${module}/cmd/ingester/ingester-${GOOS}-${GOARCH}" \
#   --save_path=../third-party-licenses/jaeger-ingester
# go-licenses save "${module}/cmd/query/query-${GOOS}-${GOARCH}" \
#   --save_path=../third-party-licenses/jaeger-query
# go-licenses save "${module}/cmd/tracegen/tracegen-${GOOS}-${GOARCH}" \
#   --save_path=../third-party-licenses/jaeger-tracegen
# go-licenses save "${module}/examples/hotrod/hotrod-${GOOS}-${GOARCH}" \
#   --save_path=../third-party-licenses/example-hotrod
