package main

import (
	"flag"
	"fmt"
	"github.com/shirou/gopsutil/v3/cpu"
	"github.com/shirou/gopsutil/v3/mem"
	"log"
	"time"
)

type Monitor interface {
	GetUsage() (float64, error)
}

type CPUMonitor struct{}

func (m CPUMonitor) GetUsage() (float64, error) {
	perc, err := cpu.Percent(1*time.Second, false)
	if err != nil {
		return 0, nil
	}
	return perc[0], nil
}

type MemoryMonitor struct{}

func (m MemoryMonitor) GetUsage() (float64, error) {
	vm, err := mem.VirtualMemory()
	if err != nil {
		return 0, nil
	}
	usagePercent := float64(vm.Used) / float64(vm.Total) * 100
	return usagePercent, nil
}

func MonitorFactory(monitorType string) Monitor {
	switch monitorType {
	case "cpu":
		return CPUMonitor{}
	case "memory":
		return MemoryMonitor{}
	default:
		log.Fatalf("Unsupported monitor type: %s", monitorType)
		return nil
	}
}

func main() {
	monitorTypePtr := flag.String("type", "", "Monitor type(cpu|memory)")
	flag.Parse()

	if *monitorTypePtr == "" {
		flag.Usage()
		log.Fatalf("Error: You must specify the monitor type with -type flag")
	}

	monitor := MonitorFactory(*monitorTypePtr)
	usage, err := monitor.GetUsage()
	if err != nil {
		log.Fatalf("Error getting usage: %v", err)
	}

	fmt.Printf("Monitor Usage: %.2f%%\n", usage)
}
