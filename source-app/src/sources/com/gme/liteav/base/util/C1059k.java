package com.gme.liteav.base.util;

import android.text.TextUtils;
import java.util.concurrent.Callable;

public final class C1059k<T> {

    private T f771a;

    private Callable<T> f772b;

    public C1059k(Callable<T> callable) {
        this.f772b = callable;
    }

    public final void m1028a(T t) {
        synchronized (this) {
            this.f771a = t;
        }
    }

    public final T m1027a() {
        T t = this.f771a;
        if (t instanceof String) {
            if (!TextUtils.isEmpty((CharSequence) t)) {
                return this.f771a;
            }
        } else if (t != null) {
            return t;
        }
        synchronized (this) {
            T t2 = this.f771a;
            if (t2 instanceof String) {
                if (!TextUtils.isEmpty((CharSequence) t2)) {
                    return this.f771a;
                }
            } else if (t2 != null) {
                return t2;
            }
            try {
                this.f771a = this.f772b.call();
            } catch (Exception e) {
                e.printStackTrace();
                LiteavLog.m994e("Stash", "Get value failed. msg:" + e.getMessage());
            }
            return this.f771a;
        }
    }
}
