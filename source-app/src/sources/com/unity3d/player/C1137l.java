package com.unity3d.player;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.PixelCopy;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import java.lang.ref.WeakReference;

final class C1137l implements Application.ActivityLifecycleCallbacks {

    Activity f451b;

    WeakReference f450a = new WeakReference(null);

    View f452c = null;

    class a extends View implements PixelCopy.OnPixelCopyFinishedListener {

        Bitmap f453a;

        a(Context context) {
            super(context);
        }

        public final void m576a(SurfaceView surfaceView) {
            C1134i.Log(3, "PersistentUnitySurface.PlaceholderView.Copy: " + surfaceView);
            Bitmap bitmapCreateBitmap = Bitmap.createBitmap(surfaceView.getWidth(), surfaceView.getHeight(), Bitmap.Config.ARGB_8888);
            this.f453a = bitmapCreateBitmap;
            PixelCopy.request(surfaceView, bitmapCreateBitmap, this, new Handler(Looper.getMainLooper()));
        }

        @Override
        public final void onPixelCopyFinished(int i) {
            C1134i.Log(3, "onPixelCopyFinished: " + i);
            if (i == 0) {
                setBackground(new LayerDrawable(new Drawable[]{new ColorDrawable(-16777216), new BitmapDrawable(getResources(), this.f453a)}));
            }
        }
    }

    C1137l(Context context) {
        if (context instanceof Activity) {
            Activity activity = (Activity) context;
            this.f451b = activity;
            activity.getApplication().registerActivityLifecycleCallbacks(this);
        }
    }

    public final void m572a() {
        Activity activity = this.f451b;
        if (activity != null) {
            activity.getApplication().unregisterActivityLifecycleCallbacks(this);
        }
    }

    public final void m573a(SurfaceView surfaceView) {
        C1134i.Log(3, "PersistentUnitySurface.preserveContent: " + surfaceView);
        if (C1138m.f457c) {
            if (this.f450a.get() == this.f451b) {
                C1134i.Log(3, "Last resumed Activity is the Unity activity, no need to preserve SurfaceView content");
            } else {
                if (this.f452c != null) {
                    C1134i.Log(3, "PlacerHoler view already exists");
                    return;
                }
                a aVar = new a(this.f451b);
                aVar.m576a(surfaceView);
                this.f452c = aVar;
            }
        }
    }

    public final void m574a(ViewGroup viewGroup) {
        View view = this.f452c;
        if (view == null || view.getParent() != null) {
            return;
        }
        viewGroup.addView(this.f452c);
        viewGroup.bringChildToFront(this.f452c);
    }

    public final void m575b(ViewGroup viewGroup) {
        View view = this.f452c;
        if (view == null || view.getParent() == null) {
            return;
        }
        viewGroup.removeView(this.f452c);
    }

    @Override
    public final void onActivityCreated(Activity activity, Bundle bundle) {
    }

    @Override
    public final void onActivityDestroyed(Activity activity) {
    }

    @Override
    public final void onActivityPaused(Activity activity) {
    }

    @Override
    public final void onActivityResumed(Activity activity) {
        C1134i.Log(3, "onActivityResumed: " + activity);
        this.f450a = new WeakReference(activity);
    }

    @Override
    public final void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
    }

    @Override
    public final void onActivityStarted(Activity activity) {
    }

    @Override
    public final void onActivityStopped(Activity activity) {
    }
}
