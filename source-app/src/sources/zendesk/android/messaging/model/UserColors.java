package zendesk.android.messaging.model;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\t\u0018\u00002\u00020\u0001B+\b\u0007\u0012\n\b\u0003\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0003\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0003\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0006R\u0015\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\t\u001a\u0004\b\u0007\u0010\bR\u0015\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\t\u001a\u0004\b\n\u0010\bR\u0015\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\t\u001a\u0004\b\u000b\u0010\b¨\u0006\f"}, m18d2 = {"Lzendesk/android/messaging/model/UserColors;", "", "onMessage", "", "onAction", "onPrimary", "(Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)V", "getOnAction", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getOnMessage", "getOnPrimary", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserColors {
    private final Integer onAction;
    private final Integer onMessage;
    private final Integer onPrimary;

    public UserColors() {
        this(null, null, null, 7, null);
    }

    public UserColors(Integer num) {
        this(num, null, null, 6, null);
    }

    public UserColors(Integer num, Integer num2) {
        this(num, num2, null, 4, null);
    }

    public UserColors(Integer num, Integer num2, Integer num3) {
        this.onMessage = num;
        this.onAction = num2;
        this.onPrimary = num3;
    }

    public UserColors(Integer num, Integer num2, Integer num3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : num, (i & 2) != 0 ? null : num2, (i & 4) != 0 ? null : num3);
    }

    public final Integer getOnMessage() {
        return this.onMessage;
    }

    public final Integer getOnAction() {
        return this.onAction;
    }

    public final Integer getOnPrimary() {
        return this.onPrimary;
    }
}
