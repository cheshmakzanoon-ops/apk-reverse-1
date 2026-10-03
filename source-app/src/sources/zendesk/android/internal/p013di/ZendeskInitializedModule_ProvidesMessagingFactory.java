package zendesk.android.internal.p013di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import zendesk.android.messaging.Messaging;

public final class ZendeskInitializedModule_ProvidesMessagingFactory implements Factory<Messaging> {
    private final ZendeskInitializedModule module;

    public ZendeskInitializedModule_ProvidesMessagingFactory(ZendeskInitializedModule zendeskInitializedModule) {
        this.module = zendeskInitializedModule;
    }

    @Override
    public Messaging get() {
        return providesMessaging(this.module);
    }

    public static ZendeskInitializedModule_ProvidesMessagingFactory create(ZendeskInitializedModule zendeskInitializedModule) {
        return new ZendeskInitializedModule_ProvidesMessagingFactory(zendeskInitializedModule);
    }

    public static Messaging providesMessaging(ZendeskInitializedModule zendeskInitializedModule) {
        return (Messaging) Preconditions.checkNotNullFromProvides(zendeskInitializedModule.getMessaging());
    }
}
