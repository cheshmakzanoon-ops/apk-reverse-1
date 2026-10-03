package zendesk.storage.android;

import android.content.Context;
import java.io.File;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.jvm.internal.Intrinsics;
import zendesk.storage.android.internal.BasicStorage;
import zendesk.storage.android.internal.ComplexStorage;
import zendesk.storage.android.internal.FileOperators;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J(\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\u0006J\u001d\u0010\f\u001a\u00020\r2\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0000¢\u0006\u0002\b\u000e¨\u0006\u000f"}, m18d2 = {"Lzendesk/storage/android/StorageFactory;", "", "()V", "create", "Lzendesk/storage/android/Storage;", "namespace", "", "context", "Landroid/content/Context;", "type", "Lzendesk/storage/android/StorageType;", "identifier", "getDirectory", "Ljava/io/File;", "getDirectory$zendesk_storage_storage_android", "zendesk.storage_storage-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class StorageFactory {
    public static final StorageFactory INSTANCE = new StorageFactory();

    private StorageFactory() {
    }

    public final Storage create(String namespace, Context context, StorageType type, String identifier) {
        String str;
        Intrinsics.checkNotNullParameter(namespace, "namespace");
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(type, "type");
        if (type instanceof StorageType.Basic) {
            return new BasicStorage(namespace, context);
        }
        if (!(type instanceof StorageType.Complex)) {
            throw new NoWhenBranchMatchedException();
        }
        StringBuilder sb = new StringBuilder();
        sb.append(namespace);
        String str2 = "";
        if (identifier != null) {
            str = "." + identifier;
            if (str == null) {
                str = "";
            }
        } else {
            str = "";
        }
        sb.append(str);
        String string = sb.toString();
        File directory$zendesk_storage_storage_android = getDirectory$zendesk_storage_storage_android(namespace, context);
        StringBuilder sb2 = new StringBuilder();
        sb2.append(namespace);
        if (identifier != null) {
            String str3 = "." + identifier;
            if (str3 != null) {
                str2 = str3;
            }
        }
        sb2.append(str2);
        return new ComplexStorage(string, directory$zendesk_storage_storage_android, getDirectory$zendesk_storage_storage_android(sb2.toString(), context), ((StorageType.Complex) type).getSerializer(), new FileOperators());
    }

    public final File getDirectory$zendesk_storage_storage_android(String namespace, Context context) {
        Intrinsics.checkNotNullParameter(namespace, "namespace");
        Intrinsics.checkNotNullParameter(context, "context");
        return new File(context.getCacheDir().getPath() + '/' + namespace);
    }
}
