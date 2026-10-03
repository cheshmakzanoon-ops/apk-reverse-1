package com.google.android.material.resources;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Typeface;
import android.os.Build;
import androidx.compose.ui.platform.AndroidComposeView$;
import androidx.core.app.NotificationCompat$;
import androidx.core.math.MathUtils;

public class TypefaceUtils {
    private TypefaceUtils() {
    }

    public static Typeface maybeCopyWithFontWeightAdjustment(Context context, Typeface typeface) {
        return maybeCopyWithFontWeightAdjustment(context.getResources().getConfiguration(), typeface);
    }

    public static Typeface maybeCopyWithFontWeightAdjustment(Configuration configuration, Typeface typeface) {
        if (Build.VERSION.SDK_INT < 31 || AndroidComposeView$.ExternalSyntheticApiModelOutline0.m(configuration) == Integer.MAX_VALUE || AndroidComposeView$.ExternalSyntheticApiModelOutline0.m(configuration) == 0 || typeface == null) {
            return null;
        }
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m(typeface, MathUtils.clamp(typeface.getWeight() + AndroidComposeView$.ExternalSyntheticApiModelOutline0.m(configuration), 1, 1000), typeface.isItalic());
    }
}
