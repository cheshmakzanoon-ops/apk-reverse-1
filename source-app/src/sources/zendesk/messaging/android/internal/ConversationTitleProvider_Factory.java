package zendesk.messaging.android.internal;

import android.content.Context;
import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogTimestampFormatter;

public final class ConversationTitleProvider_Factory implements Factory<ConversationTitleProvider> {
    private final Provider<Context> contextProvider;
    private final Provider<Boolean> is24HourFormatProvider;
    private final Provider<LocaleProvider> localeProvider;
    private final Provider<ConversationLogTimestampFormatter> timestampFormatterProvider;

    public ConversationTitleProvider_Factory(Provider<Context> provider, Provider<LocaleProvider> provider2, Provider<ConversationLogTimestampFormatter> provider3, Provider<Boolean> provider4) {
        this.contextProvider = provider;
        this.localeProvider = provider2;
        this.timestampFormatterProvider = provider3;
        this.is24HourFormatProvider = provider4;
    }

    @Override
    public ConversationTitleProvider get() {
        return newInstance(this.contextProvider.get(), this.localeProvider.get(), this.timestampFormatterProvider.get(), this.is24HourFormatProvider.get().booleanValue());
    }

    public static ConversationTitleProvider_Factory create(Provider<Context> provider, Provider<LocaleProvider> provider2, Provider<ConversationLogTimestampFormatter> provider3, Provider<Boolean> provider4) {
        return new ConversationTitleProvider_Factory(provider, provider2, provider3, provider4);
    }

    public static ConversationTitleProvider newInstance(Context context, LocaleProvider localeProvider, ConversationLogTimestampFormatter conversationLogTimestampFormatter, boolean z) {
        return new ConversationTitleProvider(context, localeProvider, conversationLogTimestampFormatter, z);
    }
}
