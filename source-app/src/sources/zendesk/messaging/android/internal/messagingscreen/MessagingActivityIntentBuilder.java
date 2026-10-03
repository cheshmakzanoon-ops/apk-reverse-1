package zendesk.messaging.android.internal.messagingscreen;

import android.content.Context;
import android.content.Intent;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.MutablePropertyReference2Impl;
import kotlin.jvm.internal.Reflection;
import kotlin.reflect.KProperty;
import zendesk.android.ZendeskCredentials;
import zendesk.messaging.android.internal.IntentDelegate;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\b\n\u0000\b\u0000\u0018\u00002\u00020\u0001B!\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bJ\u0006\u0010\u0012\u001a\u00020\nJ\u000e\u0010\u0013\u001a\u00020\u00002\u0006\u0010\u0014\u001a\u00020\u0015R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R/\u0010\u0006\u001a\u00020\u0007*\u00020\n2\u0006\u0010\u000b\u001a\u00020\u00078@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b\u0010\u0010\u0011\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000f¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingActivityIntentBuilder;", "", "context", "Landroid/content/Context;", "credentials", "Lzendesk/android/ZendeskCredentials;", "conversationId", "", "(Landroid/content/Context;Lzendesk/android/ZendeskCredentials;Ljava/lang/String;)V", "intent", "Landroid/content/Intent;", "<set-?>", "getConversationId$zendesk_messaging_messaging_android", "(Landroid/content/Intent;)Ljava/lang/String;", "setConversationId$zendesk_messaging_messaging_android", "(Landroid/content/Intent;Ljava/lang/String;)V", "conversationId$delegate", "Lzendesk/messaging/android/internal/IntentDelegate$String;", "build", "withFlags", "flags", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingActivityIntentBuilder {
    static final KProperty<Object>[] $$delegatedProperties = {Reflection.mutableProperty2(new MutablePropertyReference2Impl(MessagingActivityIntentBuilder.class, "conversationId", "getConversationId$zendesk_messaging_messaging_android(Landroid/content/Intent;)Ljava/lang/String;", 0))};

    private final IntentDelegate.String conversationId;
    private final Intent intent;

    public MessagingActivityIntentBuilder(Context context, ZendeskCredentials credentials, String str) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(credentials, "credentials");
        this.conversationId = new IntentDelegate.String(MessagingActivity.CONVERSATION_ID_KEY);
        Intent intent = new Intent(context, (Class<?>) MessagingActivity.class);
        this.intent = intent;
        MessagingActivityIntentBuilderKt.setCredentials(intent, ZendeskCredentials.INSTANCE.toQuery(credentials));
        if (str != null) {
            setConversationId$zendesk_messaging_messaging_android(intent, str);
        }
    }

    public MessagingActivityIntentBuilder(Context context, ZendeskCredentials zendeskCredentials, String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, zendeskCredentials, (i & 4) != 0 ? null : str);
    }

    public final String getConversationId$zendesk_messaging_messaging_android(Intent intent) {
        Intrinsics.checkNotNullParameter(intent, "<this>");
        return this.conversationId.getValue(intent, $$delegatedProperties[0]);
    }

    public final void setConversationId$zendesk_messaging_messaging_android(Intent intent, String str) {
        Intrinsics.checkNotNullParameter(intent, "<this>");
        Intrinsics.checkNotNullParameter(str, "<set-?>");
        this.conversationId.setValue(intent, $$delegatedProperties[0], str);
    }

    public final MessagingActivityIntentBuilder withFlags(int flags) {
        this.intent.setFlags(flags);
        return this;
    }

    public final Intent getIntent() {
        return this.intent;
    }
}
