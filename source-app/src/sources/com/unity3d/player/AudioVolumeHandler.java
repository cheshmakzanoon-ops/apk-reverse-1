package com.unity3d.player;

import android.content.Context;

public class AudioVolumeHandler implements C1127b.b {

    private C1127b f214a;

    AudioVolumeHandler(Context context) {
        C1127b c1127b = new C1127b(context);
        this.f214a = c1127b;
        c1127b.m527a(this);
    }

    public final void m441a() {
        this.f214a.m526a();
        this.f214a = null;
    }

    @Override
    public final native void onAudioVolumeChanged(int i);
}
