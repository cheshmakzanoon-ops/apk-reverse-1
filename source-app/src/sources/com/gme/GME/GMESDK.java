package com.gme.GME;

import android.content.Context;
import com.gme.TMG.ITMGContext;

public class GMESDK {
    public static int setApplicationContext(Context context) {
        ITMGContext.GetInstance(context);
        return 0;
    }
}
