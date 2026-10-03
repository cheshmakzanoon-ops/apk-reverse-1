package zendesk.android.internal.usercolors;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 $2\u00020\u0001:\u0002#$B7\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\tB)\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0001\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\nJ\u0010\u0010\u0010\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\fJ\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\fJ\u0010\u0010\u0012\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\fJ2\u0010\u0013\u001a\u00020\u00002\n\b\u0003\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0003\u0010\u0005\u001a\u0004\u0018\u00010\u00032\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010\u0014J\u0013\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0019\u001a\u00020\u001aHÖ\u0001J&\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u00002\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020!HÁ\u0001¢\u0006\u0002\b\"R\u0015\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u000b\u0010\fR\u0015\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u000e\u0010\fR\u0015\u0010\u0006\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u000f\u0010\f¨\u0006%"}, m18d2 = {"Lzendesk/android/internal/usercolors/UserColorsPersistence;", "", "seen1", "", "onMessage", "onAction", "onPrimary", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)V", "getOnAction", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getOnMessage", "getOnPrimary", "component1", "component2", "component3", "copy", "(Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)Lzendesk/android/internal/usercolors/UserColorsPersistence;", "equals", "", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class UserColorsPersistence {

    public static final Companion INSTANCE = new Companion(null);
    private final Integer onAction;
    private final Integer onMessage;
    private final Integer onPrimary;

    public static UserColorsPersistence copy$default(UserColorsPersistence userColorsPersistence, Integer num, Integer num2, Integer num3, int i, Object obj) {
        if ((i & 1) != 0) {
            num = userColorsPersistence.onMessage;
        }
        if ((i & 2) != 0) {
            num2 = userColorsPersistence.onAction;
        }
        if ((i & 4) != 0) {
            num3 = userColorsPersistence.onPrimary;
        }
        return userColorsPersistence.copy(num, num2, num3);
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

    public final UserColorsPersistence copy(Integer onMessage, Integer onAction, Integer onPrimary) {
        return new UserColorsPersistence(onMessage, onAction, onPrimary);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof UserColorsPersistence)) {
            return false;
        }
        UserColorsPersistence userColorsPersistence = (UserColorsPersistence) other;
        return Intrinsics.areEqual(this.onMessage, userColorsPersistence.onMessage) && Intrinsics.areEqual(this.onAction, userColorsPersistence.onAction) && Intrinsics.areEqual(this.onPrimary, userColorsPersistence.onPrimary);
    }

    public int hashCode() {
        Integer num = this.onMessage;
        int iHashCode = (num == null ? 0 : num.hashCode()) * 31;
        Integer num2 = this.onAction;
        int iHashCode2 = (iHashCode + (num2 == null ? 0 : num2.hashCode())) * 31;
        Integer num3 = this.onPrimary;
        return iHashCode2 + (num3 != null ? num3.hashCode() : 0);
    }

    public String toString() {
        return "UserColorsPersistence(onMessage=" + this.onMessage + ", onAction=" + this.onAction + ", onPrimary=" + this.onPrimary + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/usercolors/UserColorsPersistence$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/usercolors/UserColorsPersistence;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<UserColorsPersistence> serializer() {
            return UserColorsPersistence$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public UserColorsPersistence(int i, Integer num, Integer num2, Integer num3, SerializationConstructorMarker serializationConstructorMarker) {
        if (7 != (i & 7)) {
            PluginExceptionsKt.throwMissingFieldException(i, 7, UserColorsPersistence$$serializer.INSTANCE.getDescriptor());
        }
        this.onMessage = num;
        this.onAction = num2;
        this.onPrimary = num3;
    }

    public UserColorsPersistence(Integer num, Integer num2, Integer num3) {
        this.onMessage = num;
        this.onAction = num2;
        this.onPrimary = num3;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(UserColorsPersistence self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeNullableSerializableElement(serialDesc, 0, IntSerializer.INSTANCE, self.onMessage);
        output.encodeNullableSerializableElement(serialDesc, 1, IntSerializer.INSTANCE, self.onAction);
        output.encodeNullableSerializableElement(serialDesc, 2, IntSerializer.INSTANCE, self.onPrimary);
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
