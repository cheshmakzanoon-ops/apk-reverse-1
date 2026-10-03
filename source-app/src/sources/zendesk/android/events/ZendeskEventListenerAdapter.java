package zendesk.android.events;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b&\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0017J\u0010\u0010\u0007\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\bH\u0017J\u0010\u0010\t\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\nH\u0017J\u000e\u0010\u000b\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\fJ\u0010\u0010\r\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u000eH\u0017J\u0010\u0010\u000f\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0010H\u0017J\u0010\u0010\u0011\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0012H\u0017¨\u0006\u0013"}, m18d2 = {"Lzendesk/android/events/ZendeskEventListenerAdapter;", "Lzendesk/android/events/ZendeskEventListener;", "()V", "onAuthenticationFailed", "", "event", "Lzendesk/android/events/ZendeskEvent$AuthenticationFailed;", "onConnectionStatusChanged", "Lzendesk/android/events/ZendeskEvent$ConnectionStatusChanged;", "onConversationAdded", "Lzendesk/android/events/ZendeskEvent$ConversationAdded;", "onEvent", "Lzendesk/android/events/ZendeskEvent;", "onFieldValidationFailed", "Lzendesk/android/events/ZendeskEvent$FieldValidationFailed;", "onSendMessageFailed", "Lzendesk/android/events/ZendeskEvent$SendMessageFailed;", "onUnreadMessageCountChanged", "Lzendesk/android/events/ZendeskEvent$UnreadMessageCountChanged;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ZendeskEventListenerAdapter implements ZendeskEventListener {
    public void onAuthenticationFailed(ZendeskEvent.AuthenticationFailed event) {
        Intrinsics.checkNotNullParameter(event, "event");
    }

    public void onConnectionStatusChanged(ZendeskEvent.ConnectionStatusChanged event) {
        Intrinsics.checkNotNullParameter(event, "event");
    }

    public void onConversationAdded(ZendeskEvent.ConversationAdded event) {
        Intrinsics.checkNotNullParameter(event, "event");
    }

    public void onFieldValidationFailed(ZendeskEvent.FieldValidationFailed event) {
        Intrinsics.checkNotNullParameter(event, "event");
    }

    public void onSendMessageFailed(ZendeskEvent.SendMessageFailed event) {
        Intrinsics.checkNotNullParameter(event, "event");
    }

    public void onUnreadMessageCountChanged(ZendeskEvent.UnreadMessageCountChanged event) {
        Intrinsics.checkNotNullParameter(event, "event");
    }

    @Override
    public final void onEvent(ZendeskEvent event) {
        Intrinsics.checkNotNullParameter(event, "event");
        if (event instanceof ZendeskEvent.UnreadMessageCountChanged) {
            onUnreadMessageCountChanged((ZendeskEvent.UnreadMessageCountChanged) event);
            return;
        }
        if (event instanceof ZendeskEvent.AuthenticationFailed) {
            onAuthenticationFailed((ZendeskEvent.AuthenticationFailed) event);
            return;
        }
        if (event instanceof ZendeskEvent.FieldValidationFailed) {
            onFieldValidationFailed((ZendeskEvent.FieldValidationFailed) event);
            return;
        }
        if (event instanceof ZendeskEvent.ConnectionStatusChanged) {
            onConnectionStatusChanged((ZendeskEvent.ConnectionStatusChanged) event);
        } else if (event instanceof ZendeskEvent.SendMessageFailed) {
            onSendMessageFailed((ZendeskEvent.SendMessageFailed) event);
        } else if (event instanceof ZendeskEvent.ConversationAdded) {
            onConversationAdded((ZendeskEvent.ConversationAdded) event);
        }
    }
}
