package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.ThinkingAnalyticsSDK;
import cn.thinkingdata.android.utils.TDLog;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.HashSet;
import java.util.Iterator;
import org.json.JSONObject;

public class IronSourceSyncData extends AbstractSyncThirdData {
    private final ThinkingAnalyticsSDK mThinkingSdk;

    public IronSourceSyncData(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
        this.mThinkingSdk = thinkingAnalyticsSDK;
    }

    @Override
    public void syncThirdPartyData() {
        TDLog.m679d("ThinkingAnalytics.SyncData", "开始同步IronSource数据");
        if (checkHasAddListener()) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "IronSource数据已同步，无需重复调用");
            return;
        }
        try {
            Class<?> cls = Class.forName("com.ironsource.mediationsdk.IronSource");
            Class<?> cls2 = Class.forName("com.ironsource.mediationsdk.impressionData.ImpressionDataListener");
            cls.getMethod("addImpressionDataListener", cls2).invoke(null, Proxy.newProxyInstance(cls.getClassLoader(), new Class[]{cls2}, new InvocationHandler() {
                @Override
                public Object invoke(Object obj, Method method, Object[] objArr) throws Throwable {
                    if ("onImpressionSuccess".equals(method.getName()) && objArr != null && objArr.length == 1) {
                        try {
                            Object objInvoke = Class.forName("com.ironsource.mediationsdk.impressionData.ImpressionData").getMethod("getAllData", null).invoke(objArr[0], null);
                            if (objInvoke instanceof JSONObject) {
                                JSONObject jSONObject = (JSONObject) objInvoke;
                                if (IronSourceSyncData.this.mThinkingSdk != null) {
                                    IronSourceSyncData.this.mThinkingSdk.track(TAThirdConstants.IRON_SOURCE_EVENT_NAME, jSONObject);
                                }
                            }
                        } catch (Exception unused) {
                        }
                    }
                    return 0;
                }
            }));
            TDLog.m680e("ThinkingAnalytics.SyncData", "IronSource数据同步成功");
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "IronSource数据同步异常:" + e.getMessage());
        }
    }

    private boolean checkHasAddListener() {
        try {
            Class<?> cls = Class.forName("com.ironsource.mediationsdk.IronsourceObjectPublisherDataHolder");
            Object objInvoke = cls.getMethod("getImpressionDataListeners", null).invoke(cls.getMethod("getInstance", null).invoke(null, null), null);
            if (!(objInvoke instanceof HashSet)) {
                return false;
            }
            Iterator it = ((HashSet) objInvoke).iterator();
            while (it.hasNext()) {
                if (it.next().getClass().getName().startsWith("$Proxy")) {
                    return true;
                }
            }
            return false;
        } catch (Exception unused) {
            return false;
        }
    }
}
