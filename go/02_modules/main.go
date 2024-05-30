package main

import (
	"fmt"

	"kotur.me/devlab/modules/module1"
	"kotur.me/devlab/modules/module1/funcs"
	"kotur.me/devlab/modules/module2"
	m2funcs "kotur.me/devlab/modules/module2/funcs"
)

func main() {
	fmt.Println("Version is", module1.Version())
	fmt.Println("Version is", module2.Version())
	funcs.Hello()
	m2funcs.World()
}
