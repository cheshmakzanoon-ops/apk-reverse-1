package zendesk.android.internal.proactivemessaging.model;

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
import zendesk.core.android.internal.serializer.EnumIgnoreUnknownSerializer;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\t\b\u0081\u0081\u0002\u0018\u0000 \b2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0002\b\tB\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006j\u0002\b\u0007¨\u0006\n"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget;", "", "(Ljava/lang/String;I)V", "PATH", "PAGE_TITLE", "USER_TYPE", "LANGUAGE", "UNKNOWN", "Companion", "ExpressionTargetSerializer", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable(with = ExpressionTargetSerializer.class)
public enum ExpressionTarget {
    PATH,
    PAGE_TITLE,
    USER_TYPE,
    LANGUAGE,
    UNKNOWN;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return ExpressionTargetSerializer.INSTANCE;
        }
    });

    public static EnumEntries<ExpressionTarget> getEntries() {
        return $ENTRIES;
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) ExpressionTarget.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<ExpressionTarget> serializer() {
            return get$cachedSerializer();
        }
    }

    @Metadata(m17d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003¨\u0006\u0004"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget$ExpressionTargetSerializer;", "Lzendesk/core/android/internal/serializer/EnumIgnoreUnknownSerializer;", "Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget;", "()V", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ExpressionTargetSerializer extends EnumIgnoreUnknownSerializer<ExpressionTarget> {
        public static final ExpressionTargetSerializer INSTANCE = new ExpressionTargetSerializer();

        private ExpressionTargetSerializer() {
            super((Enum[]) ExpressionTarget.getEntries().toArray(new ExpressionTarget[0]), ExpressionTarget.UNKNOWN);
        }
    }
}
