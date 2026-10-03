package com.appsflyer.internal;

import android.os.Build;
import android.view.KeyEvent;
import com.appsflyer.AFLogger;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.internal.ServerProtocol;
import com.gme.trtc.hardwareearmonitor.honor.HonorResultCode;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Charsets;
import org.json.JSONObject;

public final class AFd1fSDK implements AFd1iSDK {
    private static int $10 = 0;
    private static int $11 = 1;
    private static long afInfoLog = 157669476547063524L;
    private static int force = 0;

    private static int f318v = 1;
    private final Lazy AFInAppEventParameterName;
    private AFd1nSDK AFInAppEventType;
    private final Lazy AFKeystoreWrapper;
    private final Lazy AFLogger;

    private final Lazy f319d;

    private final Lazy f320e;
    private final String registerClient;
    private AFd1iSDK.AFa1zSDK unregisterClient;
    private final Lazy valueOf;
    private final Lazy values;

    public AFd1fSDK(AFd1nSDK aFd1nSDK) {
        Intrinsics.checkNotNullParameter(aFd1nSDK, "");
        this.AFInAppEventType = aFd1nSDK;
        this.AFKeystoreWrapper = LazyKt.lazy(new Function0<AFf1eSDK>() {
            {
                super(0);
            }

            public final AFf1eSDK invoke() {
                AFf1eSDK aFf1eSDKMo784e = AFd1fSDK.values(AFd1fSDK.this).mo784e();
                Intrinsics.checkNotNullExpressionValue(aFf1eSDKMo784e, "");
                return aFf1eSDKMo784e;
            }
        });
        this.AFInAppEventParameterName = LazyKt.lazy(new Function0<AFd1rSDK>() {
            {
                super(0);
            }

            public final AFd1rSDK invoke() {
                AFd1rSDK aFd1rSDKAFInAppEventType = AFd1fSDK.values(AFd1fSDK.this).AFInAppEventType();
                Intrinsics.checkNotNullExpressionValue(aFd1rSDKAFInAppEventType, "");
                return aFd1rSDKAFInAppEventType;
            }
        });
        this.valueOf = LazyKt.lazy(new Function0<AFd1xSDK>() {
            {
                super(0);
            }

            public final AFd1xSDK invoke() {
                AFd1xSDK aFd1xSDKAFKeystoreWrapper = AFd1fSDK.values(AFd1fSDK.this).AFKeystoreWrapper();
                Intrinsics.checkNotNullExpressionValue(aFd1xSDKAFKeystoreWrapper, "");
                return aFd1xSDKAFKeystoreWrapper;
            }
        });
        this.values = LazyKt.lazy(new Function0<AFg1zSDK>() {
            {
                super(0);
            }

            public final AFg1zSDK invoke() {
                AFg1zSDK aFg1zSDKMo785i = AFd1fSDK.values(AFd1fSDK.this).mo785i();
                Intrinsics.checkNotNullExpressionValue(aFg1zSDKMo785i, "");
                return aFg1zSDKMo785i;
            }
        });
        this.AFLogger = LazyKt.lazy(new Function0<ExecutorService>() {
            {
                super(0);
            }

            public final ExecutorService invoke() {
                ExecutorService executorServiceValues = AFd1fSDK.values(AFd1fSDK.this).values();
                Intrinsics.checkNotNullExpressionValue(executorServiceValues, "");
                return executorServiceValues;
            }
        });
        this.registerClient = "6.13.0";
        this.f319d = LazyKt.lazy(new Function0<AFd1hSDK>() {
            {
                super(0);
            }

            public final AFd1hSDK invoke() {
                AFd1lSDK aFd1lSDKMo786v = AFd1fSDK.values(AFd1fSDK.this).mo786v();
                Intrinsics.checkNotNullExpressionValue(aFd1lSDKMo786v, "");
                return new AFd1hSDK(aFd1lSDKMo786v);
            }
        });
        this.f320e = LazyKt.lazy(new Function0<AFd1dSDK>() {
            {
                super(0);
            }

            public final AFd1dSDK invoke() {
                return new AFd1dSDK(AFd1fSDK.this.AFInAppEventParameterName());
            }
        });
    }

    public static final AFd1nSDK values(AFd1fSDK aFd1fSDK) {
        int i = 2 % 2;
        int i2 = force + 73;
        f318v = i2 % 128;
        int i3 = i2 % 2;
        AFd1nSDK aFd1nSDK = aFd1fSDK.AFInAppEventType;
        if (i3 != 0) {
            return aFd1nSDK;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private final AFf1eSDK valueOf() {
        int i = 2 % 2;
        int i2 = f318v + 17;
        force = i2 % 128;
        int i3 = i2 % 2;
        AFf1eSDK aFf1eSDK = (AFf1eSDK) this.AFKeystoreWrapper.getValue();
        int i4 = f318v + 39;
        force = i4 % 128;
        if (i4 % 2 == 0) {
            return aFf1eSDK;
        }
        throw null;
    }

    private final AFd1rSDK AFInAppEventType() {
        int i = 2 % 2;
        int i2 = f318v + 57;
        force = i2 % 128;
        int i3 = i2 % 2;
        AFd1rSDK aFd1rSDK = (AFd1rSDK) this.AFInAppEventParameterName.getValue();
        int i4 = force + 87;
        f318v = i4 % 128;
        int i5 = i4 % 2;
        return aFd1rSDK;
    }

    private final AFd1xSDK m779d() {
        int i = 2 % 2;
        int i2 = force + 49;
        f318v = i2 % 128;
        if (i2 % 2 == 0) {
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        AFd1xSDK aFd1xSDK = (AFd1xSDK) this.valueOf.getValue();
        int i3 = f318v + 7;
        force = i3 % 128;
        if (i3 % 2 != 0) {
            int i4 = 66 / 0;
        }
        return aFd1xSDK;
    }

    private final AFg1zSDK m780e() {
        int i = 2 % 2;
        int i2 = force + 85;
        f318v = i2 % 128;
        int i3 = i2 % 2;
        AFg1zSDK aFg1zSDK = (AFg1zSDK) this.values.getValue();
        int i4 = force + 121;
        f318v = i4 % 128;
        int i5 = i4 % 2;
        return aFg1zSDK;
    }

    private final ExecutorService AFLogger() {
        int i = 2 % 2;
        int i2 = f318v + 39;
        force = i2 % 128;
        if (i2 % 2 != 0) {
            throw null;
        }
        ExecutorService executorService = (ExecutorService) this.AFLogger.getValue();
        int i3 = f318v + 121;
        force = i3 % 128;
        int i4 = i3 % 2;
        return executorService;
    }

    public final AFd1gSDK AFInAppEventParameterName() {
        int i = 2 % 2;
        int i2 = force + 31;
        f318v = i2 % 128;
        int i3 = i2 % 2;
        AFd1gSDK aFd1gSDK = (AFd1gSDK) this.f319d.getValue();
        if (i3 != 0) {
            return aFd1gSDK;
        }
        throw null;
    }

    private AFd1jSDK unregisterClient() {
        int i = 2 % 2;
        int i2 = f318v + 77;
        force = i2 % 128;
        int i3 = i2 % 2;
        AFd1jSDK aFd1jSDK = (AFd1jSDK) this.f320e.getValue();
        int i4 = f318v + 11;
        force = i4 % 128;
        if (i4 % 2 == 0) {
            return aFd1jSDK;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    @Override
    public final void values(final Throwable th, final String str) {
        int i = 2 % 2;
        int i2 = force + 89;
        f318v = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(th, "");
        Intrinsics.checkNotNullParameter(str, "");
        AFLogger().execute(new Runnable() {
            @Override
            public final void run() {
                AFd1fSDK.values(this.f$0, th, str);
            }
        });
        int i4 = f318v + 69;
        force = i4 % 128;
        int i5 = i4 % 2;
    }

    public static final void values(AFd1fSDK aFd1fSDK, Throwable th, String str) {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(aFd1fSDK, "");
        Intrinsics.checkNotNullParameter(th, "");
        Intrinsics.checkNotNullParameter(str, "");
        AFh1lSDK aFh1lSDKRegisterClient = aFd1fSDK.registerClient();
        boolean z = false;
        if (aFh1lSDKRegisterClient != null) {
            int i2 = force + 65;
            f318v = i2 % 128;
            int i3 = i2 % 2;
            if (aFd1fSDK.AFInAppEventType(aFh1lSDKRegisterClient)) {
                z = true;
            }
        } else {
            int i4 = force + 13;
            f318v = i4 % 128;
            int i5 = i4 % 2;
        }
        if (!(!z)) {
            int i6 = f318v + 109;
            force = i6 % 128;
            int i7 = i6 % 2;
            aFd1fSDK.AFInAppEventParameterName().values(th, str);
            if (i7 == 0) {
                return;
            }
            Object obj = null;
            obj.hashCode();
            throw null;
        }
    }

    @Override
    public final void valueOf(AFd1iSDK.AFa1zSDK aFa1zSDK) {
        int i = 2 % 2;
        int i2 = force + 31;
        f318v = i2 % 128;
        if (i2 % 2 == 0) {
            this.unregisterClient = aFa1zSDK;
            AFLogger().execute(new Runnable() {
                @Override
                public final void run() {
                    AFd1fSDK.valueOf(this.f$0);
                }
            });
            int i3 = 85 / 0;
        } else {
            this.unregisterClient = aFa1zSDK;
            AFLogger().execute(new Runnable() {
                @Override
                public final void run() {
                    AFd1fSDK.valueOf(this.f$0);
                }
            });
        }
    }

    public static final void valueOf(AFd1fSDK aFd1fSDK) {
        int i = 2 % 2;
        int i2 = force + 25;
        f318v = i2 % 128;
        if (i2 % 2 == 0) {
            Intrinsics.checkNotNullParameter(aFd1fSDK, "");
            aFd1fSDK.m781i();
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        Intrinsics.checkNotNullParameter(aFd1fSDK, "");
        aFd1fSDK.m781i();
        int i3 = force + 105;
        f318v = i3 % 128;
        int i4 = i3 % 2;
    }

    @Override
    public final void values() {
        int i = 2 % 2;
        int i2 = f318v + 49;
        force = i2 % 128;
        if (i2 % 2 != 0) {
            AFLogger().execute(new Runnable() {
                @Override
                public final void run() {
                    AFd1fSDK.AFKeystoreWrapper(this.f$0);
                }
            });
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        AFLogger().execute(new Runnable() {
            @Override
            public final void run() {
                AFd1fSDK.AFKeystoreWrapper(this.f$0);
            }
        });
        int i3 = f318v + 37;
        force = i3 % 128;
        int i4 = i3 % 2;
    }

    public static final void AFKeystoreWrapper(AFd1fSDK aFd1fSDK) {
        int i = 2 % 2;
        int i2 = force + 35;
        f318v = i2 % 128;
        if (i2 % 2 != 0) {
            Intrinsics.checkNotNullParameter(aFd1fSDK, "");
            aFd1fSDK.afInfoLog();
        } else {
            Intrinsics.checkNotNullParameter(aFd1fSDK, "");
            aFd1fSDK.afInfoLog();
            int i3 = 66 / 0;
        }
    }

    @Override
    public final void AFKeystoreWrapper() {
        int i = 2 % 2;
        int i2 = f318v + 91;
        force = i2 % 128;
        int i3 = i2 % 2;
        AFLogger().execute(new Runnable() {
            @Override
            public final void run() {
                AFd1fSDK.AFInAppEventType(this.f$0);
            }
        });
        int i4 = force + 31;
        f318v = i4 % 128;
        if (i4 % 2 == 0) {
            int i5 = 66 / 0;
        }
    }

    public static final void AFInAppEventType(AFd1fSDK aFd1fSDK) {
        int i = 2 % 2;
        int i2 = f318v + 117;
        force = i2 % 128;
        if (i2 % 2 == 0) {
            Intrinsics.checkNotNullParameter(aFd1fSDK, "");
            aFd1fSDK.m782w();
        } else {
            Intrinsics.checkNotNullParameter(aFd1fSDK, "");
            aFd1fSDK.m782w();
            Object obj = null;
            obj.hashCode();
            throw null;
        }
    }

    private final synchronized void m781i() {
        throw new UnsupportedOperationException("Method not decompiled: com.appsflyer.internal.AFd1fSDK.m781i():void");
    }

    private final void afInfoLog() {
        int i = 2 % 2;
        int i2 = force + 35;
        f318v = i2 % 128;
        Object obj = null;
        if (i2 % 2 == 0) {
            registerClient();
            obj.hashCode();
            throw null;
        }
        AFh1lSDK aFh1lSDKRegisterClient = registerClient();
        if (aFh1lSDKRegisterClient != null) {
            if (!valueOf(aFh1lSDKRegisterClient)) {
                AFg1mSDK.v$default(AFLogger.INSTANCE, AFg1hSDK.EXCEPTION_MANAGER, "skipping", false, 4, null);
                return;
            }
            int i3 = f318v + 11;
            force = i3 % 128;
            if (i3 % 2 != 0) {
                String str = m780e().registerClient;
                throw null;
            }
            String str2 = m780e().registerClient;
            if (str2 != null) {
                String string = new JSONObject(valueOf(AFKeystoreWrapper(aFh1lSDKRegisterClient), AFInAppEventParameterName().AFInAppEventParameterName())).toString();
                Intrinsics.checkNotNullExpressionValue(string, "");
                Intrinsics.checkNotNullExpressionValue(str2, "");
                values(string, str2);
            }
        }
    }

    private final synchronized void m782w() {
        boolean zAFInAppEventType;
        int i = 2 % 2;
        int i2 = force + 33;
        f318v = i2 % 128;
        int i3 = i2 % 2;
        AFh1lSDK aFh1lSDKRegisterClient = registerClient();
        if (aFh1lSDKRegisterClient != null) {
            if (aFh1lSDKRegisterClient.AFInAppEventType == -1) {
                m779d().AFKeystoreWrapper("af_send_exc_to_server_window");
            } else if (m779d().AFInAppEventType("af_send_exc_to_server_window", -1L) == -1) {
                int i4 = f318v + 81;
                force = i4 % 128;
                if (i4 % 2 != 0) {
                    AFInAppEventParameterName(aFh1lSDKRegisterClient);
                    Object obj = null;
                    obj.hashCode();
                    throw null;
                }
                AFInAppEventParameterName(aFh1lSDKRegisterClient);
                int i5 = 2 % 2;
            }
            zAFInAppEventType = AFInAppEventType(aFh1lSDKRegisterClient);
        } else {
            zAFInAppEventType = false;
        }
        AFd1iSDK.AFa1zSDK aFa1zSDK = this.unregisterClient;
        if (aFa1zSDK != null) {
            aFa1zSDK.onConfigurationChanged(zAFInAppEventType);
            int i6 = f318v + 1;
            force = i6 % 128;
            int i7 = i6 % 2;
        }
    }

    private final void AFInAppEventParameterName(AFh1lSDK aFh1lSDK) {
        int i;
        long jCurrentTimeMillis;
        int i2 = 2 % 2;
        int i3 = f318v + 67;
        force = i3 % 128;
        if (i3 % 2 != 0) {
            i = aFh1lSDK.valueOf;
            jCurrentTimeMillis = System.currentTimeMillis() / TimeUnit.DAYS.toMillis(aFh1lSDK.AFInAppEventType);
        } else {
            i = aFh1lSDK.valueOf;
            jCurrentTimeMillis = System.currentTimeMillis() + TimeUnit.DAYS.toMillis(aFh1lSDK.AFInAppEventType);
        }
        AFd1xSDK aFd1xSDKM779d = m779d();
        aFd1xSDKM779d.AFInAppEventParameterName("af_send_exc_to_server_window", jCurrentTimeMillis);
        aFd1xSDKM779d.AFInAppEventParameterName("af_send_exc_min", i);
        int i4 = force + 5;
        f318v = i4 % 128;
        if (i4 % 2 != 0) {
            return;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private final Map<String, String> AFKeystoreWrapper(AFh1lSDK aFh1lSDK) {
        int i = 2 % 2;
        Object[] objArr = new Object[1];
        m778a("읋\uf0aaꢪ悔ᢉ", KeyEvent.keyCodeFromString("") + 14321, objArr);
        AFd1rSDK aFd1rSDKAFInAppEventType = AFInAppEventType();
        Map<String, String> mapMapOf = MapsKt.mapOf(new Pair[]{TuplesKt.to(((String) objArr[0]).intern(), Build.BRAND), TuplesKt.to(DeviceRequestsHelper.DEVICE_INFO_MODEL, Build.MODEL), TuplesKt.to("app_id", AFInAppEventType().AFKeystoreWrapper.AFInAppEventParameterName.getPackageName()), TuplesKt.to("p_ex", new AFb1gSDK().AFInAppEventType()), TuplesKt.to("api", String.valueOf(Build.VERSION.SDK_INT)), TuplesKt.to(ServerProtocol.DIALOG_PARAM_SDK_VERSION, this.registerClient), TuplesKt.to("uid", AFb1lSDK.values(aFd1rSDKAFInAppEventType.AFKeystoreWrapper, aFd1rSDKAFInAppEventType.AFInAppEventParameterName)), TuplesKt.to("exc_config", aFh1lSDK.AFInAppEventType())});
        int i2 = f318v + 99;
        force = i2 % 128;
        if (i2 % 2 == 0) {
            return mapMapOf;
        }
        throw null;
    }

    private static Map<String, Object> valueOf(Map<String, ? extends Object> map, List<AFd1oSDK> list) {
        int i = 2 % 2;
        int i2 = f318v + 115;
        force = i2 % 128;
        int i3 = i2 % 2;
        Map<String, Object> mapMapOf = MapsKt.mapOf(new Pair[]{TuplesKt.to("deviceInfo", map), TuplesKt.to("excs", AFd1eSDK.values(list))});
        int i4 = f318v + 97;
        force = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 33 / 0;
        }
        return mapMapOf;
    }

    private final boolean valueOf(AFh1lSDK aFh1lSDK) {
        int iValueOf;
        int i = 2 % 2;
        int i2 = force + 85;
        f318v = i2 % 128;
        int i3 = i2 % 2;
        long jCurrentTimeMillis = System.currentTimeMillis();
        long jAFInAppEventType = m779d().AFInAppEventType("af_send_exc_to_server_window", -1L);
        if (aFh1lSDK.AFKeystoreWrapper >= TimeUnit.MILLISECONDS.toSeconds(jCurrentTimeMillis) && jAFInAppEventType != -1 && jAFInAppEventType >= jCurrentTimeMillis && (iValueOf = m779d().valueOf("af_send_exc_min", -1)) != -1) {
            int i4 = f318v + 89;
            force = i4 % 128;
            int i5 = i4 % 2;
            if (AFInAppEventParameterName().valueOf() >= iValueOf) {
                return values(aFh1lSDK);
            }
        }
        return false;
    }

    private final boolean AFInAppEventType(AFh1lSDK aFh1lSDK) {
        int i = 2 % 2;
        int i2 = f318v + 25;
        force = i2 % 128;
        int i3 = i2 % 2;
        long jCurrentTimeMillis = System.currentTimeMillis();
        long jAFInAppEventType = m779d().AFInAppEventType("af_send_exc_to_server_window", -1L);
        if (aFh1lSDK.AFKeystoreWrapper < TimeUnit.MILLISECONDS.toSeconds(jCurrentTimeMillis)) {
            return false;
        }
        if (jAFInAppEventType != -1 && jAFInAppEventType >= jCurrentTimeMillis) {
            return values(aFh1lSDK);
        }
        int i4 = force + 89;
        f318v = i4 % 128;
        if (i4 % 2 != 0) {
            return false;
        }
        throw null;
    }

    private final boolean values(AFh1lSDK aFh1lSDK) {
        int i = 2 % 2;
        new AFd1cSDK();
        String str = this.registerClient;
        String str2 = aFh1lSDK.values;
        Intrinsics.checkNotNullExpressionValue(str2, "");
        boolean zAFInAppEventType = AFd1cSDK.AFInAppEventType(str, str2);
        int i2 = f318v + 57;
        force = i2 % 128;
        int i3 = i2 % 2;
        return zAFInAppEventType;
    }

    private final AFh1lSDK registerClient() {
        AFh1mSDK aFh1mSDK;
        int i = 2 % 2;
        int i2 = force + 67;
        f318v = i2 % 128;
        int i3 = i2 % 2;
        AFh1nSDK aFh1nSDK = valueOf().valueOf.AFInAppEventType;
        if (aFh1nSDK == null || (aFh1mSDK = aFh1nSDK.AFInAppEventType) == null) {
            return null;
        }
        AFh1lSDK aFh1lSDK = aFh1mSDK.valueOf;
        int i4 = force + 53;
        f318v = i4 % 128;
        int i5 = i4 % 2;
        return aFh1lSDK;
    }

    private final void values(String str, String str2) {
        int i = 2 % 2;
        int i2 = f318v + 39;
        force = i2 % 128;
        int i3 = i2 % 2;
        byte[] bytes = str.getBytes(Charsets.UTF_8);
        Intrinsics.checkNotNullExpressionValue(bytes, "");
        unregisterClient().AFKeystoreWrapper(bytes, MapsKt.mapOf(TuplesKt.to("Authorization", AFb1mSDK.AFInAppEventParameterName(str, str2))), HonorResultCode.ADVANCED_RECORD_SUCCESS);
        int i4 = force + 69;
        f318v = i4 % 128;
        if (i4 % 2 == 0) {
            throw null;
        }
    }

    private static void m778a(String str, int i, Object[] objArr) {
        int i2 = 2 % 2;
        int i3 = $11 + 37;
        $10 = i3 % 128;
        Object charArray = str;
        if (i3 % 2 != 0) {
            int i4 = 36 / 0;
            if (str != null) {
                charArray = str;
                charArray = str.toCharArray();
            }
        } else if (str != null) {
            charArray = str;
            charArray = str.toCharArray();
        }
        charArray = str;
        char[] cArr = (char[]) charArray;
        AFj1mSDK aFj1mSDK = new AFj1mSDK();
        aFj1mSDK.AFInAppEventType = i;
        int length = cArr.length;
        long[] jArr = new long[length];
        aFj1mSDK.valueOf = 0;
        while (aFj1mSDK.valueOf < cArr.length) {
            jArr[aFj1mSDK.valueOf] = (((long) cArr[aFj1mSDK.valueOf]) ^ (((long) aFj1mSDK.valueOf) * ((long) aFj1mSDK.AFInAppEventType))) ^ (afInfoLog ^ (-6248676346930026035L));
            aFj1mSDK.valueOf++;
            int i5 = $11 + 49;
            $10 = i5 % 128;
            int i6 = i5 % 2;
        }
        char[] cArr2 = new char[length];
        aFj1mSDK.valueOf = 0;
        while (aFj1mSDK.valueOf < cArr.length) {
            cArr2[aFj1mSDK.valueOf] = (char) jArr[aFj1mSDK.valueOf];
            aFj1mSDK.valueOf++;
        }
        String str2 = new String(cArr2);
        int i7 = $10 + 27;
        $11 = i7 % 128;
        if (i7 % 2 == 0) {
            throw null;
        }
        objArr[0] = str2;
    }
}
