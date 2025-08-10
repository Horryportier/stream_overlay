package tcp_client

import "core:fmt"
import "core:net"

port: net.TCP_Socket : 42069

main :: proc() {
	buff: [dynamic]byte
	//append(&buff, 0)
	message := stob("hello world!")
	for b in message {
		append(&buff, b)
	}
	n, err := net.tcp(port, {0})
	fmt.println(n, " ", err)
}

stob :: proc(s: string) -> []byte {
	buff: [dynamic]byte
	for r in s {
		append(&buff, cast(byte)r)
	}
	return buff[:]
}
