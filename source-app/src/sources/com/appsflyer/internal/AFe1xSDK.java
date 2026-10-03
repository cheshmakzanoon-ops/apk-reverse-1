package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.internal.components.network.http.exceptions.ParsingException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.atomic.AtomicBoolean;
import org.json.JSONException;

public final class AFe1xSDK<ResponseBody> {
    private final AFe1sSDK AFInAppEventParameterName;
    private final AtomicBoolean AFInAppEventType = new AtomicBoolean(false);
    private final AFe1kSDK<ResponseBody> AFKeystoreWrapper;
    public final AFe1mSDK valueOf;
    private final ExecutorService values;

    public AFe1xSDK(AFe1mSDK aFe1mSDK, ExecutorService executorService, AFe1sSDK aFe1sSDK, AFe1kSDK<ResponseBody> aFe1kSDK) {
        this.valueOf = aFe1mSDK;
        this.values = executorService;
        this.AFInAppEventParameterName = aFe1sSDK;
        this.AFKeystoreWrapper = aFe1kSDK;
    }

    public final AFe1pSDK<ResponseBody> valueOf() throws Throwable {
        if (!this.AFInAppEventType.getAndSet(true)) {
            AFe1pSDK<String> aFe1pSDKValueOf = this.AFInAppEventParameterName.valueOf(this.valueOf);
            try {
                return new AFe1pSDK<>(this.AFKeystoreWrapper.valueOf(aFe1pSDKValueOf.getBody()), aFe1pSDKValueOf.AFInAppEventType, aFe1pSDKValueOf.AFInAppEventParameterName, aFe1pSDKValueOf.valueOf, aFe1pSDKValueOf.values);
            } catch (JSONException e) {
                AFLogger.afErrorLogForExcManagerOnly("could not parse raw response - execute", e);
                throw new ParsingException(e.getMessage(), e, aFe1pSDKValueOf);
            }
        }
        throw new IllegalStateException("Http call is already executed");
    }
}
