package com.appsflyer.internal;

import android.os.SystemClock;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewConfiguration;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\u0018\u00002\u00020\u0001B\u000f\u0012\u0006\u0010\b\u001a\u00020\u0005¢\u0006\u0004\b\t\u0010\nJ\r\u0010\u0003\u001a\u00020\u0002¢\u0006\u0004\b\u0003\u0010\u0004R\u0014\u0010\u0006\u001a\u00020\u00058\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\u0006\u0010\u0007"}, d2 = {"Lcom/appsflyer/internal/AFb1sSDK;", "", "", "afInfoLog", "()V", "Lcom/appsflyer/internal/AFa1pSDK;", "AFKeystoreWrapper", "Lcom/appsflyer/internal/AFa1pSDK;", "p0", "<init>", "(Lcom/appsflyer/internal/AFa1pSDK;)V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFb1sSDK {
    private final AFa1pSDK AFKeystoreWrapper;

    public AFb1sSDK(AFa1pSDK aFa1pSDK) {
        Intrinsics.checkNotNullParameter(aFa1pSDK, "");
        this.AFKeystoreWrapper = aFa1pSDK;
    }

    public final void afInfoLog() throws Throwable {
        try {
            Object declaredConstructor = AFc1fSDK.afRDLog.get(-1120247015);
            if (declaredConstructor == null) {
                declaredConstructor = ((Class) AFc1fSDK.AFInAppEventType(37 - View.MeasureSpec.makeMeasureSpec(0, 0), (char) (ViewConfiguration.getKeyRepeatDelay() >> 16), 88 - (SystemClock.elapsedRealtime() > 0L ? 1 : (SystemClock.elapsedRealtime() == 0L ? 0 : -1)))).getDeclaredConstructor(null);
                AFc1fSDK.afRDLog.put(-1120247015, declaredConstructor);
            }
            Object objNewInstance = ((Constructor) declaredConstructor).newInstance(null);
            try {
                Object[] objArr = {this.AFKeystoreWrapper};
                Object method = AFc1fSDK.afRDLog.get(-372018287);
                if (method == null) {
                    method = ((Class) AFc1fSDK.AFInAppEventType(37 - View.getDefaultSize(0, 0), (char) KeyEvent.normalizeMetaState(0), TextUtils.getCapsMode("", 0, 0) + 87)).getMethod("AFInAppEventType", AFa1pSDK.class);
                    AFc1fSDK.afRDLog.put(-372018287, method);
                }
                ((Method) method).invoke(objNewInstance, objArr);
            } catch (Throwable th) {
                Throwable cause = th.getCause();
                if (cause == null) {
                    throw th;
                }
                throw cause;
            }
        } catch (Throwable th2) {
            Throwable cause2 = th2.getCause();
            if (cause2 == null) {
                throw th2;
            }
            throw cause2;
        }
    }
}
