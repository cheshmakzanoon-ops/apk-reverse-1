package kotlinx.serialization.descriptors;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlinx.serialization.ExperimentalSerializationApi;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001:\u0002\u0003\u0004B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0002\u0005\u0006¨\u0006\u0007"}, m18d2 = {"Lkotlinx/serialization/descriptors/PolymorphicKind;", "Lkotlinx/serialization/descriptors/SerialKind;", "()V", "OPEN", "SEALED", "Lkotlinx/serialization/descriptors/PolymorphicKind$OPEN;", "Lkotlinx/serialization/descriptors/PolymorphicKind$SEALED;", "kotlinx-serialization-core"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@ExperimentalSerializationApi
public abstract class PolymorphicKind extends SerialKind {
    public PolymorphicKind(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private PolymorphicKind() {
        super(null);
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lkotlinx/serialization/descriptors/PolymorphicKind$SEALED;", "Lkotlinx/serialization/descriptors/PolymorphicKind;", "()V", "kotlinx-serialization-core"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SEALED extends PolymorphicKind {
        public static final SEALED INSTANCE = new SEALED();

        private SEALED() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lkotlinx/serialization/descriptors/PolymorphicKind$OPEN;", "Lkotlinx/serialization/descriptors/PolymorphicKind;", "()V", "kotlinx-serialization-core"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class OPEN extends PolymorphicKind {
        public static final OPEN INSTANCE = new OPEN();

        private OPEN() {
            super(null);
        }
    }
}
