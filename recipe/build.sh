#!/usr/bin/env bash
set -ex

module='github.com/jaegertracing/jaeger'

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

# ensure binary destination
mkdir -vp "${PREFIX}/bin"

# copy built binaries
cp -v "src/${module}/cmd/agent/agent-${GOOS}-${GOARCH}" "${PREFIX}/bin/jaeger-agent"
cp -v "src/${module}/cmd/all-in-one/all-in-one-${GOOS}-${GOARCH}" "${PREFIX}/bin/jaeger-all-in-one"
cp -v "src/${module}/cmd/collector/collector-${GOOS}-${GOARCH}" "${PREFIX}/bin/jaeger-collector"
cp -v "src/${module}/cmd/ingester/ingester-${GOOS}-${GOARCH}" "${PREFIX}/bin/jaeger-ingester"
cp -v "src/${module}/cmd/query/query-${GOOS}-${GOARCH}" "${PREFIX}/bin/jaeger-query"
cp -v "src/${module}/cmd/tracegen/tracegen-${GOOS}-${GOARCH}" "${PREFIX}/bin/jaeger-tracegen"
cp -v "src/${module}/examples/hotrod/hotrod-${GOOS}-${GOARCH}" "${PREFIX}/bin/jaeger-hotrod"

# make executable
chmod -v 755 ${PREFIX}/bin/jaeger-agent
chmod -v 755 ${PREFIX}/bin/jaeger-all-in-one
chmod -v 755 ${PREFIX}/bin/jaeger-collector
chmod -v 755 ${PREFIX}/bin/jaeger-ingester
chmod -v 755 ${PREFIX}/bin/jaeger-query
chmod -v 755 ${PREFIX}/bin/jaeger-tracegen
chmod -v 755 ${PREFIX}/bin/jaeger-hotrod
