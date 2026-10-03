package com.appsflyer.internal;

import android.content.Intent;
import com.appsflyer.AFLogger;
import java.util.ConcurrentModificationException;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.collections.ArraysKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlin.reflect.KClass;

public final class AFi1jSDK {
    final Intent AFKeystoreWrapper;

    public AFi1jSDK(Intent intent) {
        Intrinsics.checkNotNullParameter(intent, "");
        this.AFKeystoreWrapper = intent;
    }

    public final String AFKeystoreWrapper(final String str) {
        Intrinsics.checkNotNullParameter(str, "");
        Function0<String> function0 = new Function0<String>() {
            {
                super(0);
            }

            public final String invoke() {
                return AFi1jSDK.this.AFKeystoreWrapper.getStringExtra(str);
            }
        };
        StringBuilder sb = new StringBuilder("Error while trying to read ");
        sb.append(str);
        sb.append(" extra from intent");
        return (String) AFInAppEventParameterName(function0, sb.toString(), null, true);
    }

    public final boolean valueOf(final String str) {
        Intrinsics.checkNotNullParameter(str, "");
        Function0<Boolean> function0 = new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean invoke() {
                return Boolean.valueOf(AFi1jSDK.this.AFKeystoreWrapper.hasExtra(str));
            }
        };
        StringBuilder sb = new StringBuilder("Error while trying to check presence of ");
        sb.append(str);
        sb.append(" extra from intent");
        Boolean bool = (Boolean) AFInAppEventParameterName(function0, sb.toString(), Boolean.TRUE, true);
        if (bool != null) {
            return bool.booleanValue();
        }
        return true;
    }

    public final Intent AFInAppEventParameterName(final String str, final long j) {
        Intrinsics.checkNotNullParameter(str, "");
        Function0<Intent> function0 = new Function0<Intent>() {
            {
                super(0);
            }

            public final Intent invoke() {
                return AFi1jSDK.this.AFKeystoreWrapper.putExtra(str, j);
            }
        };
        StringBuilder sb = new StringBuilder("Error while trying to write ");
        sb.append(str);
        sb.append(" extra to intent");
        return (Intent) AFInAppEventParameterName(function0, sb.toString(), null, true);
    }

    public final <T> T AFInAppEventParameterName(Function0<? extends T> function0, String str, T t, boolean z) {
        Object obj;
        Object obj2;
        Object objAFInAppEventParameterName;
        KClass[] kClassArr;
        Throwable th;
        Object obj3;
        synchronized (this.AFKeystoreWrapper) {
            try {
                Result.Companion companion = Result.Companion;
                AFi1jSDK aFi1jSDK = this;
                obj = Result.constructor-impl(function0.invoke());
            } catch (Throwable th2) {
                Result.Companion companion2 = Result.Companion;
                obj = Result.constructor-impl(ResultKt.createFailure(th2));
            }
            KClass[] kClassArr2 = {Reflection.getOrCreateKotlinClass(ConcurrentModificationException.class), Reflection.getOrCreateKotlinClass(ArrayIndexOutOfBoundsException.class)};
            Throwable th3 = Result.exceptionOrNull-impl(obj);
            if (th3 == null) {
                kClassArr = new KClass[]{Reflection.getOrCreateKotlinClass(RuntimeException.class)};
                th = Result.exceptionOrNull-impl(obj);
                if (th != null) {
                    try {
                        Result.Companion companion3 = Result.Companion;
                        if (ArraysKt.contains(kClassArr, Reflection.getOrCreateKotlinClass(th.getClass()))) {
                            AFLogger.afErrorLog(str, th, false, false);
                            obj3 = Result.constructor-impl(t);
                            obj = (T) obj3;
                        } else {
                            throw th;
                        }
                    } catch (Throwable th4) {
                        Result.Companion companion4 = Result.Companion;
                        obj3 = Result.constructor-impl(ResultKt.createFailure(th4));
                    }
                }
                ResultKt.throwOnFailure(obj);
            } else {
                try {
                    Result.Companion companion5 = Result.Companion;
                    if (ArraysKt.contains(kClassArr2, Reflection.getOrCreateKotlinClass(th3.getClass()))) {
                        if (z) {
                            objAFInAppEventParameterName = AFInAppEventParameterName(function0, str, t, false);
                        } else {
                            AFLogger.afErrorLog(str, th3, false, false);
                            objAFInAppEventParameterName = t;
                        }
                        obj2 = Result.constructor-impl(objAFInAppEventParameterName);
                        obj = obj2;
                        kClassArr = new KClass[]{Reflection.getOrCreateKotlinClass(RuntimeException.class)};
                        th = Result.exceptionOrNull-impl(obj);
                        if (th != null) {
                            Result.Companion companion6 = Result.Companion;
                            if (ArraysKt.contains(kClassArr, Reflection.getOrCreateKotlinClass(th.getClass()))) {
                                AFLogger.afErrorLog(str, th, false, false);
                                obj3 = Result.constructor-impl(t);
                                obj = (T) obj3;
                            } else {
                                throw th;
                            }
                        }
                        ResultKt.throwOnFailure(obj);
                    } else {
                        throw th3;
                    }
                } catch (Throwable th5) {
                    Result.Companion companion7 = Result.Companion;
                    obj2 = Result.constructor-impl(ResultKt.createFailure(th5));
                }
            }
            throw th;
        }
        return (T) obj;
    }
}
