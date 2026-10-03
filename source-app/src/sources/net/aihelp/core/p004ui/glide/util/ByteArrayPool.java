package net.aihelp.core.p004ui.glide.util;

import android.util.Log;
import java.util.Queue;

public final class ByteArrayPool {
    private static final ByteArrayPool BYTE_ARRAY_POOL = new ByteArrayPool();
    private static final int MAX_BYTE_ARRAY_COUNT = 32;
    private static final int MAX_SIZE = 2146304;
    private static final String TAG = "ByteArrayPool";
    private static final int TEMP_BYTES_SIZE = 65536;
    private final Queue<byte[]> tempQueue = Util.createQueue(0);

    public static ByteArrayPool get() {
        return BYTE_ARRAY_POOL;
    }

    private ByteArrayPool() {
    }

    public void clear() {
        synchronized (this.tempQueue) {
            this.tempQueue.clear();
        }
    }

    public byte[] getBytes() {
        byte[] bArrPoll;
        synchronized (this.tempQueue) {
            bArrPoll = this.tempQueue.poll();
        }
        if (bArrPoll == null) {
            bArrPoll = new byte[TEMP_BYTES_SIZE];
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Created temp bytes");
            }
        }
        return bArrPoll;
    }

    public boolean releaseBytes(byte[] bArr) {
        boolean z = false;
        if (bArr.length != TEMP_BYTES_SIZE) {
            return false;
        }
        synchronized (this.tempQueue) {
            if (this.tempQueue.size() < 32) {
                this.tempQueue.offer(bArr);
                z = true;
            }
        }
        return z;
    }
}
