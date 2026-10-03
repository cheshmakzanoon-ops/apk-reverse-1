package zendesk.messaging.android.internal.messagingscreen;

import android.content.Intent;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.MutablePropertyReference1Impl;
import kotlin.jvm.internal.Reflection;
import kotlin.reflect.KProperty;
import zendesk.messaging.android.internal.IntentDelegate;

@Metadata(m17d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\"/\u0010\u0002\u001a\u00020\u0001*\u00020\u00032\u0006\u0010\u0000\u001a\u00020\u00018@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b\b\u0010\t\u001a\u0004\b\u0004\u0010\u0005\"\u0004\b\u0006\u0010\u0007¨\u0006\n"}, m18d2 = {"<set-?>", "", "credentials", "Landroid/content/Intent;", "getCredentials", "(Landroid/content/Intent;)Ljava/lang/String;", "setCredentials", "(Landroid/content/Intent;Ljava/lang/String;)V", "credentials$delegate", "Lzendesk/messaging/android/internal/IntentDelegate$String;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingActivityIntentBuilderKt {
    static final KProperty<Object>[] $$delegatedProperties = {Reflection.mutableProperty1(new MutablePropertyReference1Impl(MessagingActivityIntentBuilderKt.class, "credentials", "getCredentials(Landroid/content/Intent;)Ljava/lang/String;", 1))};
    private static final IntentDelegate.String credentials$delegate = new IntentDelegate.String("CREDENTIALS");

    public static final String getCredentials(Intent intent) {
        Intrinsics.checkNotNullParameter(intent, "<this>");
        return credentials$delegate.getValue(intent, $$delegatedProperties[0]);
    }

    public static final void setCredentials(Intent intent, String str) {
        Intrinsics.checkNotNullParameter(intent, "<this>");
        Intrinsics.checkNotNullParameter(str, "<set-?>");
        credentials$delegate.setValue(intent, $$delegatedProperties[0], str);
    }
}
