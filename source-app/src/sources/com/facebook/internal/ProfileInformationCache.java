package com.facebook.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import j$.util.concurrent.ConcurrentHashMap;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\b\u0004\bÀ\u0002\u0018\u00002\u00020\u0001B\t\b\u0002¢\u0006\u0004\b\u0002\u0010\u0003J\u0019\u0010\u0007\u001a\u0004\u0018\u00010\u00062\u0006\u0010\u0005\u001a\u00020\u0004H\u0007¢\u0006\u0004\b\u0007\u0010\bJ\u001f\u0010\f\u001a\u00020\u000b2\u0006\u0010\t\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\u0006H\u0007¢\u0006\u0004\b\f\u0010\rR \u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00060\u000e8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u000f\u0010\u0010¨\u0006\u0011"}, d2 = {"Lcom/facebook/internal/ProfileInformationCache;", "", "<init>", "()V", "", SDKConstants.PARAM_ACCESS_TOKEN, "Lorg/json/JSONObject;", "getProfileInformation", "(Ljava/lang/String;)Lorg/json/JSONObject;", SDKConstants.PARAM_KEY, SDKConstants.PARAM_VALUE, "", "putProfileInformation", "(Ljava/lang/String;Lorg/json/JSONObject;)V", "j$/util/concurrent/ConcurrentHashMap", "infoCache", "Lj$/util/concurrent/ConcurrentHashMap;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ProfileInformationCache {
    public static final ProfileInformationCache INSTANCE = new ProfileInformationCache();
    private static final ConcurrentHashMap<String, JSONObject> infoCache = new ConcurrentHashMap<>();

    private ProfileInformationCache() {
    }

    @JvmStatic
    public static final JSONObject getProfileInformation(String accessToken) {
        Intrinsics.checkNotNullParameter(accessToken, SDKConstants.PARAM_ACCESS_TOKEN);
        return (JSONObject) infoCache.get(accessToken);
    }

    @JvmStatic
    public static final void putProfileInformation(String key, JSONObject value) {
        Intrinsics.checkNotNullParameter(key, SDKConstants.PARAM_KEY);
        Intrinsics.checkNotNullParameter(value, SDKConstants.PARAM_VALUE);
        infoCache.put(key, value);
    }
}
