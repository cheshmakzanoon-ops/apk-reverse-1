package com.unity3d.player;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import androidx.core.content.ContextCompat;
import cn.thinkingdata.android.j$;

public class HFPStatus {

    private Context f245a;

    private AudioManager f249e;

    private BroadcastReceiver f246b = null;

    private Intent f247c = null;

    private boolean f248d = false;

    private boolean f250f = false;

    private int f251g = EnumC1085a.f253a;

    static final class EnumC1085a {

        public static final int f253a = 1;

        public static final int f254b = 2;

        private static final int[] f255c = {1, 2};
    }

    public HFPStatus(Context context) {
        this.f249e = null;
        this.f245a = context;
        this.f249e = (AudioManager) context.getSystemService("audio");
        initHFPStatusJni();
    }

    private void m469b() {
        BroadcastReceiver broadcastReceiver = this.f246b;
        if (broadcastReceiver != null) {
            this.f245a.unregisterReceiver(broadcastReceiver);
            this.f246b = null;
            this.f247c = null;
        }
        this.f251g = EnumC1085a.f253a;
    }

    public void m472c() {
        if (this.f250f) {
            this.f250f = false;
            this.f249e.stopBluetoothSco();
        }
    }

    private final native void deinitHFPStatusJni();

    private final native void initHFPStatusJni();

    public final void m473a() {
        clearHFPStat();
        deinitHFPStatusJni();
    }

    protected void clearHFPStat() {
        m469b();
        m472c();
    }

    protected boolean getHFPStat() {
        return this.f251g == EnumC1085a.f254b;
    }

    protected void requestHFPStat() {
        try {
            clearHFPStat();
            BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    if (intent.getIntExtra("android.media.extra.SCO_AUDIO_STATE", -1) != 1) {
                        return;
                    }
                    HFPStatus.this.f251g = EnumC1085a.f254b;
                    HFPStatus.this.m472c();
                    if (HFPStatus.this.f248d) {
                        HFPStatus.this.f249e.setMode(3);
                    }
                }
            };
            this.f246b = broadcastReceiver;
            this.f247c = j$.ExternalSyntheticApiModelOutline0.m(this.f245a, broadcastReceiver, new IntentFilter("android.media.ACTION_SCO_AUDIO_STATE_UPDATED"), ContextCompat.RECEIVER_EXPORTED);
            this.f250f = true;
            this.f249e.startBluetoothSco();
        } catch (Exception unused) {
            C1134i.Log(5, "startBluetoothSco() failed. no bluetooth device connected.");
        }
    }

    protected void setHFPRecordingStat(boolean z) {
        this.f248d = z;
        if (z) {
            return;
        }
        this.f249e.setMode(0);
    }
}
