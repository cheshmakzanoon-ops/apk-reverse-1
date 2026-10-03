package org.fmod;

import android.media.AudioRecord;
import android.util.Log;
import java.nio.ByteBuffer;

final class RunnableC0909a implements Runnable {

    private final FMODAudioDevice f122a;

    private final ByteBuffer f123b;

    private final int f124c;

    private final int f125d;

    private final int f126e = 2;

    private volatile Thread f127f;

    private volatile boolean f128g;

    private AudioRecord f129h;

    private boolean f130i;

    RunnableC0909a(FMODAudioDevice fMODAudioDevice, int i, int i2) {
        this.f122a = fMODAudioDevice;
        this.f124c = i;
        this.f125d = i2;
        this.f123b = ByteBuffer.allocateDirect(AudioRecord.getMinBufferSize(i, i2, 2));
    }

    private void m191d() {
        AudioRecord audioRecord = this.f129h;
        if (audioRecord != null) {
            if (audioRecord.getState() == 1) {
                this.f129h.stop();
            }
            this.f129h.release();
            this.f129h = null;
        }
        this.f123b.position(0);
        this.f130i = false;
    }

    public final int m192a() {
        return this.f123b.capacity();
    }

    public final void m193b() {
        if (this.f127f != null) {
            m194c();
        }
        this.f128g = true;
        this.f127f = new Thread(this);
        this.f127f.start();
    }

    public final void m194c() {
        while (this.f127f != null) {
            this.f128g = false;
            try {
                this.f127f.join();
                this.f127f = null;
            } catch (InterruptedException unused) {
            }
        }
    }

    @Override
    public final void run() {
        int i = 3;
        while (this.f128g) {
            if (!this.f130i && i > 0) {
                m191d();
                AudioRecord audioRecord = new AudioRecord(1, this.f124c, this.f125d, this.f126e, this.f123b.capacity());
                this.f129h = audioRecord;
                boolean z = audioRecord.getState() == 1;
                this.f130i = z;
                if (z) {
                    this.f123b.position(0);
                    this.f129h.startRecording();
                    i = 3;
                } else {
                    Log.e("FMOD", "AudioRecord failed to initialize (status " + this.f129h.getState() + ")");
                    i += -1;
                    m191d();
                }
            }
            if (this.f130i && this.f129h.getRecordingState() == 3) {
                AudioRecord audioRecord2 = this.f129h;
                ByteBuffer byteBuffer = this.f123b;
                this.f122a.fmodProcessMicData(this.f123b, audioRecord2.read(byteBuffer, byteBuffer.capacity()));
                this.f123b.position(0);
            }
        }
        m191d();
    }
}
