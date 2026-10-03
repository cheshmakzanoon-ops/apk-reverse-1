package zendesk.storage.android.internal;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.p002io.TextStreamsKt;
import zendesk.logger.Logger;
import zendesk.storage.android.Serializer;
import zendesk.storage.android.Storage;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\r\b\u0000\u0018\u0000  2\u00020\u0001:\u0001 B-\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bJ\b\u0010\u000e\u001a\u00020\u000fH\u0016J+\u0010\u0010\u001a\u0004\u0018\u0001H\u0011\"\u0004\b\u0000\u0010\u00112\u0006\u0010\u0012\u001a\u00020\u00032\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u0002H\u00110\u0014H\u0016¢\u0006\u0002\u0010\u0015J\u0015\u0010\u0016\u001a\u00020\u00052\u0006\u0010\u0017\u001a\u00020\u0003H\u0000¢\u0006\u0002\b\u0018J\u0015\u0010\u0019\u001a\u00020\u000f2\u0006\u0010\u001a\u001a\u00020\u0005H\u0000¢\u0006\u0002\b\u001bJ\u0010\u0010\u001c\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u0003H\u0016J3\u0010\u001d\u001a\u00020\u000f\"\u0004\b\u0000\u0010\u00112\u0006\u0010\u0012\u001a\u00020\u00032\b\u0010\u001e\u001a\u0004\u0018\u0001H\u00112\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u0002H\u00110\u0014H\u0016¢\u0006\u0002\u0010\u001fR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006!"}, m18d2 = {"Lzendesk/storage/android/internal/ComplexStorage;", "Lzendesk/storage/android/Storage;", "namespace", "", "baseDirectory", "Ljava/io/File;", "directory", "serializer", "Lzendesk/storage/android/Serializer;", "fileOperators", "Lzendesk/storage/android/internal/FileOperators;", "(Ljava/lang/String;Ljava/io/File;Ljava/io/File;Lzendesk/storage/android/Serializer;Lzendesk/storage/android/internal/FileOperators;)V", "getNamespace", "()Ljava/lang/String;", "clear", "", "get", "T", "key", "type", "Ljava/lang/Class;", "(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;", "getFile", "name", "getFile$zendesk_storage_storage_android", "recursiveClear", "file", "recursiveClear$zendesk_storage_storage_android", "remove", "set", "value", "(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Class;)V", "Companion", "zendesk.storage_storage-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ComplexStorage implements Storage {
    private static final String LOG_TAG = "ComplexStorage";
    private final File baseDirectory;
    private final File directory;
    private final FileOperators fileOperators;
    private final String namespace;
    private final Serializer serializer;

    public ComplexStorage(String namespace, File baseDirectory, File directory, Serializer serializer, FileOperators fileOperators) {
        Intrinsics.checkNotNullParameter(namespace, "namespace");
        Intrinsics.checkNotNullParameter(baseDirectory, "baseDirectory");
        Intrinsics.checkNotNullParameter(directory, "directory");
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        Intrinsics.checkNotNullParameter(fileOperators, "fileOperators");
        this.namespace = namespace;
        this.baseDirectory = baseDirectory;
        this.directory = directory;
        this.serializer = serializer;
        this.fileOperators = fileOperators;
        if (!baseDirectory.isDirectory()) {
            if (directory.isDirectory()) {
                return;
            }
            directory.mkdirs();
            return;
        }
        baseDirectory.renameTo(directory);
    }

    @Override
    public String getNamespace() {
        return this.namespace;
    }

    @Override
    public <T> T get(String key, Class<T> type) {
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.checkNotNullParameter(type, "type");
        File file$zendesk_storage_storage_android = getFile$zendesk_storage_storage_android(key);
        if (!file$zendesk_storage_storage_android.exists()) {
            Logger.m225w(LOG_TAG, "There is no stored data for the given key", new Object[0]);
            return null;
        }
        try {
            return (T) this.serializer.deserialize(this.fileOperators.reader(file$zendesk_storage_storage_android, new Function1<FileReader, String>() {
                @Override
                public final String invoke(FileReader reader) {
                    Intrinsics.checkNotNullParameter(reader, "$this$reader");
                    return TextStreamsKt.readText(reader);
                }
            }), type);
        } catch (FileNotFoundException e) {
            Logger.m224w(LOG_TAG, String.valueOf(e.getMessage()), e, new Object[0]);
            return null;
        }
    }

    @Override
    public <T> void set(String key, final T value, final Class<T> type) {
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.checkNotNullParameter(type, "type");
        if (value == null) {
            getFile$zendesk_storage_storage_android(key).delete();
            return;
        }
        try {
            this.fileOperators.writer(getFile$zendesk_storage_storage_android(key), new Function1<FileWriter, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(FileWriter fileWriter) {
                    invoke2(fileWriter);
                    return Unit.INSTANCE;
                }

                public final void invoke2(FileWriter writer) {
                    Intrinsics.checkNotNullParameter(writer, "$this$writer");
                    writer.write(ComplexStorage.this.serializer.serialize(value, type));
                }
            });
        } catch (IOException e) {
            Logger.m224w(LOG_TAG, String.valueOf(e.getMessage()), e, new Object[0]);
        }
    }

    @Override
    public void remove(String key) {
        Intrinsics.checkNotNullParameter(key, "key");
        File file$zendesk_storage_storage_android = getFile$zendesk_storage_storage_android(key);
        if (file$zendesk_storage_storage_android.exists()) {
            file$zendesk_storage_storage_android.delete();
        }
    }

    @Override
    public void clear() {
        recursiveClear$zendesk_storage_storage_android(this.directory);
    }

    public final void recursiveClear$zendesk_storage_storage_android(File file) {
        Intrinsics.checkNotNullParameter(file, "file");
        if (!file.isDirectory()) {
            file.delete();
            return;
        }
        File[] fileArrListFiles = file.listFiles();
        if (fileArrListFiles != null) {
            for (File file2 : fileArrListFiles) {
                recursiveClear$zendesk_storage_storage_android(file2);
            }
        }
        file.delete();
    }

    public final File getFile$zendesk_storage_storage_android(String name) {
        File file;
        Intrinsics.checkNotNullParameter(name, "name");
        if (!this.directory.isDirectory()) {
            this.directory.mkdirs();
            return new File(this.directory.getPath(), name);
        }
        File[] fileArrListFiles = this.directory.listFiles();
        if (fileArrListFiles != null) {
            int length = fileArrListFiles.length;
            int i = 0;
            while (true) {
                if (i >= length) {
                    file = null;
                    break;
                }
                file = fileArrListFiles[i];
                if (Intrinsics.areEqual(file.getName(), name)) {
                    break;
                }
                i++;
            }
            if (file != null) {
                return file;
            }
        }
        return new File(this.directory.getPath(), name);
    }
}
