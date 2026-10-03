package androidx.compose.p002ui.platform;

import androidx.compose.runtime.snapshots.Snapshot;
import java.util.concurrent.atomic.AtomicBoolean;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.channels.BufferOverflow;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;

@Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0006\u001a\u00020\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\b"}, d2 = {"Landroidx/compose/ui/platform/GlobalSnapshotManager;", "", "()V", "sent", "Ljava/util/concurrent/atomic/AtomicBoolean;", "started", "ensureStarted", "", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class GlobalSnapshotManager {
    public static final GlobalSnapshotManager INSTANCE = new GlobalSnapshotManager();
    private static final AtomicBoolean started = new AtomicBoolean(false);
    private static final AtomicBoolean sent = new AtomicBoolean(false);
    public static final int $stable = 8;

    private GlobalSnapshotManager() {
    }

    public final void ensureStarted() {
        if (started.compareAndSet(false, true)) {
            final Channel channelChannel$default = ChannelKt.Channel$default(1, (BufferOverflow) null, (Function1) null, 6, (Object) null);
            BuildersKt.launch$default(CoroutineScopeKt.CoroutineScope(AndroidUiDispatcher.INSTANCE.getMain()), (CoroutineContext) null, (CoroutineStart) null, new C17391(channelChannel$default, null), 3, (Object) null);
            Snapshot.INSTANCE.registerGlobalWriteObserver(new Function1<Object, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    m6542invoke(obj);
                    return Unit.INSTANCE;
                }

                public final void m6542invoke(Object obj) {
                    if (GlobalSnapshotManager.sent.compareAndSet(false, true)) {
                        channelChannel$default.trySend-JP2dKIU(Unit.INSTANCE);
                    }
                }
            });
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.platform.GlobalSnapshotManager$ensureStarted$1", f = "GlobalSnapshotManager.android.kt", i = {0}, l = {67}, m = "invokeSuspend", n = {"$this$consume$iv$iv"}, s = {"L$0"})
    static final class C17391 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Channel<Unit> $channel;
        Object L$0;
        Object L$1;
        int label;

        C17391(Channel<Unit> channel, Continuation<? super C17391> continuation) {
            super(2, continuation);
            this.$channel = channel;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C17391(this.$channel, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final java.lang.Object invokeSuspend(java.lang.Object r7) {
            throw new UnsupportedOperationException("Method not decompiled: androidx.compose.p002ui.platform.GlobalSnapshotManager.C17391.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }
}
