package zendesk.messaging.android.internal.model;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u000e\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001B!\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0007HÆ\u0003J'\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00072\b\u0010\u0014\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J\t\u0010\u0017\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u0018"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageReceipt;", "", "label", "", "icon", "Lzendesk/messaging/android/internal/model/MessageStatusIcon;", "shouldAnimateReceipt", "", "(Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessageStatusIcon;Z)V", "getIcon", "()Lzendesk/messaging/android/internal/model/MessageStatusIcon;", "getLabel", "()Ljava/lang/String;", "getShouldAnimateReceipt", "()Z", "component1", "component2", "component3", "copy", "equals", "other", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageReceipt {
    private final MessageStatusIcon icon;
    private final String label;
    private final boolean shouldAnimateReceipt;

    public static MessageReceipt copy$default(MessageReceipt messageReceipt, String str, MessageStatusIcon messageStatusIcon, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            str = messageReceipt.label;
        }
        if ((i & 2) != 0) {
            messageStatusIcon = messageReceipt.icon;
        }
        if ((i & 4) != 0) {
            z = messageReceipt.shouldAnimateReceipt;
        }
        return messageReceipt.copy(str, messageStatusIcon, z);
    }

    public final String getLabel() {
        return this.label;
    }

    public final MessageStatusIcon getIcon() {
        return this.icon;
    }

    public final boolean getShouldAnimateReceipt() {
        return this.shouldAnimateReceipt;
    }

    public final MessageReceipt copy(String label, MessageStatusIcon icon, boolean shouldAnimateReceipt) {
        Intrinsics.checkNotNullParameter(label, "label");
        Intrinsics.checkNotNullParameter(icon, "icon");
        return new MessageReceipt(label, icon, shouldAnimateReceipt);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessageReceipt)) {
            return false;
        }
        MessageReceipt messageReceipt = (MessageReceipt) other;
        return Intrinsics.areEqual(this.label, messageReceipt.label) && this.icon == messageReceipt.icon && this.shouldAnimateReceipt == messageReceipt.shouldAnimateReceipt;
    }

    public int hashCode() {
        return (((this.label.hashCode() * 31) + this.icon.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldAnimateReceipt);
    }

    public String toString() {
        return "MessageReceipt(label=" + this.label + ", icon=" + this.icon + ", shouldAnimateReceipt=" + this.shouldAnimateReceipt + ')';
    }

    public MessageReceipt(String label, MessageStatusIcon icon, boolean z) {
        Intrinsics.checkNotNullParameter(label, "label");
        Intrinsics.checkNotNullParameter(icon, "icon");
        this.label = label;
        this.icon = icon;
        this.shouldAnimateReceipt = z;
    }

    public final String getLabel() {
        return this.label;
    }

    public MessageReceipt(String str, MessageStatusIcon messageStatusIcon, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, (i & 2) != 0 ? MessageStatusIcon.NO_ICON : messageStatusIcon, (i & 4) != 0 ? false : z);
    }

    public final MessageStatusIcon getIcon() {
        return this.icon;
    }

    public final boolean getShouldAnimateReceipt() {
        return this.shouldAnimateReceipt;
    }
}
