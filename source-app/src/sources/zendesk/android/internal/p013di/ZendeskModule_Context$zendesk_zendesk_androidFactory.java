package zendesk.android.internal.p013di;

import android.content.Context;
import dagger.internal.Factory;
import dagger.internal.Preconditions;

public final class ZendeskModule_Context$zendesk_zendesk_androidFactory implements Factory<Context> {
    private final ZendeskModule module;

    public ZendeskModule_Context$zendesk_zendesk_androidFactory(ZendeskModule zendeskModule) {
        this.module = zendeskModule;
    }

    @Override
    public Context get() {
        return context$zendesk_zendesk_android(this.module);
    }

    public static ZendeskModule_Context$zendesk_zendesk_androidFactory create(ZendeskModule zendeskModule) {
        return new ZendeskModule_Context$zendesk_zendesk_androidFactory(zendeskModule);
    }

    public static Context context$zendesk_zendesk_android(ZendeskModule zendeskModule) {
        return (Context) Preconditions.checkNotNullFromProvides(zendeskModule.getContext());
    }
}
