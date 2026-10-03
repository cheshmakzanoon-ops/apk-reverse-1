package zendesk.android.internal.p013di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import kotlinx.coroutines.CoroutineScope;

public final class ZendeskModule_MainScope$zendesk_zendesk_androidFactory implements Factory<CoroutineScope> {
    private final ZendeskModule module;

    public ZendeskModule_MainScope$zendesk_zendesk_androidFactory(ZendeskModule zendeskModule) {
        this.module = zendeskModule;
    }

    @Override
    public CoroutineScope get() {
        return mainScope$zendesk_zendesk_android(this.module);
    }

    public static ZendeskModule_MainScope$zendesk_zendesk_androidFactory create(ZendeskModule zendeskModule) {
        return new ZendeskModule_MainScope$zendesk_zendesk_androidFactory(zendeskModule);
    }

    public static CoroutineScope mainScope$zendesk_zendesk_android(ZendeskModule zendeskModule) {
        return (CoroutineScope) Preconditions.checkNotNullFromProvides(zendeskModule.getMainScope());
    }
}
