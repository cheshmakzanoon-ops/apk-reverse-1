package com.cheatfirst.cheatspeed;

public class CheatPlusPlus {
    private static native Object nativeIoCtl(int i, Object obj);

    static {
        try {
            System.loadLibrary("c1stplusplus");
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    public static Object ioctl(int io_code, Object io_object) {
        try {
            return nativeIoCtl(io_code, io_object);
        } catch (Throwable th) {
            return null;
        }
    }
}
