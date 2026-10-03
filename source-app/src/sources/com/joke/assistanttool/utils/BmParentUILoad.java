package com.joke.assistanttool.utils;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import com.joke.basetoollib.LoadDrawableUtils;
import com.joke.connectdevice.utils.ActivityRegistry;

public class BmParentUILoad {
    public static void addActivity(Activity activity) {
        ActivityRegistry.getInstance().addActivity(activity);
    }

    public static void remoreActivity(Activity activity) {
        ActivityRegistry.getInstance().remoreActivity(activity);
    }

    public static void initContent(Context context) {
        LoadDrawableUtils.getInstance().initContext(context);
    }

    public static Drawable getDrawable(String fileName) {
        return LoadDrawableUtils.getInstance().getDrawable(fileName);
    }

    private BmParentUILoad() {
    }
}
