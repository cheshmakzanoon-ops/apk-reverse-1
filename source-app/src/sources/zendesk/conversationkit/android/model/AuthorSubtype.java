package zendesk.conversationkit.android.model;

import java.lang.annotation.Annotation;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.internal.EnumsKt;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0004\b\u0087\u0081\u0002\u0018\u0000 \u00042\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\u0004B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003¨\u0006\u0005"}, m18d2 = {"Lzendesk/conversationkit/android/model/AuthorSubtype;", "", "(Ljava/lang/String;I)V", "AI", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public enum AuthorSubtype {
    AI;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return EnumsKt.createAnnotatedEnumSerializer("zendesk.conversationkit.android.model.AuthorSubtype", AuthorSubtype.values(), new String[]{"AI"}, new Annotation[][]{null}, null);
        }
    });

    public static EnumEntries<AuthorSubtype> getEntries() {
        return $ENTRIES;
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u0004\u0018\u00010\u00042\u0006\u0010\u0005\u001a\u00020\u0006J\u000f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\u00040\bHÆ\u0001¨\u0006\t"}, m18d2 = {"Lzendesk/conversationkit/android/model/AuthorSubtype$Companion;", "", "()V", "findByValue", "Lzendesk/conversationkit/android/model/AuthorSubtype;", "value", "", "serializer", "Lkotlinx/serialization/KSerializer;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) AuthorSubtype.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<AuthorSubtype> serializer() {
            return get$cachedSerializer();
        }

        public final AuthorSubtype findByValue(String value) {
            Intrinsics.checkNotNullParameter(value, "value");
            for (AuthorSubtype authorSubtype : AuthorSubtype.values()) {
                if (Intrinsics.areEqual(authorSubtype.name(), value)) {
                    return authorSubtype;
                }
            }
            return null;
        }
    }
}
