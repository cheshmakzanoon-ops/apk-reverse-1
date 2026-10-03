package com.appsflyer.internal;

import android.net.Uri;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.appsflyer.AFLogger;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\u0018\u0000 \u00162\u00020\u0001:\u0001\u0016B\u001b\b\u0007\u0012\u0006\u0010\u0003\u001a\u00020\u0010\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0012¢\u0006\u0004\b\u0014\u0010\u0015J#\u0010\u0005\u001a\u00020\u00022\b\u0010\u0003\u001a\u0004\u0018\u00010\u00022\b\u0010\u0004\u001a\u0004\u0018\u00010\u0002H\u0007¢\u0006\u0004\b\u0005\u0010\u0006J\u0017\u0010\u0005\u001a\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\u0005\u0010\bJ\u001b\u0010\n\u001a\u00020\u0002*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\tH\u0002¢\u0006\u0004\b\n\u0010\u000bJ\u0013\u0010\n\u001a\u00020\u0002*\u00020\u0002H\u0002¢\u0006\u0004\b\n\u0010\fJ'\u0010\u000e\u001a\u00020\r*\u00020\r2\b\u0010\u0003\u001a\u0004\u0018\u00010\u00022\b\u0010\u0004\u001a\u0004\u0018\u00010\u0002H\u0002¢\u0006\u0004\b\u000e\u0010\u000fR\u0014\u0010\n\u001a\u00020\u00108\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\n\u0010\u0011R\u0014\u0010\u000e\u001a\u00020\u00128\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\u000e\u0010\u0013"}, d2 = {"Lcom/appsflyer/internal/AFi1cSDK;", "", "", "p0", "p1", "AFInAppEventParameterName", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", "Lcom/appsflyer/internal/AFh1qSDK;", "(Lcom/appsflyer/internal/AFh1qSDK;)Ljava/lang/String;", "", "valueOf", "(Ljava/lang/String;Z)Ljava/lang/String;", "(Ljava/lang/String;)Ljava/lang/String;", "Landroid/net/Uri$Builder;", "values", "(Landroid/net/Uri$Builder;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri$Builder;", "Lcom/appsflyer/internal/AFd1rSDK;", "Lcom/appsflyer/internal/AFd1rSDK;", "Lcom/appsflyer/internal/AFi1aSDK;", "Lcom/appsflyer/internal/AFi1aSDK;", "<init>", "(Lcom/appsflyer/internal/AFd1rSDK;Lcom/appsflyer/internal/AFi1aSDK;)V", "AFa1zSDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFi1cSDK {
    public static final String AFInAppEventParameterName;
    public static final String AFInAppEventType;
    public static final String AFKeystoreWrapper;
    public static final String AFLogger;

    public static final String f399d;

    public static final String f400e;
    private static final String force;
    public static final String registerClient;
    public static String unregisterClient;
    public final AFd1rSDK valueOf;
    public final AFi1aSDK values;

    public AFi1cSDK(AFd1rSDK aFd1rSDK) {
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        AFi1aSDK aFi1aSDK = null;
        this(aFd1rSDK, aFi1aSDK, 2, aFi1aSDK);
    }

    private AFi1cSDK(AFd1rSDK aFd1rSDK, AFi1aSDK aFi1aSDK) {
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        Intrinsics.checkNotNullParameter(aFi1aSDK, "");
        this.valueOf = aFd1rSDK;
        this.values = aFi1aSDK;
    }

    public AFi1cSDK(AFd1rSDK aFd1rSDK, AFi1dSDK aFi1dSDK, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(aFd1rSDK, (i & 2) != 0 ? new AFi1dSDK() : aFi1dSDK);
    }

    static {
        StringBuilder sb = new StringBuilder();
        sb.append(AFb1vSDK.AFInAppEventParameterName);
        sb.append("/androidevent?app_id=");
        String string = sb.toString();
        force = string;
        StringBuilder sb2 = new StringBuilder("https://%sattr.%s/api/v");
        sb2.append(string);
        AFInAppEventParameterName = sb2.toString();
        AFKeystoreWrapper = "https://%sadrevenue.%s/api/v2/generic/v6.13.0/android?app_id=";
        AFInAppEventType = "https://%sadrevenue.%s/api/v2/log/AdImpression/v6.13.0/android?app_id=";
        StringBuilder sb3 = new StringBuilder("https://%sconversions.%s/api/v");
        sb3.append(string);
        AFLogger = sb3.toString();
        StringBuilder sb4 = new StringBuilder("https://%slaunches.%s/api/v");
        sb4.append(string);
        f400e = sb4.toString();
        StringBuilder sb5 = new StringBuilder("https://%sinapps.%s/api/v");
        sb5.append(string);
        registerClient = sb5.toString();
        f399d = "https://%smonitorsdk.%s/api/remote-debug/v2.0?app_id=";
        StringBuilder sb6 = new StringBuilder("https://%svalidate.%s/api/v");
        sb6.append(AFb1vSDK.AFInAppEventParameterName);
        sb6.append("/androidevent?buildnumber=6.13.0&app_id=");
        unregisterClient = sb6.toString();
    }

    public final String AFInAppEventParameterName(String p0, String p1) {
        String packageName = this.valueOf.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName();
        Intrinsics.checkNotNullExpressionValue(packageName, "");
        String strValues = this.valueOf.values();
        String str = strValues;
        if (str != null && !StringsKt.isBlank(str)) {
            strValues = "-".concat(String.valueOf(StringsKt.trim(str).toString()));
        }
        if (strValues == null) {
            strValues = "";
        }
        String string = StringsKt.trim(strValues).toString();
        Uri.Builder builderBuildUpon = Uri.parse(this.values.AFInAppEventParameterName("https://%sdlsdk.%s/v1.0/android/")).buildUpon();
        StringBuilder sb = new StringBuilder();
        sb.append(packageName);
        sb.append(string);
        Uri.Builder builderAppendPath = builderBuildUpon.appendPath(sb.toString());
        Intrinsics.checkNotNullExpressionValue(builderAppendPath, "");
        String string2 = values(builderAppendPath, p0, p1).appendQueryParameter("sdk_version", AFb1vSDK.AFInAppEventParameterName).build().toString();
        Intrinsics.checkNotNullExpressionValue(string2, "");
        return string2;
    }

    private static Uri.Builder values(Uri.Builder builder, String str, String str2) {
        if (str == null || str2 == null) {
            String str3 = str == null ? "devKey" : SDKConstants.PARAM_DEBUG_MESSAGE_TIMESTAMP;
            AFLogger.afErrorLog(str3.concat(" is null at attempt to generate ddl event url"), new IllegalStateException(str3.concat(" is null")));
            return builder;
        }
        StringBuilder sb = new StringBuilder();
        sb.append(str2);
        sb.append(str);
        builder.appendQueryParameter("af_sig", AFb1mSDK.AFInAppEventParameterName(sb.toString(), str));
        return builder;
    }

    public final String AFInAppEventParameterName(AFh1qSDK p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        if (!(p0 instanceof AFh1rSDK)) {
            if (!(p0 instanceof AFh1oSDK)) {
                throw new UnsupportedOperationException();
            }
            String strAFInAppEventParameterName = this.values.AFInAppEventParameterName(unregisterClient);
            StringBuilder sb = new StringBuilder();
            sb.append(strAFInAppEventParameterName);
            sb.append(this.valueOf.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName());
            return sb.toString();
        }
        return this.values.AFInAppEventParameterName("https://%ssdk-services.%s/validate-android-signature");
    }

    public static String valueOf(String str, boolean z) {
        StringBuilder sb = new StringBuilder();
        sb.append(str);
        sb.append(!z ? "&buildnumber=6.13.0" : "");
        return sb.toString();
    }

    public final String valueOf(String str) {
        StringBuilder sb = new StringBuilder();
        sb.append(str);
        String strValues = this.valueOf.values();
        String strConcat = strValues != null ? "&channel=".concat(String.valueOf(strValues)) : null;
        if (strConcat == null) {
            strConcat = "";
        }
        sb.append(strConcat);
        return sb.toString();
    }
}
