package com.appsflyer.internal;

import android.os.Build;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.appsflyer.AFKeystoreWrapper;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import java.security.KeyStoreException;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\bÆ\u0002\u0018\u00002\u00020\u0001B\t\b\u0002¢\u0006\u0004\b\f\u0010\rJ\u001f\u0010\u0007\u001a\u00020\u00062\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u0004H\u0007¢\u0006\u0004\b\u0007\u0010\bJ\u0011\u0010\n\u001a\u0004\u0018\u00010\tH\u0007¢\u0006\u0004\b\n\u0010\u000bJ\u0011\u0010\u0007\u001a\u0004\u0018\u00010\tH\u0007¢\u0006\u0004\b\u0007\u0010\u000b"}, d2 = {"Lcom/appsflyer/internal/AFc1vSDK;", "", "Lcom/appsflyer/internal/AFd1lSDK;", "p0", "Lcom/appsflyer/internal/AFd1xSDK;", "p1", "", "AFKeystoreWrapper", "(Lcom/appsflyer/internal/AFd1lSDK;Lcom/appsflyer/internal/AFd1xSDK;)V", "", "AFInAppEventParameterName", "()Ljava/lang/String;", "<init>", "()V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFc1vSDK {
    public static final AFc1vSDK INSTANCE = new AFc1vSDK();

    private AFc1vSDK() {
    }

    @JvmStatic
    public static final void AFKeystoreWrapper(AFd1lSDK p0, AFd1xSDK p1) {
        int i;
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        AppsFlyerProperties appsFlyerProperties = AppsFlyerProperties.getInstance();
        if (AFb1qSDK.AFKeystoreWrapper()) {
            AFLogger.afRDLog("OPPO device found");
            i = 23;
        } else {
            i = 18;
        }
        if (Build.VERSION.SDK_INT >= i && !appsFlyerProperties.getBoolean(AppsFlyerProperties.DISABLE_KEYSTORE, true)) {
            StringBuilder sb = new StringBuilder("OS SDK is=");
            sb.append(Build.VERSION.SDK_INT);
            sb.append("; use KeyStore");
            AFLogger.afRDLog(sb.toString());
            AFKeystoreWrapper aFKeystoreWrapper = new AFKeystoreWrapper(p0.AFInAppEventParameterName);
            if (!aFKeystoreWrapper.values()) {
                aFKeystoreWrapper.AFInAppEventParameterName = AFb1lSDK.values(p0, p1);
                aFKeystoreWrapper.valueOf = 0;
                aFKeystoreWrapper.values(aFKeystoreWrapper.AFKeystoreWrapper());
            } else {
                String strAFKeystoreWrapper = aFKeystoreWrapper.AFKeystoreWrapper();
                synchronized (aFKeystoreWrapper.AFInAppEventType) {
                    aFKeystoreWrapper.valueOf++;
                    AFLogger.afInfoLog("Deleting key with alias: ".concat(String.valueOf(strAFKeystoreWrapper)));
                    try {
                        synchronized (aFKeystoreWrapper.AFInAppEventType) {
                            aFKeystoreWrapper.AFKeystoreWrapper.deleteEntry(strAFKeystoreWrapper);
                        }
                    } catch (KeyStoreException e) {
                        StringBuilder sb2 = new StringBuilder("Exception ");
                        sb2.append(e.getMessage());
                        sb2.append(" occurred");
                        AFLogger.afErrorLog(sb2.toString(), e);
                    }
                }
                aFKeystoreWrapper.values(aFKeystoreWrapper.AFKeystoreWrapper());
            }
            appsFlyerProperties.set("KSAppsFlyerId", aFKeystoreWrapper.AFInAppEventParameterName());
            appsFlyerProperties.set("KSAppsFlyerRICounter", String.valueOf(aFKeystoreWrapper.valueOf()));
            return;
        }
        StringBuilder sb3 = new StringBuilder("OS SDK is=");
        sb3.append(Build.VERSION.SDK_INT);
        sb3.append("; no KeyStore usage");
        AFLogger.afRDLog(sb3.toString());
    }

    public static String AFInAppEventParameterName() {
        return AppsFlyerProperties.getInstance().getString("KSAppsFlyerId");
    }

    public static String AFKeystoreWrapper() {
        return AppsFlyerProperties.getInstance().getString("KSAppsFlyerRICounter");
    }
}
