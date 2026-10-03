package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import com.appsflyer.internal.components.network.http.exceptions.HttpException;
import com.appsflyer.internal.components.network.http.exceptions.ParsingException;
import com.appsflyer.internal.components.queue.exceptions.CreateHttpCallException;
import java.io.IOException;

public abstract class AFf1tSDK<Result> extends AFe1fSDK<AFe1pSDK<Result>> {
    public AFe1pSDK<Result> AFLogger;

    protected final AFb1cSDK f366d;

    protected final AFe1zSDK f367e;
    private AFb1rSDK registerClient;
    public final AFg1zSDK unregisterClient;

    private String f368v;

    @Override
    public long AFKeystoreWrapper() {
        return 60000L;
    }

    protected boolean force() {
        return true;
    }

    protected abstract AppsFlyerRequestListener registerClient();

    protected abstract boolean unregisterClient();

    protected abstract AFe1xSDK<Result> valueOf(String str);

    private AFf1tSDK(AFe1bSDK aFe1bSDK, AFe1bSDK[] aFe1bSDKArr, AFe1zSDK aFe1zSDK, AFg1zSDK aFg1zSDK, AFb1cSDK aFb1cSDK, AFb1rSDK aFb1rSDK, String str) {
        super(aFe1bSDK, aFe1bSDKArr, str);
        this.f367e = aFe1zSDK;
        this.unregisterClient = aFg1zSDK;
        this.f366d = aFb1cSDK;
        this.registerClient = aFb1rSDK;
    }

    public AFf1tSDK(AFe1bSDK aFe1bSDK, AFe1bSDK[] aFe1bSDKArr, AFd1nSDK aFd1nSDK, String str) {
        this(aFe1bSDK, aFe1bSDKArr, aFd1nSDK.AFInAppEventParameterName(), aFd1nSDK.mo785i(), aFd1nSDK.afInfoLog(), aFd1nSDK.afRDLog(), str);
    }

    public AFf1tSDK(AFe1bSDK aFe1bSDK, AFe1bSDK[] aFe1bSDKArr, AFd1nSDK aFd1nSDK, String str, String str2) {
        this(aFe1bSDK, aFe1bSDKArr, aFd1nSDK.AFInAppEventParameterName(), aFd1nSDK.mo785i(), aFd1nSDK.afInfoLog(), aFd1nSDK.afRDLog(), str);
        this.f368v = str2;
    }

    @Override
    public final void AFInAppEventParameterName() {
        String str;
        super.AFInAppEventParameterName();
        if (!unregisterClient() || (str = this.unregisterClient.registerClient) == null || str.trim().isEmpty()) {
            return;
        }
        AFe1xSDK<Result> aFe1xSDKValueOf = valueOf(str);
        if (aFe1xSDKValueOf != null) {
            AFInAppEventParameterName(aFe1xSDKValueOf.valueOf);
        } else {
            AFLogger.afErrorLogForExcManagerOnly("Failed to create a cached HTTP call", new CreateHttpCallException("createHttpCall returned null"));
        }
    }

    @Override
    public AFe1cSDK AFInAppEventType() throws Exception {
        if (force() && this.unregisterClient.valueOf()) {
            AppsFlyerRequestListener appsFlyerRequestListenerRegisterClient = registerClient();
            if (appsFlyerRequestListenerRegisterClient != null) {
                appsFlyerRequestListenerRegisterClient.onError(11, "Skipping event because 'isStopped' is true");
            }
            throw new AFf1zSDK();
        }
        String str = this.unregisterClient.registerClient;
        if (str != null && !str.trim().isEmpty()) {
            AFe1xSDK<Result> aFe1xSDKValueOf = valueOf(str);
            if (aFe1xSDKValueOf == null) {
                AFLogger.afErrorLogForExcManagerOnly("Failed to create a cached HTTP call", new CreateHttpCallException("createHttpCall returned null"));
                return AFe1cSDK.FAILURE;
            }
            if (unregisterClient()) {
                AFInAppEventParameterName(aFe1xSDKValueOf.valueOf);
            }
            AFe1pSDK<Result> aFe1pSDKValueOf = aFe1xSDKValueOf.valueOf();
            this.AFLogger = aFe1pSDKValueOf;
            this.f366d.AFInAppEventParameterName(aFe1xSDKValueOf.valueOf.values, aFe1pSDKValueOf.getStatusCode(), aFe1pSDKValueOf.getBody().toString());
            AppsFlyerRequestListener appsFlyerRequestListenerRegisterClient2 = registerClient();
            if (appsFlyerRequestListenerRegisterClient2 != null) {
                if (aFe1pSDKValueOf.isSuccessful()) {
                    appsFlyerRequestListenerRegisterClient2.onSuccess();
                } else {
                    StringBuilder sb = new StringBuilder("Status code failure ");
                    sb.append(aFe1pSDKValueOf.getStatusCode());
                    appsFlyerRequestListenerRegisterClient2.onError(50, sb.toString());
                }
            }
            if (aFe1pSDKValueOf.isSuccessful()) {
                return AFe1cSDK.SUCCESS;
            }
            return AFe1cSDK.FAILURE;
        }
        AppsFlyerRequestListener appsFlyerRequestListenerRegisterClient3 = registerClient();
        if (appsFlyerRequestListenerRegisterClient3 != null) {
            appsFlyerRequestListenerRegisterClient3.onError(41, "No dev key");
        }
        throw new AFf1ySDK();
    }

    @Override
    public boolean values() {
        if (m790d() instanceof AFf1zSDK) {
            return false;
        }
        if (this.AFKeystoreWrapper == AFe1cSDK.TIMEOUT) {
            return true;
        }
        Throwable thM790d = m790d();
        return (thM790d instanceof IOException) && !(thM790d instanceof ParsingException);
    }

    @Override
    public final void AFInAppEventType(Throwable th) {
        boolean z = !(th instanceof HttpException);
        if (th instanceof AFf1zSDK) {
            AFLogger.INSTANCE.m800e(AFg1hSDK.HTTP_CLIENT, "AppsFlyer SDK is stopped: the request was not sent to the server", th, true, false);
        } else {
            AFLogger.INSTANCE.m801e(AFg1hSDK.HTTP_CLIENT, "Error while sending request to server: ".concat(String.valueOf(th)), th, true, true, z);
        }
        AppsFlyerRequestListener appsFlyerRequestListenerRegisterClient = registerClient();
        if (appsFlyerRequestListenerRegisterClient != null) {
            String message = th.getMessage();
            if (message == null) {
                message = "";
            }
            appsFlyerRequestListenerRegisterClient.onError(40, message);
        }
    }

    private void AFInAppEventParameterName(AFe1mSDK aFe1mSDK) {
        String str = this.f368v;
        this.f368v = this.registerClient.AFInAppEventType(new AFb1kSDK(aFe1mSDK.values, aFe1mSDK.values(), "6.13.0", this.AFInAppEventType));
        if (str != null) {
            this.registerClient.valueOf(str);
        }
    }

    @Override
    public void valueOf() {
        String str;
        if (this.AFKeystoreWrapper != AFe1cSDK.SUCCESS) {
            if (values() || (str = this.f368v) == null) {
                return;
            }
            this.registerClient.valueOf(str);
            return;
        }
        String str2 = this.f368v;
        if (str2 != null) {
            this.registerClient.valueOf(str2);
        }
    }
}
