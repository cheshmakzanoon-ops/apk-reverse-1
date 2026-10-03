package com.facebook.internal.gatekeeper;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\r\n\u0002\b\u0004\u0018\u00002\u00020\u0001B\u0007¢\u0006\u0004\b\u0002\u0010\u0003J)\u0010\u000b\u001a\u00020\n2\f\b\u0002\u0010\u0006\u001a\u00060\u0004j\u0002`\u00052\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\b0\u0007¢\u0006\u0004\b\u000b\u0010\fJ#\u0010\r\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u00072\f\b\u0002\u0010\u0006\u001a\u00060\u0004j\u0002`\u0005¢\u0006\u0004\b\r\u0010\u000eJ+\u0010\u0012\u001a\u00020\u00102\f\b\u0002\u0010\u0006\u001a\u00060\u0004j\u0002`\u00052\u0006\u0010\u000f\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u0010¢\u0006\u0004\b\u0012\u0010\u0013J+\u0010\u0015\u001a\u00020\n2\f\b\u0002\u0010\u0006\u001a\u00060\u0004j\u0002`\u00052\u0006\u0010\u000f\u001a\u00020\u00042\u0006\u0010\u0014\u001a\u00020\u0010¢\u0006\u0004\b\u0015\u0010\u0016J%\u0010\u0017\u001a\u0004\u0018\u00010\b2\f\b\u0002\u0010\u0006\u001a\u00060\u0004j\u0002`\u00052\u0006\u0010\u000f\u001a\u00020\u0004¢\u0006\u0004\b\u0017\u0010\u0018J#\u0010\u001a\u001a\u00020\n2\f\b\u0002\u0010\u0006\u001a\u00060\u0004j\u0002`\u00052\u0006\u0010\u0019\u001a\u00020\b¢\u0006\u0004\b\u001a\u0010\u001bJ\u001b\u0010\u001c\u001a\u00020\n2\f\b\u0002\u0010\u0006\u001a\u00060\u0004j\u0002`\u0005¢\u0006\u0004\b\u001c\u0010\u001dR0\u0010\u001f\u001a\u001e\u0012\b\u0012\u00060\u0004j\u0002`\u0005\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\b0\u001e0\u001e8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u001f\u0010 ¨\u0006!"}, d2 = {"Lcom/facebook/internal/gatekeeper/GateKeeperRuntimeCache;", "", "<init>", "()V", "", "Lcom/facebook/internal/gatekeeper/AppID;", "appId", "", "Lcom/facebook/internal/gatekeeper/GateKeeper;", "gateKeeperList", "", "setGateKeepers", "(Ljava/lang/String;Ljava/util/List;)V", "dumpGateKeepers", "(Ljava/lang/String;)Ljava/util/List;", "name", "", "defaultValue", "getGateKeeperValue", "(Ljava/lang/String;Ljava/lang/String;Z)Z", SDKConstants.PARAM_VALUE, "setGateKeeperValue", "(Ljava/lang/String;Ljava/lang/String;Z)V", "getGateKeeper", "(Ljava/lang/String;Ljava/lang/String;)Lcom/facebook/internal/gatekeeper/GateKeeper;", "gateKeeper", "setGateKeeper", "(Ljava/lang/String;Lcom/facebook/internal/gatekeeper/GateKeeper;)V", "resetCache", "(Ljava/lang/String;)V", "j$/util/concurrent/ConcurrentHashMap", "gateKeepers", "Lj$/util/concurrent/ConcurrentHashMap;", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class GateKeeperRuntimeCache {
    private final ConcurrentHashMap<String, ConcurrentHashMap<String, GateKeeper>> gateKeepers = new ConcurrentHashMap<>();

    public static void setGateKeepers$default(GateKeeperRuntimeCache gateKeeperRuntimeCache, String str, List list, int i, Object obj) {
        if ((i & 1) != 0) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            str = FacebookSdk.getApplicationId();
        }
        gateKeeperRuntimeCache.setGateKeepers(str, list);
    }

    public final void setGateKeepers(String appId, List<GateKeeper> gateKeeperList) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(gateKeeperList, "gateKeeperList");
        Map concurrentHashMap = new ConcurrentHashMap();
        for (GateKeeper gateKeeper : gateKeeperList) {
            concurrentHashMap.put(gateKeeper.getName(), gateKeeper);
        }
        this.gateKeepers.put(appId, concurrentHashMap);
    }

    public static List dumpGateKeepers$default(GateKeeperRuntimeCache gateKeeperRuntimeCache, String str, int i, Object obj) {
        if ((i & 1) != 0) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            str = FacebookSdk.getApplicationId();
        }
        return gateKeeperRuntimeCache.dumpGateKeepers(str);
    }

    public final List<GateKeeper> dumpGateKeepers(String appId) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Map map = (ConcurrentHashMap) this.gateKeepers.get(appId);
        if (map == null) {
            return null;
        }
        Map map2 = map;
        ArrayList arrayList = new ArrayList(map2.size());
        Iterator it = map2.entrySet().iterator();
        while (it.hasNext()) {
            arrayList.add((GateKeeper) ((Map.Entry) it.next()).getValue());
        }
        return arrayList;
    }

    public static boolean getGateKeeperValue$default(GateKeeperRuntimeCache gateKeeperRuntimeCache, String str, String str2, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            str = FacebookSdk.getApplicationId();
        }
        return gateKeeperRuntimeCache.getGateKeeperValue(str, str2, z);
    }

    public final boolean getGateKeeperValue(String appId, String name, boolean defaultValue) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(name, "name");
        GateKeeper gateKeeper = getGateKeeper(appId, name);
        return gateKeeper == null ? defaultValue : gateKeeper.getValue();
    }

    public static void setGateKeeperValue$default(GateKeeperRuntimeCache gateKeeperRuntimeCache, String str, String str2, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            str = FacebookSdk.getApplicationId();
        }
        gateKeeperRuntimeCache.setGateKeeperValue(str, str2, z);
    }

    public final void setGateKeeperValue(String appId, String name, boolean value) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(name, "name");
        setGateKeeper(appId, new GateKeeper(name, value));
    }

    public static GateKeeper getGateKeeper$default(GateKeeperRuntimeCache gateKeeperRuntimeCache, String str, String str2, int i, Object obj) {
        if ((i & 1) != 0) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            str = FacebookSdk.getApplicationId();
        }
        return gateKeeperRuntimeCache.getGateKeeper(str, str2);
    }

    public final GateKeeper getGateKeeper(String appId, String name) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(name, "name");
        ConcurrentHashMap concurrentHashMap = (ConcurrentHashMap) this.gateKeepers.get(appId);
        if (concurrentHashMap == null) {
            return null;
        }
        return (GateKeeper) concurrentHashMap.get(name);
    }

    public static void setGateKeeper$default(GateKeeperRuntimeCache gateKeeperRuntimeCache, String str, GateKeeper gateKeeper, int i, Object obj) {
        if ((i & 1) != 0) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            str = FacebookSdk.getApplicationId();
        }
        gateKeeperRuntimeCache.setGateKeeper(str, gateKeeper);
    }

    public final void setGateKeeper(String appId, GateKeeper gateKeeper) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(gateKeeper, "gateKeeper");
        if (!this.gateKeepers.containsKey(appId)) {
            this.gateKeepers.put(appId, new ConcurrentHashMap());
        }
        Map map = (ConcurrentHashMap) this.gateKeepers.get(appId);
        if (map == null) {
            return;
        }
        map.put(gateKeeper.getName(), gateKeeper);
    }

    public static void resetCache$default(GateKeeperRuntimeCache gateKeeperRuntimeCache, String str, int i, Object obj) {
        if ((i & 1) != 0) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            str = FacebookSdk.getApplicationId();
        }
        gateKeeperRuntimeCache.resetCache(str);
    }

    public final void resetCache(String appId) {
        Intrinsics.checkNotNullParameter(appId, "appId");
        this.gateKeepers.remove(appId);
    }
}
