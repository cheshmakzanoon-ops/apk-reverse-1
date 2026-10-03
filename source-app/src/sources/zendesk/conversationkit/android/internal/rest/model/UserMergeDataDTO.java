package zendesk.conversationkit.android.internal.rest.model;

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

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 !2\u00020\u0001:\u0002 !B-\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\u0015\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u000bJ\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0007HÆ\u0003J\u001d\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0016\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0017\u001a\u00020\u0007HÖ\u0001J&\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u00002\u0006\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001eHÁ\u0001¢\u0006\u0002\b\u001fR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\""}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/UserMergeDataDTO;", "", "seen1", "", "survivingAppUser", "Lzendesk/conversationkit/android/internal/rest/model/SurvivingAppUserDTO;", "reason", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/internal/rest/model/SurvivingAppUserDTO;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/internal/rest/model/SurvivingAppUserDTO;Ljava/lang/String;)V", "getReason", "()Ljava/lang/String;", "getSurvivingAppUser", "()Lzendesk/conversationkit/android/internal/rest/model/SurvivingAppUserDTO;", "component1", "component2", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class UserMergeDataDTO {

    public static final Companion INSTANCE = new Companion(null);
    private final String reason;
    private final SurvivingAppUserDTO survivingAppUser;

    public static UserMergeDataDTO copy$default(UserMergeDataDTO userMergeDataDTO, SurvivingAppUserDTO survivingAppUserDTO, String str, int i, Object obj) {
        if ((i & 1) != 0) {
            survivingAppUserDTO = userMergeDataDTO.survivingAppUser;
        }
        if ((i & 2) != 0) {
            str = userMergeDataDTO.reason;
        }
        return userMergeDataDTO.copy(survivingAppUserDTO, str);
    }

    public final SurvivingAppUserDTO getSurvivingAppUser() {
        return this.survivingAppUser;
    }

    public final String getReason() {
        return this.reason;
    }

    public final UserMergeDataDTO copy(SurvivingAppUserDTO survivingAppUser, String reason) {
        Intrinsics.checkNotNullParameter(survivingAppUser, "survivingAppUser");
        Intrinsics.checkNotNullParameter(reason, "reason");
        return new UserMergeDataDTO(survivingAppUser, reason);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof UserMergeDataDTO)) {
            return false;
        }
        UserMergeDataDTO userMergeDataDTO = (UserMergeDataDTO) other;
        return Intrinsics.areEqual(this.survivingAppUser, userMergeDataDTO.survivingAppUser) && Intrinsics.areEqual(this.reason, userMergeDataDTO.reason);
    }

    public int hashCode() {
        return (this.survivingAppUser.hashCode() * 31) + this.reason.hashCode();
    }

    public String toString() {
        return "UserMergeDataDTO(survivingAppUser=" + this.survivingAppUser + ", reason=" + this.reason + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/UserMergeDataDTO$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/UserMergeDataDTO;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<UserMergeDataDTO> serializer() {
            return UserMergeDataDTO$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public UserMergeDataDTO(int i, SurvivingAppUserDTO survivingAppUserDTO, String str, SerializationConstructorMarker serializationConstructorMarker) {
        if (3 != (i & 3)) {
            PluginExceptionsKt.throwMissingFieldException(i, 3, UserMergeDataDTO$$serializer.INSTANCE.getDescriptor());
        }
        this.survivingAppUser = survivingAppUserDTO;
        this.reason = str;
    }

    public UserMergeDataDTO(SurvivingAppUserDTO survivingAppUser, String reason) {
        Intrinsics.checkNotNullParameter(survivingAppUser, "survivingAppUser");
        Intrinsics.checkNotNullParameter(reason, "reason");
        this.survivingAppUser = survivingAppUser;
        this.reason = reason;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(UserMergeDataDTO self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeSerializableElement(serialDesc, 0, SurvivingAppUserDTO$$serializer.INSTANCE, self.survivingAppUser);
        output.encodeStringElement(serialDesc, 1, self.reason);
    }

    public final SurvivingAppUserDTO getSurvivingAppUser() {
        return this.survivingAppUser;
    }

    public final String getReason() {
        return this.reason;
    }
}
