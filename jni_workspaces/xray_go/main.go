package main

/*
#cgo LDFLAGS: -llog
#include <android/log.h>
static void xlog(const char* msg) { __android_log_write(ANDROID_LOG_INFO, "Xray-Go-JNI", msg); }
*/
import "C"

import (
	"os"
	"sync/atomic"

	"github.com/xtls/xray-core/common/cmdarg"
	"github.com/xtls/xray-core/core"
)

var (
	running  int32
	xrayInst core.Server
)

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
	// Prepare environment so xray-core uses our config path
	_ = os.Setenv("XRAY_LOCATION_ASSET", "/data/data")

	// Build cmdarg.Arg with our single config path and load using upstream API
	files := cmdarg.Arg{path}
	format := "auto"
	c, err := core.LoadConfig(format, files)
	if err != nil {
		C.xlog(C.CString("Xray LoadConfig failed"))
		atomic.StoreInt32(&running, 0)
		return -2
	}
	srv, err := core.New(c)
	if err != nil {
		C.xlog(C.CString("Xray New() failed"))
		atomic.StoreInt32(&running, 0)
		return -3
	}
	if err := srv.Start(); err != nil {
		C.xlog(C.CString("Xray Start() failed"))
		_ = srv.Close()
		atomic.StoreInt32(&running, 0)
		return -4
	}
	xrayInst = srv
	C.xlog(C.CString("Xray started"))
	return 0
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
	C.xlog(C.CString("Xray stopped"))
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
