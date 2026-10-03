package zendesk.storage.android;

import kotlin.Metadata;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\bf\u0018\u00002\u00020\u0001J+\u0010\u0002\u001a\u0004\u0018\u0001H\u0003\"\u0004\b\u0000\u0010\u00032\u0006\u0010\u0004\u001a\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u0002H\u00030\u0007H&¢\u0006\u0002\u0010\bJ)\u0010\t\u001a\u00020\u0005\"\u0004\b\u0000\u0010\u00032\u0006\u0010\n\u001a\u0002H\u00032\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u0002H\u00030\u0007H&¢\u0006\u0002\u0010\u000b¨\u0006\f"}, m18d2 = {"Lzendesk/storage/android/Serializer;", "", "deserialize", "T", "source", "", "type", "Ljava/lang/Class;", "(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;", "serialize", Bayeux.KEY_DATA, "(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/String;", "zendesk.storage_storage-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface Serializer {
    <T> T deserialize(String source, Class<T> type);

    <T> String serialize(T data, Class<T> type);
}
