package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.appsflyer.AppsFlyerLib;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0012\n\u0000\n\u0002\u0010$\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\b\u0000\u0018\u0000 \u00142\u00020\u0001:\u0001\u0014B/\u0012\u0006\u0010\r\u001a\u00020\f\u0012\u0014\u0010\u000f\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0002\u0018\u00010\u000e\u0012\b\b\u0002\u0010\u0011\u001a\u00020\u0010¢\u0006\u0004\b\u0012\u0010\u0013J\u0015\u0010\u0003\u001a\u00020\u0002*\u0004\u0018\u00010\u0002H\u0017¢\u0006\u0004\b\u0003\u0010\u0004R\u001a\u0010\u0003\u001a\u00020\u00058\u0017X\u0097\u0004¢\u0006\f\n\u0004\b\u0006\u0010\u0007\u001a\u0004\b\b\u0010\tR\u0014\u0010\u000b\u001a\u00020\u00028WX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0003\u0010\n"}, d2 = {"Lcom/appsflyer/internal/AFd1bSDK;", "Lcom/appsflyer/internal/AFd1mSDK;", "", "AFInAppEventType", "(Ljava/lang/String;)Ljava/lang/String;", "Lcom/appsflyer/internal/AFe1uSDK;", "AFKeystoreWrapper", "Lcom/appsflyer/internal/AFe1uSDK;", "values", "()Lcom/appsflyer/internal/AFe1uSDK;", "()Ljava/lang/String;", "AFInAppEventParameterName", "", "p0", "", "p1", "", "p2", "<init>", "([BLjava/util/Map;I)V", "AFa1vSDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFd1bSDK extends AFd1mSDK {

    private final AFe1uSDK AFInAppEventType;
    public static String AFInAppEventParameterName = "https://%smonitorsdk.%s/remote-debug/exception-manager";

    public AFd1bSDK(byte[] bArr, Map<String, String> map, int i) {
        super(bArr, map, i);
        Intrinsics.checkNotNullParameter(bArr, "");
        this.AFInAppEventType = AFe1uSDK.JSON;
    }

    @Override
    public final String AFInAppEventType() {
        String str = String.format(AFInAppEventParameterName, AppsFlyerLib.getInstance().getHostPrefix(), AFb1vSDK.valueOf().getHostName());
        Intrinsics.checkNotNullExpressionValue(str, "");
        return str;
    }

    @Override
    public final AFe1uSDK getAFInAppEventType() {
        return this.AFInAppEventType;
    }

    @Override
    public final String AFInAppEventType(String str) {
        Intrinsics.checkNotNullParameter(str, "");
        Intrinsics.checkNotNullParameter(str, "");
        return "[Exception Manager]: ".concat(String.valueOf(str));
    }
}
