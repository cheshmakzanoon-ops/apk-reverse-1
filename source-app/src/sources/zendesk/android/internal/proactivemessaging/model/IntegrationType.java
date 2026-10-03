package zendesk.android.internal.proactivemessaging.model;

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

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0006\b\u0081\u0081\u0002\u0018\u0000 \u00062\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\u0006B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0007"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/IntegrationType;", "", "(Ljava/lang/String;I)V", "ANDROID", "IOS", "WEB", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public enum IntegrationType {
    ANDROID,
    IOS,
    WEB;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return EnumsKt.createAnnotatedEnumSerializer("zendesk.android.internal.proactivemessaging.model.IntegrationType", IntegrationType.values(), new String[]{"android", "ios", "web"}, new Annotation[][]{null, null, null}, null);
        }
    });

    public static EnumEntries<IntegrationType> getEntries() {
        return $ENTRIES;
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/IntegrationType$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/IntegrationType;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) IntegrationType.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<IntegrationType> serializer() {
            return get$cachedSerializer();
        }
    }
}
