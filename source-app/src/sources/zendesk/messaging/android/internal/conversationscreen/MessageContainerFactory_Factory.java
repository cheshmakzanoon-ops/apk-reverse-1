package zendesk.messaging.android.internal.conversationscreen;

import dagger.internal.Factory;
import j$.time.LocalDateTime;
import javax.inject.Provider;
import kotlin.jvm.functions.Function0;

public final class MessageContainerFactory_Factory implements Factory<MessageContainerFactory> {
    private final Provider<Function0<LocalDateTime>> currentTimeProvider;
    private final Provider<MessageLogLabelProvider> labelProvider;
    private final Provider<MessageLogTimestampFormatter> timestampFormatterProvider;

    public MessageContainerFactory_Factory(Provider<MessageLogLabelProvider> provider, Provider<MessageLogTimestampFormatter> provider2, Provider<Function0<LocalDateTime>> provider3) {
        this.labelProvider = provider;
        this.timestampFormatterProvider = provider2;
        this.currentTimeProvider = provider3;
    }

    @Override
    public MessageContainerFactory get() {
        return newInstance(this.labelProvider.get(), this.timestampFormatterProvider.get(), this.currentTimeProvider.get());
    }

    public static MessageContainerFactory_Factory create(Provider<MessageLogLabelProvider> provider, Provider<MessageLogTimestampFormatter> provider2, Provider<Function0<LocalDateTime>> provider3) {
        return new MessageContainerFactory_Factory(provider, provider2, provider3);
    }

    public static MessageContainerFactory newInstance(MessageLogLabelProvider messageLogLabelProvider, MessageLogTimestampFormatter messageLogTimestampFormatter, Function0<LocalDateTime> function0) {
        return new MessageContainerFactory(messageLogLabelProvider, messageLogTimestampFormatter, function0);
    }
}
