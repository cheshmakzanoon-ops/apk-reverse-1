package zendesk.messaging.android.internal.p023di;

import android.content.Context;
import dagger.internal.Factory;
import javax.inject.Provider;

public final class MessagingDateFormatModule_ProvidesIs24HoursFactory implements Factory<Boolean> {
    private final Provider<Context> contextProvider;
    private final MessagingDateFormatModule module;

    public MessagingDateFormatModule_ProvidesIs24HoursFactory(MessagingDateFormatModule messagingDateFormatModule, Provider<Context> provider) {
        this.module = messagingDateFormatModule;
        this.contextProvider = provider;
    }

    @Override
    public Boolean get() {
        return Boolean.valueOf(providesIs24Hours(this.module, this.contextProvider.get()));
    }

    public static MessagingDateFormatModule_ProvidesIs24HoursFactory create(MessagingDateFormatModule messagingDateFormatModule, Provider<Context> provider) {
        return new MessagingDateFormatModule_ProvidesIs24HoursFactory(messagingDateFormatModule, provider);
    }

    public static boolean providesIs24Hours(MessagingDateFormatModule messagingDateFormatModule, Context context) {
        return messagingDateFormatModule.providesIs24Hours(context);
    }
}
