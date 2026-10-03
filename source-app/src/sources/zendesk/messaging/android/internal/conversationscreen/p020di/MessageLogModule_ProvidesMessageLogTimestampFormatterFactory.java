package zendesk.messaging.android.internal.conversationscreen.p020di;

import android.content.Context;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.messaging.android.internal.conversationscreen.MessageLogTimestampFormatter;

public final class MessageLogModule_ProvidesMessageLogTimestampFormatterFactory implements Factory<MessageLogTimestampFormatter> {
    private final Provider<Context> contextProvider;
    private final Provider<LocaleProvider> localeProvider;
    private final MessageLogModule module;

    public MessageLogModule_ProvidesMessageLogTimestampFormatterFactory(MessageLogModule messageLogModule, Provider<Context> provider, Provider<LocaleProvider> provider2) {
        this.module = messageLogModule;
        this.contextProvider = provider;
        this.localeProvider = provider2;
    }

    @Override
    public MessageLogTimestampFormatter get() {
        return providesMessageLogTimestampFormatter(this.module, this.contextProvider.get(), this.localeProvider.get());
    }

    public static MessageLogModule_ProvidesMessageLogTimestampFormatterFactory create(MessageLogModule messageLogModule, Provider<Context> provider, Provider<LocaleProvider> provider2) {
        return new MessageLogModule_ProvidesMessageLogTimestampFormatterFactory(messageLogModule, provider, provider2);
    }

    public static MessageLogTimestampFormatter providesMessageLogTimestampFormatter(MessageLogModule messageLogModule, Context context, LocaleProvider localeProvider) {
        return (MessageLogTimestampFormatter) Preconditions.checkNotNullFromProvides(messageLogModule.providesMessageLogTimestampFormatter(context, localeProvider));
    }
}
