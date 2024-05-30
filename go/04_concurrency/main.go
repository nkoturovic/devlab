package main

import (
  "kotur.me/devlab/concurrency/examples"
)

func main() {

  // examples.Deadlock()
  examples.Detached()
  examples.WaitGroup()
  examples.HelloFromChannel()
  examples.BufferedChannels()
  examples.Select()
}
