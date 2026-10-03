package zendesk.android.internal.proactivemessaging;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlin.jvm.functions.Function0;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.internal.frontendevents.analyticsevents.ProactiveMessagingAnalyticsManager;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;

public final class ProactiveMessagingManager_Factory implements Factory<ProactiveMessagingManager> {
    private final Provider<ConversationKit> conversationKitProvider;
    private final Provider<CoroutineScope> coroutineScopeProvider;
    private final Provider<Function0<Long>> currentTimeProvider;
    private final Provider<LocaleProvider> localeProvider;
    private final Provider<ProactiveMessagingAnalyticsManager> proactiveMessagingAnalyticsManagerProvider;
    private final Provider<ProactiveMessagingRepository> proactiveMessagingRepositoryProvider;
    private final Provider<ProcessLifecycleEventObserver> processLifecycleEventObserverProvider;
    private final Provider<VisitTypeProvider> visitTypeProvider;

    public ProactiveMessagingManager_Factory(Provider<ProcessLifecycleEventObserver> provider, Provider<CoroutineScope> provider2, Provider<LocaleProvider> provider3, Provider<VisitTypeProvider> provider4, Provider<ConversationKit> provider5, Provider<ProactiveMessagingRepository> provider6, Provider<Function0<Long>> provider7, Provider<ProactiveMessagingAnalyticsManager> provider8) {
        this.processLifecycleEventObserverProvider = provider;
        this.coroutineScopeProvider = provider2;
        this.localeProvider = provider3;
        this.visitTypeProvider = provider4;
        this.conversationKitProvider = provider5;
        this.proactiveMessagingRepositoryProvider = provider6;
        this.currentTimeProvider = provider7;
        this.proactiveMessagingAnalyticsManagerProvider = provider8;
    }

    @Override
    public ProactiveMessagingManager get() {
        return newInstance(this.processLifecycleEventObserverProvider.get(), this.coroutineScopeProvider.get(), this.localeProvider.get(), this.visitTypeProvider.get(), this.conversationKitProvider.get(), this.proactiveMessagingRepositoryProvider.get(), this.currentTimeProvider.get(), this.proactiveMessagingAnalyticsManagerProvider.get());
    }

    public static ProactiveMessagingManager_Factory create(Provider<ProcessLifecycleEventObserver> provider, Provider<CoroutineScope> provider2, Provider<LocaleProvider> provider3, Provider<VisitTypeProvider> provider4, Provider<ConversationKit> provider5, Provider<ProactiveMessagingRepository> provider6, Provider<Function0<Long>> provider7, Provider<ProactiveMessagingAnalyticsManager> provider8) {
        return new ProactiveMessagingManager_Factory(provider, provider2, provider3, provider4, provider5, provider6, provider7, provider8);
    }

    public static ProactiveMessagingManager newInstance(ProcessLifecycleEventObserver processLifecycleEventObserver, CoroutineScope coroutineScope, LocaleProvider localeProvider, VisitTypeProvider visitTypeProvider, ConversationKit conversationKit, ProactiveMessagingRepository proactiveMessagingRepository, Function0<Long> function0, ProactiveMessagingAnalyticsManager proactiveMessagingAnalyticsManager) {
        return new ProactiveMessagingManager(processLifecycleEventObserver, coroutineScope, localeProvider, visitTypeProvider, conversationKit, proactiveMessagingRepository, function0, proactiveMessagingAnalyticsManager);
    }
}
