package main

import "fmt"

type Foo struct {
	bar string
}

func main() {
	f := Foo{bar: "baz"}
	fmt.Printf("%+v\n", f)
}
