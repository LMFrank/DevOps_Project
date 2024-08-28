package main

import (
	"fmt"
	"github.com/shirou/gopsutil/v3/cpu"
	"os"
	"time"
)

func getCPUUsage() (float64, error) {
	perc, err := cpu.Percent(1*time.Second, false)
	if err != nil {
		return 0, nil
	}
	return perc[0], nil
}

func main() {
	if len(os.Args) < 2 || os.Args[1] != "cpu" {
		fmt.Println("Usage: ./godo cpu")
		os.Exit(1)
	}

	usage, err := getCPUUsage()
	if err != nil {
		fmt.Printf("Error retrieving CPU usage: %v\n", err)
	}
	fmt.Printf("CPU usage: %.2f%%\n", usage)
}
