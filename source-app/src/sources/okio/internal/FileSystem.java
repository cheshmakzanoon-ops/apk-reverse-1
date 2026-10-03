package okio.internal;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import kotlin.ExceptionsKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.ArrayDeque;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.sequences.Sequence;
import kotlin.sequences.SequenceScope;
import kotlin.sequences.SequencesKt;
import okio.BufferedSink;
import okio.FileMetadata;
import okio.Okio;
import okio.Path;
import okio.Source;

@Metadata(m17d1 = {"\u00004\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\r\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001aF\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00030\u00022\u0006\u0010\u0004\u001a\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00030\u00072\u0006\u0010\b\u001a\u00020\u00032\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\nH\u0080@¢\u0006\u0002\u0010\f\u001a\u001c\u0010\r\u001a\u00020\u0001*\u00020\u00052\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u000f\u001a\u00020\u0003H\u0000\u001a\u001c\u0010\u0010\u001a\u00020\u0001*\u00020\u00052\u0006\u0010\u0011\u001a\u00020\u00032\u0006\u0010\u0012\u001a\u00020\nH\u0000\u001a\u001c\u0010\u0013\u001a\u00020\u0001*\u00020\u00052\u0006\u0010\u0014\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\nH\u0000\u001a\u0014\u0010\u0016\u001a\u00020\n*\u00020\u00052\u0006\u0010\b\u001a\u00020\u0003H\u0000\u001a\"\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00030\u0018*\u00020\u00052\u0006\u0010\u0011\u001a\u00020\u00032\u0006\u0010\t\u001a\u00020\nH\u0000\u001a\u0014\u0010\u0019\u001a\u00020\u001a*\u00020\u00052\u0006\u0010\b\u001a\u00020\u0003H\u0000\u001a\u0016\u0010\u001b\u001a\u0004\u0018\u00010\u0003*\u00020\u00052\u0006\u0010\b\u001a\u00020\u0003H\u0000¨\u0006\u001c"}, m18d2 = {"collectRecursively", "", "Lkotlin/sequences/SequenceScope;", "Lokio/Path;", "fileSystem", "Lokio/FileSystem;", "stack", "Lkotlin/collections/ArrayDeque;", ClientCookie.PATH_ATTR, "followSymlinks", "", "postorder", "(Lkotlin/sequences/SequenceScope;Lokio/FileSystem;Lkotlin/collections/ArrayDeque;Lokio/Path;ZZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "commonCopy", "source", "target", "commonCreateDirectories", "dir", "mustCreate", "commonDeleteRecursively", "fileOrDirectory", "mustExist", "commonExists", "commonListRecursively", "Lkotlin/sequences/Sequence;", "commonMetadata", "Lokio/FileMetadata;", "symlinkTarget", "okio"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class FileSystem {

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "okio.internal.-FileSystem", m37f = "FileSystem.kt", m38i = {0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1}, m39l = {116, 135, 145}, m40m = "collectRecursively", m41n = {"$this$collectRecursively", "fileSystem", "stack", ClientCookie.PATH_ATTR, "followSymlinks", "postorder", "$this$collectRecursively", "fileSystem", "stack", ClientCookie.PATH_ATTR, "followSymlinks", "postorder"}, m42s = {"L$0", "L$1", "L$2", "L$3", "Z$0", "Z$1", "L$0", "L$1", "L$2", "L$3", "Z$0", "Z$1"})
    static final class C08911 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        boolean Z$0;
        boolean Z$1;
        int label;
        Object result;

        C08911(Continuation<? super C08911> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FileSystem.collectRecursively(null, null, null, null, false, false, this);
        }
    }

    public static final FileMetadata commonMetadata(okio.FileSystem fileSystem, Path path) throws IOException {
        Intrinsics.checkNotNullParameter(fileSystem, "<this>");
        Intrinsics.checkNotNullParameter(path, "path");
        FileMetadata fileMetadataMetadataOrNull = fileSystem.metadataOrNull(path);
        if (fileMetadataMetadataOrNull != null) {
            return fileMetadataMetadataOrNull;
        }
        throw new FileNotFoundException("no such file: " + path);
    }

    public static final boolean commonExists(okio.FileSystem fileSystem, Path path) throws IOException {
        Intrinsics.checkNotNullParameter(fileSystem, "<this>");
        Intrinsics.checkNotNullParameter(path, "path");
        return fileSystem.metadataOrNull(path) != null;
    }

    public static final void commonCreateDirectories(okio.FileSystem fileSystem, Path dir, boolean z) throws IOException {
        Intrinsics.checkNotNullParameter(fileSystem, "<this>");
        Intrinsics.checkNotNullParameter(dir, "dir");
        ArrayDeque arrayDeque = new ArrayDeque();
        for (Path pathParent = dir; pathParent != null && !fileSystem.exists(pathParent); pathParent = pathParent.parent()) {
            arrayDeque.addFirst(pathParent);
        }
        if (z && arrayDeque.isEmpty()) {
            throw new IOException(dir + " already exists.");
        }
        Iterator it = arrayDeque.iterator();
        while (it.hasNext()) {
            fileSystem.createDirectory((Path) it.next());
        }
    }

    public static final void commonDeleteRecursively(okio.FileSystem fileSystem, Path fileOrDirectory, boolean z) throws IOException {
        Intrinsics.checkNotNullParameter(fileSystem, "<this>");
        Intrinsics.checkNotNullParameter(fileOrDirectory, "fileOrDirectory");
        Iterator it = SequencesKt.sequence(new FileSystem$commonDeleteRecursively$sequence$1(fileSystem, fileOrDirectory, null)).iterator();
        while (it.hasNext()) {
            fileSystem.delete((Path) it.next(), z && !it.hasNext());
        }
    }

    @Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00030\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlin/sequences/SequenceScope;", "Lokio/Path;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "okio.internal.-FileSystem$commonListRecursively$1", m37f = "FileSystem.kt", m38i = {0, 0}, m39l = {96}, m40m = "invokeSuspend", m41n = {"$this$sequence", "stack"}, m42s = {"L$0", "L$1"})
    static final class C08921 extends RestrictedSuspendLambda implements Function2<SequenceScope<? super Path>, Continuation<? super Unit>, Object> {
        final Path $dir;
        final boolean $followSymlinks;
        final okio.FileSystem $this_commonListRecursively;
        private Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C08921(Path path, okio.FileSystem fileSystem, boolean z, Continuation<? super C08921> continuation) {
            super(2, continuation);
            this.$dir = path;
            this.$this_commonListRecursively = fileSystem;
            this.$followSymlinks = z;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C08921 c08921 = new C08921(this.$dir, this.$this_commonListRecursively, this.$followSymlinks, continuation);
            c08921.L$0 = obj;
            return c08921;
        }

        @Override
        public final Object invoke(SequenceScope<? super Path> sequenceScope, Continuation<? super Unit> continuation) {
            return ((C08921) create(sequenceScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            SequenceScope sequenceScope;
            ArrayDeque arrayDeque;
            Iterator<Path> it;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                SequenceScope sequenceScope2 = (SequenceScope) this.L$0;
                ArrayDeque arrayDeque2 = new ArrayDeque();
                arrayDeque2.addLast(this.$dir);
                sequenceScope = sequenceScope2;
                arrayDeque = arrayDeque2;
                it = this.$this_commonListRecursively.list(this.$dir).iterator();
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                it = (Iterator) this.L$2;
                ArrayDeque arrayDeque3 = (ArrayDeque) this.L$1;
                SequenceScope sequenceScope3 = (SequenceScope) this.L$0;
                ResultKt.throwOnFailure(obj);
                arrayDeque = arrayDeque3;
                sequenceScope = sequenceScope3;
            }
            while (it.hasNext()) {
                Path next = it.next();
                this.L$0 = sequenceScope;
                this.L$1 = arrayDeque;
                this.L$2 = it;
                this.label = 1;
                if (FileSystem.collectRecursively(sequenceScope, this.$this_commonListRecursively, arrayDeque, next, this.$followSymlinks, false, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            return Unit.INSTANCE;
        }
    }

    public static final Sequence<Path> commonListRecursively(okio.FileSystem fileSystem, Path dir, boolean z) throws IOException {
        Intrinsics.checkNotNullParameter(fileSystem, "<this>");
        Intrinsics.checkNotNullParameter(dir, "dir");
        return SequencesKt.sequence(new C08921(dir, fileSystem, z, null));
    }

    public static final Object collectRecursively(SequenceScope<? super Path> sequenceScope, okio.FileSystem fileSystem, ArrayDeque<Path> arrayDeque, Path path, boolean z, boolean z2, Continuation<? super Unit> continuation) throws Throwable {
        C08911 c08911;
        okio.FileSystem fileSystem2;
        ArrayDeque<Path> arrayDeque2;
        boolean z3;
        okio.FileSystem fileSystem3;
        ?? r11;
        boolean z4;
        ArrayDeque<Path> arrayDeque3;
        Path path2;
        boolean z5;
        boolean z6;
        Iterator<Path> it;
        Path next;
        Path path3 = path;
        boolean z7 = z2;
        if (continuation instanceof C08911) {
            c08911 = (C08911) continuation;
            if ((c08911.label & Integer.MIN_VALUE) != 0) {
                c08911.label -= Integer.MIN_VALUE;
            } else {
                c08911 = new C08911(continuation);
            }
        } else {
            c08911 = new C08911(continuation);
        }
        Object obj = c08911.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08911.label;
        int i2 = 0;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (z7) {
                fileSystem2 = fileSystem;
                arrayDeque2 = arrayDeque;
                z3 = z;
            } else {
                c08911.L$0 = sequenceScope;
                fileSystem2 = fileSystem;
                c08911.L$1 = fileSystem2;
                arrayDeque2 = arrayDeque;
                c08911.L$2 = arrayDeque2;
                c08911.L$3 = path3;
                z3 = z;
                c08911.Z$0 = z3;
                c08911.Z$1 = z7;
                c08911.label = 1;
                if (sequenceScope.yield(path3, c08911) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            fileSystem3 = fileSystem2;
            boolean z8 = z3;
            r11 = sequenceScope;
            z4 = z8;
        } else {
            if (i != 1) {
                if (i == 2) {
                    z6 = c08911.Z$1;
                    z5 = c08911.Z$0;
                    it = (Iterator) c08911.L$4;
                    path2 = (Path) c08911.L$3;
                    arrayDeque3 = (ArrayDeque) c08911.L$2;
                    fileSystem3 = (okio.FileSystem) c08911.L$1;
                    SequenceScope sequenceScope2 = (SequenceScope) c08911.L$0;
                    try {
                        ResultKt.throwOnFailure(obj);
                        r11 = sequenceScope2;
                        while (it.hasNext()) {
                            next = it.next();
                            c08911.L$0 = r11;
                            c08911.L$1 = fileSystem3;
                            c08911.L$2 = arrayDeque3;
                            c08911.L$3 = path2;
                            c08911.L$4 = it;
                            c08911.Z$0 = z5;
                            c08911.Z$1 = z6;
                            c08911.label = 2;
                            if (collectRecursively(r11, fileSystem3, arrayDeque3, next, z5, z6, c08911) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        }
                        arrayDeque3.removeLast();
                        z7 = z6;
                        path3 = path2;
                        if (z7) {
                            return Unit.INSTANCE;
                        }
                        c08911.L$0 = null;
                        c08911.L$1 = null;
                        c08911.L$2 = null;
                        c08911.L$3 = null;
                        c08911.L$4 = null;
                        c08911.label = 3;
                        if (r11.yield(path3, c08911) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } catch (Throwable th) {
                        th = th;
                        arrayDeque3.removeLast();
                        throw th;
                    }
                } else {
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            boolean z9 = c08911.Z$1;
            boolean z10 = c08911.Z$0;
            Path path4 = (Path) c08911.L$3;
            arrayDeque2 = (ArrayDeque) c08911.L$2;
            fileSystem3 = (okio.FileSystem) c08911.L$1;
            SequenceScope sequenceScope3 = (SequenceScope) c08911.L$0;
            ResultKt.throwOnFailure(obj);
            z7 = z9;
            z4 = z10;
            path3 = path4;
            r11 = sequenceScope3;
        }
        List<Path> listListOrNull = fileSystem3.listOrNull(path3);
        if (listListOrNull == null) {
            listListOrNull = CollectionsKt.emptyList();
        }
        if (!listListOrNull.isEmpty()) {
            Path path5 = path3;
            while (true) {
                if (z4 && arrayDeque2.contains(path5)) {
                    throw new IOException("symlink cycle at " + path3);
                }
                Path pathSymlinkTarget = symlinkTarget(fileSystem3, path5);
                if (pathSymlinkTarget != null) {
                    i2++;
                    path5 = pathSymlinkTarget;
                } else if (z4 || i2 == 0) {
                    arrayDeque2.addLast(path5);
                    try {
                        arrayDeque3 = arrayDeque2;
                        path2 = path3;
                        z5 = z4;
                        z6 = z7;
                        it = listListOrNull.iterator();
                        r11 = r11;
                        while (it.hasNext()) {
                            next = it.next();
                            c08911.L$0 = r11;
                            c08911.L$1 = fileSystem3;
                            c08911.L$2 = arrayDeque3;
                            c08911.L$3 = path2;
                            c08911.L$4 = it;
                            c08911.Z$0 = z5;
                            c08911.Z$1 = z6;
                            c08911.label = 2;
                            if (collectRecursively(r11, fileSystem3, arrayDeque3, next, z5, z6, c08911) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        }
                        arrayDeque3.removeLast();
                        z7 = z6;
                        path3 = path2;
                    } catch (Throwable th2) {
                        th = th2;
                        arrayDeque3 = arrayDeque2;
                        arrayDeque3.removeLast();
                        throw th;
                    }
                }
            }
        }
        if (z7) {
            return Unit.INSTANCE;
        }
        c08911.L$0 = null;
        c08911.L$1 = null;
        c08911.L$2 = null;
        c08911.L$3 = null;
        c08911.L$4 = null;
        c08911.label = 3;
        if (r11.yield(path3, c08911) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public static final Path symlinkTarget(okio.FileSystem fileSystem, Path path) throws IOException {
        Intrinsics.checkNotNullParameter(fileSystem, "<this>");
        Intrinsics.checkNotNullParameter(path, "path");
        Path symlinkTarget = fileSystem.metadata(path).getSymlinkTarget();
        if (symlinkTarget == null) {
            return null;
        }
        Path pathParent = path.parent();
        Intrinsics.checkNotNull(pathParent);
        return pathParent.resolve(symlinkTarget);
    }

    public static final void commonCopy(okio.FileSystem fileSystem, Path source, Path target) throws IOException {
        Long lValueOf;
        Throwable th;
        Long lValueOf2;
        Intrinsics.checkNotNullParameter(fileSystem, "<this>");
        Intrinsics.checkNotNullParameter(source, "source");
        Intrinsics.checkNotNullParameter(target, "target");
        Source source2 = fileSystem.source(source);
        Throwable th2 = null;
        try {
            Source source3 = source2;
            BufferedSink bufferedSinkBuffer = Okio.buffer(fileSystem.sink(target));
            try {
                lValueOf2 = Long.valueOf(bufferedSinkBuffer.writeAll(source3));
                if (bufferedSinkBuffer != null) {
                    try {
                        bufferedSinkBuffer.close();
                    } catch (Throwable th3) {
                        th = th3;
                    }
                }
                th = null;
            } catch (Throwable th4) {
                if (bufferedSinkBuffer != null) {
                    try {
                        bufferedSinkBuffer.close();
                    } catch (Throwable th5) {
                        ExceptionsKt.addSuppressed(th4, th5);
                    }
                }
                th = th4;
                lValueOf2 = null;
            }
            if (th != null) {
                throw th;
            }
            Intrinsics.checkNotNull(lValueOf2);
            lValueOf = Long.valueOf(lValueOf2.longValue());
            if (source2 != null) {
                try {
                    source2.close();
                } catch (Throwable th6) {
                    th2 = th6;
                }
            }
            if (th2 != null) {
                throw th2;
            }
            Intrinsics.checkNotNull(lValueOf);
        } catch (Throwable th7) {
            if (source2 != null) {
                try {
                    source2.close();
                } catch (Throwable th8) {
                    ExceptionsKt.addSuppressed(th7, th8);
                }
            }
            th2 = th7;
            lValueOf = null;
        }
    }
}
