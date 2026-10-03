package com.appsflyer.internal;

import com.appsflyer.internal.platform_extension.PluginInfo;
import java.util.Map;

public interface AFi1xSDK {
    Map<String, Object> AFInAppEventType();

    void values(PluginInfo pluginInfo);
}
