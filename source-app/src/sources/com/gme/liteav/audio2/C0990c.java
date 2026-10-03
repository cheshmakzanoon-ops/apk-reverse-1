package com.gme.liteav.audio2;

import android.media.AudioManager;
import android.media.AudioPlaybackConfiguration;
import android.os.Handler;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.system.LiteavSystemInfo;
import com.unity3d.player.l$a$;
import java.util.List;

public final class C0990c extends AudioManager.AudioPlaybackCallback {

    volatile a f575a;

    interface a {
        void mo922a();
    }

    public C0990c() {
        AudioManager audioManager;
        if (LiteavSystemInfo.getSystemOSVersionInt() >= 26 && (audioManager = (AudioManager) ContextUtils.getApplicationContext().getSystemService("audio")) != null) {
            try {
                l$a$.ExternalSyntheticApiModelOutline0.m(audioManager, this, (Handler) null);
                Log.m949i("LiteavAudioPlaybackCallback", "register audio playback callback", new Object[0]);
            } catch (Throwable th) {
                Log.m948e("LiteavAudioPlaybackCallback", "register audio playback callback exception " + th.getMessage(), new Object[0]);
            }
        }
    }

    @Override
    public final void onPlaybackConfigChanged(List<AudioPlaybackConfiguration> list) {
        a aVar = this.f575a;
        if (aVar == null) {
            return;
        }
        aVar.mo922a();
    }
}
