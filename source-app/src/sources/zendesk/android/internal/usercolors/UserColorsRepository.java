package zendesk.android.internal.usercolors;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.UserColors;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0005\u001a\u00020\u0006H\u0082@¢\u0006\u0002\u0010\u0007J\u0010\u0010\b\u001a\u0004\u0018\u00010\tH\u0086@¢\u0006\u0002\u0010\u0007J\"\u0010\n\u001a\u00020\u00062\b\u0010\u000b\u001a\u0004\u0018\u00010\f2\b\u0010\r\u001a\u0004\u0018\u00010\fH\u0086@¢\u0006\u0002\u0010\u000eR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000f"}, m18d2 = {"Lzendesk/android/internal/usercolors/UserColorsRepository;", "", "storage", "Lzendesk/android/internal/usercolors/UserColorsStorage;", "(Lzendesk/android/internal/usercolors/UserColorsStorage;)V", "clearStorage", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUserColors", "Lzendesk/android/internal/usercolors/UserColorsSchemePersistence;", "updateUserColors", MessagingComponentKt.USER_LIGHT_COLORS, "Lzendesk/android/messaging/model/UserColors;", MessagingComponentKt.USER_DARK_COLORS, "(Lzendesk/android/messaging/model/UserColors;Lzendesk/android/messaging/model/UserColors;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserColorsRepository {
    private final UserColorsStorage storage;

    public UserColorsRepository(UserColorsStorage storage) {
        Intrinsics.checkNotNullParameter(storage, "storage");
        this.storage = storage;
    }

    public final Object updateUserColors(UserColors userColors, UserColors userColors2, Continuation<? super Unit> continuation) {
        if (userColors == null && userColors2 == null) {
            Object objClearStorage = clearStorage(continuation);
            return objClearStorage == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClearStorage : Unit.INSTANCE;
        }
        Object userColors3 = this.storage.setUserColors(new UserColorsSchemePersistence(UserColorsPersistenceKt.toPersistence(userColors), UserColorsPersistenceKt.toPersistence(userColors2)), continuation);
        return userColors3 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? userColors3 : Unit.INSTANCE;
    }

    public final Object getUserColors(Continuation<? super UserColorsSchemePersistence> continuation) {
        return this.storage.getUserColors(continuation);
    }

    public final Object clearStorage(Continuation<? super Unit> continuation) {
        Object objClear = this.storage.clear(continuation);
        return objClear == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClear : Unit.INSTANCE;
    }
}
