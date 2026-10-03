package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.gme.trtc.hardwareearmonitor.honor.HonorResultCode;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0010\u0012\n\u0000\n\u0002\u0010$\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\u0018\u00002\u00020\u0001B;\b\u0007\u0012\u0006\u0010\u0013\u001a\u00020\u000b\u0012\u0006\u0010\u0015\u001a\u00020\u0014\u0012\u0016\b\u0002\u0010\u0017\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0002\u0018\u00010\u0016\u0012\b\b\u0002\u0010\u0019\u001a\u00020\u0018¢\u0006\u0004\b\u001a\u0010\u001bJ\u0015\u0010\u0003\u001a\u00020\u0002*\u0004\u0018\u00010\u0002H\u0017¢\u0006\u0004\b\u0003\u0010\u0004R\u001a\u0010\n\u001a\u00020\u00058\u0017X\u0097\u0004¢\u0006\f\n\u0004\b\u0006\u0010\u0007\u001a\u0004\b\b\u0010\tR\u0011\u0010\b\u001a\u00020\u000bX\u0007¢\u0006\u0006\n\u0004\b\f\u0010\rR\u001a\u0010\f\u001a\u00020\u000e8\u0017X\u0097D¢\u0006\f\n\u0004\b\u000f\u0010\u0010\u001a\u0004\b\n\u0010\u0011R\u0014\u0010\u000f\u001a\u00020\u00028WX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0003\u0010\u0012"}, d2 = {"Lcom/appsflyer/internal/AFe1ySDK;", "Lcom/appsflyer/internal/AFd1mSDK;", "", "AFInAppEventType", "(Ljava/lang/String;)Ljava/lang/String;", "Lcom/appsflyer/internal/AFe1uSDK;", "e", "Lcom/appsflyer/internal/AFe1uSDK;", "values", "()Lcom/appsflyer/internal/AFe1uSDK;", "valueOf", "Lcom/appsflyer/internal/AFd1rSDK;", "AFInAppEventParameterName", "Lcom/appsflyer/internal/AFd1rSDK;", "", "AFKeystoreWrapper", "Z", "()Z", "()Ljava/lang/String;", "p0", "", "p1", "", "p2", "", "p3", "<init>", "(Lcom/appsflyer/internal/AFd1rSDK;[BLjava/util/Map;I)V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFe1ySDK extends AFd1mSDK {

    public AFd1rSDK values;

    private final boolean AFInAppEventParameterName;

    private final AFe1uSDK valueOf;

    public AFe1ySDK(AFd1rSDK aFd1rSDK, byte[] bArr) {
        this(aFd1rSDK, bArr, null, 0, 12, null);
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        Intrinsics.checkNotNullParameter(bArr, "");
    }

    public AFe1ySDK(AFd1rSDK aFd1rSDK, byte[] bArr, Map map, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(aFd1rSDK, bArr, (i2 & 4) != 0 ? null : map, (i2 & 8) != 0 ? HonorResultCode.ADVANCED_RECORD_SUCCESS : i);
    }

    private AFe1ySDK(AFd1rSDK aFd1rSDK, byte[] bArr, Map<String, String> map, int i) {
        super(bArr, map, i);
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        Intrinsics.checkNotNullParameter(bArr, "");
        this.values = aFd1rSDK;
        this.valueOf = AFe1uSDK.OCTET_STREAM;
    }

    @Override
    public final boolean getAFInAppEventParameterName() {
        return this.AFInAppEventParameterName;
    }

    @Override
    public final String AFInAppEventType() {
        AFi1cSDK aFi1cSDK = new AFi1cSDK(this.values, null, 2, null);
        String strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName(AFi1cSDK.f399d);
        StringBuilder sb = new StringBuilder();
        sb.append(strAFInAppEventParameterName);
        sb.append(aFi1cSDK.valueOf.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName());
        return sb.toString();
    }

    @Override
    public final AFe1uSDK getValueOf() {
        return this.valueOf;
    }

    @Override
    public final String AFInAppEventType(String str) {
        Intrinsics.checkNotNullParameter(str, "");
        return "[RD]: ".concat(String.valueOf(str));
    }
}
