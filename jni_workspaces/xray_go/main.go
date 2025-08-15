package main
/*
#cgo LDFLAGS: -llog
#include <android/log.h>
static void xlog(const char* msg) { __android_log_write(ANDROID_LOG_INFO, "Xray-Go-JNI", msg); }
*/
import "C"
import "sync/atomic"
var running int32
//export StartXray
func StartXray(configPath *C.char) C.int { atomic.StoreInt32(&running, 1); C.xlog(C.CString("StartXray")); return 0 }
//export StopXray
func StopXray() C.int { atomic.StoreInt32(&running, 0); C.xlog(C.CString("StopXray")); return 0 }
//export IsXrayRunning
func IsXrayRunning() C.int { if atomic.LoadInt32(&running)==1 {return 1}; return 0 }
//export GetVersion
func GetVersion() *C.char { return C.CString("xray-core-jni-stub") }
func main() {}
