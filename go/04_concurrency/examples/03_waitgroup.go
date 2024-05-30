package examples

import (
	"fmt"
	"sync"
)

func WaitGroup() {
	var wg sync.WaitGroup

	// Number of goroutines to wait for
	numGoroutines := 3
	wg.Add(numGoroutines)

	for i := 1; i <= numGoroutines; i++ {
		go func(i int) {
			defer wg.Done() // Signal completion
			fmt.Printf("Goroutine %d is working\n", i)
		}(i)
	}

	// Wait for all goroutines to complete
	wg.Wait()
	fmt.Println("All goroutines have completed")
}
