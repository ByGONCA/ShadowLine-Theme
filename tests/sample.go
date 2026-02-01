// sample.go
package main

import "fmt"

type User struct {
	ID   int
	Name string
}

func add(a, b int) int {
	return a + b
}

func main() {
	users := []User{{ID: 1, Name: "Ada"}, {ID: 2, Name: "Linus"}}
	fmt.Println(users[0])
	fmt.Println(add(2, 3))
}
