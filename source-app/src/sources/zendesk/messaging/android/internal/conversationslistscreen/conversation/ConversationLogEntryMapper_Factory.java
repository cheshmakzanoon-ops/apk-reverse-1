package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import android.content.Context;
import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.messaging.android.internal.ConversationTitleProvider;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIO;

public final class ConversationLogEntryMapper_Factory implements Factory<ConversationLogEntryMapper> {
    private final Provider<Context> contextProvider;
    private final Provider<ConversationTitleProvider> conversationTitleProvider;
    private final Provider<ConversationsListLocalStorageIO> conversationsListLocalStorageIOProvider;
    private final Provider<ConversationLogTimestampFormatter> logTimestampFormatterProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;

    public ConversationLogEntryMapper_Factory(Provider<Context> provider, Provider<ConversationLogTimestampFormatter> provider2, Provider<MessagingSettings> provider3, Provider<ConversationsListLocalStorageIO> provider4, Provider<ConversationTitleProvider> provider5) {
        this.contextProvider = provider;
        this.logTimestampFormatterProvider = provider2;
        this.messagingSettingsProvider = provider3;
        this.conversationsListLocalStorageIOProvider = provider4;
        this.conversationTitleProvider = provider5;
    }

    @Override
    public ConversationLogEntryMapper get() {
        return newInstance(this.contextProvider.get(), this.logTimestampFormatterProvider.get(), this.messagingSettingsProvider.get(), this.conversationsListLocalStorageIOProvider.get(), this.conversationTitleProvider.get());
    }

    public static ConversationLogEntryMapper_Factory create(Provider<Context> provider, Provider<ConversationLogTimestampFormatter> provider2, Provider<MessagingSettings> provider3, Provider<ConversationsListLocalStorageIO> provider4, Provider<ConversationTitleProvider> provider5) {
        return new ConversationLogEntryMapper_Factory(provider, provider2, provider3, provider4, provider5);
    }

    public static ConversationLogEntryMapper newInstance(Context context, ConversationLogTimestampFormatter conversationLogTimestampFormatter, MessagingSettings messagingSettings, ConversationsListLocalStorageIO conversationsListLocalStorageIO, ConversationTitleProvider conversationTitleProvider) {
        return new ConversationLogEntryMapper(context, conversationLogTimestampFormatter, messagingSettings, conversationsListLocalStorageIO, conversationTitleProvider);
    }
}
