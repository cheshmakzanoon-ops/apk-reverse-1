package com.appsflyer.internal;

import com.appsflyer.attribution.AppsFlyerRequestListener;
import com.appsflyer.internal.components.network.http.exceptions.ParsingException;
import com.appsflyer.share.LinkGenerator;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public final class AFf1uSDK extends AFf1tSDK<String> {
    private final UUID afInfoLog;
    private final String force;

    private final LinkGenerator f369i;
    private final String registerClient;

    private final LinkGenerator.ResponseListener f370v;

    private final Map<String, String> f371w;

    @Override
    public final long AFKeystoreWrapper() {
        return 3000L;
    }

    @Override
    protected final boolean force() {
        return false;
    }

    @Override
    protected final AppsFlyerRequestListener registerClient() {
        return null;
    }

    @Override
    protected final boolean unregisterClient() {
        return false;
    }

    public AFf1uSDK(AFd1nSDK aFd1nSDK, UUID uuid, String str, Map<String, String> map, String str2, LinkGenerator.ResponseListener responseListener, LinkGenerator linkGenerator) {
        super(AFe1bSDK.ONELINK, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, aFd1nSDK, uuid.toString());
        this.afInfoLog = uuid;
        this.registerClient = str;
        this.f371w = new HashMap(map);
        this.f370v = responseListener;
        this.force = str2;
        this.f369i = linkGenerator;
    }

    @Override
    public final void valueOf() {
        super.valueOf();
        LinkGenerator.ResponseListener responseListener = this.f370v;
        if (responseListener != null) {
            if (this.AFKeystoreWrapper == AFe1cSDK.SUCCESS && this.AFLogger != null) {
                responseListener.onResponse((String) this.AFLogger.getBody());
                return;
            }
            Throwable thM790d = m790d();
            if (thM790d instanceof ParsingException) {
                if (((ParsingException) thM790d).getRawResponse().isSuccessful()) {
                    responseListener.onResponseError("Can't parse one link data");
                    return;
                } else {
                    responseListener.onResponse(this.f369i.generateLink());
                    return;
                }
            }
            responseListener.onResponse(this.f369i.generateLink());
        }
    }

    @Override
    protected final AFe1xSDK<String> valueOf(String str) {
        return ((AFf1tSDK) this).f367e.AFInAppEventType(this.registerClient, this.f371w, this.force, this.afInfoLog, str);
    }
}
