package com.joke.assistanttool.utils;

import android.content.Context;

public class DpiConvert {
    public static int dp2px(Context context, int dp) {
        float density = context.getResources().getDisplayMetrics().density;
        return (int) ((dp * density) + 0.5f);
    }

    private DpiConvert() {
    }
}
