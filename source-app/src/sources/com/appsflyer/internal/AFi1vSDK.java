package com.appsflyer.internal;

import com.appsflyer.internal.platform_extension.Plugin;
import com.appsflyer.internal.platform_extension.PluginInfo;
import com.facebook.internal.ServerProtocol;
import java.util.Map;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;

public final class AFi1vSDK implements AFi1xSDK {
    private PluginInfo values = new PluginInfo(Plugin.NATIVE, "6.13.0", null, 4, null);

    @Override
    public final void values(PluginInfo pluginInfo) {
        Intrinsics.checkNotNullParameter(pluginInfo, "");
        this.values = pluginInfo;
    }

    @Override
    public final Map<String, Object> AFInAppEventType() {
        Map<String, Object> mapMutableMapOf = MapsKt.mutableMapOf(new Pair[]{TuplesKt.to("platform", this.values.getPlugin().getPluginName()), TuplesKt.to(ServerProtocol.FALLBACK_DIALOG_PARAM_VERSION, this.values.getVersion())});
        if (!this.values.getAdditionalParams().isEmpty()) {
            mapMutableMapOf.put("extras", this.values.getAdditionalParams());
        }
        return mapMutableMapOf;
    }
}
