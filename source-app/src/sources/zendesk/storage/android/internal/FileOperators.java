package zendesk.storage.android.internal;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.p002io.CloseableKt;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J'\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0017\u0010\u0007\u001a\u0013\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\nJ'\u0010\u000b\u001a\u00020\f2\u0006\u0010\u0005\u001a\u00020\u00062\u0017\u0010\u0007\u001a\u0013\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\f0\b¢\u0006\u0002\b\n¨\u0006\u000e"}, m18d2 = {"Lzendesk/storage/android/internal/FileOperators;", "", "()V", "reader", "", "file", "Ljava/io/File;", "block", "Lkotlin/Function1;", "Ljava/io/FileReader;", "Lkotlin/ExtensionFunctionType;", "writer", "", "Ljava/io/FileWriter;", "zendesk.storage_storage-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FileOperators {
    public final String reader(File file, Function1<? super FileReader, String> block) {
        Intrinsics.checkNotNullParameter(file, "file");
        Intrinsics.checkNotNullParameter(block, "block");
        FileReader fileReader = new FileReader(file);
        try {
            String strInvoke = block.invoke(fileReader);
            CloseableKt.closeFinally(fileReader, null);
            return strInvoke;
        } catch (Throwable th) {
            try {
                throw th;
            } catch (Throwable th2) {
                CloseableKt.closeFinally(fileReader, th);
                throw th2;
            }
        }
    }

    public final void writer(File file, Function1<? super FileWriter, Unit> block) {
        Intrinsics.checkNotNullParameter(file, "file");
        Intrinsics.checkNotNullParameter(block, "block");
        FileWriter fileWriter = new FileWriter(file);
        try {
            block.invoke(fileWriter);
            CloseableKt.closeFinally(fileWriter, null);
        } catch (Throwable th) {
            try {
                throw th;
            } catch (Throwable th2) {
                CloseableKt.closeFinally(fileWriter, th);
                throw th2;
            }
        }
    }
}
