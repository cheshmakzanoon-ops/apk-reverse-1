package com.unity3d.player;

import android.util.Log;

final class C1134i {

    protected static boolean f449a;

    protected static void Log(int i, String str) {
        if (f449a) {
            return;
        }
        if (i == 6) {
            Log.e("Unity", str);
        }
        if (i == 5) {
            Log.w("Unity", str);
        }
        if (i == 4) {
            Log.i("Unity", str);
        }
        if (i == 3) {
            Log.d("Unity", str);
        }
    }
}
