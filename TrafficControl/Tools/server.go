package main

import "flag"
import "net/http"
import "log"
import "strconv"
import "fmt"

var (
	port uint
	ip   string
)

func init(){
	flag.StringVar(&ip, "ip", "0.0.0.0", "listen ip")
	flag.UintVar(&port, "port", 0, "listen port")
}

func main() {
	flag.Parse()

	if port <=0 || port > 65536{
		log.Fatalln("port is illegle")
	}

	addr := []byte(ip)
	addr = append(addr, ':')
	addr = strconv.AppendUint(addr, uint64(port), 10)
	fmt.Println("Listen: ", string(addr))
	http.Handle("/", http.FileServer(http.Dir("/tmp")))
	log.Fatal(http.ListenAndServe(string(addr), nil))
}

