package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\u0010\u000e\n\u0002\b\b\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0011\b\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0002¢\u0006\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0003\u001a\u00020\u0002X\u0007¢\u0006\u0006\n\u0004\b\u0003\u0010\u0004j\u0002\b\bj\u0002\b\tj\u0002\b\n"}, d2 = {"Lcom/appsflyer/internal/AFe1iSDK;", "", "", "AFInAppEventParameterName", "Ljava/lang/String;", "p0", "<init>", "(Ljava/lang/String;ILjava/lang/String;)V", "AFInAppEventType", "AFKeystoreWrapper", "values"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public enum AFe1iSDK {
    API("api"),
    RC("rc"),
    DEFAULT("");

    public final String AFInAppEventParameterName;

    AFe1iSDK(String str) {
        this.AFInAppEventParameterName = str;
    }
}
