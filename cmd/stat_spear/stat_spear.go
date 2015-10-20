package main

import (
	"flag"
	"fmt"
	"sync"
	"time"

	"github.com/shirou/gopsutil/cpu"
	"github.com/shirou/gopsutil/mem"
	"github.com/shirou/gopsutil/net"
	"github.com/tarm/serial"
)

// Spear represent color of the spr
type Spear struct {
	sync.RWMutex
	R, G, B byte
}

func (s *Spear) String() string {
	s.RLock()
	defer s.RUnlock()
	return fmt.Sprintf("#%02x%02x%02x", s.R, s.G, s.B)
}

var (
	spr      *Spear
	flagPort string
	flagCPU  bool
	flagMEM  bool
	flagNET  bool
)

func init() {
	flag.StringVar(&flagPort, "p", "/dev/ttyUSB0", "set port name for spear")
	flag.BoolVar(&flagCPU, "c", true, "enable to read cpu usage")
	flag.BoolVar(&flagMEM, "m", true, "enable to read memory usage")
	flag.BoolVar(&flagNET, "n", true, "enable to read network usage")
	flag.Parse()
}

func main() {
	fmt.Println("Hello RGB-spear")

	ser, err := serial.OpenPort(&serial.Config{
		Name: flagPort,
		Baud: 9600,
	})
	if err != nil {
		panic(err)
	}
	defer ser.Close()
	defer ser.Flush()

	fmt.Println("Wating 10 seconds for booting...")
	time.Sleep(10 * time.Second)

	spr = new(Spear)

	// RED for cpu
	if flagCPU {
		fmt.Println("enable CPU")
		go func() {
			for {
				c, err := cpu.CPUPercent(100*time.Millisecond, false)
				if err != nil {
					panic(err)
				}

				t := byte((c[0] * 255) / 100)
				spr.Lock()
				spr.R = t
				// log.Println("R->", spr.R)
				spr.Unlock()
				time.Sleep(300 * time.Millisecond)
			}
		}()
	}

	// Green for memory
	if flagMEM {
		fmt.Println("Enable MEM")
		go func() {
			for {
				v, err := mem.VirtualMemory()
				if err != nil {
					panic(err)
				}
				t := byte((v.UsedPercent * 255) / 100)
				spr.Lock()
				spr.G = t
				// log.Println("G->", spr.R)
				spr.Unlock()
				time.Sleep(300 * time.Millisecond)
			}
		}()
	}

	// Blue for network
	if flagNET {
		fmt.Println("Enable Network")
		go func() {
			lastSent, lastRecv := uint64(0), uint64(0)

			for {
				c, err := net.NetIOCounters(false)
				if err != nil {
					panic(err)
				}
				currSent := c[0].BytesSent
				currRecv := c[0].BytesRecv

				sent := currSent - lastSent
				recv := currRecv - lastRecv

				t := byte(((sent + recv) * 255) / 1000000)

				spr.Lock()
				spr.B = t
				spr.Unlock()
				time.Sleep(1 * time.Second)

				lastSent = currSent
				lastRecv = currRecv
			}
		}()

		t := time.NewTicker(100 * time.Millisecond)
		for {
			select {
			case <-t.C:
				fmt.Fprint(ser, spr)
				// log.Println("spr:", spr)
				ser.Flush()
			}
		}
	}
}
