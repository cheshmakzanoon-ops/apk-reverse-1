package com.appsflyer.internal;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.appsflyer.AFLogger;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b&\u0018\u0000 \u00172\u00020\u0001:\u0001\u0017B\u000f\u0012\u0006\u0010\t\u001a\u00020\u0014¢\u0006\u0004\b\u0015\u0010\u0016J\u000f\u0010\u0003\u001a\u00020\u0002H%¢\u0006\u0004\b\u0003\u0010\u0004J\u000f\u0010\u0006\u001a\u00020\u0005H\u0007¢\u0006\u0004\b\u0006\u0010\u0007J\u0019\u0010\u000b\u001a\u00020\n2\b\u0010\t\u001a\u0004\u0018\u00010\bH\u0004¢\u0006\u0004\b\u000b\u0010\fJ\u000f\u0010\r\u001a\u00020\nH&¢\u0006\u0004\b\r\u0010\u000eR\u0014\u0010\u0003\u001a\u0004\u0018\u00010\u000fX\u0085\u0002¢\u0006\u0006\n\u0004\b\r\u0010\u0010R\u0016\u0010\u0006\u001a\u0004\u0018\u00010\u00118\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\u0012\u0010\u0013"}, d2 = {"Lcom/appsflyer/internal/AFh1cSDK;", "", "", "values", "()Ljava/lang/String;", "Lcom/appsflyer/internal/AFh1eSDK;", "AFInAppEventParameterName", "()Lcom/appsflyer/internal/AFh1eSDK;", "Landroid/net/NetworkInfo;", "p0", "", "valueOf", "(Landroid/net/NetworkInfo;)Z", "AFInAppEventType", "()Z", "Landroid/net/ConnectivityManager;", "Landroid/net/ConnectivityManager;", "Landroid/telephony/TelephonyManager;", "AFKeystoreWrapper", "Landroid/telephony/TelephonyManager;", "Landroid/content/Context;", "<init>", "(Landroid/content/Context;)V", "AFa1tSDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public abstract class AFh1cSDK {

    ConnectivityManager values;

    private final TelephonyManager AFInAppEventParameterName;

    public abstract boolean AFInAppEventType();

    protected abstract String values();

    public AFh1cSDK(Context context) {
        Intrinsics.checkNotNullParameter(context, "");
        Object systemService = context.getSystemService("connectivity");
        this.values = systemService instanceof ConnectivityManager ? (ConnectivityManager) systemService : null;
        Object systemService2 = context.getSystemService("phone");
        this.AFInAppEventParameterName = systemService2 instanceof TelephonyManager ? (TelephonyManager) systemService2 : null;
    }

    protected static boolean valueOf(NetworkInfo p0) {
        if (p0 != null) {
            return p0.isConnectedOrConnecting();
        }
        return false;
    }

    public final AFh1eSDK AFInAppEventParameterName() {
        Throwable th;
        String str;
        String simOperatorName;
        String networkOperatorName = null;
        try {
            TelephonyManager telephonyManager = this.AFInAppEventParameterName;
            if (telephonyManager != null) {
                simOperatorName = telephonyManager.getSimOperatorName();
                try {
                    networkOperatorName = telephonyManager.getNetworkOperatorName();
                    String str2 = networkOperatorName;
                    if ((str2 == null || str2.length() == 0) && telephonyManager.getPhoneType() == 2) {
                        networkOperatorName = "CDMA";
                    }
                } catch (Throwable th2) {
                    str = networkOperatorName;
                    networkOperatorName = simOperatorName;
                    th = th2;
                    AFLogger.afErrorLog("Exception while collecting network info. ", th);
                    simOperatorName = networkOperatorName;
                    networkOperatorName = str;
                }
            } else {
                simOperatorName = null;
            }
        } catch (Throwable th3) {
            th = th3;
            str = null;
        }
        return new AFh1eSDK(values(), networkOperatorName, simOperatorName, AFInAppEventType());
    }
}
