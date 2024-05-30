package examples

import "fmt"
import "time"

func Detached() {
	go hello()
}

func hello() {
	time.Sleep(1 * time.Minute)
	fmt.Println("it's most likely you will never see this")
	// We need have some kind of waiting mechanism
}
