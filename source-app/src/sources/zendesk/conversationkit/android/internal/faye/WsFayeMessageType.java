package zendesk.conversationkit.android.internal.faye;

import java.lang.annotation.Annotation;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.internal.EnumsKt;
import net.aihelp.core.util.logger.table.LoggerTable;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\r\b\u0081\u0081\u0002\u0018\u0000 \u000f2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\u000fB\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\bj\u0002\b\tj\u0002\b\nj\u0002\b\u000bj\u0002\b\fj\u0002\b\rj\u0002\b\u000e¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsFayeMessageType;", "", "value", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getValue", "()Ljava/lang/String;", LoggerTable.Columns.MESSAGE, "ACTIVITY", "CONVERSATION_ADDED", "CONVERSATION_REMOVED", "CONVERSATION_UPDATE", "USER_MERGE", "UPLOAD_FAILED", "UNKNOWN", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public enum WsFayeMessageType {
    MESSAGE("message"),
    ACTIVITY("activity"),
    CONVERSATION_ADDED("conversation:added"),
    CONVERSATION_REMOVED("conversation:removed"),
    CONVERSATION_UPDATE("conversation:update"),
    USER_MERGE("user:merge"),
    UPLOAD_FAILED("upload:failed"),
    UNKNOWN("unknown");

    private final String value;
    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return EnumsKt.createAnnotatedEnumSerializer("zendesk.conversationkit.android.internal.faye.WsFayeMessageType", WsFayeMessageType.values(), new String[]{"message", "activity", "conversation:added", "conversation:removed", "conversation:update", "user:merge", "upload:failed", "unknown"}, new Annotation[][]{null, null, null, null, null, null, null, null}, null);
        }
    });

    public static EnumEntries<WsFayeMessageType> getEntries() {
        return $ENTRIES;
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsFayeMessageType$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/faye/WsFayeMessageType;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) WsFayeMessageType.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<WsFayeMessageType> serializer() {
            return get$cachedSerializer();
        }
    }

    WsFayeMessageType(String str) {
        this.value = str;
    }

    public final String getValue() {
        return this.value;
    }
}
