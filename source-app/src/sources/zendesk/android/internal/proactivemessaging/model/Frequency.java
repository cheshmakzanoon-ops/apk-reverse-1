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

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\b\b\u0081\u0081\u0002\u0018\u0000 \u00072\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0002\u0007\bB\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006¨\u0006\t"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Frequency;", "", "(Ljava/lang/String;I)V", "SEND_ONCE", "ONCE_PER_SESSION", "SEND_EVERYTIME", "UNKNOWN", "Companion", "FrequencySerializer", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable(with = FrequencySerializer.class)
public enum Frequency {
    SEND_ONCE,
    ONCE_PER_SESSION,
    SEND_EVERYTIME,
    UNKNOWN;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return FrequencySerializer.INSTANCE;
        }
    });

    public static EnumEntries<Frequency> getEntries() {
        return $ENTRIES;
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Frequency$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Frequency;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) Frequency.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<Frequency> serializer() {
            return get$cachedSerializer();
        }
    }

    @Metadata(m17d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003¨\u0006\u0004"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Frequency$FrequencySerializer;", "Lzendesk/core/android/internal/serializer/EnumIgnoreUnknownSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Frequency;", "()V", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FrequencySerializer extends EnumIgnoreUnknownSerializer<Frequency> {
        public static final FrequencySerializer INSTANCE = new FrequencySerializer();

        private FrequencySerializer() {
            super((Enum[]) Frequency.getEntries().toArray(new Frequency[0]), Frequency.UNKNOWN);
        }
    }
}
