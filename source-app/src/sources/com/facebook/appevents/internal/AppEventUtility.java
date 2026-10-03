package com.facebook.appevents.internal;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Looper;
import android.view.View;
import android.view.Window;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.internal.Utility;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.Arrays;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.text.StringsKt;

@Metadata(d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u0012\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0006\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\b\u001a\u00020\tH\u0007J\b\u0010\n\u001a\u00020\tH\u0007J\u0010\u0010\u000b\u001a\u00020\u00042\u0006\u0010\f\u001a\u00020\rH\u0007J\b\u0010\u000e\u001a\u00020\u0004H\u0007J\u0014\u0010\u000f\u001a\u0004\u0018\u00010\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012H\u0007J\b\u0010\u0013\u001a\u00020\u0006H\u0007J\u0012\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0004H\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u0014\u0010\u0005\u001a\u00020\u00068CX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0007¨\u0006\u0017"}, d2 = {"Lcom/facebook/appevents/internal/AppEventUtility;", "", "()V", "PRICE_REGEX", "", "isMainThread", "", "()Z", "assertIsMainThread", "", "assertIsNotMainThread", "bytesToHex", "bytes", "", "getAppVersion", "getRootView", "Landroid/view/View;", "activity", "Landroid/app/Activity;", "isEmulator", "normalizePrice", "", SDKConstants.PARAM_VALUE, "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AppEventUtility {
    public static final AppEventUtility INSTANCE = new AppEventUtility();
    private static final String PRICE_REGEX = "[-+]*\\d+([.,]\\d+)*([.,]\\d+)?";

    @JvmStatic
    public static final void assertIsMainThread() {
    }

    @JvmStatic
    public static final void assertIsNotMainThread() {
    }

    private AppEventUtility() {
    }

    @JvmStatic
    public static final double normalizePrice(String value) {
        try {
            Matcher matcher = Pattern.compile(PRICE_REGEX, 8).matcher(value);
            if (!matcher.find()) {
                return 0.0d;
            }
            String strGroup = matcher.group(0);
            Utility utility = Utility.INSTANCE;
            return NumberFormat.getNumberInstance(Utility.getCurrentLocale()).parse(strGroup).doubleValue();
        } catch (ParseException unused) {
            return 0.0d;
        }
    }

    @JvmStatic
    public static final String bytesToHex(byte[] bytes) {
        Intrinsics.checkNotNullParameter(bytes, "bytes");
        StringBuffer stringBuffer = new StringBuffer();
        int length = bytes.length;
        int i = 0;
        while (i < length) {
            byte b = bytes[i];
            i++;
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format("%02x", Arrays.copyOf(new Object[]{Byte.valueOf(b)}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
            stringBuffer.append(str);
        }
        String string = stringBuffer.toString();
        Intrinsics.checkNotNullExpressionValue(string, "sb.toString()");
        return string;
    }

    @JvmStatic
    public static final boolean isEmulator() {
        String str = Build.FINGERPRINT;
        Intrinsics.checkNotNullExpressionValue(str, "FINGERPRINT");
        if (!StringsKt.startsWith$default(str, "generic", false, 2, (Object) null)) {
            String str2 = Build.FINGERPRINT;
            Intrinsics.checkNotNullExpressionValue(str2, "FINGERPRINT");
            if (!StringsKt.startsWith$default(str2, "unknown", false, 2, (Object) null)) {
                String str3 = Build.MODEL;
                Intrinsics.checkNotNullExpressionValue(str3, "MODEL");
                if (!StringsKt.contains$default(str3, "google_sdk", false, 2, (Object) null)) {
                    String str4 = Build.MODEL;
                    Intrinsics.checkNotNullExpressionValue(str4, "MODEL");
                    if (!StringsKt.contains$default(str4, "Emulator", false, 2, (Object) null)) {
                        String str5 = Build.MODEL;
                        Intrinsics.checkNotNullExpressionValue(str5, "MODEL");
                        if (!StringsKt.contains$default(str5, "Android SDK built for x86", false, 2, (Object) null)) {
                            String str6 = Build.MANUFACTURER;
                            Intrinsics.checkNotNullExpressionValue(str6, "MANUFACTURER");
                            if (!StringsKt.contains$default(str6, "Genymotion", false, 2, (Object) null)) {
                                String str7 = Build.BRAND;
                                Intrinsics.checkNotNullExpressionValue(str7, "BRAND");
                                if (StringsKt.startsWith$default(str7, "generic", false, 2, (Object) null)) {
                                    String str8 = Build.DEVICE;
                                    Intrinsics.checkNotNullExpressionValue(str8, "DEVICE");
                                    if (!StringsKt.startsWith$default(str8, "generic", false, 2, (Object) null)) {
                                        if (Intrinsics.areEqual("google_sdk", Build.PRODUCT)) {
                                            return false;
                                        }
                                    }
                                } else if (Intrinsics.areEqual("google_sdk", Build.PRODUCT)) {
                                    return false;
                                }
                            }
                        }
                    }
                }
            }
        }
        return true;
    }

    @JvmStatic
    private static final boolean isMainThread() {
        return Intrinsics.areEqual(Looper.myLooper(), Looper.getMainLooper());
    }

    @JvmStatic
    public static final String getAppVersion() {
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        Context applicationContext = FacebookSdk.getApplicationContext();
        try {
            String str = applicationContext.getPackageManager().getPackageInfo(applicationContext.getPackageName(), 0).versionName;
            Intrinsics.checkNotNullExpressionValue(str, "{\n      val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)\n      packageInfo.versionName\n    }");
            return str;
        } catch (PackageManager.NameNotFoundException unused) {
            return "";
        }
    }

    @JvmStatic
    public static final View getRootView(Activity activity) {
        if (CrashShieldHandler.isObjectCrashing(AppEventUtility.class) || activity == null) {
            return null;
        }
        try {
            try {
                Window window = activity.getWindow();
                if (window == null) {
                    return null;
                }
                return window.getDecorView().getRootView();
            } catch (Exception unused) {
                return null;
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, AppEventUtility.class);
            return null;
        }
        CrashShieldHandler.handleThrowable(th, AppEventUtility.class);
        return null;
    }
}
