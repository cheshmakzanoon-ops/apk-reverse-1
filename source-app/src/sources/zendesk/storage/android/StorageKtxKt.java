package zendesk.storage.android;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\u001a$\u0010\u0000\u001a\u0004\u0018\u0001H\u0001\"\u0006\b\u0000\u0010\u0001\u0018\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0086\b¢\u0006\u0002\u0010\u0005\u001a#\u0010\u0006\u001a\b\u0012\u0004\u0012\u0002H\u00010\u0007\"\u0006\b\u0000\u0010\u0001\u0018\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0086\b\u001a*\u0010\b\u001a\u00020\t\"\u0006\b\u0000\u0010\u0001\u0018\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\n\u001a\u0002H\u0001H\u0086\b¢\u0006\u0002\u0010\u000b¨\u0006\f"}, m18d2 = {"get", "T", "Lzendesk/storage/android/Storage;", "key", "", "(Lzendesk/storage/android/Storage;Ljava/lang/String;)Ljava/lang/Object;", "persistedProperty", "Lzendesk/storage/android/PersistedProperty;", "set", "", "value", "(Lzendesk/storage/android/Storage;Ljava/lang/String;Ljava/lang/Object;)V", "zendesk.storage_storage-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class StorageKtxKt {
    public static final <T> T get(Storage storage, String key) {
        Intrinsics.checkNotNullParameter(storage, "<this>");
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.reifiedOperationMarker(4, "T");
        String name = Object.class.getName();
        if (name != null) {
            switch (name.hashCode()) {
                case -2056817302:
                    if (name.equals("java.lang.Integer")) {
                        T t = (T) storage.get(key, Integer.TYPE);
                        Intrinsics.reifiedOperationMarker(1, "T?");
                        return t;
                    }
                    break;
                case -527879800:
                    if (name.equals("java.lang.Float")) {
                        T t2 = (T) storage.get(key, Float.TYPE);
                        Intrinsics.reifiedOperationMarker(1, "T?");
                        return t2;
                    }
                    break;
                case 344809556:
                    if (name.equals("java.lang.Boolean")) {
                        T t3 = (T) storage.get(key, Boolean.TYPE);
                        Intrinsics.reifiedOperationMarker(1, "T?");
                        return t3;
                    }
                    break;
                case 398795216:
                    if (name.equals("java.lang.Long")) {
                        T t4 = (T) storage.get(key, Long.TYPE);
                        Intrinsics.reifiedOperationMarker(1, "T?");
                        return t4;
                    }
                    break;
            }
        }
        Intrinsics.reifiedOperationMarker(4, "T");
        return (T) storage.get(key, Object.class);
    }

    public static final <T> void set(Storage storage, String key, T t) {
        Intrinsics.checkNotNullParameter(storage, "<this>");
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.reifiedOperationMarker(4, "T");
        storage.set(key, t, Object.class);
    }

    public static final <T> PersistedProperty<T> persistedProperty(Storage storage, String key) {
        Intrinsics.checkNotNullParameter(storage, "<this>");
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.reifiedOperationMarker(4, "T");
        return new PersistedProperty<>(storage, key, Object.class);
    }
}
