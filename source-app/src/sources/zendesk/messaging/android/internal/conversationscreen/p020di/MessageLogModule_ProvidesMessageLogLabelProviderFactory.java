package zendesk.messaging.android.internal.conversationscreen.p020di;

import androidx.appcompat.app.AppCompatActivity;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.messaging.android.internal.conversationscreen.MessageLogLabelProvider;

public final class MessageLogModule_ProvidesMessageLogLabelProviderFactory implements Factory<MessageLogLabelProvider> {
    private final Provider<AppCompatActivity> activityProvider;
    private final MessageLogModule module;

    public MessageLogModule_ProvidesMessageLogLabelProviderFactory(MessageLogModule messageLogModule, Provider<AppCompatActivity> provider) {
        this.module = messageLogModule;
        this.activityProvider = provider;
    }

    @Override
    public MessageLogLabelProvider get() {
        return providesMessageLogLabelProvider(this.module, this.activityProvider.get());
    }

    public static MessageLogModule_ProvidesMessageLogLabelProviderFactory create(MessageLogModule messageLogModule, Provider<AppCompatActivity> provider) {
        return new MessageLogModule_ProvidesMessageLogLabelProviderFactory(messageLogModule, provider);
    }

    public static MessageLogLabelProvider providesMessageLogLabelProvider(MessageLogModule messageLogModule, AppCompatActivity appCompatActivity) {
        return (MessageLogLabelProvider) Preconditions.checkNotNullFromProvides(messageLogModule.providesMessageLogLabelProvider(appCompatActivity));
    }
}
