package zendesk.android.internal.p013di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;

public final class C0950xd9bebeda implements Factory<ProcessLifecycleEventObserver> {
    private final ZendeskModule module;

    public C0950xd9bebeda(ZendeskModule zendeskModule) {
        this.module = zendeskModule;
    }

    @Override
    public ProcessLifecycleEventObserver get() {
        return provideProcessLifecycleEventObserver$zendesk_zendesk_android(this.module);
    }

    public static C0950xd9bebeda create(ZendeskModule zendeskModule) {
        return new C0950xd9bebeda(zendeskModule);
    }

    public static ProcessLifecycleEventObserver provideProcessLifecycleEventObserver$zendesk_zendesk_android(ZendeskModule zendeskModule) {
        return (ProcessLifecycleEventObserver) Preconditions.checkNotNullFromProvides(zendeskModule.provideProcessLifecycleEventObserver$zendesk_zendesk_android());
    }
}
