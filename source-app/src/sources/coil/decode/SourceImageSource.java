package coil.decode;

import androidx.constraintlayout.widget.ConstraintLayout;
import coil.util.Utils;
import com.facebook.share.internal.ShareConstants;
import com.facebook.share.internal.ShareInternalUtility;
import java.io.Closeable;
import java.io.File;
import kotlin.ExceptionsKt;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import okio.BufferedSink;
import okio.BufferedSource;
import okio.FileSystem;
import okio.Okio;
import okio.Path;
import okio.Source;

@Metadata(d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\tJ\b\u0010\u0014\u001a\u00020\u0015H\u0002J\b\u0010\u0016\u001a\u00020\u0015H\u0016J\b\u0010\u0017\u001a\u00020\u000bH\u0002J\b\u0010\n\u001a\u00020\u000bH\u0016J\n\u0010\u0018\u001a\u0004\u0018\u00010\u000bH\u0016J\b\u0010\u0002\u001a\u00020\u0003H\u0016J\b\u0010\u0019\u001a\u00020\u0003H\u0016R\u0016\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\n\u001a\u0004\u0018\u00010\u000bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\f\u001a\u00020\r8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000fR\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0010\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u001a"}, d2 = {"Lcoil/decode/SourceImageSource;", "Lcoil/decode/ImageSource;", ShareConstants.FEED_SOURCE_PARAM, "Lokio/BufferedSource;", "cacheDirectoryFactory", "Lkotlin/Function0;", "Ljava/io/File;", "metadata", "Lcoil/decode/ImageSource$Metadata;", "(Lokio/BufferedSource;Lkotlin/jvm/functions/Function0;Lcoil/decode/ImageSource$Metadata;)V", ShareInternalUtility.STAGING_PARAM, "Lokio/Path;", "fileSystem", "Lokio/FileSystem;", "getFileSystem", "()Lokio/FileSystem;", "isClosed", "", "getMetadata", "()Lcoil/decode/ImageSource$Metadata;", "assertNotClosed", "", "close", "createTempFile", "fileOrNull", "sourceOrNull", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class SourceImageSource extends ImageSource {
    private Function0<? extends File> cacheDirectoryFactory;
    private Path file;
    private boolean isClosed;
    private final ImageSource.Metadata metadata;
    private BufferedSource source;

    @Override
    public ImageSource.Metadata getMetadata() {
        return this.metadata;
    }

    public SourceImageSource(BufferedSource bufferedSource, Function0<? extends File> function0, ImageSource.Metadata metadata) {
        super(null);
        this.metadata = metadata;
        this.source = bufferedSource;
        this.cacheDirectoryFactory = function0;
    }

    @Override
    public FileSystem getFileSystem() {
        return FileSystem.SYSTEM;
    }

    @Override
    public synchronized BufferedSource source() {
        assertNotClosed();
        BufferedSource bufferedSource = this.source;
        if (bufferedSource != null) {
            return bufferedSource;
        }
        FileSystem fileSystem = getFileSystem();
        Path path = this.file;
        Intrinsics.checkNotNull(path);
        BufferedSource bufferedSourceBuffer = Okio.buffer(fileSystem.source(path));
        this.source = bufferedSourceBuffer;
        return bufferedSourceBuffer;
    }

    @Override
    public BufferedSource sourceOrNull() {
        return source();
    }

    @Override
    public synchronized Path file() {
        Throwable th;
        Long lValueOf;
        assertNotClosed();
        Path path = this.file;
        if (path != null) {
            return path;
        }
        Path pathCreateTempFile = createTempFile();
        BufferedSink bufferedSink = (Closeable) Okio.buffer(getFileSystem().sink(pathCreateTempFile, false));
        try {
            Source source = this.source;
            Intrinsics.checkNotNull(source);
            lValueOf = Long.valueOf(bufferedSink.writeAll(source));
            if (bufferedSink != null) {
                try {
                    bufferedSink.close();
                } catch (Throwable th2) {
                    th = th2;
                }
            }
            th = null;
        } catch (Throwable th3) {
            if (bufferedSink != null) {
                try {
                    bufferedSink.close();
                } catch (Throwable th4) {
                    ExceptionsKt.addSuppressed(th3, th4);
                }
            }
            th = th3;
            lValueOf = null;
        }
        if (th != null) {
            throw th;
        }
        Intrinsics.checkNotNull(lValueOf);
        this.source = null;
        this.file = pathCreateTempFile;
        this.cacheDirectoryFactory = null;
        return pathCreateTempFile;
    }

    @Override
    public synchronized Path fileOrNull() {
        assertNotClosed();
        return this.file;
    }

    @Override
    public synchronized void close() {
        this.isClosed = true;
        Closeable closeable = this.source;
        if (closeable != null) {
            Utils.closeQuietly(closeable);
        }
        Path path = this.file;
        if (path != null) {
            getFileSystem().delete(path);
        }
    }

    private final Path createTempFile() {
        Function0<? extends File> function0 = this.cacheDirectoryFactory;
        Intrinsics.checkNotNull(function0);
        File file = (File) function0.invoke();
        if (!file.isDirectory()) {
            throw new IllegalStateException("cacheDirectory must be a directory.".toString());
        }
        return Path.Companion.get$default(Path.Companion, File.createTempFile("tmp", null, file), false, 1, (Object) null);
    }

    private final void assertNotClosed() {
        if (this.isClosed) {
            throw new IllegalStateException("closed".toString());
        }
    }
}
