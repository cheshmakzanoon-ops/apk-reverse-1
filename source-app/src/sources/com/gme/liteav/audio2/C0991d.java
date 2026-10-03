package com.gme.liteav.audio2;

import android.media.AudioManager;
import android.media.AudioRecordingConfiguration;
import android.os.Handler;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.system.LiteavSystemInfo;
import com.unity3d.player.l$a$;
import java.util.List;

public final class C0991d extends AudioManager.AudioRecordingCallback {

    volatile a f576a;

    interface a {
        void OnRecordingConfigChanged(List<AudioRecordingConfiguration> list);
    }

    public C0991d() {
        AudioManager audioManager;
        if (LiteavSystemInfo.getSystemOSVersionInt() >= 24 && (audioManager = (AudioManager) ContextUtils.getApplicationContext().getSystemService("audio")) != null) {
            try {
                l$a$.ExternalSyntheticApiModelOutline0.m(audioManager, this, (Handler) null);
                Log.m949i("LiteavAudioRecordingCallback", "register audio recording callback", new Object[0]);
            } catch (Throwable th) {
                Log.m948e("LiteavAudioRecordingCallback", "register audio recording callback exception " + th.getMessage(), new Object[0]);
            }
        }
    }

    @Override
    public final void onRecordingConfigChanged(List<AudioRecordingConfiguration> list) {
        a aVar = this.f576a;
        if (aVar == null) {
            return;
        }
        aVar.OnRecordingConfigChanged(list);
    }
}
