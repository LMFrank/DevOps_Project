package main

import (
	"github.com/gin-gonic/gin"
	"github.com/shirou/gopsutil/v3/cpu"
	"github.com/shirou/gopsutil/v3/mem"
	"log"
	"net/http"
	"time"
)

type Monitor interface {
	GetUsage() (float64, error)
}

type MonitorResponse struct {
	Usage float64 `json:"usage"`
	Error string  `json:"error,omitempty"`
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

func monitorHandler(c *gin.Context, monitor Monitor) {
	usage, err := monitor.GetUsage()
	if err != nil {
		c.JSON(http.StatusInternalServerError, MonitorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusOK, MonitorResponse{Usage: usage})
}

func main() {
	r := gin.Default()

	r.GET("/cpu", func(c *gin.Context) {
		monitor := CPUMonitor{}
		monitorHandler(c, monitor)
	})

	r.GET("/mem", func(c *gin.Context) {
		monitor := MemoryMonitor{}
		monitorHandler(c, monitor)
	})

	log.Printf("Server starting on port 8080...")
	err := r.Run(":8080")
	if err != nil {
		return
	}
}
