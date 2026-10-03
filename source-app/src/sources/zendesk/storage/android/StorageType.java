package zendesk.storage.android;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b6\u0018\u00002\u00020\u0001:\u0002\u0003\u0004B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0002\u0005\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/storage/android/StorageType;", "", "()V", "Basic", "Complex", "Lzendesk/storage/android/StorageType$Basic;", "Lzendesk/storage/android/StorageType$Complex;", "zendesk.storage_storage-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class StorageType {
    public StorageType(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private StorageType() {
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/storage/android/StorageType$Basic;", "Lzendesk/storage/android/StorageType;", "()V", "zendesk.storage_storage-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Basic extends StorageType {
        public static final Basic INSTANCE = new Basic();

        private Basic() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/storage/android/StorageType$Complex;", "Lzendesk/storage/android/StorageType;", "serializer", "Lzendesk/storage/android/Serializer;", "(Lzendesk/storage/android/Serializer;)V", "getSerializer", "()Lzendesk/storage/android/Serializer;", "zendesk.storage_storage-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Complex extends StorageType {
        private final Serializer serializer;

        public Complex(Serializer serializer) {
            super(null);
            Intrinsics.checkNotNullParameter(serializer, "serializer");
            this.serializer = serializer;
        }

        public final Serializer getSerializer() {
            return this.serializer;
        }
    }
}
