package com.appsflyer.internal.platform_extension;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.ServerProtocol;
import java.util.Map;
import kotlin.Metadata;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0011\b\u0086\b\u0018\u00002\u00020\u0001B/\b\u0007\u0012\u0006\u0010\u000b\u001a\u00020\u0002\u0012\u0006\u0010\f\u001a\u00020\u0005\u0012\u0014\b\u0002\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\b¢\u0006\u0004\b#\u0010$J\u0010\u0010\u0003\u001a\u00020\u0002HÇ\u0003¢\u0006\u0004\b\u0003\u0010\u0004J\u0010\u0010\u0006\u001a\u00020\u0005HÇ\u0003¢\u0006\u0004\b\u0006\u0010\u0007J\u001c\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\bHÇ\u0003¢\u0006\u0004\b\t\u0010\nJ:\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u000b\u001a\u00020\u00022\b\b\u0002\u0010\f\u001a\u00020\u00052\u0014\b\u0002\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\bHÇ\u0001¢\u0006\u0004\b\u000e\u0010\u000fJ\u001a\u0010\u0011\u001a\u00020\u00102\b\u0010\u000b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u0011\u0010\u0012J\u0010\u0010\u0014\u001a\u00020\u0013HÖ\u0001¢\u0006\u0004\b\u0014\u0010\u0015J\u0010\u0010\u0016\u001a\u00020\u0005H×\u0001¢\u0006\u0004\b\u0016\u0010\u0007R&\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\b8\u0007X\u0087\u0004¢\u0006\f\n\u0004\b\u0017\u0010\u0018\u001a\u0004\b\u0019\u0010\nR\u001a\u0010\u001e\u001a\u00020\u00028\u0007X\u0087\u0004¢\u0006\f\n\u0004\b\u001b\u0010\u001c\u001a\u0004\b\u001d\u0010\u0004R\u001a\u0010\"\u001a\u00020\u00058\u0007X\u0087\u0004¢\u0006\f\n\u0004\b\u001f\u0010 \u001a\u0004\b!\u0010\u0007"}, d2 = {"Lcom/appsflyer/internal/platform_extension/PluginInfo;", "", "Lcom/appsflyer/internal/platform_extension/Plugin;", "component1", "()Lcom/appsflyer/internal/platform_extension/Plugin;", "", "component2", "()Ljava/lang/String;", "", "component3", "()Ljava/util/Map;", "p0", "p1", "p2", "copy", "(Lcom/appsflyer/internal/platform_extension/Plugin;Ljava/lang/String;Ljava/util/Map;)Lcom/appsflyer/internal/platform_extension/PluginInfo;", "", "equals", "(Ljava/lang/Object;)Z", "", "hashCode", "()I", "toString", "AFInAppEventType", "Ljava/util/Map;", "getAdditionalParams", "additionalParams", "values", "Lcom/appsflyer/internal/platform_extension/Plugin;", "getPlugin", "plugin", "AFInAppEventParameterName", "Ljava/lang/String;", "getVersion", ServerProtocol.FALLBACK_DIALOG_PARAM_VERSION, "<init>", "(Lcom/appsflyer/internal/platform_extension/Plugin;Ljava/lang/String;Ljava/util/Map;)V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class PluginInfo {

    private final String version;

    private final Map<String, String> additionalParams;

    private final Plugin plugin;

    public PluginInfo(Plugin plugin, String str) {
        this(plugin, str, null, 4, null);
        Intrinsics.checkNotNullParameter(plugin, "");
        Intrinsics.checkNotNullParameter(str, "");
    }

    public static PluginInfo copy$default(PluginInfo pluginInfo, Plugin plugin, String str, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            plugin = pluginInfo.plugin;
        }
        if ((i & 2) != 0) {
            str = pluginInfo.version;
        }
        if ((i & 4) != 0) {
            map = pluginInfo.additionalParams;
        }
        return pluginInfo.copy(plugin, str, map);
    }

    public final Plugin getPlugin() {
        return this.plugin;
    }

    public final String getVersion() {
        return this.version;
    }

    public final Map<String, String> component3() {
        return this.additionalParams;
    }

    public final PluginInfo copy(Plugin p0, String p1, Map<String, String> p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        Intrinsics.checkNotNullParameter(p2, "");
        return new PluginInfo(p0, p1, p2);
    }

    public final boolean equals(Object p0) {
        if (this == p0) {
            return true;
        }
        if (!(p0 instanceof PluginInfo)) {
            return false;
        }
        PluginInfo pluginInfo = (PluginInfo) p0;
        return this.plugin == pluginInfo.plugin && Intrinsics.areEqual(this.version, pluginInfo.version) && Intrinsics.areEqual(this.additionalParams, pluginInfo.additionalParams);
    }

    public final int hashCode() {
        return (((this.plugin.hashCode() * 31) + this.version.hashCode()) * 31) + this.additionalParams.hashCode();
    }

    public final String toString() {
        StringBuilder sb = new StringBuilder("PluginInfo(plugin=");
        sb.append(this.plugin);
        sb.append(", version=");
        sb.append(this.version);
        sb.append(", additionalParams=");
        sb.append(this.additionalParams);
        sb.append(')');
        return sb.toString();
    }

    public PluginInfo(Plugin plugin, String str, Map<String, String> map) {
        Intrinsics.checkNotNullParameter(plugin, "");
        Intrinsics.checkNotNullParameter(str, "");
        Intrinsics.checkNotNullParameter(map, "");
        this.plugin = plugin;
        this.version = str;
        this.additionalParams = map;
    }

    public final Plugin getPlugin() {
        return this.plugin;
    }

    public final String getVersion() {
        return this.version;
    }

    public PluginInfo(Plugin plugin, String str, Map map, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(plugin, str, (i & 4) != 0 ? MapsKt.emptyMap() : map);
    }

    public final Map<String, String> getAdditionalParams() {
        return this.additionalParams;
    }
}
