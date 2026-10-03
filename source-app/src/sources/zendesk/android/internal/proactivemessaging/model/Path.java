package zendesk.android.internal.proactivemessaging.model;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 '2\u00020\u0001:\u0002&'B;\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\u0002\u0010\u000bB\u001d\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\fJ\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0017\u001a\u00020\bHÆ\u0003J'\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001c\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001d\u001a\u00020\u0005HÖ\u0001J&\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020\u00002\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020$HÁ\u0001¢\u0006\u0002\b%R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000f\u0010\u0010\u001a\u0004\b\u0011\u0010\u0012R\u001c\u0010\u0006\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0013\u0010\u0010\u001a\u0004\b\u0014\u0010\u0012¨\u0006("}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Path;", "", "seen1", "", "pathId", "", "zrlVersion", "condition", "Lzendesk/android/internal/proactivemessaging/model/Condition;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Lzendesk/android/internal/proactivemessaging/model/Condition;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/android/internal/proactivemessaging/model/Condition;)V", "getCondition", "()Lzendesk/android/internal/proactivemessaging/model/Condition;", "getPathId$annotations", "()V", "getPathId", "()Ljava/lang/String;", "getZrlVersion$annotations", "getZrlVersion", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class Path {

    public static final Companion INSTANCE = new Companion(null);
    private final Condition condition;
    private final String pathId;
    private final String zrlVersion;

    public static Path copy$default(Path path, String str, String str2, Condition condition, int i, Object obj) {
        if ((i & 1) != 0) {
            str = path.pathId;
        }
        if ((i & 2) != 0) {
            str2 = path.zrlVersion;
        }
        if ((i & 4) != 0) {
            condition = path.condition;
        }
        return path.copy(str, str2, condition);
    }

    @SerialName("path_id")
    public static void getPathId$annotations() {
    }

    @SerialName("zrl_version")
    public static void getZrlVersion$annotations() {
    }

    public final String getPathId() {
        return this.pathId;
    }

    public final String getZrlVersion() {
        return this.zrlVersion;
    }

    public final Condition getCondition() {
        return this.condition;
    }

    public final Path copy(String pathId, String zrlVersion, Condition condition) {
        Intrinsics.checkNotNullParameter(pathId, "pathId");
        Intrinsics.checkNotNullParameter(zrlVersion, "zrlVersion");
        Intrinsics.checkNotNullParameter(condition, "condition");
        return new Path(pathId, zrlVersion, condition);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Path)) {
            return false;
        }
        Path path = (Path) other;
        return Intrinsics.areEqual(this.pathId, path.pathId) && Intrinsics.areEqual(this.zrlVersion, path.zrlVersion) && Intrinsics.areEqual(this.condition, path.condition);
    }

    public int hashCode() {
        return (((this.pathId.hashCode() * 31) + this.zrlVersion.hashCode()) * 31) + this.condition.hashCode();
    }

    public String toString() {
        return "Path(pathId=" + this.pathId + ", zrlVersion=" + this.zrlVersion + ", condition=" + this.condition + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Path$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Path;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<Path> serializer() {
            return Path$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public Path(int i, @SerialName("path_id") String str, @SerialName("zrl_version") String str2, Condition condition, SerializationConstructorMarker serializationConstructorMarker) {
        if (7 != (i & 7)) {
            PluginExceptionsKt.throwMissingFieldException(i, 7, Path$$serializer.INSTANCE.getDescriptor());
        }
        this.pathId = str;
        this.zrlVersion = str2;
        this.condition = condition;
    }

    public Path(String pathId, String zrlVersion, Condition condition) {
        Intrinsics.checkNotNullParameter(pathId, "pathId");
        Intrinsics.checkNotNullParameter(zrlVersion, "zrlVersion");
        Intrinsics.checkNotNullParameter(condition, "condition");
        this.pathId = pathId;
        this.zrlVersion = zrlVersion;
        this.condition = condition;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(Path self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.pathId);
        output.encodeStringElement(serialDesc, 1, self.zrlVersion);
        output.encodeSerializableElement(serialDesc, 2, Condition$$serializer.INSTANCE, self.condition);
    }

    public final String getPathId() {
        return this.pathId;
    }

    public final String getZrlVersion() {
        return this.zrlVersion;
    }

    public final Condition getCondition() {
        return this.condition;
    }
}
