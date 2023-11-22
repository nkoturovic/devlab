package main

import (
	"encoding/json"
	"fmt"
)

type Point struct {
	X int `json:"x"`
	Y int `json:"y"`
}

func main() {
	point := Point{X: 1, Y: 2}

	// serializes Point to []byte
	serialized, _ := json.Marshal(point)
	fmt.Printf("Serialized = %s\n", string(serialized))

	// new variable to store deserialized data
	var otherPoint Point
	// deserialize from []byte to Point
	_ = json.Unmarshal(serialized, &otherPoint)
	fmt.Printf("Deserialized = %+v\n", otherPoint)
}
