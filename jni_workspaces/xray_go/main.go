package main

/*
#cgo LDFLAGS: -llog
#include <android/log.h>
static void xlog(const char* msg) { __android_log_write(ANDROID_LOG_INFO, "Xray-Go-JNI", msg); }
*/
import "C"

import (
	"fmt"
	"os"
	"sync/atomic"

	"github.com/xtls/xray-core/common/cmdarg"
	"github.com/xtls/xray-core/core"
)

var (
	running  int32
	xrayInst core.Server
)

func startXrayInternal(path string) (rc int) {
	defer func() {
		if r := recover(); r != nil {
			C.xlog(C.CString(fmt.Sprintf("panic in StartXray: %v", r)))
			rc = -9
			atomic.StoreInt32(&running, 0)
		}
	}()
	files := cmdarg.Arg{path}
	format := "auto"
	C.xlog(C.CString("[JNI] before LoadConfig"))
	c, err := core.LoadConfig(format, files)
	if err != nil {
		C.xlog(C.CString("[JNI] LoadConfig failed"))
		return -2
	}
	C.xlog(C.CString("[JNI] after LoadConfig"))
	srv, err := core.New(c)
	if err != nil {
		C.xlog(C.CString("[JNI] core.New failed"))
		return -3
	}
	C.xlog(C.CString("[JNI] after core.New"))
	if err := srv.Start(); err != nil {
		C.xlog(C.CString("[JNI] srv.Start failed"))
		_ = srv.Close()
		return -4
	}
	xrayInst = srv
	C.xlog(C.CString("[JNI] Xray started OK"))
	return 0
}

//export StartXray
func StartXray(configPath *C.char) C.int {
	if !atomic.CompareAndSwapInt32(&running, 0, 1) {
		return 1
	}
	path := C.GoString(configPath)
	if path == "" {
		atomic.StoreInt32(&running, 0)
		return -1
	}
	_ = os.Setenv("XRAY_LOCATION_ASSET", "")
	C.xlog(C.CString("[JNI] StartXray entered"))
	rc := startXrayInternal(path)
	if rc != 0 {
		atomic.StoreInt32(&running, 0)
	}
	return C.int(rc)
}

//export StopXray
func StopXray() C.int {
	if !atomic.CompareAndSwapInt32(&running, 1, 0) {
		return 1
	}
	if xrayInst != nil {
		_ = xrayInst.Close()
		xrayInst = nil
	}
	C.xlog(C.CString("[JNI] Xray stopped"))
	return 0
}

//export IsXrayRunning
func IsXrayRunning() C.int {
	if atomic.LoadInt32(&running) == 1 {
		return 1
	}
	return 0
}

//export GetVersion
func GetVersion() *C.char {
	return C.CString(core.Version())
}

func main() {}
