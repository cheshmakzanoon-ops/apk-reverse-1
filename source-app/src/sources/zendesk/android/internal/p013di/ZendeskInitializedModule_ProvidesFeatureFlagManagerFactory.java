package zendesk.android.internal.p013di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import zendesk.core.android.internal.app.FeatureFlagManager;

public final class ZendeskInitializedModule_ProvidesFeatureFlagManagerFactory implements Factory<FeatureFlagManager> {
    private final ZendeskInitializedModule module;

    public ZendeskInitializedModule_ProvidesFeatureFlagManagerFactory(ZendeskInitializedModule zendeskInitializedModule) {
        this.module = zendeskInitializedModule;
    }

    @Override
    public FeatureFlagManager get() {
        return providesFeatureFlagManager(this.module);
    }

    public static ZendeskInitializedModule_ProvidesFeatureFlagManagerFactory create(ZendeskInitializedModule zendeskInitializedModule) {
        return new ZendeskInitializedModule_ProvidesFeatureFlagManagerFactory(zendeskInitializedModule);
    }

    public static FeatureFlagManager providesFeatureFlagManager(ZendeskInitializedModule zendeskInitializedModule) {
        return (FeatureFlagManager) Preconditions.checkNotNullFromProvides(zendeskInitializedModule.getFeatureFlagManager());
    }
}
