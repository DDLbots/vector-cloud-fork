# BUILD vector-cloud from root directory (see notes)
# does not work in current directory
#
export PWD=`pwd`
export GOPATH=/go
export GOOS=linux
export GOARCH=arm
export GOARM=7
export CGO_ENABLED=1
export CGO_LDFLAGS="-L/anki/lib"
export CGO_CFLAGS="-I/anki/lib"
export CC=arm-linux-gnueabi-gcc
export PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabi/pkgconfig
export CXX="arm-linux-gnueabi-g++-8"
export GOCACHE=/tmp

docker container run  -v "${PWD}":/go/src/digital-dream-labs/vector-cloud -v ${GOPATH}/pkg/mod:/go/pkg/mod -w /go/src/digital-dream-labs/vector-cloud -e GOROOT=/usr/local/go --user ${UID}:${GID} armbuilder  go build   -tags nolibopusfile,vicos  --trimpath -ldflags '-w -s -linkmode internal -extldflags "-static" -r /anki/lib' -o build/vic-cloud cloud/main.go

docker container run \
-v "${PWD}":/go/src/digital-dream-labs/vector-cloud \
-v ${GOPATH}/pkg/mod:/go/pkg/mod \
-w /go/src/digital-dream-labs/vector-cloud \
--user ${UID}:${GID} \
armbuilder \
upx build/vic-cloud

docker container run \
-v "${PWD}":/go/src/digital-dream-labs/vector-cloud \
-v ${GOPATH}/pkg/mod:/go/pkg/mod \
-w /go/src/digital-dream-labs/vector-cloud \
--user ${UID}:${GID} \
armbuilder \
go build  \
-tags nolibopusfile,vicos \
--trimpath \
-ldflags '-w -s -linkmode internal -extldflags "-static" -r /anki/lib' \
-o build/vic-gateway \
gateway/*.go

docker container run \
-v "${PWD}":/go/src/digital-dream-labs/vector-cloud \
-v ${GOPATH}/pkg/mod:/go/pkg/mod \
-w /go/src/digital-dream-labs/vector-cloud \
--user ${UID}:${GID} \
armbuilder \
upx build/vic-gateway
