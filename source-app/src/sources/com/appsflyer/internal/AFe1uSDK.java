package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.webkit.internal.AssetHelper;
import coil.util.Utils;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\u0010\u000e\n\u0002\b\r\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0011\b\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0002¢\u0006\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0003\u001a\u00020\u0002X\u0007¢\u0006\u0006\n\u0004\b\u0003\u0010\u0004j\u0002\b\bj\u0002\b\tj\u0002\b\nj\u0002\b\u000bj\u0002\b\fj\u0002\b\rj\u0002\b\u000ej\u0002\b\u000f"}, d2 = {"Lcom/appsflyer/internal/AFe1uSDK;", "", "", "AFInAppEventParameterName", "Ljava/lang/String;", "p0", "<init>", "(Ljava/lang/String;ILjava/lang/String;)V", "values", "AFInAppEventType", "valueOf", "AFKeystoreWrapper", "registerClient", "unregisterClient", "e", "d"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public enum AFe1uSDK {
    TEXT(AssetHelper.DEFAULT_MIME_TYPE),
    JSON("application/json"),
    OCTET_STREAM("application/octet-stream"),
    XML("application/xml"),
    HTML("text/html"),
    FORM("application/x-www-form-urlencoded"),
    IMAGE_JPEG(Utils.MIME_TYPE_JPEG),
    IMAGE_PNG("image/png");

    public final String AFInAppEventParameterName;

    AFe1uSDK(String str) {
        this.AFInAppEventParameterName = str;
    }
}
