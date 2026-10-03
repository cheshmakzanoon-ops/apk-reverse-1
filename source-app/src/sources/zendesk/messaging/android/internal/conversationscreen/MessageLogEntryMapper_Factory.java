package zendesk.messaging.android.internal.conversationscreen;

import dagger.internal.Factory;
import j$.time.LocalDateTime;
import javax.inject.Provider;
import kotlin.jvm.functions.Function0;
import kotlinx.coroutines.CoroutineDispatcher;

public final class MessageLogEntryMapper_Factory implements Factory<MessageLogEntryMapper> {
    private final Provider<Function0<LocalDateTime>> currentTimeProvider;
    private final Provider<CoroutineDispatcher> defaultDispatcherProvider;
    private final Provider<Function0<String>> idProvider;
    private final Provider<MessageLogLabelProvider> labelProvider;
    private final Provider<MessageContainerFactory> messageContainerFactoryProvider;
    private final Provider<MessageLogTimestampFormatter> timestampFormatterProvider;

    public MessageLogEntryMapper_Factory(Provider<MessageContainerFactory> provider, Provider<MessageLogLabelProvider> provider2, Provider<MessageLogTimestampFormatter> provider3, Provider<Function0<LocalDateTime>> provider4, Provider<Function0<String>> provider5, Provider<CoroutineDispatcher> provider6) {
        this.messageContainerFactoryProvider = provider;
        this.labelProvider = provider2;
        this.timestampFormatterProvider = provider3;
        this.currentTimeProvider = provider4;
        this.idProvider = provider5;
        this.defaultDispatcherProvider = provider6;
    }

    @Override
    public MessageLogEntryMapper get() {
        return newInstance(this.messageContainerFactoryProvider.get(), this.labelProvider.get(), this.timestampFormatterProvider.get(), this.currentTimeProvider.get(), this.idProvider.get(), this.defaultDispatcherProvider.get());
    }

    public static MessageLogEntryMapper_Factory create(Provider<MessageContainerFactory> provider, Provider<MessageLogLabelProvider> provider2, Provider<MessageLogTimestampFormatter> provider3, Provider<Function0<LocalDateTime>> provider4, Provider<Function0<String>> provider5, Provider<CoroutineDispatcher> provider6) {
        return new MessageLogEntryMapper_Factory(provider, provider2, provider3, provider4, provider5, provider6);
    }

    public static MessageLogEntryMapper newInstance(MessageContainerFactory messageContainerFactory, MessageLogLabelProvider messageLogLabelProvider, MessageLogTimestampFormatter messageLogTimestampFormatter, Function0<LocalDateTime> function0, Function0<String> function1, CoroutineDispatcher coroutineDispatcher) {
        return new MessageLogEntryMapper(messageContainerFactory, messageLogLabelProvider, messageLogTimestampFormatter, function0, function1, coroutineDispatcher);
    }
}
