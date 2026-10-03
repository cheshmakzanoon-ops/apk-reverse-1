package zendesk.messaging.android.internal.messagingscreen.p024di;

import dagger.internal.Factory;

public final class MessagingNavigatorModule_ProvideFragmentContainerIdFactory implements Factory<Integer> {
    private final MessagingNavigatorModule module;

    public MessagingNavigatorModule_ProvideFragmentContainerIdFactory(MessagingNavigatorModule messagingNavigatorModule) {
        this.module = messagingNavigatorModule;
    }

    @Override
    public Integer get() {
        return Integer.valueOf(provideFragmentContainerId(this.module));
    }

    public static MessagingNavigatorModule_ProvideFragmentContainerIdFactory create(MessagingNavigatorModule messagingNavigatorModule) {
        return new MessagingNavigatorModule_ProvideFragmentContainerIdFactory(messagingNavigatorModule);
    }

    public static int provideFragmentContainerId(MessagingNavigatorModule messagingNavigatorModule) {
        return messagingNavigatorModule.provideFragmentContainerId();
    }
}
