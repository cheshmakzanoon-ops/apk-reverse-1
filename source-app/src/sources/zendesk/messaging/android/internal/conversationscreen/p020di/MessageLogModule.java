package zendesk.messaging.android.internal.conversationscreen.p020di;

import android.content.Context;
import android.text.format.DateFormat;
import androidx.appcompat.app.AppCompatActivity;
import dagger.Module;
import dagger.Provides;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.messaging.android.internal.conversationscreen.MessageContainerFactory;
import zendesk.messaging.android.internal.conversationscreen.MessageLogLabelProvider;
import zendesk.messaging.android.internal.conversationscreen.MessageLogTimestampFormatter;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0007J\u0010\u0010\t\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u000bH\u0007J\u0018\u0010\f\u001a\u00020\b2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0010H\u0007¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/di/MessageLogModule;", "", "()V", "providesMessageContainerFactory", "Lzendesk/messaging/android/internal/conversationscreen/MessageContainerFactory;", "messageLogLabelProvider", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogLabelProvider;", "messageLogTimestampFormatter", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogTimestampFormatter;", "providesMessageLogLabelProvider", "activity", "Landroidx/appcompat/app/AppCompatActivity;", "providesMessageLogTimestampFormatter", "context", "Landroid/content/Context;", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class MessageLogModule {
    @Provides
    public final MessageLogLabelProvider providesMessageLogLabelProvider(AppCompatActivity activity) {
        Intrinsics.checkNotNullParameter(activity, "activity");
        return new MessageLogLabelProvider((Context) activity);
    }

    @Provides
    public final MessageLogTimestampFormatter providesMessageLogTimestampFormatter(Context context, LocaleProvider localeProvider) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        return new MessageLogTimestampFormatter(localeProvider, DateFormat.is24HourFormat(context));
    }

    @Provides
    public final MessageContainerFactory providesMessageContainerFactory(MessageLogLabelProvider messageLogLabelProvider, MessageLogTimestampFormatter messageLogTimestampFormatter) {
        Intrinsics.checkNotNullParameter(messageLogLabelProvider, "messageLogLabelProvider");
        Intrinsics.checkNotNullParameter(messageLogTimestampFormatter, "messageLogTimestampFormatter");
        return new MessageContainerFactory(messageLogLabelProvider, messageLogTimestampFormatter, null, 4, null);
    }
}
