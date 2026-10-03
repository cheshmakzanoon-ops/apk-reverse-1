package com.unity3d.player;

import android.content.Context;
import android.database.ContentObserver;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Handler;
import android.provider.Settings;

final class C1127b {

    private final Context f394a;

    private final AudioManager f395b;

    private a f396c;

    private class a extends ContentObserver {

        private final b f398b;

        private final AudioManager f399c;

        private final int f400d;

        private int f401e;

        public a(Handler handler, AudioManager audioManager, int i, b bVar) {
            super(handler);
            this.f399c = audioManager;
            this.f400d = 3;
            this.f398b = bVar;
            this.f401e = audioManager.getStreamVolume(3);
        }

        @Override
        public final boolean deliverSelfNotifications() {
            return super.deliverSelfNotifications();
        }

        @Override
        public final void onChange(boolean z, Uri uri) {
            int streamVolume;
            AudioManager audioManager = this.f399c;
            if (audioManager == null || this.f398b == null || (streamVolume = audioManager.getStreamVolume(this.f400d)) == this.f401e) {
                return;
            }
            this.f401e = streamVolume;
            this.f398b.onAudioVolumeChanged(streamVolume);
        }
    }

    public interface b {
        void onAudioVolumeChanged(int i);
    }

    public C1127b(Context context) {
        this.f394a = context;
        this.f395b = (AudioManager) context.getSystemService("audio");
    }

    public final void m526a() {
        if (this.f396c != null) {
            this.f394a.getContentResolver().unregisterContentObserver(this.f396c);
            this.f396c = null;
        }
    }

    public final void m527a(b bVar) {
        this.f396c = new a(new Handler(), this.f395b, 3, bVar);
        this.f394a.getContentResolver().registerContentObserver(Settings.System.CONTENT_URI, true, this.f396c);
    }
}
