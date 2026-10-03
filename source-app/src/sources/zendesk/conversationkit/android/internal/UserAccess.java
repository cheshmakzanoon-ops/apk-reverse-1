package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.user.UserActionProcessor;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0080\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0015HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/internal/UserAccess;", "Lzendesk/conversationkit/android/internal/AccessLevel;", "userProcessor", "Lzendesk/conversationkit/android/internal/user/UserActionProcessor;", "conversationKitStorage", "Lzendesk/conversationkit/android/internal/ConversationKitStorage;", "(Lzendesk/conversationkit/android/internal/user/UserActionProcessor;Lzendesk/conversationkit/android/internal/ConversationKitStorage;)V", "getConversationKitStorage", "()Lzendesk/conversationkit/android/internal/ConversationKitStorage;", "getUserProcessor", "()Lzendesk/conversationkit/android/internal/user/UserActionProcessor;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserAccess extends AccessLevel {
    private final ConversationKitStorage conversationKitStorage;
    private final UserActionProcessor userProcessor;

    public static UserAccess copy$default(UserAccess userAccess, UserActionProcessor userActionProcessor, ConversationKitStorage conversationKitStorage, int i, Object obj) {
        if ((i & 1) != 0) {
            userActionProcessor = userAccess.userProcessor;
        }
        if ((i & 2) != 0) {
            conversationKitStorage = userAccess.conversationKitStorage;
        }
        return userAccess.copy(userActionProcessor, conversationKitStorage);
    }

    public final UserActionProcessor getUserProcessor() {
        return this.userProcessor;
    }

    public final ConversationKitStorage getConversationKitStorage() {
        return this.conversationKitStorage;
    }

    public final UserAccess copy(UserActionProcessor userProcessor, ConversationKitStorage conversationKitStorage) {
        Intrinsics.checkNotNullParameter(userProcessor, "userProcessor");
        Intrinsics.checkNotNullParameter(conversationKitStorage, "conversationKitStorage");
        return new UserAccess(userProcessor, conversationKitStorage);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof UserAccess)) {
            return false;
        }
        UserAccess userAccess = (UserAccess) other;
        return Intrinsics.areEqual(this.userProcessor, userAccess.userProcessor) && Intrinsics.areEqual(this.conversationKitStorage, userAccess.conversationKitStorage);
    }

    public int hashCode() {
        return (this.userProcessor.hashCode() * 31) + this.conversationKitStorage.hashCode();
    }

    public String toString() {
        return "UserAccess(userProcessor=" + this.userProcessor + ", conversationKitStorage=" + this.conversationKitStorage + ')';
    }

    public final UserActionProcessor getUserProcessor() {
        return this.userProcessor;
    }

    public final ConversationKitStorage getConversationKitStorage() {
        return this.conversationKitStorage;
    }

    public UserAccess(UserActionProcessor userProcessor, ConversationKitStorage conversationKitStorage) {
        super("UserAccess", null);
        Intrinsics.checkNotNullParameter(userProcessor, "userProcessor");
        Intrinsics.checkNotNullParameter(conversationKitStorage, "conversationKitStorage");
        this.userProcessor = userProcessor;
        this.conversationKitStorage = conversationKitStorage;
    }
}
