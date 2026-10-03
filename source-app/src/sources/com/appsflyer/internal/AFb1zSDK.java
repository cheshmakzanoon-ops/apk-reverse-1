package com.appsflyer.internal;

import android.content.Context;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.Map;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0003\bf\u0018\u0000 \b2\u00020\u0001:\u0001\bJ#\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0003\u001a\u00020\u0002H'¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"Lcom/appsflyer/internal/AFb1zSDK;", "", "Landroid/content/Context;", "p0", "", "", "AFKeystoreWrapper", "(Landroid/content/Context;)Ljava/util/Map;", "AFa1zSDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public interface AFb1zSDK {

    public static final Companion INSTANCE = Companion.AFInAppEventParameterName;

    Map<String, String> AFKeystoreWrapper(Context p0);

    public static final class Companion {
        static final Companion AFInAppEventParameterName = new Companion();

        private Companion() {
        }
    }
}
