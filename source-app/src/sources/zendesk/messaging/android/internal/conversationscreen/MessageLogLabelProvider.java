package zendesk.messaging.android.internal.conversationscreen;

import android.content.Context;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.C1256R;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\t\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0006\u0010\u0005\u001a\u00020\u0006J\u0006\u0010\u0007\u001a\u00020\u0006J\u000e\u0010\b\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\nJ\u0006\u0010\u000b\u001a\u00020\u0006J\u0006\u0010\f\u001a\u00020\u0006J\u0006\u0010\r\u001a\u00020\u0006J\u0006\u0010\u000e\u001a\u00020\u0006J\u000e\u0010\u000f\u001a\u00020\u00062\u0006\u0010\u0010\u001a\u00020\u0006J\u0006\u0010\u0011\u001a\u00020\u0006J\u0006\u0010\u0012\u001a\u00020\u0006R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageLogLabelProvider;", "", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "downloadFailed", "", "downloading", "exceedsMaxFileSize", "size", "", "formSubmissionFailed", "justNow", "newMessages", "sending", "sentAt", "timestamp", "sentJustNow", "tapToRetry", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLogLabelProvider {
    private final Context context;

    public MessageLogLabelProvider(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        this.context = context;
    }

    public final String newMessages() {
        String string = this.context.getString(C1256R.string.zuia_conversation_message_label_new);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String justNow() {
        String string = this.context.getString(C1256R.string.zuia_conversation_message_label_just_now);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String sentAt(String timestamp) {
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        String string = this.context.getString(C1256R.string.zuia_conversation_message_label_sent_absolute, timestamp);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String sentJustNow() {
        String string = this.context.getString(C1256R.string.zuia_conversation_message_label_sent_relative);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String sending() {
        String string = this.context.getString(C1256R.string.zuia_conversation_message_label_sending);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String tapToRetry() {
        String string = this.context.getString(C1256R.string.zuia_conversation_message_label_tap_to_retry);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String formSubmissionFailed() {
        String string = this.context.getString(C1256R.string.zma_form_submission_error);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String exceedsMaxFileSize(int size) {
        String string = this.context.getString(C1256R.string.zuia_exceeds_max_file_size, Integer.valueOf(size));
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String downloading() {
        String string = this.context.getString(C1256R.string.zuia_conversation_message_label_downloading);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String downloadFailed() {
        String string = this.context.getString(C1256R.string.zuia_conversation_message_label_download_failed);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }
}
