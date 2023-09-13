## Go programming language

Simple:

```go
cd 01_helloworld
go run main.go
```

Init go module

```go
cd 02_module
go mod init helloworld
```

Update module requirements

```go
go mod tidy
```

Building a binary

```
go build
```

## TODO

- Investigate how to use comments to embed additional metadata
  - No just struct tags
