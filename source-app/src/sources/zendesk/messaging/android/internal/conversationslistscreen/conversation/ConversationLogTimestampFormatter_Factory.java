package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import android.content.Context;
import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;

public final class ConversationLogTimestampFormatter_Factory implements Factory<ConversationLogTimestampFormatter> {
    private final Provider<Context> contextProvider;
    private final Provider<Boolean> is24HourFormatProvider;
    private final Provider<LocaleProvider> localeProvider;

    public ConversationLogTimestampFormatter_Factory(Provider<Context> provider, Provider<LocaleProvider> provider2, Provider<Boolean> provider3) {
        this.contextProvider = provider;
        this.localeProvider = provider2;
        this.is24HourFormatProvider = provider3;
    }

    @Override
    public ConversationLogTimestampFormatter get() {
        return newInstance(this.contextProvider.get(), this.localeProvider.get(), this.is24HourFormatProvider.get().booleanValue());
    }

    public static ConversationLogTimestampFormatter_Factory create(Provider<Context> provider, Provider<LocaleProvider> provider2, Provider<Boolean> provider3) {
        return new ConversationLogTimestampFormatter_Factory(provider, provider2, provider3);
    }

    public static ConversationLogTimestampFormatter newInstance(Context context, LocaleProvider localeProvider, boolean z) {
        return new ConversationLogTimestampFormatter(context, localeProvider, z);
    }
}
