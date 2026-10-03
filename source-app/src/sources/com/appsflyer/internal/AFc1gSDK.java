package com.appsflyer.internal;

import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import com.appsflyer.AFLogger;
import com.facebook.applinks.AppLinkData;
import com.facebook.share.internal.ShareConstants;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.jvm.internal.Intrinsics;

public final class AFc1gSDK implements AFc1eSDK {
    private boolean AFInAppEventType;
    Map<String, Object> valueOf;
    private final AFd1lSDK values;

    public AFc1gSDK(AFd1lSDK aFd1lSDK) {
        Intrinsics.checkNotNullParameter(aFd1lSDK, "");
        this.values = aFd1lSDK;
    }

    private boolean AFInAppEventParameterName() {
        return this.AFInAppEventType;
    }

    @Override
    public final void valueOf(boolean z) {
        this.AFInAppEventType = z;
    }

    @Override
    public final Map<String, Object> valueOf() {
        return this.valueOf;
    }

    @Override
    public final void AFKeystoreWrapper() {
        Context context;
        if (AFInAppEventParameterName() && (context = this.values.AFInAppEventParameterName) != null) {
            this.valueOf = new LinkedHashMap();
            AFa1tSDK aFa1tSDK = new AFa1tSDK(System.currentTimeMillis());
            try {
                Class.forName("com.facebook.FacebookSdk").getMethod("sdkInitialize", Context.class).invoke(null, context);
                Class<?> cls = Class.forName("com.facebook.applinks.AppLinkData");
                Class<?> cls2 = Class.forName("com.facebook.applinks.AppLinkData$CompletionHandler");
                Method method = cls.getMethod("fetchDeferredAppLinkData", Context.class, String.class, cls2);
                Object objNewProxyInstance = Proxy.newProxyInstance(cls2.getClassLoader(), new Class[]{cls2}, new InvocationHandler() {
                    private Class AFInAppEventParameterName;
                    private AFa1uSDK values;

                    public C08324() {
                        cls = cls;
                        aFa1uSDK = aFa1tSDK;
                    }

                    @Override
                    public final Object invoke(Object obj, Method method2, Object[] objArr) throws Throwable {
                        String string;
                        String string2;
                        String string3;
                        Bundle bundle;
                        if (method2.getName().equals("onDeferredAppLinkDataFetched")) {
                            Object obj2 = objArr[0];
                            if (obj2 != null) {
                                Bundle bundle2 = (Bundle) Bundle.class.cast(cls.getMethod("getArgumentBundle", null).invoke(cls.cast(obj2), null));
                                if (bundle2 != null) {
                                    string2 = bundle2.getString(AppLinkData.ARGUMENTS_NATIVE_URL);
                                    string3 = bundle2.getString("target_url");
                                    Bundle bundle3 = bundle2.getBundle("extras");
                                    string = (bundle3 == null || (bundle = bundle3.getBundle(ShareConstants.DEEPLINK_CONTEXT)) == null) ? null : bundle.getString(ShareConstants.PROMO_CODE);
                                } else {
                                    string = null;
                                    string2 = null;
                                    string3 = null;
                                }
                                AFa1uSDK aFa1uSDK = aFa1uSDK;
                                if (aFa1uSDK != null) {
                                    aFa1uSDK.AFInAppEventType(string2, string3, string);
                                }
                            } else {
                                AFa1uSDK aFa1uSDK2 = aFa1uSDK;
                                if (aFa1uSDK2 != null) {
                                    aFa1uSDK2.AFInAppEventType(null, null, null);
                                }
                            }
                            return null;
                        }
                        AFa1uSDK aFa1uSDK3 = aFa1uSDK;
                        if (aFa1uSDK3 != null) {
                            aFa1uSDK3.AFInAppEventType("onDeferredAppLinkDataFetched invocation failed");
                        }
                        return null;
                    }
                });
                String string = context.getString(context.getResources().getIdentifier("facebook_app_id", TypedValues.Custom.S_STRING, context.getPackageName()));
                if (TextUtils.isEmpty(string)) {
                    aFa1tSDK.AFInAppEventType("Facebook app id not defined in resources");
                } else {
                    method.invoke(null, context, string, objNewProxyInstance);
                }
            } catch (ClassNotFoundException e) {
                AFLogger.afErrorLogForExcManagerOnly("FB class missing error", e);
                aFa1tSDK.AFInAppEventType(e.toString());
            } catch (IllegalAccessException e2) {
                AFLogger.afErrorLogForExcManagerOnly("FB illegal access", e2);
                aFa1tSDK.AFInAppEventType(e2.toString());
            } catch (NoSuchMethodException e3) {
                AFLogger.afErrorLogForExcManagerOnly("FB method missing error", e3);
                aFa1tSDK.AFInAppEventType(e3.toString());
            } catch (InvocationTargetException e4) {
                AFLogger.afErrorLogForExcManagerOnly("FB invocation error", e4);
                aFa1tSDK.AFInAppEventType(e4.toString());
            }
        }
    }

    public static final class AFa1tSDK implements AFa1qSDK.AFa1uSDK {
        private long valueOf;

        AFa1tSDK(long j) {
            this.valueOf = j;
        }

        @Override
        public final void AFInAppEventType(String str, String str2, String str3) {
            Map<String, Object> map;
            if (str != null) {
                AFLogger.afInfoLog("Facebook Deferred AppLink data received: ".concat(String.valueOf(str)));
                Map<String, Object> map2 = AFc1gSDK.this.valueOf;
                if (map2 != null) {
                    map2.put("link", str);
                }
                if (str2 != null && (map = AFc1gSDK.this.valueOf) != null) {
                    map.put("target_url", str2);
                }
                if (str3 != null) {
                    AFc1gSDK aFc1gSDK = AFc1gSDK.this;
                    LinkedHashMap linkedHashMap = new LinkedHashMap();
                    LinkedHashMap linkedHashMap2 = new LinkedHashMap();
                    linkedHashMap2.put(ShareConstants.PROMO_CODE, str3);
                    linkedHashMap.put(ShareConstants.DEEPLINK_CONTEXT, linkedHashMap2);
                    Map<String, Object> map3 = aFc1gSDK.valueOf;
                    if (map3 != null) {
                        map3.put("extras", linkedHashMap);
                    }
                }
            } else {
                Map<String, Object> map4 = AFc1gSDK.this.valueOf;
                if (map4 != null) {
                    map4.put("link", "");
                }
            }
            String strValueOf = String.valueOf(System.currentTimeMillis() - this.valueOf);
            Map<String, Object> map5 = AFc1gSDK.this.valueOf;
            if (map5 != null) {
                map5.put("ttr", strValueOf);
            }
        }

        @Override
        public final void AFInAppEventType(String str) {
            Map<String, Object> map = AFc1gSDK.this.valueOf;
            if (map != null) {
                map.put("error", str);
            }
        }
    }

    @Override
    public final boolean AFInAppEventType() {
        if (!AFInAppEventParameterName()) {
            return false;
        }
        Map<String, Object> map = this.valueOf;
        return map == null || map.isEmpty();
    }
}
