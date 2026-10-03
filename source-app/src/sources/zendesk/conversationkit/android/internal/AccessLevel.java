package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import zendesk.conversationkit.android.internal.user.UserActionProcessor;
import zendesk.conversationkit.android.model.User;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001B\u000f\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0007\u001a\u00020\u0003H\u0086@¢\u0006\u0002\u0010\bJ\u0010\u0010\t\u001a\u0004\u0018\u00010\nH\u0086@¢\u0006\u0002\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\u0002\u000b\f¨\u0006\r"}, m18d2 = {"Lzendesk/conversationkit/android/internal/AccessLevel;", "", "logName", "", "(Ljava/lang/String;)V", "getLogName", "()Ljava/lang/String;", "getClientId", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getCurrentUser", "Lzendesk/conversationkit/android/model/User;", "Lzendesk/conversationkit/android/internal/AppAccess;", "Lzendesk/conversationkit/android/internal/UserAccess;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class AccessLevel {
    private final String logName;

    public AccessLevel(String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(str);
    }

    private AccessLevel(String str) {
        this.logName = str;
    }

    public final String getLogName() {
        return this.logName;
    }

    public final Object getClientId(Continuation<? super String> continuation) {
        if (this instanceof AppAccess) {
            return ((AppAccess) this).getConversationKitStorage().getClientId(continuation);
        }
        if (this instanceof UserAccess) {
            return ((UserAccess) this).getConversationKitStorage().getClientId(continuation);
        }
        throw new NoWhenBranchMatchedException();
    }

    public final Object getCurrentUser(Continuation<? super User> continuation) {
        UserActionProcessor userProcessor;
        UserAccess userAccess = this instanceof UserAccess ? (UserAccess) this : null;
        if (userAccess == null || (userProcessor = userAccess.getUserProcessor()) == null) {
            return null;
        }
        Object user = userProcessor.getUser(continuation);
        return user == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? user : (User) user;
    }
}
