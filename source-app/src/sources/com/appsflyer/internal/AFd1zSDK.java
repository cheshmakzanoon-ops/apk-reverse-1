package com.appsflyer.internal;

import android.content.Context;
import android.content.pm.PackageItemInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import com.appsflyer.AFLogger;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.util.Arrays;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public abstract class AFd1zSDK<T> {
    public final AFd1nSDK AFInAppEventParameterName;
    public final FutureTask<T> AFInAppEventType = new FutureTask<>(new Callable<T>() {
        @Override
        public final T call() {
            if (AFd1zSDK.this.AFInAppEventParameterName()) {
                return (T) AFd1zSDK.this.AFInAppEventType();
            }
            return null;
        }
    });
    public final Context AFKeystoreWrapper;
    public final String valueOf;
    private final String[] values;

    protected abstract T AFInAppEventType();

    public AFd1zSDK(Context context, AFd1nSDK aFd1nSDK, String str, String... strArr) {
        this.AFKeystoreWrapper = context;
        this.valueOf = str;
        this.values = strArr;
        this.AFInAppEventParameterName = aFd1nSDK;
    }

    public T valueOf() {
        try {
            return this.AFInAppEventType.get(500L, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            e = e;
            AFLogger.afErrorLog(e.getMessage(), e, false, true);
            return null;
        } catch (ExecutionException e2) {
            e = e2;
            AFLogger.afErrorLog(e.getMessage(), e, false, true);
            return null;
        } catch (TimeoutException e3) {
            AFLogger.afErrorLog(e3.getMessage(), e3, false, false);
            return null;
        }
    }

    public final boolean AFInAppEventParameterName() {
        try {
            ProviderInfo providerInfoResolveContentProvider = this.AFKeystoreWrapper.getPackageManager().resolveContentProvider(this.valueOf, 128);
            return providerInfoResolveContentProvider != null && Arrays.asList(this.values).contains(AFb1qSDK.AFInAppEventParameterName(this.AFKeystoreWrapper.getPackageManager(), ((PackageItemInfo) providerInfoResolveContentProvider).packageName));
        } catch (PackageManager.NameNotFoundException | NoSuchAlgorithmException | CertificateException e) {
            AFLogger.afErrorLog(e.getMessage(), e, false, true);
            return false;
        }
    }
}
