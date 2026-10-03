package com.appsflyer.internal.components.network.http.exceptions;

import com.appsflyer.internal.AFe1tSDK;
import java.io.IOException;

public class HttpException extends IOException {
    private final AFe1tSDK AFInAppEventParameterName;

    public HttpException(Throwable th, AFe1tSDK aFe1tSDK) {
        super(th.getMessage(), th);
        this.AFInAppEventParameterName = aFe1tSDK;
    }

    public AFe1tSDK getMetrics() {
        return this.AFInAppEventParameterName;
    }
}
