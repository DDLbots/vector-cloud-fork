.PHONY: vic-cloud vic-gateway

all: vic-cloud vic-gateway

go_deps:
	echo `/usr/local/go/bin/go version` && cd $(PWD) && /usr/local/go/bin/go mod download

vic-cloud: go_deps
	CGO_ENABLED=1 GOARM=7 GOARCH=arm CC=arm-linux-gnueabi-gcc CXX=arm-linux-gnueabi-g++ PKG_CONFIG_PATH="$(PWD)/armlibs/lib/pkgconfig" CGO_CFLAGS="-I$(PWD)/armlibs/include -I$(PWD)/armlibs/include/opus -I$(PWD)/armlibs/include/ogg" CGO_CXXFLAGS="-std=c++11" CGO_LDFLAGS="-L$(PWD)/armlibs/lib -L$(PWD)/armlibs/lib/arm-linux-gnueabi/android" /usr/local/go/bin/go build -tags nolibopusfile,vicos -ldflags '-w -s -linkmode internal -extldflags "-static" -r /anki/lib' -o build/vic-cloud cloud/main.go

	upx build/vic-cloud


vic-gateway: go_deps
	CGO_ENABLED=1 GOARM=7 GOARCH=arm CC=arm-linux-gnueabi-gcc CXX=arm-linux-gnueabi-g++ PKG_CONFIG_PATH="$(PWD)/armlibs/lib/pkgconfig" CGO_CFLAGS="-I$(PWD)/armlibs/include -I$(PWD)/armlibs/include/opus -I$(PWD)/armlibs/include/ogg" CGO_CXXFLAGS="-std=c++11" CGO_LDFLAGS="-L$(PWD)/armlibs/lib -L$(PWD)/armlibs/lib/arm-linux-gnueabi/android" /usr/local/go/bin/go build -tags nolibopusfile,vicos -ldflags '-w -s -linkmode internal -extldflags "-static" -r /anki/lib' -o build/vic-gateway gateway/*.go

	upx build/vic-gateway

