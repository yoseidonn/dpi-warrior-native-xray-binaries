#ifndef Xray_h
#define Xray_h

// Xray iOS Framework Header
// This framework provides Xray functionality for iOS applications

#ifdef __cplusplus
extern "C" {
#endif

// Initialize Xray
int xray_init(const char* config_path);

// Start Xray service
int xray_start(void);

// Stop Xray service
int xray_stop(void);

// Get Xray version
const char* xray_version(void);

#ifdef __cplusplus
}
#endif

#endif /* Xray_h */
