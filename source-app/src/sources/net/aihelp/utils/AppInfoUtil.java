package net.aihelp.utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.Uri;
import android.text.TextUtils;
import cz.msebera.android.httpclient.HttpHost;
import net.aihelp.common.Const;

public class AppInfoUtil {
    public static String getAppName(Context context) {
        String string;
        try {
            string = context.getPackageManager().getApplicationLabel(context.getApplicationInfo()).toString();
        } catch (Exception e) {
            e.printStackTrace();
            string = null;
        }
        return string == null ? "AIHelp" : string;
    }

    public static String getAppVersion(Context context) {
        if (context == null) {
            return "Context is null!";
        }
        try {
            return context.getPackageManager().getPackageInfo(context.getPackageName(), 0).versionName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static Intent getLaunchIntent(Context context, String str) {
        try {
            return context.getPackageManager().getLaunchIntentForPackage(str);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void goRateApp(Context context) {
        Intent intent = new Intent("android.intent.action.VIEW");
        intent.setData(Uri.parse("market://details?id=" + context.getPackageName()));
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            context.startActivity(intent);
            return;
        }
        intent.setData(Uri.parse("https://play.google.com/store/apps/details?id=" + context.getPackageName()));
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            context.startActivity(intent);
        }
    }

    public static boolean isUrlStillNeedResponding(Context context, String str) {
        if (TextUtils.isEmpty(str) || !validateNetwork(context)) {
            return false;
        }
        if (str.contains("js-bridge=enable") && Const.sOnSpecificUrlClickedListener != null) {
            if (FastClickValidator.validate(0.5f)) {
                Const.sOnSpecificUrlClickedListener.onSpecificUrlClicked(str);
            }
            return false;
        }
        if (context == null || str.startsWith(HttpHost.DEFAULT_SCHEME_NAME)) {
            return true;
        }
        openWithBrowser(context, str);
        return false;
    }

    public static void openWithBrowser(Context context, String str) {
        if (RegexDefinition.isLocalFile(str)) {
            return;
        }
        try {
            Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(str));
            if (intent.resolveActivity(context.getPackageManager()) != null) {
                if (context instanceof Activity) {
                    context.startActivity(intent);
                } else {
                    intent.setFlags(268435456);
                    context.getApplicationContext().startActivity(intent);
                }
            } else {
                Intent uri = Intent.parseUri(str, 1);
                if (uri != null) {
                    uri.addCategory("android.intent.category.BROWSABLE");
                    uri.setComponent(null);
                    uri.setSelector(null);
                    if (context.getPackageManager().resolveActivity(uri, 65536) != null) {
                        context.startActivity(uri);
                    }
                }
            }
        } catch (Exception unused) {
        }
    }

    public static boolean isNetworkAvailable(Context context) {
        Network activeNetwork;
        if (context == null) {
            return true;
        }
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getApplicationContext().getSystemService("connectivity");
        if (connectivityManager == null || (activeNetwork = connectivityManager.getActiveNetwork()) == null) {
            return false;
        }
        NetworkCapabilities networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork);
        return networkCapabilities != null && (networkCapabilities.hasCapability(12) || networkCapabilities.hasTransport(0) || networkCapabilities.hasTransport(1) || networkCapabilities.hasTransport(3) || networkCapabilities.hasTransport(4));
    }

    public static boolean validateNetwork(Context context) {
        boolean zIsNetworkAvailable = isNetworkAvailable(context);
        if (!zIsNetworkAvailable) {
            ToastUtil.INSTANCE.makeRawToast(context, ResResolver.getString("aihelp_network_no_connect"));
        }
        return zIsNetworkAvailable;
    }
}
