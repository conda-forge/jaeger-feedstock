#!/usr/bin/env bash
set -eux

if [ $PKG_NAME = "jaeger-example-hotrod" ]; then
    export bin="example-hotrod"
else
    export bin=$PKG_NAME
fi

cp bin/$bin $PREFIX/bin/$bin
