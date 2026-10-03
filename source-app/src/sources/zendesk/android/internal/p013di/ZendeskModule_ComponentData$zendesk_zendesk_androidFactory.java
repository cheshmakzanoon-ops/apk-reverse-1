package zendesk.android.internal.p013di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;

public final class ZendeskModule_ComponentData$zendesk_zendesk_androidFactory implements Factory<ZendeskComponentConfig> {
    private final ZendeskModule module;

    public ZendeskModule_ComponentData$zendesk_zendesk_androidFactory(ZendeskModule zendeskModule) {
        this.module = zendeskModule;
    }

    @Override
    public ZendeskComponentConfig get() {
        return componentData$zendesk_zendesk_android(this.module);
    }

    public static ZendeskModule_ComponentData$zendesk_zendesk_androidFactory create(ZendeskModule zendeskModule) {
        return new ZendeskModule_ComponentData$zendesk_zendesk_androidFactory(zendeskModule);
    }

    public static ZendeskComponentConfig componentData$zendesk_zendesk_android(ZendeskModule zendeskModule) {
        return (ZendeskComponentConfig) Preconditions.checkNotNullFromProvides(zendeskModule.getComponentConfig());
    }
}
