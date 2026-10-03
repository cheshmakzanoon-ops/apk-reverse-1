package com.unity3d.player;

import android.content.Context;
import android.graphics.Rect;
import android.hardware.Camera;

public class Camera2Wrapper implements InterfaceC1131f {

    private Context f215a;

    private C1128c f216b = null;

    private final int f217c = 100;

    public Camera2Wrapper(Context context) {
        this.f215a = context;
        initCamera2Jni();
    }

    private static int m442a(float f) {
        return (int) Math.min(Math.max((f * 2000.0f) - 1000.0f, -900.0f), 900.0f);
    }

    private final native void deinitCamera2Jni();

    private final native void initCamera2Jni();

    private final native void nativeFrameReady(Object obj, Object obj2, Object obj3, int i, int i2, int i3);

    private final native void nativeSurfaceTextureReady(Object obj);

    public final void m443a() {
        deinitCamera2Jni();
        closeCamera2();
    }

    @Override
    public final void mo444a(Object obj) {
        nativeSurfaceTextureReady(obj);
    }

    @Override
    public final void mo445a(Object obj, Object obj2, Object obj3, int i, int i2, int i3) {
        nativeFrameReady(obj, obj2, obj3, i, i2, i3);
    }

    protected void closeCamera2() {
        C1128c c1128c = this.f216b;
        if (c1128c != null) {
            c1128c.m565b();
        }
        this.f216b = null;
    }

    protected int getCamera2Count() {
        if (C1138m.f455a) {
            return C1128c.m528a(this.f215a);
        }
        return 0;
    }

    protected int[] getCamera2Resolutions(int i) {
        if (C1138m.f455a) {
            return C1128c.m550d(this.f215a, i);
        }
        return null;
    }

    protected int getCamera2SensorOrientation(int i) {
        if (C1138m.f455a) {
            return C1128c.m529a(this.f215a, i);
        }
        return 0;
    }

    protected Object getCameraFocusArea(float f, float f2) {
        int iM442a = m442a(f);
        int iM442a2 = m442a(1.0f - f2);
        return new Camera.Area(new Rect(iM442a - 100, iM442a2 - 100, iM442a + 100, iM442a2 + 100), 1000);
    }

    protected Rect getFrameSizeCamera2() {
        C1128c c1128c = this.f216b;
        return c1128c != null ? c1128c.m562a() : new Rect();
    }

    protected boolean initializeCamera2(int i, int i2, int i3, int i4, int i5) {
        if (!C1138m.f455a || this.f216b != null || UnityPlayer.currentActivity == null) {
            return false;
        }
        C1128c c1128c = new C1128c(this);
        this.f216b = c1128c;
        return c1128c.m564a(this.f215a, i, i2, i3, i4, i5);
    }

    protected boolean isCamera2AutoFocusPointSupported(int i) {
        if (C1138m.f455a) {
            return C1128c.m547c(this.f215a, i);
        }
        return false;
    }

    protected boolean isCamera2FrontFacing(int i) {
        if (C1138m.f455a) {
            return C1128c.m545b(this.f215a, i);
        }
        return false;
    }

    protected void pauseCamera2() {
        C1128c c1128c = this.f216b;
        if (c1128c != null) {
            c1128c.m567d();
        }
    }

    protected boolean setAutoFocusPoint(float f, float f2) {
        C1128c c1128c;
        if (!C1138m.f455a || (c1128c = this.f216b) == null) {
            return false;
        }
        return c1128c.m563a(f, f2);
    }

    protected void startCamera2() {
        C1128c c1128c = this.f216b;
        if (c1128c != null) {
            c1128c.m566c();
        }
    }

    protected void stopCamera2() {
        C1128c c1128c = this.f216b;
        if (c1128c != null) {
            c1128c.m568e();
        }
    }
}
