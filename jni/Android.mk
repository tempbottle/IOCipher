#
# run "make -C external" before running "ndk-build"
#

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

# NOTE the following flags,
#   SQLITE_TEMP_STORE=3 causes all TEMP files to go into RAM. and thats the behavior we want
#   SQLITE_ENABLE_FTS3   enables usage of FTS3 - NOT FTS1 or 2.
#   SQLITE_DEFAULT_AUTOVACUUM=1  causes the databases to be subject to auto-vacuum
android_sqlite_cflags :=  -DHAVE_USLEEP=1 -DSQLITE_DEFAULT_JOURNAL_SIZE_LIMIT=1048576 -DSQLITE_THREADSAFE=1 -DNDEBUG=1 -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1 -DSQLITE_DEFAULT_AUTOVACUUM=1 -DSQLITE_TEMP_STORE=3 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_BACKWARDS -DSQLITE_ENABLE_LOAD_EXTENSION
sqlcipher_cflags := -DSQLITE_HAS_CODEC -DHAVE_FDATASYNC=0 -Dfdatasync=fsync

LOCAL_CFLAGS += $(android_sqlite_cflags) $(sqlcipher_cflags)
LOCAL_C_INCLUDES:= \
	external/libcore/include \
	external/libsqlfs \
	external/openssl/include \
	external/sqlcipher
LOCAL_LDFLAGS   += \
	-L$(LOCAL_PATH)/../external/android-libs \
	-L$(LOCAL_PATH)/../external/openssl/obj/local/armeabi/
LOCAL_LDLIBS    += -lcrypto -llog -lnativehelper
LOCAL_MODULE    := libiocipher
LOCAL_SRC_FILES := \
	AsynchronousSocketCloseMonitor.cpp \
	JniConstants.cpp \
	toStringArray.cpp \
	java_io_Console.cpp \
	java_io_File.cpp \
	java_io_ObjectStreamClass.cpp \
	libcore_io_AsynchronousCloseMonitor.cpp \
	libcore_io_Memory.cpp \
	libcore_io_OsConstants.cpp \
	libcore_io_Posix.cpp \
	../external/libsqlfs/sqlfs.c \
	../external/sqlcipher/sqlite3.c

include $(BUILD_SHARED_LIBRARY)
