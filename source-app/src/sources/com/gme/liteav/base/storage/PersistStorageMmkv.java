package com.gme.liteav.base.storage;

import com.gme.liteav.base.annotations.JNINamespace;

@JNINamespace("liteav")
public class PersistStorageMmkv {
    private long mNativePersistStorageMmkv;

    private static native void nativeClear(long j, String str);

    private static native void nativeCommit(long j);

    private static native long nativeCreatePersistStorageMmkv(String str);

    private static native void nativeDestroyPersistStorageMmkv(long j);

    private static native String[] nativeGetAllKeys(long j);

    private static native Integer nativeGetInt32(long j, String str);

    private static native Long nativeGetLong(long j, String str);

    private static native String nativeGetString(long j, String str);

    private static native void nativePutInt32(long j, String str, int i);

    private static native void nativePutLong(long j, String str, long j2);

    private static native void nativePutString(long j, String str, String str2);

    public PersistStorageMmkv(String str) {
        this.mNativePersistStorageMmkv = 0L;
        this.mNativePersistStorageMmkv = nativeCreatePersistStorageMmkv(str);
    }

    protected void finalize() throws Throwable {
        super.finalize();
        long j = this.mNativePersistStorageMmkv;
        if (j != 0) {
            nativeDestroyPersistStorageMmkv(j);
        }
    }

    public void put(String str, int i) {
        long j = this.mNativePersistStorageMmkv;
        if (j == 0) {
            return;
        }
        try {
            nativePutInt32(j, str, i);
        } catch (Throwable unused) {
        }
    }

    public void put(String str, long j) {
        long j2 = this.mNativePersistStorageMmkv;
        if (j2 == 0) {
            return;
        }
        try {
            nativePutLong(j2, str, j);
        } catch (Throwable unused) {
        }
    }

    public void put(String str, String str2) {
        long j = this.mNativePersistStorageMmkv;
        if (j == 0) {
            return;
        }
        try {
            nativePutString(j, str, str2);
        } catch (Throwable unused) {
        }
    }

    public void clear(String str) {
        long j = this.mNativePersistStorageMmkv;
        if (j == 0) {
            return;
        }
        try {
            nativeClear(j, str);
        } catch (Throwable unused) {
        }
    }

    public void commit() {
        long j = this.mNativePersistStorageMmkv;
        if (j == 0) {
            return;
        }
        try {
            nativeCommit(j);
        } catch (Throwable unused) {
        }
    }

    public Integer getInt(String str) {
        long j = this.mNativePersistStorageMmkv;
        if (j == 0) {
            return null;
        }
        try {
            return nativeGetInt32(j, str);
        } catch (Throwable unused) {
            return null;
        }
    }

    public Long getLong(String str) {
        long j = this.mNativePersistStorageMmkv;
        if (j == 0) {
            return null;
        }
        try {
            return nativeGetLong(j, str);
        } catch (Throwable unused) {
            return null;
        }
    }

    public String getString(String str) {
        long j = this.mNativePersistStorageMmkv;
        if (j == 0) {
            return null;
        }
        try {
            return nativeGetString(j, str);
        } catch (Throwable unused) {
            return null;
        }
    }

    public String[] getAllKeys() {
        long j = this.mNativePersistStorageMmkv;
        if (j == 0) {
            return new String[0];
        }
        try {
            String[] strArrNativeGetAllKeys = nativeGetAllKeys(j);
            return strArrNativeGetAllKeys == null ? new String[0] : strArrNativeGetAllKeys;
        } catch (Throwable unused) {
            return new String[0];
        }
    }
}
