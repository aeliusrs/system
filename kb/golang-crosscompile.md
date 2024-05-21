Golang cross compilation:
check supported platform by running "go tool dist list", platforms are listed in the format of "${os}/${arch}"
cross compilation command: GOOS=${os} GOARCH=${arch} go build -o ${output_dir}
has context menu
