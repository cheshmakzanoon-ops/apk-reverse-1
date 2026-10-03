package com.appsflyer.internal;

import android.content.Context;
import com.appsflyer.AppsFlyerLib;

public final class AFg1pSDK extends AFa1pSDK {
    @Override
    public final boolean mo765e() {
        return false;
    }

    public AFg1pSDK(Context context) {
        StringBuilder sb = new StringBuilder();
        sb.append(String.format(AFg1tSDK.valueOf, AppsFlyerLib.getInstance().getHostPrefix(), AFb1vSDK.valueOf().getHostName()));
        sb.append(context.getPackageName());
        super("Register", sb.toString(), Boolean.FALSE);
    }

    @Override
    public final AFe1bSDK AFInAppEventParameterName() {
        return AFe1bSDK.REGISTER;
    }
}
