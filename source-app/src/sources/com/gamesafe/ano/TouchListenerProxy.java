package com.gamesafe.ano;

import android.content.Context;
import android.util.DisplayMetrics;
import android.view.InputDevice;
import android.view.MotionEvent;
import android.view.View;
import java.util.Locale;

public class TouchListenerProxy implements View.OnTouchListener {

    private static volatile TouchListenerProxy f533f;

    private View.OnTouchListener f534a;

    private int f535b;

    private int f536c;

    private int f537d;

    private boolean f538e = false;

    private TouchListenerProxy() {
    }

    private void m842a(MotionEvent motionEvent) {
        AnoSdk.ioctl(String.format(Locale.ENGLISH, C0975a.m846a("VyyVijOjpxcZqzio:dy=%y|zo=%y|yo=%y|hd=%.1a|hv=%.1a"), Integer.valueOf(motionEvent.getPointerId(motionEvent.getActionIndex())), Long.valueOf(motionEvent.getDownTime()), Long.valueOf(motionEvent.getEventTime()), Float.valueOf(motionEvent.getTouchMinor()), Float.valueOf(motionEvent.getTouchMajor())));
    }

    private void m843a(String str) {
        try {
            byte[] bytes = ("*#06#:" + str).getBytes("utf-8");
            AnoSdk.onruntimeinfo(bytes, bytes.length);
        } catch (Exception unused) {
        }
    }

    private void m844b(MotionEvent motionEvent) {
        if (motionEvent == null) {
            return;
        }
        if (this.f535b == 0 || this.f536c == 0) {
            Context contextM854b = C0977c.m854b();
            if (contextM854b == null) {
                return;
            }
            try {
                DisplayMetrics displayMetrics = contextM854b.getResources().getDisplayMetrics();
                this.f535b = displayMetrics.widthPixels;
                this.f536c = displayMetrics.heightPixels;
            } catch (Throwable unused) {
                this.f535b = 1;
                this.f536c = 1;
            }
        }
        if (this.f535b < 2 || this.f536c < 2) {
            return;
        }
        int rawX = (int) motionEvent.getRawX();
        int rawY = (int) motionEvent.getRawY();
        int i = this.f535b;
        int i2 = this.f536c;
        int deviceId = motionEvent.getDeviceId();
        InputDevice device = motionEvent.getDevice();
        String str = String.format(Locale.ENGLISH, "AddTouchEvent:col=%d|row=%d|col_max=%d|row_max=%d|id=%d|name=%s|source=%d|external=%d|flags=%d", Integer.valueOf(rawX), Integer.valueOf(rawY), Integer.valueOf(i), Integer.valueOf(i2), Integer.valueOf(deviceId), device == null ? "unavailable" : device.getName(), Integer.valueOf(motionEvent.getSource()), 0, Integer.valueOf(motionEvent.getFlags()));
        AnoSdk.ioctl(str);
        int i3 = this.f537d;
        this.f537d = i3 + 1;
        if (i3 < 4) {
            m843a(str);
        }
    }

    public static TouchListenerProxy getInstance() {
        if (f533f == null) {
            synchronized (TouchListenerProxy.class) {
                if (f533f == null) {
                    f533f = new TouchListenerProxy();
                }
            }
        }
        return f533f;
    }

    @Override
    public boolean onTouch(View view, MotionEvent motionEvent) {
        if (motionEvent != null) {
            int action = motionEvent.getAction();
            if (action == 0 || action == 1 || action == 2) {
                m844b(motionEvent);
            }
            if (motionEvent.getActionMasked() == 6 || motionEvent.getActionMasked() == 1) {
                m842a(motionEvent);
            }
        }
        View.OnTouchListener onTouchListener = this.f534a;
        return onTouchListener != null ? onTouchListener.onTouch(view, motionEvent) : this.f538e;
    }

    public void setOntouchRetVal(boolean z) {
        this.f538e = z;
    }

    public void setRawListener(View.OnTouchListener onTouchListener) {
        this.f534a = onTouchListener;
    }
}
