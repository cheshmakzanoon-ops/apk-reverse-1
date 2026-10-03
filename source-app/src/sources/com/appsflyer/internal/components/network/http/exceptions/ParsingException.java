package com.appsflyer.internal.components.network.http.exceptions;

import com.appsflyer.internal.AFe1pSDK;
import java.io.IOException;

public class ParsingException extends IOException {
    private final AFe1pSDK<String> valueOf;

    public ParsingException(String str, Throwable th, AFe1pSDK<String> aFe1pSDK) {
        super(str, th);
        this.valueOf = aFe1pSDK;
    }

    public AFe1pSDK<String> getRawResponse() {
        return this.valueOf;
    }
}
