package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import java.util.concurrent.TimeUnit;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

public final class AFf1fSDK {
    public final boolean AFInAppEventParameterName(String str) {
        return AFInAppEventParameterName(this, str);
    }

    private static boolean AFInAppEventParameterName(AFf1fSDK aFf1fSDK, String str) {
        return values(str, TimeUnit.HOURS, 1L);
    }

    private static boolean values(String str, TimeUnit timeUnit, long j) {
        Long longOrNull;
        Object obj;
        Intrinsics.checkNotNullParameter(timeUnit, "");
        if (str != null && (longOrNull = StringsKt.toLongOrNull(str)) != null) {
            try {
                Result.Companion companion = Result.Companion;
                obj = Result.constructor-impl(Boolean.valueOf(Math.abs(longOrNull.longValue() - TimeUnit.MILLISECONDS.toSeconds(AFb1vSDK.valueOf().AFInAppEventType().mo783d().AFKeystoreWrapper())) < timeUnit.toSeconds(1L)));
            } catch (Throwable th) {
                Result.Companion companion2 = Result.Companion;
                obj = Result.constructor-impl(ResultKt.createFailure(th));
            }
            Throwable th2 = Result.exceptionOrNull-impl(obj);
            if (th2 != null) {
                StringBuilder sb = new StringBuilder("Could not convert ");
                sb.append(str);
                sb.append(" to TS");
                AFLogger.afErrorLog(sb.toString(), th2);
            }
            if (Result.isFailure-impl(obj)) {
                obj = null;
            }
            Boolean bool = (Boolean) obj;
            if (bool != null) {
                return bool.booleanValue();
            }
        }
        return false;
    }
}
