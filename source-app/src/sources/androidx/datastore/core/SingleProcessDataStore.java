package androidx.datastore.core;

import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.datastore.core.handlers.NoOpCorruptionHandler;
import androidx.exifinterface.media.ExifInterface;
import com.facebook.share.internal.ShareInternalUtility;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CancellationException;
import kotlin.ExceptionsKt;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.io.CloseableKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CompletableDeferred;
import kotlinx.coroutines.CompletableDeferredKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.SupervisorKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;

@Metadata(d1 = {"\u0000\u0088\u0001\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\f\b\u0000\u0018\u0000 F*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002:\u0003FGHB\u007f\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00028\u00000\u0007\u0012?\b\u0002\u0010\b\u001a9\u00125\u00123\b\u0001\u0012\u0019\u0012\u0017\u0012\u0004\u0012\u00028\u00000\u000b¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00100\u000f\u0012\u0006\u0012\u0004\u0018\u00010\u00110\n0\t\u0012\u000e\b\u0002\u0010\u0012\u001a\b\u0012\u0004\u0012\u00028\u00000\u0013\u0012\b\b\u0002\u0010\u0014\u001a\u00020\u0015ø\u0001\u0000¢\u0006\u0002\u0010\u0016J\u001f\u0010+\u001a\u00020\u00102\f\u0010,\u001a\b\u0012\u0004\u0012\u00028\u00000-H\u0082@ø\u0001\u0000¢\u0006\u0002\u0010.J\u001f\u0010/\u001a\u00020\u00102\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u000001H\u0082@ø\u0001\u0000¢\u0006\u0002\u00102J\u0011\u00103\u001a\u00020\u0010H\u0082@ø\u0001\u0000¢\u0006\u0002\u00104J\u0011\u00105\u001a\u00020\u0010H\u0082@ø\u0001\u0000¢\u0006\u0002\u00104J\u0011\u00106\u001a\u00020\u0010H\u0082@ø\u0001\u0000¢\u0006\u0002\u00104J\u0011\u00107\u001a\u00028\u0000H\u0082@ø\u0001\u0000¢\u0006\u0002\u00104J\u0011\u00108\u001a\u00028\u0000H\u0082@ø\u0001\u0000¢\u0006\u0002\u00104JL\u00109\u001a\u00028\u000021\u0010:\u001a-\b\u0001\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(;\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u000f\u0012\u0006\u0012\u0004\u0018\u00010\u00110\n2\u0006\u0010<\u001a\u00020=H\u0082@ø\u0001\u0000¢\u0006\u0002\u0010>JD\u0010?\u001a\u00028\u000021\u0010:\u001a-\b\u0001\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(;\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u000f\u0012\u0006\u0012\u0004\u0018\u00010\u00110\nH\u0096@ø\u0001\u0000¢\u0006\u0002\u0010@J\u001b\u0010A\u001a\u00020\u00102\u0006\u0010B\u001a\u00028\u0000H\u0080@ø\u0001\u0000¢\u0006\u0004\bC\u0010DJ\f\u0010E\u001a\u00020\u0010*\u00020\u0005H\u0002R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082D¢\u0006\u0002\n\u0000R\u001a\u0010\u0019\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u001b0\u001aX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0012\u001a\b\u0012\u0004\u0012\u00028\u00000\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u001c\u001a\b\u0012\u0004\u0012\u00028\u00000\u001dX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR \u0010 \u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\"0!X\u0082\u0004¢\u0006\b\n\u0000\u0012\u0004\b#\u0010$R\u001b\u0010%\u001a\u00020\u00058BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b(\u0010)\u001a\u0004\b&\u0010'RJ\u0010*\u001a;\u00125\u00123\b\u0001\u0012\u0019\u0012\u0017\u0012\u0004\u0012\u00028\u00000\u000b¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00100\u000f\u0012\u0006\u0012\u0004\u0018\u00010\u00110\n\u0018\u00010\tX\u0082\u000eø\u0001\u0000¢\u0006\u0002\n\u0000R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00028\u00000\u0007X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0004\n\u0002\b\u0019¨\u0006I"}, d2 = {"Landroidx/datastore/core/SingleProcessDataStore;", ExifInterface.GPS_DIRECTION_TRUE, "Landroidx/datastore/core/DataStore;", "produceFile", "Lkotlin/Function0;", "Ljava/io/File;", "serializer", "Landroidx/datastore/core/Serializer;", "initTasksList", "", "Lkotlin/Function2;", "Landroidx/datastore/core/InitializerApi;", "Lkotlin/ParameterName;", "name", "api", "Lkotlin/coroutines/Continuation;", "", "", "corruptionHandler", "Landroidx/datastore/core/CorruptionHandler;", "scope", "Lkotlinx/coroutines/CoroutineScope;", "(Lkotlin/jvm/functions/Function0;Landroidx/datastore/core/Serializer;Ljava/util/List;Landroidx/datastore/core/CorruptionHandler;Lkotlinx/coroutines/CoroutineScope;)V", "SCRATCH_SUFFIX", "", "actor", "Landroidx/datastore/core/SimpleActor;", "Landroidx/datastore/core/SingleProcessDataStore$Message;", "data", "Lkotlinx/coroutines/flow/Flow;", "getData", "()Lkotlinx/coroutines/flow/Flow;", "downstreamFlow", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Landroidx/datastore/core/State;", "getDownstreamFlow$annotations", "()V", ShareInternalUtility.STAGING_PARAM, "getFile", "()Ljava/io/File;", "file$delegate", "Lkotlin/Lazy;", "initTasks", "handleRead", "read", "Landroidx/datastore/core/SingleProcessDataStore$Message$Read;", "(Landroidx/datastore/core/SingleProcessDataStore$Message$Read;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handleUpdate", "update", "Landroidx/datastore/core/SingleProcessDataStore$Message$Update;", "(Landroidx/datastore/core/SingleProcessDataStore$Message$Update;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "readAndInit", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "readAndInitOrPropagateAndThrowFailure", "readAndInitOrPropagateFailure", "readData", "readDataOrHandleCorruption", "transformAndWrite", "transform", "t", "callerContext", "Lkotlin/coroutines/CoroutineContext;", "(Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/CoroutineContext;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateData", "(Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "writeData", "newData", "writeData$datastore_core", "(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createParentDirectories", "Companion", "Message", "UncloseableOutputStream", "datastore-core"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class SingleProcessDataStore<T> implements DataStore<T> {

    public static final Companion INSTANCE = new Companion(null);
    private static final Set<String> activeFiles = new LinkedHashSet();
    private static final Object activeFilesLock = new Object();
    private final String SCRATCH_SUFFIX;
    private final SimpleActor<Message<T>> actor;
    private final CorruptionHandler<T> corruptionHandler;
    private final Flow<T> data;
    private final MutableStateFlow<State<T>> downstreamFlow;

    private final Lazy file;
    private List<? extends Function2<? super InitializerApi<T>, ? super Continuation<? super Unit>, ? extends Object>> initTasks;
    private final Function0<File> produceFile;
    private final CoroutineScope scope;
    private final Serializer<T> serializer;

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.datastore.core.SingleProcessDataStore", f = "SingleProcessDataStore.kt", i = {1, 1}, l = {276, 281, 284}, m = "handleUpdate", n = {"update", "$this$handleUpdate_u24lambda_u2d0"}, s = {"L$0", "L$1"})
    static final class C02171 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;
        final SingleProcessDataStore<T> this$0;

        C02171(SingleProcessDataStore<T> singleProcessDataStore, Continuation<? super C02171> continuation) {
            super(continuation);
            this.this$0 = singleProcessDataStore;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.handleUpdate(null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.datastore.core.SingleProcessDataStore", f = "SingleProcessDataStore.kt", i = {0, 0, 1, 1, 1, 2}, l = {322, 348, TypedValues.PositionType.TYPE_SIZE_PERCENT}, m = "readAndInit", n = {"updateLock", "initData", "updateLock", "initData", "initializationComplete", "$this$withLock_u24default$iv"}, s = {"L$1", "L$2", "L$1", "L$2", "L$3", "L$3"})
    static final class C02181 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        int label;
        Object result;
        final SingleProcessDataStore<T> this$0;

        C02181(SingleProcessDataStore<T> singleProcessDataStore, Continuation<? super C02181> continuation) {
            super(continuation);
            this.this$0 = singleProcessDataStore;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.readAndInit((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.datastore.core.SingleProcessDataStore", f = "SingleProcessDataStore.kt", i = {0}, l = {302}, m = "readAndInitOrPropagateAndThrowFailure", n = {"this"}, s = {"L$0"})
    static final class C02191 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;
        final SingleProcessDataStore<T> this$0;

        C02191(SingleProcessDataStore<T> singleProcessDataStore, Continuation<? super C02191> continuation) {
            super(continuation);
            this.this$0 = singleProcessDataStore;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.readAndInitOrPropagateAndThrowFailure((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.datastore.core.SingleProcessDataStore", f = "SingleProcessDataStore.kt", i = {0}, l = {311}, m = "readAndInitOrPropagateFailure", n = {"this"}, s = {"L$0"})
    static final class C02201 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;
        final SingleProcessDataStore<T> this$0;

        C02201(SingleProcessDataStore<T> singleProcessDataStore, Continuation<? super C02201> continuation) {
            super(continuation);
            this.this$0 = singleProcessDataStore;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.readAndInitOrPropagateFailure((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.datastore.core.SingleProcessDataStore", f = "SingleProcessDataStore.kt", i = {0}, l = {381}, m = "readData", n = {"this"}, s = {"L$0"})
    static final class C02211 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;
        final SingleProcessDataStore<T> this$0;

        C02211(SingleProcessDataStore<T> singleProcessDataStore, Continuation<? super C02211> continuation) {
            super(continuation);
            this.this$0 = singleProcessDataStore;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.readData((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.datastore.core.SingleProcessDataStore", f = "SingleProcessDataStore.kt", i = {0, 1, 2, 2}, l = {359, 362, 365}, m = "readDataOrHandleCorruption", n = {"this", "ex", "ex", "newData"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C02221 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;
        final SingleProcessDataStore<T> this$0;

        C02221(SingleProcessDataStore<T> singleProcessDataStore, Continuation<? super C02221> continuation) {
            super(continuation);
            this.this$0 = singleProcessDataStore;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.readDataOrHandleCorruption((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.datastore.core.SingleProcessDataStore", f = "SingleProcessDataStore.kt", i = {0, 0, 0}, l = {TypedValues.CycleType.TYPE_VISIBILITY, 410}, m = "transformAndWrite", n = {"this", "curDataAndHash", "curData"}, s = {"L$0", "L$1", "L$2"})
    static final class C02231 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;
        final SingleProcessDataStore<T> this$0;

        C02231(SingleProcessDataStore<T> singleProcessDataStore, Continuation<? super C02231> continuation) {
            super(continuation);
            this.this$0 = singleProcessDataStore;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.transformAndWrite(null, null, (Continuation) this);
        }
    }

    private static void getDownstreamFlow$annotations() {
    }

    public SingleProcessDataStore(Function0<? extends File> function0, Serializer<T> serializer, List<? extends Function2<? super InitializerApi<T>, ? super Continuation<? super Unit>, ? extends Object>> list, CorruptionHandler<T> corruptionHandler, CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(function0, "produceFile");
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        Intrinsics.checkNotNullParameter(list, "initTasksList");
        Intrinsics.checkNotNullParameter(corruptionHandler, "corruptionHandler");
        Intrinsics.checkNotNullParameter(coroutineScope, "scope");
        this.produceFile = function0;
        this.serializer = serializer;
        this.corruptionHandler = corruptionHandler;
        this.scope = coroutineScope;
        this.data = FlowKt.flow(new SingleProcessDataStore$data$1(this, null));
        this.SCRATCH_SUFFIX = ".tmp";
        this.file = LazyKt.lazy(new Function0<File>(this) {
            final SingleProcessDataStore<T> this$0;

            {
                super(0);
                this.this$0 = this;
            }

            public final File m2170invoke() {
                File file = (File) ((SingleProcessDataStore) this.this$0).produceFile.invoke();
                String absolutePath = file.getAbsolutePath();
                synchronized (SingleProcessDataStore.INSTANCE.getActiveFilesLock$datastore_core()) {
                    if (SingleProcessDataStore.INSTANCE.getActiveFiles$datastore_core().contains(absolutePath)) {
                        throw new IllegalStateException(("There are multiple DataStores active for the same file: " + file + ". You should either maintain your DataStore as a singleton or confirm that there is no two DataStore's active on the same file (by confirming that the scope is cancelled).").toString());
                    }
                    Set<String> activeFiles$datastore_core = SingleProcessDataStore.INSTANCE.getActiveFiles$datastore_core();
                    Intrinsics.checkNotNullExpressionValue(absolutePath, "it");
                    activeFiles$datastore_core.add(absolutePath);
                }
                return file;
            }
        });
        this.downstreamFlow = StateFlowKt.MutableStateFlow(UnInitialized.INSTANCE);
        this.initTasks = CollectionsKt.toList(list);
        this.actor = new SimpleActor<>(coroutineScope, new Function1<Throwable, Unit>(this) {
            final SingleProcessDataStore<T> this$0;

            {
                super(1);
                this.this$0 = this;
            }

            public Object invoke(Object obj) {
                invoke((Throwable) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Throwable th) {
                if (th != null) {
                    ((SingleProcessDataStore) this.this$0).downstreamFlow.setValue(new Final(th));
                }
                Object activeFilesLock$datastore_core = SingleProcessDataStore.INSTANCE.getActiveFilesLock$datastore_core();
                SingleProcessDataStore<T> singleProcessDataStore = this.this$0;
                synchronized (activeFilesLock$datastore_core) {
                    SingleProcessDataStore.INSTANCE.getActiveFiles$datastore_core().remove(singleProcessDataStore.getFile().getAbsolutePath());
                    Unit unit = Unit.INSTANCE;
                }
            }
        }, new Function2<Message<T>, Throwable, Unit>() {
            public Object invoke(Object obj, Object obj2) {
                invoke((SingleProcessDataStore.Message) obj, (Throwable) obj2);
                return Unit.INSTANCE;
            }

            public final void invoke(SingleProcessDataStore.Message<T> message, Throwable th) {
                Intrinsics.checkNotNullParameter(message, "msg");
                if (message instanceof SingleProcessDataStore.Message.Update) {
                    CompletableDeferred<T> ack = ((SingleProcessDataStore.Message.Update) message).getAck();
                    if (th == null) {
                        th = new CancellationException("DataStore scope was cancelled before updateData could complete");
                    }
                    ack.completeExceptionally(th);
                }
            }
        }, new SingleProcessDataStore$actor$3(this, null));
    }

    public SingleProcessDataStore(Function0 function0, Serializer serializer, List list, NoOpCorruptionHandler noOpCorruptionHandler, CoroutineScope coroutineScope, int i, DefaultConstructorMarker defaultConstructorMarker) {
        List listEmptyList = (i & 4) != 0 ? CollectionsKt.emptyList() : list;
        CorruptionHandler noOpCorruptionHandler2 = (i & 8) != 0 ? new NoOpCorruptionHandler() : noOpCorruptionHandler;
        if ((i & 16) != 0) {
            Dispatchers dispatchers = Dispatchers.INSTANCE;
            coroutineScope = CoroutineScopeKt.CoroutineScope(Dispatchers.getIO().plus(SupervisorKt.SupervisorJob$default((Job) null, 1, (Object) null)));
        }
        this(function0, serializer, listEmptyList, noOpCorruptionHandler2, coroutineScope);
    }

    @Override
    public Flow<T> getData() {
        return this.data;
    }

    @Override
    public Object updateData(Function2<? super T, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) throws Throwable {
        CompletableDeferred completableDeferredCompletableDeferred$default = CompletableDeferredKt.CompletableDeferred$default((Job) null, 1, (Object) null);
        this.actor.offer(new Message.Update(function2, completableDeferredCompletableDeferred$default, (State) this.downstreamFlow.getValue(), continuation.getContext()));
        return completableDeferredCompletableDeferred$default.await(continuation);
    }

    public final File getFile() {
        return (File) this.file.getValue();
    }

    @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b2\u0018\u0000*\u0004\b\u0001\u0010\u00012\u00020\u0002:\u0002\b\tB\u0007\b\u0004¢\u0006\u0002\u0010\u0003R\u001a\u0010\u0004\u001a\n\u0012\u0004\u0012\u00028\u0001\u0018\u00010\u0005X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007\u0082\u0001\u0002\n\u000b¨\u0006\f"}, d2 = {"Landroidx/datastore/core/SingleProcessDataStore$Message;", ExifInterface.GPS_DIRECTION_TRUE, "", "()V", "lastState", "Landroidx/datastore/core/State;", "getLastState", "()Landroidx/datastore/core/State;", "Read", "Update", "Landroidx/datastore/core/SingleProcessDataStore$Message$Read;", "Landroidx/datastore/core/SingleProcessDataStore$Message$Update;", "datastore-core"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    static abstract class Message<T> {
        public Message(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public abstract State<T> getLastState();

        private Message() {
        }

        @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\u0018\u0000*\u0004\b\u0002\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B\u0015\u0012\u000e\u0010\u0003\u001a\n\u0012\u0004\u0012\u00028\u0002\u0018\u00010\u0004¢\u0006\u0002\u0010\u0005R\u001c\u0010\u0003\u001a\n\u0012\u0004\u0012\u00028\u0002\u0018\u00010\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\b"}, d2 = {"Landroidx/datastore/core/SingleProcessDataStore$Message$Read;", ExifInterface.GPS_DIRECTION_TRUE, "Landroidx/datastore/core/SingleProcessDataStore$Message;", "lastState", "Landroidx/datastore/core/State;", "(Landroidx/datastore/core/State;)V", "getLastState", "()Landroidx/datastore/core/State;", "datastore-core"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Read<T> extends Message<T> {
            private final State<T> lastState;

            @Override
            public State<T> getLastState() {
                return this.lastState;
            }

            public Read(State<T> state) {
                super(null);
                this.lastState = state;
            }
        }

        @Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\u0018\u0000*\u0004\b\u0002\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002Ba\u00121\u0010\u0003\u001a-\b\u0001\u0012\u0013\u0012\u00118\u0002¢\u0006\f\b\u0005\u0012\b\b\u0006\u0012\u0004\b\b(\u0007\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00020\b\u0012\u0006\u0012\u0004\u0018\u00010\t0\u0004\u0012\f\u0010\n\u001a\b\u0012\u0004\u0012\u00028\u00020\u000b\u0012\u000e\u0010\f\u001a\n\u0012\u0004\u0012\u00028\u0002\u0018\u00010\r\u0012\u0006\u0010\u000e\u001a\u00020\u000fø\u0001\u0000¢\u0006\u0002\u0010\u0010R\u0017\u0010\n\u001a\b\u0012\u0004\u0012\u00028\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u001c\u0010\f\u001a\n\u0012\u0004\u0012\u00028\u0002\u0018\u00010\rX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016RA\u0010\u0003\u001a-\b\u0001\u0012\u0013\u0012\u00118\u0002¢\u0006\f\b\u0005\u0012\b\b\u0006\u0012\u0004\b\b(\u0007\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00020\b\u0012\u0006\u0012\u0004\u0018\u00010\t0\u0004ø\u0001\u0000¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\u0017\u0010\u0018\u0082\u0002\u0004\n\u0002\b\u0019¨\u0006\u001a"}, d2 = {"Landroidx/datastore/core/SingleProcessDataStore$Message$Update;", ExifInterface.GPS_DIRECTION_TRUE, "Landroidx/datastore/core/SingleProcessDataStore$Message;", "transform", "Lkotlin/Function2;", "Lkotlin/ParameterName;", "name", "t", "Lkotlin/coroutines/Continuation;", "", "ack", "Lkotlinx/coroutines/CompletableDeferred;", "lastState", "Landroidx/datastore/core/State;", "callerContext", "Lkotlin/coroutines/CoroutineContext;", "(Lkotlin/jvm/functions/Function2;Lkotlinx/coroutines/CompletableDeferred;Landroidx/datastore/core/State;Lkotlin/coroutines/CoroutineContext;)V", "getAck", "()Lkotlinx/coroutines/CompletableDeferred;", "getCallerContext", "()Lkotlin/coroutines/CoroutineContext;", "getLastState", "()Landroidx/datastore/core/State;", "getTransform", "()Lkotlin/jvm/functions/Function2;", "Lkotlin/jvm/functions/Function2;", "datastore-core"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Update<T> extends Message<T> {
            private final CompletableDeferred<T> ack;
            private final CoroutineContext callerContext;
            private final State<T> lastState;
            private final Function2<T, Continuation<? super T>, Object> transform;

            public final Function2<T, Continuation<? super T>, Object> getTransform() {
                return this.transform;
            }

            public final CompletableDeferred<T> getAck() {
                return this.ack;
            }

            @Override
            public State<T> getLastState() {
                return this.lastState;
            }

            public final CoroutineContext getCallerContext() {
                return this.callerContext;
            }

            public Update(Function2<? super T, ? super Continuation<? super T>, ? extends Object> function2, CompletableDeferred<T> completableDeferred, State<T> state, CoroutineContext coroutineContext) {
                super(null);
                Intrinsics.checkNotNullParameter(function2, "transform");
                Intrinsics.checkNotNullParameter(completableDeferred, "ack");
                Intrinsics.checkNotNullParameter(coroutineContext, "callerContext");
                this.transform = function2;
                this.ack = completableDeferred;
                this.lastState = state;
                this.callerContext = coroutineContext;
            }
        }
    }

    public final Object handleRead(Message.Read<T> read, Continuation<? super Unit> continuation) {
        State<T> state = (State) this.downstreamFlow.getValue();
        if (!(state instanceof Data)) {
            if (state instanceof ReadException) {
                if (state == read.getLastState()) {
                    Object andInitOrPropagateFailure = readAndInitOrPropagateFailure(continuation);
                    return andInitOrPropagateFailure == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? andInitOrPropagateFailure : Unit.INSTANCE;
                }
            } else {
                if (Intrinsics.areEqual(state, UnInitialized.INSTANCE)) {
                    Object andInitOrPropagateFailure2 = readAndInitOrPropagateFailure(continuation);
                    return andInitOrPropagateFailure2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? andInitOrPropagateFailure2 : Unit.INSTANCE;
                }
                if (state instanceof Final) {
                    throw new IllegalStateException("Can't read in final state.".toString());
                }
            }
        }
        return Unit.INSTANCE;
    }

    public final Object handleUpdate(Message.Update<T> update, Continuation<? super Unit> continuation) {
        C02171 c02171;
        Object obj;
        Message.Update<T> ack;
        SingleProcessDataStore<T> singleProcessDataStore;
        Object objTransformAndWrite;
        if (continuation instanceof C02171) {
            c02171 = (C02171) continuation;
            if ((c02171.label & Integer.MIN_VALUE) != 0) {
                c02171.label -= Integer.MIN_VALUE;
            } else {
                c02171 = new C02171(this, continuation);
            }
        } else {
            c02171 = new C02171(this, continuation);
        }
        Object obj2 = c02171.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02171.label;
        boolean z = true;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj2);
                ack = update.getAck();
                try {
                    Result.Companion companion = Result.Companion;
                    SingleProcessDataStore<T> singleProcessDataStore2 = this;
                    State<T> state = (State) this.downstreamFlow.getValue();
                    if (state instanceof Data) {
                        Function2<? super T, ? super Continuation<? super T>, ? extends Object> transform = update.getTransform();
                        CoroutineContext callerContext = update.getCallerContext();
                        c02171.L$0 = ack;
                        c02171.label = 1;
                        objTransformAndWrite = transformAndWrite(transform, callerContext, c02171);
                        if (objTransformAndWrite == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (!(state instanceof ReadException)) {
                            z = state instanceof UnInitialized;
                        }
                        if (z) {
                            if (state == update.getLastState()) {
                                c02171.L$0 = update;
                                c02171.L$1 = this;
                                c02171.L$2 = ack;
                                c02171.label = 2;
                                if (readAndInitOrPropagateAndThrowFailure(c02171) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                singleProcessDataStore = this;
                            } else {
                                throw ((ReadException) state).getReadException();
                            }
                        } else {
                            if (state instanceof Final) {
                                throw ((Final) state).getFinalException();
                            }
                            throw new NoWhenBranchMatchedException();
                        }
                    }
                    Message.Update<T> update2 = ack;
                    obj2 = objTransformAndWrite;
                    update = update2;
                    obj = Result.constructor-impl(obj2);
                } catch (Throwable th) {
                    th = th;
                    update = ack;
                    Result.Companion companion2 = Result.Companion;
                    obj = Result.constructor-impl(ResultKt.createFailure(th));
                }
                CompletableDeferredKt.completeWith(update, obj);
                return Unit.INSTANCE;
            }
            if (i == 1) {
                update = (CompletableDeferred) c02171.L$0;
            } else if (i == 2) {
                Message.Update<T> update3 = (CompletableDeferred) c02171.L$2;
                singleProcessDataStore = (SingleProcessDataStore) c02171.L$1;
                Message.Update<T> update4 = (Message.Update) c02171.L$0;
                ResultKt.throwOnFailure(obj2);
                ack = update3;
                update = update4;
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                update = (CompletableDeferred) c02171.L$0;
            }
            ResultKt.throwOnFailure(obj2);
            obj = Result.constructor-impl(obj2);
            CompletableDeferredKt.completeWith(update, obj);
            return Unit.INSTANCE;
            Function2<? super T, ? super Continuation<? super T>, ? extends Object> transform2 = update.getTransform();
            CoroutineContext callerContext2 = update.getCallerContext();
            c02171.L$0 = ack;
            c02171.L$1 = null;
            c02171.L$2 = null;
            c02171.label = 3;
            objTransformAndWrite = singleProcessDataStore.transformAndWrite(transform2, callerContext2, c02171);
            if (objTransformAndWrite == coroutine_suspended) {
                return coroutine_suspended;
            }
            Message.Update<T> update5 = ack;
            obj2 = objTransformAndWrite;
            update = update5;
            obj = Result.constructor-impl(obj2);
        } catch (Throwable th2) {
            th = th2;
        }
        CompletableDeferredKt.completeWith(update, obj);
        return Unit.INSTANCE;
    }

    public final Object readAndInitOrPropagateAndThrowFailure(Continuation<? super Unit> continuation) throws Throwable {
        C02191 c02191;
        SingleProcessDataStore<T> singleProcessDataStore;
        if (continuation instanceof C02191) {
            c02191 = (C02191) continuation;
            if ((c02191.label & Integer.MIN_VALUE) != 0) {
                c02191.label -= Integer.MIN_VALUE;
            } else {
                c02191 = new C02191(this, continuation);
            }
        } else {
            c02191 = new C02191(this, continuation);
        }
        Object obj = c02191.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02191.label;
        if (i != 0) {
            if (i == 1) {
                singleProcessDataStore = (SingleProcessDataStore) c02191.L$0;
                try {
                    ResultKt.throwOnFailure(obj);
                    return Unit.INSTANCE;
                } catch (Throwable th) {
                    th = th;
                    singleProcessDataStore.downstreamFlow.setValue(new ReadException(th));
                    throw th;
                }
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        try {
            c02191.L$0 = this;
            c02191.label = 1;
            if (readAndInit(c02191) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        } catch (Throwable th2) {
            th = th2;
            singleProcessDataStore = this;
            singleProcessDataStore.downstreamFlow.setValue(new ReadException(th));
            throw th;
        }
    }

    public final Object readAndInitOrPropagateFailure(Continuation<? super Unit> continuation) {
        C02201 c02201;
        SingleProcessDataStore<T> singleProcessDataStore;
        if (continuation instanceof C02201) {
            c02201 = (C02201) continuation;
            if ((c02201.label & Integer.MIN_VALUE) != 0) {
                c02201.label -= Integer.MIN_VALUE;
            } else {
                c02201 = new C02201(this, continuation);
            }
        } else {
            c02201 = new C02201(this, continuation);
        }
        Object obj = c02201.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02201.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            try {
                c02201.L$0 = this;
                c02201.label = 1;
                if (readAndInit(c02201) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (Throwable th) {
                th = th;
                singleProcessDataStore = this;
                singleProcessDataStore.downstreamFlow.setValue(new ReadException(th));
            }
        } else if (i == 1) {
            singleProcessDataStore = (SingleProcessDataStore) c02201.L$0;
            try {
                ResultKt.throwOnFailure(obj);
            } catch (Throwable th2) {
                th = th2;
                singleProcessDataStore.downstreamFlow.setValue(new ReadException(th));
            }
        } else {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        return Unit.INSTANCE;
    }

    public final Object readAndInit(Continuation<? super Unit> continuation) throws CorruptionException, FileNotFoundException {
        C02181 c02181;
        Mutex mutexMutex$default;
        Ref.ObjectRef objectRef;
        SingleProcessDataStore<T> singleProcessDataStore;
        Ref.ObjectRef objectRef2;
        SingleProcessDataStore<T> singleProcessDataStore2;
        Ref.ObjectRef objectRef3;
        SingleProcessDataStore$readAndInit$api$1 singleProcessDataStore$readAndInit$api$1;
        Iterator<T> it;
        Mutex mutex;
        Ref.BooleanRef booleanRef;
        Ref.BooleanRef booleanRef2;
        SingleProcessDataStore<T> singleProcessDataStore3;
        Ref.ObjectRef objectRef4;
        Mutex mutex2;
        Function2 function2;
        if (continuation instanceof C02181) {
            c02181 = (C02181) continuation;
            if ((c02181.label & Integer.MIN_VALUE) != 0) {
                c02181.label -= Integer.MIN_VALUE;
            } else {
                c02181 = new C02181(this, continuation);
            }
        } else {
            c02181 = new C02181(this, continuation);
        }
        Object dataOrHandleCorruption = c02181.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02181.label;
        if (i == 0) {
            ResultKt.throwOnFailure(dataOrHandleCorruption);
            if (!(Intrinsics.areEqual(this.downstreamFlow.getValue(), UnInitialized.INSTANCE) || (this.downstreamFlow.getValue() instanceof ReadException))) {
                throw new IllegalStateException("Check failed.".toString());
            }
            mutexMutex$default = MutexKt.Mutex$default(false, 1, (Object) null);
            objectRef = new Ref.ObjectRef();
            c02181.L$0 = this;
            c02181.L$1 = mutexMutex$default;
            c02181.L$2 = objectRef;
            c02181.L$3 = objectRef;
            c02181.label = 1;
            dataOrHandleCorruption = readDataOrHandleCorruption(c02181);
            if (dataOrHandleCorruption == coroutine_suspended) {
                return coroutine_suspended;
            }
            singleProcessDataStore = this;
            objectRef2 = objectRef;
        } else {
            if (i == 1) {
                objectRef = (Ref.ObjectRef) c02181.L$3;
                objectRef2 = (Ref.ObjectRef) c02181.L$2;
                mutexMutex$default = (Mutex) c02181.L$1;
                singleProcessDataStore = (SingleProcessDataStore) c02181.L$0;
                ResultKt.throwOnFailure(dataOrHandleCorruption);
            } else if (i == 2) {
                it = (Iterator) c02181.L$5;
                singleProcessDataStore$readAndInit$api$1 = (SingleProcessDataStore$readAndInit$api$1) c02181.L$4;
                booleanRef = (Ref.BooleanRef) c02181.L$3;
                objectRef3 = (Ref.ObjectRef) c02181.L$2;
                mutex = (Mutex) c02181.L$1;
                singleProcessDataStore2 = (SingleProcessDataStore) c02181.L$0;
                ResultKt.throwOnFailure(dataOrHandleCorruption);
                while (it.hasNext()) {
                    function2 = (Function2) it.next();
                    c02181.L$0 = singleProcessDataStore2;
                    c02181.L$1 = mutex;
                    c02181.L$2 = objectRef3;
                    c02181.L$3 = booleanRef;
                    c02181.L$4 = singleProcessDataStore$readAndInit$api$1;
                    c02181.L$5 = it;
                    c02181.label = 2;
                    if (function2.invoke(singleProcessDataStore$readAndInit$api$1, c02181) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                booleanRef2 = booleanRef;
                objectRef2 = objectRef3;
                mutexMutex$default = mutex;
                singleProcessDataStore3 = singleProcessDataStore2;
                singleProcessDataStore3.initTasks = null;
                c02181.L$0 = singleProcessDataStore3;
                c02181.L$1 = objectRef2;
                c02181.L$2 = booleanRef2;
                c02181.L$3 = mutexMutex$default;
                c02181.L$4 = null;
                c02181.L$5 = null;
                c02181.label = 3;
                if (mutexMutex$default.lock((Object) null, c02181) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                objectRef4 = objectRef2;
                mutex2 = mutexMutex$default;
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                mutex2 = (Mutex) c02181.L$3;
                booleanRef2 = (Ref.BooleanRef) c02181.L$2;
                objectRef4 = (Ref.ObjectRef) c02181.L$1;
                singleProcessDataStore3 = (SingleProcessDataStore) c02181.L$0;
                ResultKt.throwOnFailure(dataOrHandleCorruption);
            }
            try {
                booleanRef2.element = true;
                Unit unit = Unit.INSTANCE;
                mutex2.unlock((Object) null);
                MutableStateFlow<State<T>> mutableStateFlow = singleProcessDataStore3.downstreamFlow;
                Object obj = objectRef4.element;
                Object obj2 = objectRef4.element;
                mutableStateFlow.setValue(new Data(obj, obj2 != null ? obj2.hashCode() : 0));
                return Unit.INSTANCE;
            } catch (Throwable th) {
                mutex2.unlock((Object) null);
                throw th;
            }
        }
        objectRef.element = dataOrHandleCorruption;
        Ref.BooleanRef booleanRef3 = new Ref.BooleanRef();
        SingleProcessDataStore$readAndInit$api$1 singleProcessDataStore$readAndInit$api$2 = new SingleProcessDataStore$readAndInit$api$1(mutexMutex$default, booleanRef3, objectRef2, singleProcessDataStore);
        List<? extends Function2<? super InitializerApi<T>, ? super Continuation<? super Unit>, ? extends Object>> list = singleProcessDataStore.initTasks;
        if (list == null) {
            booleanRef2 = booleanRef3;
            singleProcessDataStore3 = singleProcessDataStore;
        } else {
            singleProcessDataStore2 = singleProcessDataStore;
            objectRef3 = objectRef2;
            singleProcessDataStore$readAndInit$api$1 = singleProcessDataStore$readAndInit$api$2;
            it = list.iterator();
            mutex = mutexMutex$default;
            booleanRef = booleanRef3;
            while (it.hasNext()) {
                function2 = (Function2) it.next();
                c02181.L$0 = singleProcessDataStore2;
                c02181.L$1 = mutex;
                c02181.L$2 = objectRef3;
                c02181.L$3 = booleanRef;
                c02181.L$4 = singleProcessDataStore$readAndInit$api$1;
                c02181.L$5 = it;
                c02181.label = 2;
                if (function2.invoke(singleProcessDataStore$readAndInit$api$1, c02181) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            booleanRef2 = booleanRef;
            objectRef2 = objectRef3;
            mutexMutex$default = mutex;
            singleProcessDataStore3 = singleProcessDataStore2;
        }
        singleProcessDataStore3.initTasks = null;
        c02181.L$0 = singleProcessDataStore3;
        c02181.L$1 = objectRef2;
        c02181.L$2 = booleanRef2;
        c02181.L$3 = mutexMutex$default;
        c02181.L$4 = null;
        c02181.L$5 = null;
        c02181.label = 3;
        if (mutexMutex$default.lock((Object) null, c02181) == coroutine_suspended) {
            return coroutine_suspended;
        }
        objectRef4 = objectRef2;
        mutex2 = mutexMutex$default;
        booleanRef2.element = true;
        Unit unit2 = Unit.INSTANCE;
        mutex2.unlock((Object) null);
        MutableStateFlow<State<T>> mutableStateFlow2 = singleProcessDataStore3.downstreamFlow;
        Object obj3 = objectRef4.element;
        Object obj4 = objectRef4.element;
        mutableStateFlow2.setValue(new Data(obj3, obj4 != null ? obj4.hashCode() : 0));
        return Unit.INSTANCE;
    }

    public final Object readDataOrHandleCorruption(Continuation<? super T> continuation) throws CorruptionException, FileNotFoundException {
        C02221 c02221;
        SingleProcessDataStore singleProcessDataStore;
        Object objHandleCorruption;
        CorruptionException corruptionException;
        SingleProcessDataStore singleProcessDataStore2;
        CorruptionException corruptionException2;
        if (continuation instanceof C02221) {
            c02221 = (C02221) continuation;
            if ((c02221.label & Integer.MIN_VALUE) != 0) {
                c02221.label -= Integer.MIN_VALUE;
            } else {
                c02221 = new C02221(this, continuation);
            }
        } else {
            c02221 = new C02221(this, continuation);
        }
        Object data = c02221.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02221.label;
        if (i == 0) {
            ResultKt.throwOnFailure(data);
            try {
                c02221.L$0 = this;
                c02221.label = 1;
                data = readData(c02221);
                return data == coroutine_suspended ? coroutine_suspended : data;
            } catch (CorruptionException e) {
                e = e;
                singleProcessDataStore = this;
                CorruptionHandler<T> corruptionHandler = singleProcessDataStore.corruptionHandler;
                c02221.L$0 = singleProcessDataStore;
                c02221.L$1 = e;
                c02221.label = 2;
                objHandleCorruption = corruptionHandler.handleCorruption(e, c02221);
                if (objHandleCorruption == coroutine_suspended) {
                    return coroutine_suspended;
                }
                SingleProcessDataStore singleProcessDataStore3 = singleProcessDataStore;
                corruptionException = e;
                data = objHandleCorruption;
                singleProcessDataStore2 = singleProcessDataStore3;
                c02221.L$0 = corruptionException;
                c02221.L$1 = data;
                c02221.label = 3;
                if (singleProcessDataStore2.writeData$datastore_core(data, c02221) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return data;
            }
        }
        if (i == 1) {
            singleProcessDataStore = (SingleProcessDataStore) c02221.L$0;
            try {
                ResultKt.throwOnFailure(data);
            } catch (CorruptionException e2) {
                e = e2;
                CorruptionHandler<T> corruptionHandler2 = singleProcessDataStore.corruptionHandler;
                c02221.L$0 = singleProcessDataStore;
                c02221.L$1 = e;
                c02221.label = 2;
                objHandleCorruption = corruptionHandler2.handleCorruption(e, c02221);
                if (objHandleCorruption == coroutine_suspended) {
                    return coroutine_suspended;
                }
                SingleProcessDataStore singleProcessDataStore4 = singleProcessDataStore;
                corruptionException = e;
                data = objHandleCorruption;
                singleProcessDataStore2 = singleProcessDataStore4;
                c02221.L$0 = corruptionException;
                c02221.L$1 = data;
                c02221.label = 3;
                if (singleProcessDataStore2.writeData$datastore_core(data, c02221) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return data;
            }
        }
        if (i == 2) {
            corruptionException = (CorruptionException) c02221.L$1;
            SingleProcessDataStore singleProcessDataStore5 = (SingleProcessDataStore) c02221.L$0;
            ResultKt.throwOnFailure(data);
            singleProcessDataStore2 = singleProcessDataStore5;
        } else {
            if (i != 3) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Object obj = c02221.L$1;
            corruptionException2 = (CorruptionException) c02221.L$0;
            try {
                ResultKt.throwOnFailure(data);
                return obj;
            } catch (IOException e3) {
                e = e3;
            }
        }
        ExceptionsKt.addSuppressed(corruptionException2, e);
        throw corruptionException2;
        try {
            c02221.L$0 = corruptionException;
            c02221.L$1 = data;
            c02221.label = 3;
            if (singleProcessDataStore2.writeData$datastore_core(data, c02221) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return data;
        } catch (IOException e4) {
            e = e4;
            corruptionException2 = corruptionException;
        }
    }

    public final Object readData(Continuation<? super T> continuation) throws FileNotFoundException {
        ?? c02211;
        FileInputStream fileInputStream;
        Throwable th;
        if (continuation instanceof C02211) {
            C02211 c02212 = (C02211) continuation;
            if ((c02212.label & Integer.MIN_VALUE) != 0) {
                c02212.label -= Integer.MIN_VALUE;
                c02211 = c02212;
            } else {
                c02211 = new C02211(this, continuation);
            }
        } else {
            c02211 = new C02211(this, continuation);
        }
        Object obj = c02211.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02211.label;
        try {
            if (i != 0) {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                th = (Throwable) c02211.L$2;
                fileInputStream = (Closeable) c02211.L$1;
                c02211 = (SingleProcessDataStore) c02211.L$0;
                try {
                    ResultKt.throwOnFailure(obj);
                    CloseableKt.closeFinally(fileInputStream, th);
                    return obj;
                } catch (Throwable th2) {
                    th = th2;
                    try {
                        throw th;
                    } catch (Throwable th3) {
                        CloseableKt.closeFinally(fileInputStream, th);
                        throw th3;
                    }
                }
            }
            ResultKt.throwOnFailure(obj);
            try {
                fileInputStream = new FileInputStream(getFile());
                try {
                    c02211.L$0 = this;
                    c02211.L$1 = fileInputStream;
                    c02211.L$2 = null;
                    c02211.label = 1;
                    Object from = this.serializer.readFrom(fileInputStream, c02211);
                    if (from == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    th = null;
                    obj = from;
                    CloseableKt.closeFinally(fileInputStream, th);
                    return obj;
                } catch (Throwable th4) {
                    th = th4;
                    c02211 = this;
                    throw th;
                }
            } catch (FileNotFoundException e) {
                e = e;
                c02211 = this;
                if (c02211.getFile().exists()) {
                    throw e;
                }
                return c02211.serializer.getDefaultValue();
            }
        } catch (FileNotFoundException e2) {
            e = e2;
        }
    }

    public final Object transformAndWrite(Function2<? super T, ? super Continuation<? super T>, ? extends Object> function2, CoroutineContext coroutineContext, Continuation<? super T> continuation) {
        Continuation<? super Unit> c02231;
        Data data;
        Object obj;
        SingleProcessDataStore singleProcessDataStore;
        SingleProcessDataStore singleProcessDataStore2;
        int iHashCode;
        if (continuation instanceof C02231) {
            c02231 = (C02231) continuation;
            if ((c02231.label & Integer.MIN_VALUE) != 0) {
                c02231.label -= Integer.MIN_VALUE;
            } else {
                c02231 = new C02231(this, continuation);
            }
        } else {
            c02231 = new C02231(this, continuation);
        }
        Object obj2 = c02231.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02231.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj2);
            Data data2 = (Data) this.downstreamFlow.getValue();
            data2.checkHashCode();
            Object value = data2.getValue();
            SingleProcessDataStore$transformAndWrite$newData$1 singleProcessDataStore$transformAndWrite$newData$1 = new SingleProcessDataStore$transformAndWrite$newData$1(function2, value, null);
            c02231.L$0 = this;
            c02231.L$1 = data2;
            c02231.L$2 = value;
            c02231.label = 1;
            Object objWithContext = BuildersKt.withContext(coroutineContext, singleProcessDataStore$transformAndWrite$newData$1, c02231);
            if (objWithContext == coroutine_suspended) {
                return coroutine_suspended;
            }
            data = data2;
            obj2 = objWithContext;
            obj = value;
            singleProcessDataStore = this;
        } else {
            if (i == 1) {
                obj = c02231.L$2;
                data = (Data) c02231.L$1;
                SingleProcessDataStore singleProcessDataStore3 = (SingleProcessDataStore) c02231.L$0;
                ResultKt.throwOnFailure(obj2);
                singleProcessDataStore = singleProcessDataStore3;
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                obj = c02231.L$1;
                SingleProcessDataStore singleProcessDataStore4 = (SingleProcessDataStore) c02231.L$0;
                ResultKt.throwOnFailure(obj2);
                singleProcessDataStore2 = singleProcessDataStore4;
            }
            MutableStateFlow<State<T>> mutableStateFlow = singleProcessDataStore2.downstreamFlow;
            if (obj != null) {
                iHashCode = obj.hashCode();
            } else {
                iHashCode = 0;
            }
            mutableStateFlow.setValue(new Data(obj, iHashCode));
            return obj;
        }
        data.checkHashCode();
        if (!Intrinsics.areEqual(obj, obj2)) {
            c02231.L$0 = singleProcessDataStore;
            c02231.L$1 = obj2;
            c02231.L$2 = null;
            c02231.label = 2;
            if (singleProcessDataStore.writeData$datastore_core(obj2, c02231) == coroutine_suspended) {
                return coroutine_suspended;
            }
            obj = obj2;
            singleProcessDataStore2 = singleProcessDataStore;
            MutableStateFlow<State<T>> mutableStateFlow2 = singleProcessDataStore2.downstreamFlow;
            if (obj != null) {
                iHashCode = obj.hashCode();
            } else {
                iHashCode = 0;
            }
            mutableStateFlow2.setValue(new Data(obj, iHashCode));
        }
        return obj;
    }

    public final Object writeData$datastore_core(T t, Continuation<? super Unit> continuation) throws IOException {
        SingleProcessDataStore$writeData$1 singleProcessDataStore$writeData$1;
        ?? file;
        FileOutputStream fileOutputStream;
        SingleProcessDataStore<T> singleProcessDataStore;
        Throwable th;
        FileOutputStream fileOutputStream2;
        if (continuation instanceof SingleProcessDataStore$writeData$1) {
            singleProcessDataStore$writeData$1 = (SingleProcessDataStore$writeData$1) continuation;
            if ((singleProcessDataStore$writeData$1.label & Integer.MIN_VALUE) != 0) {
                singleProcessDataStore$writeData$1.label -= Integer.MIN_VALUE;
            } else {
                singleProcessDataStore$writeData$1 = new SingleProcessDataStore$writeData$1(this, continuation);
            }
        } else {
            singleProcessDataStore$writeData$1 = new SingleProcessDataStore$writeData$1(this, continuation);
        }
        Object obj = singleProcessDataStore$writeData$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = singleProcessDataStore$writeData$1.label;
        ?? r4 = 1;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                createParentDirectories(getFile());
                file = new File(Intrinsics.stringPlus(getFile().getAbsolutePath(), this.SCRATCH_SUFFIX));
                try {
                    fileOutputStream = new FileOutputStream((File) file);
                    try {
                        FileOutputStream fileOutputStream3 = fileOutputStream;
                        Serializer<T> serializer = this.serializer;
                        UncloseableOutputStream uncloseableOutputStream = new UncloseableOutputStream(fileOutputStream3);
                        singleProcessDataStore$writeData$1.L$0 = this;
                        singleProcessDataStore$writeData$1.L$1 = file;
                        singleProcessDataStore$writeData$1.L$2 = fileOutputStream;
                        singleProcessDataStore$writeData$1.L$3 = null;
                        singleProcessDataStore$writeData$1.L$4 = fileOutputStream3;
                        singleProcessDataStore$writeData$1.label = 1;
                        if (serializer.writeTo(t, uncloseableOutputStream, singleProcessDataStore$writeData$1) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        singleProcessDataStore = this;
                        r4 = file;
                        th = null;
                        fileOutputStream2 = fileOutputStream3;
                    } catch (Throwable th2) {
                        th = th2;
                        r4 = file;
                        throw th;
                    }
                } catch (IOException e) {
                    e = e;
                    if (file.exists()) {
                        file.delete();
                    }
                    throw e;
                }
            } else if (i == 1) {
                fileOutputStream2 = (FileOutputStream) singleProcessDataStore$writeData$1.L$4;
                th = (Throwable) singleProcessDataStore$writeData$1.L$3;
                fileOutputStream = (Closeable) singleProcessDataStore$writeData$1.L$2;
                r4 = (File) singleProcessDataStore$writeData$1.L$1;
                singleProcessDataStore = (SingleProcessDataStore) singleProcessDataStore$writeData$1.L$0;
                try {
                    ResultKt.throwOnFailure(obj);
                    r4 = r4;
                } catch (Throwable th3) {
                    th = th3;
                    try {
                        throw th;
                    } catch (Throwable th4) {
                        CloseableKt.closeFinally(fileOutputStream, th);
                        throw th4;
                    }
                }
            } else {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            fileOutputStream2.getFD().sync();
            Unit unit = Unit.INSTANCE;
            CloseableKt.closeFinally(fileOutputStream, th);
            if (!r4.renameTo(singleProcessDataStore.getFile())) {
                throw new IOException("Unable to rename " + r4 + ".This likely means that there are multiple instances of DataStore for this file. Ensure that you are only creating a single instance of datastore for this file.");
            }
            return Unit.INSTANCE;
        } catch (IOException e2) {
            e = e2;
            file = r4;
            if (file.exists()) {
                file.delete();
            }
            throw e;
        }
    }

    private final void createParentDirectories(File file) throws IOException {
        File parentFile = file.getCanonicalFile().getParentFile();
        if (parentFile == null) {
            return;
        }
        parentFile.mkdirs();
        if (!parentFile.isDirectory()) {
            throw new IOException(Intrinsics.stringPlus("Unable to create parent directories of ", file));
        }
    }

    @Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u0012\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0002\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\b\u0010\u0007\u001a\u00020\bH\u0016J\b\u0010\t\u001a\u00020\bH\u0016J\u0010\u0010\n\u001a\u00020\b2\u0006\u0010\u000b\u001a\u00020\fH\u0016J \u0010\n\u001a\u00020\b2\u0006\u0010\r\u001a\u00020\f2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000fH\u0016J\u0010\u0010\n\u001a\u00020\b2\u0006\u0010\u000b\u001a\u00020\u000fH\u0016R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, d2 = {"Landroidx/datastore/core/SingleProcessDataStore$UncloseableOutputStream;", "Ljava/io/OutputStream;", "fileOutputStream", "Ljava/io/FileOutputStream;", "(Ljava/io/FileOutputStream;)V", "getFileOutputStream", "()Ljava/io/FileOutputStream;", "close", "", "flush", "write", "b", "", "bytes", "off", "", "len", "datastore-core"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class UncloseableOutputStream extends OutputStream {
        private final FileOutputStream fileOutputStream;

        @Override
        public void close() {
        }

        public UncloseableOutputStream(FileOutputStream fileOutputStream) {
            Intrinsics.checkNotNullParameter(fileOutputStream, "fileOutputStream");
            this.fileOutputStream = fileOutputStream;
        }

        public final FileOutputStream getFileOutputStream() {
            return this.fileOutputStream;
        }

        @Override
        public void write(int b) throws IOException {
            this.fileOutputStream.write(b);
        }

        @Override
        public void write(byte[] b) throws IOException {
            Intrinsics.checkNotNullParameter(b, "b");
            this.fileOutputStream.write(b);
        }

        @Override
        public void write(byte[] bytes, int off, int len) throws IOException {
            Intrinsics.checkNotNullParameter(bytes, "bytes");
            this.fileOutputStream.write(bytes, off, len);
        }

        @Override
        public void flush() {
            this.fileOutputStream.flush();
        }
    }

    @Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010#\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001c\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00048\u0000X\u0081\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\b\u001a\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u000b"}, d2 = {"Landroidx/datastore/core/SingleProcessDataStore$Companion;", "", "()V", "activeFiles", "", "", "getActiveFiles$datastore_core", "()Ljava/util/Set;", "activeFilesLock", "getActiveFilesLock$datastore_core", "()Ljava/lang/Object;", "datastore-core"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final Set<String> getActiveFiles$datastore_core() {
            return SingleProcessDataStore.activeFiles;
        }

        public final Object getActiveFilesLock$datastore_core() {
            return SingleProcessDataStore.activeFilesLock;
        }
    }
}
