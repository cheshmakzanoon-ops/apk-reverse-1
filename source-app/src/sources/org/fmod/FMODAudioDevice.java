package org.fmod;

import android.media.AudioTrack;
import android.util.Log;
import java.nio.ByteBuffer;

public class FMODAudioDevice implements Runnable {

    private static int f111h = 0;

    private static int f112i = 1;

    private static int f113j = 2;

    private static int f114k = 3;

    private volatile Thread f115a = null;

    private volatile boolean f116b = false;

    private AudioTrack f117c = null;

    private boolean f118d = false;

    private ByteBuffer f119e = null;

    private byte[] f120f = null;

    private volatile RunnableC0909a f121g;

    private native int fmodGetInfo(int i);

    private native int fmodProcess(ByteBuffer byteBuffer);

    private void releaseAudioTrack() {
        AudioTrack audioTrack = this.f117c;
        if (audioTrack != null) {
            if (audioTrack.getState() == 1) {
                this.f117c.stop();
            }
            this.f117c.release();
            this.f117c = null;
        }
        this.f119e = null;
        this.f120f = null;
        this.f118d = false;
    }

    public synchronized void close() {
        stop();
    }

    native int fmodProcessMicData(ByteBuffer byteBuffer, int i);

    public boolean isRunning() {
        return this.f115a != null && this.f115a.isAlive();
    }

    @Override
    public void run() {
        int i = 3;
        while (this.f116b) {
            if (!this.f118d && i > 0) {
                releaseAudioTrack();
                int iFmodGetInfo = fmodGetInfo(f111h);
                int iRound = Math.round(AudioTrack.getMinBufferSize(iFmodGetInfo, 3, 2) * 1.1f) & (-4);
                int iFmodGetInfo2 = fmodGetInfo(f112i);
                int iFmodGetInfo3 = fmodGetInfo(f113j) * iFmodGetInfo2 * 4;
                AudioTrack audioTrack = new AudioTrack(3, iFmodGetInfo, 3, 2, iFmodGetInfo3 > iRound ? iFmodGetInfo3 : iRound, 1);
                this.f117c = audioTrack;
                boolean z = audioTrack.getState() == 1;
                this.f118d = z;
                if (z) {
                    ByteBuffer byteBufferAllocateDirect = ByteBuffer.allocateDirect(iFmodGetInfo2 * 4);
                    this.f119e = byteBufferAllocateDirect;
                    this.f120f = new byte[byteBufferAllocateDirect.capacity()];
                    this.f117c.play();
                    i = 3;
                } else {
                    Log.e("FMOD", "AudioTrack failed to initialize (status " + this.f117c.getState() + ")");
                    releaseAudioTrack();
                    i += -1;
                }
            }
            if (this.f118d) {
                if (fmodGetInfo(f114k) == 1) {
                    fmodProcess(this.f119e);
                    ByteBuffer byteBuffer = this.f119e;
                    byteBuffer.get(this.f120f, 0, byteBuffer.capacity());
                    this.f117c.write(this.f120f, 0, this.f119e.capacity());
                    this.f119e.position(0);
                } else {
                    releaseAudioTrack();
                }
            }
        }
        releaseAudioTrack();
    }

    public synchronized void start() {
        if (this.f115a != null) {
            stop();
        }
        this.f115a = new Thread(this, "FMODAudioDevice");
        this.f115a.setPriority(10);
        this.f116b = true;
        this.f115a.start();
        if (this.f121g != null) {
            this.f121g.m193b();
        }
    }

    public synchronized int startAudioRecord(int i, int i2, int i3) {
        if (this.f121g == null) {
            this.f121g = new RunnableC0909a(this, i, i2);
            this.f121g.m193b();
        }
        return this.f121g.m192a();
    }

    public synchronized void stop() {
        while (this.f115a != null) {
            this.f116b = false;
            try {
                this.f115a.join();
                this.f115a = null;
            } catch (InterruptedException unused) {
            }
        }
        if (this.f121g != null) {
            this.f121g.m194c();
        }
    }

    public synchronized void stopAudioRecord() {
        if (this.f121g != null) {
            this.f121g.m194c();
            this.f121g = null;
        }
    }
}
