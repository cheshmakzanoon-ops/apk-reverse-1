package net.aihelp.utils;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import androidx.activity.ComponentDialog$;
import androidx.compose.ui.graphics.Api26Bitmap$;
import java.util.Locale;
import net.aihelp.common.SpKeys;
import net.aihelp.config.AIHelpContext;

public class LocaleUtil {
    public static Locale getLocale() {
        Context context = AIHelpContext.getInstance().getContext();
        if (context != null) {
            Configuration configuration = context.getResources().getConfiguration();
            return Build.VERSION.SDK_INT >= 24 ? Api26Bitmap$.ExternalSyntheticApiModelOutline0.m(ComponentDialog$.ExternalSyntheticApiModelOutline0.m(configuration), 0) : configuration.locale;
        }
        return Locale.getDefault();
    }

    public static void updateLocale(Locale locale) {
        Context context = AIHelpContext.getInstance().getContext();
        if (context != null) {
            Resources resources = context.getResources();
            DisplayMetrics displayMetrics = resources.getDisplayMetrics();
            Configuration configuration = resources.getConfiguration();
            configuration.locale = locale;
            resources.updateConfiguration(configuration, displayMetrics);
        }
    }

    public static String getSDKLanguage() {
        String string = SpUtil.getInstance().getString(SpKeys.SDK_LANGUAGE);
        return TextUtils.isEmpty(string) ? "" : string;
    }

    public static Locale getCurrentLocale(String str) {
        Locale locale;
        if (TextUtils.isEmpty(str)) {
            return Locale.getDefault();
        }
        if (str.contains("-")) {
            String[] strArrSplit = str.split("-");
            locale = new Locale(strArrSplit[0], strArrSplit[1]);
        } else {
            locale = new Locale(str);
        }
        return locale;
    }

    public static String getFormatLanguage(String str) {
        if (TextUtils.isEmpty(str)) {
            str = "en";
        } else if (str.equalsIgnoreCase("in_id") || str.equalsIgnoreCase("in") || str.equalsIgnoreCase("id")) {
            str = "id";
        } else if (str.equalsIgnoreCase("zh")) {
            str = "zh-CN";
        }
        return filterSymbol(str);
    }

    private static String filterSymbol(String str) {
        if (TextUtils.isEmpty(str)) {
            return "en";
        }
        if (str.contains("_")) {
            str = str.replace("_", "-");
        }
        return str.contains("#") ? str.replace("#", "") : str;
    }
}
