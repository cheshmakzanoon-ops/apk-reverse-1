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
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000  2\u00020\u0001:\u0002\u001f B-\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\tB\u0019\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\nJ\u000b\u0010\u000e\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010\u000f\u001a\u0004\u0018\u00010\u0005HÆ\u0003J!\u0010\u0010\u001a\u00020\u00002\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u0011\u001a\u00020\u00122\b\u0010\u0013\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J&\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00002\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001dHÁ\u0001¢\u0006\u0002\b\u001eR\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\f¨\u0006!"}, m18d2 = {"Lzendesk/android/internal/usercolors/UserColorsSchemePersistence;", "", "seen1", "", "light", "Lzendesk/android/internal/usercolors/UserColorsPersistence;", "dark", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/android/internal/usercolors/UserColorsPersistence;Lzendesk/android/internal/usercolors/UserColorsPersistence;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/android/internal/usercolors/UserColorsPersistence;Lzendesk/android/internal/usercolors/UserColorsPersistence;)V", "getDark", "()Lzendesk/android/internal/usercolors/UserColorsPersistence;", "getLight", "component1", "component2", "copy", "equals", "", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class UserColorsSchemePersistence {

    public static final Companion INSTANCE = new Companion(null);
    private final UserColorsPersistence dark;
    private final UserColorsPersistence light;

    public static UserColorsSchemePersistence copy$default(UserColorsSchemePersistence userColorsSchemePersistence, UserColorsPersistence userColorsPersistence, UserColorsPersistence userColorsPersistence2, int i, Object obj) {
        if ((i & 1) != 0) {
            userColorsPersistence = userColorsSchemePersistence.light;
        }
        if ((i & 2) != 0) {
            userColorsPersistence2 = userColorsSchemePersistence.dark;
        }
        return userColorsSchemePersistence.copy(userColorsPersistence, userColorsPersistence2);
    }

    public final UserColorsPersistence getLight() {
        return this.light;
    }

    public final UserColorsPersistence getDark() {
        return this.dark;
    }

    public final UserColorsSchemePersistence copy(UserColorsPersistence light, UserColorsPersistence dark) {
        return new UserColorsSchemePersistence(light, dark);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof UserColorsSchemePersistence)) {
            return false;
        }
        UserColorsSchemePersistence userColorsSchemePersistence = (UserColorsSchemePersistence) other;
        return Intrinsics.areEqual(this.light, userColorsSchemePersistence.light) && Intrinsics.areEqual(this.dark, userColorsSchemePersistence.dark);
    }

    public int hashCode() {
        UserColorsPersistence userColorsPersistence = this.light;
        int iHashCode = (userColorsPersistence == null ? 0 : userColorsPersistence.hashCode()) * 31;
        UserColorsPersistence userColorsPersistence2 = this.dark;
        return iHashCode + (userColorsPersistence2 != null ? userColorsPersistence2.hashCode() : 0);
    }

    public String toString() {
        return "UserColorsSchemePersistence(light=" + this.light + ", dark=" + this.dark + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/usercolors/UserColorsSchemePersistence$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/usercolors/UserColorsSchemePersistence;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<UserColorsSchemePersistence> serializer() {
            return UserColorsSchemePersistence$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public UserColorsSchemePersistence(int i, UserColorsPersistence userColorsPersistence, UserColorsPersistence userColorsPersistence2, SerializationConstructorMarker serializationConstructorMarker) {
        if (3 != (i & 3)) {
            PluginExceptionsKt.throwMissingFieldException(i, 3, UserColorsSchemePersistence$$serializer.INSTANCE.getDescriptor());
        }
        this.light = userColorsPersistence;
        this.dark = userColorsPersistence2;
    }

    public UserColorsSchemePersistence(UserColorsPersistence userColorsPersistence, UserColorsPersistence userColorsPersistence2) {
        this.light = userColorsPersistence;
        this.dark = userColorsPersistence2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(UserColorsSchemePersistence self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeNullableSerializableElement(serialDesc, 0, UserColorsPersistence$$serializer.INSTANCE, self.light);
        output.encodeNullableSerializableElement(serialDesc, 1, UserColorsPersistence$$serializer.INSTANCE, self.dark);
    }

    public final UserColorsPersistence getLight() {
        return this.light;
    }

    public final UserColorsPersistence getDark() {
        return this.dark;
    }
}
