package androidx.compose.runtime.snapshots;

import androidx.collection.MutableScatterSet;
import androidx.compose.runtime.ActualJvm_jvmKt;
import androidx.compose.runtime.PreconditionsKt;
import java.util.Set;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0016\n\u0002\u0018\u0002\n\u0002\b\u001b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u0000 T2\u00020\u0001:\u0001TB\u0017\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\r\u00101\u001a\u00020\"H\u0000¢\u0006\u0002\b2J\r\u00103\u001a\u00020\"H\u0010¢\u0006\u0002\b4J\b\u00105\u001a\u00020\"H\u0016J\"\u00106\u001a\u0002H7\"\u0004\b\u0000\u001072\f\u00108\u001a\b\u0012\u0004\u0012\u0002H709H\u0086\b¢\u0006\u0002\u0010:J\b\u0010;\u001a\u00020\bH&J\n\u0010<\u001a\u0004\u0018\u00010\u0000H\u0011J\u0015\u0010=\u001a\u00020\"2\u0006\u0010>\u001a\u00020\u0000H ¢\u0006\u0002\b?J\u0015\u0010@\u001a\u00020\"2\u0006\u0010>\u001a\u00020\u0000H ¢\u0006\u0002\bAJ\r\u0010B\u001a\u00020\"H ¢\u0006\u0002\bCJ\u0015\u0010D\u001a\u00020\"2\u0006\u0010E\u001a\u00020\u001aH ¢\u0006\u0002\bFJ\r\u0010G\u001a\u00020\"H\u0000¢\u0006\u0002\bHJ\r\u0010I\u001a\u00020\"H\u0010¢\u0006\u0002\bJJ\u0012\u0010K\u001a\u00020\"2\b\u0010>\u001a\u0004\u0018\u00010\u0000H\u0011J \u0010L\u001a\u00020\u00002\u0016\b\u0002\u0010 \u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\"\u0018\u00010!H&J\r\u0010M\u001a\u00020\u0003H\u0000¢\u0006\u0002\bNJ\n\u0010O\u001a\u0004\u0018\u00010\u0000H\u0007J\u0012\u0010P\u001a\u00020\"2\b\u0010Q\u001a\u0004\u0018\u00010\u0000H\u0007J\r\u0010R\u001a\u00020\"H\u0000¢\u0006\u0002\bSR\u001a\u0010\u0007\u001a\u00020\bX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR$\u0010\u0002\u001a\u00020\u00032\u0006\u0010\r\u001a\u00020\u0003@PX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000e\u0010\u000f\"\u0004\b\u0010\u0010\u0011R\u001a\u0010\u0004\u001a\u00020\u0005X\u0090\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015R\u0015\u0010\u0016\u001a\u00020\b8À\u0002X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0017\u0010\nR\u001a\u0010\u0018\u001a\n\u0012\u0004\u0012\u00020\u001a\u0018\u00010\u0019X \u0004¢\u0006\u0006\u001a\u0004\b\u001b\u0010\u001cR\u0014\u0010\u001d\u001a\u00020\u0003X\u0082\u000e¢\u0006\b\n\u0000\u0012\u0004\b\u001e\u0010\u001fR(\u0010 \u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\"\u0018\u00010!8 X¡\u0004¢\u0006\f\u0012\u0004\b#\u0010\u001f\u001a\u0004\b$\u0010%R\u0012\u0010&\u001a\u00020\bX¦\u0004¢\u0006\u0006\u001a\u0004\b'\u0010\nR\u0012\u0010(\u001a\u00020\u0000X¦\u0004¢\u0006\u0006\u001a\u0004\b)\u0010*R$\u0010,\u001a\u00020\u00032\u0006\u0010+\u001a\u00020\u00038P@PX\u0090\u000e¢\u0006\f\u001a\u0004\b-\u0010\u000f\"\u0004\b.\u0010\u0011R \u0010/\u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\"\u0018\u00010!X \u0004¢\u0006\u0006\u001a\u0004\b0\u0010%\u0082\u0001\u0004UVWX¨\u0006Y"}, d2 = {"Landroidx/compose/runtime/snapshots/Snapshot;", "", "id", "", "invalid", "Landroidx/compose/runtime/snapshots/SnapshotIdSet;", "(ILandroidx/compose/runtime/snapshots/SnapshotIdSet;)V", "disposed", "", "getDisposed$runtime_release", "()Z", "setDisposed$runtime_release", "(Z)V", "<set-?>", "getId", "()I", "setId$runtime_release", "(I)V", "getInvalid$runtime_release", "()Landroidx/compose/runtime/snapshots/SnapshotIdSet;", "setInvalid$runtime_release", "(Landroidx/compose/runtime/snapshots/SnapshotIdSet;)V", "isPinned", "isPinned$runtime_release", "modified", "Landroidx/collection/MutableScatterSet;", "Landroidx/compose/runtime/snapshots/StateObject;", "getModified$runtime_release", "()Landroidx/collection/MutableScatterSet;", "pinningTrackingHandle", "getPinningTrackingHandle$annotations", "()V", "readObserver", "Lkotlin/Function1;", "", "getReadObserver$annotations", "getReadObserver", "()Lkotlin/jvm/functions/Function1;", "readOnly", "getReadOnly", "root", "getRoot", "()Landroidx/compose/runtime/snapshots/Snapshot;", "value", "writeCount", "getWriteCount$runtime_release", "setWriteCount$runtime_release", "writeObserver", "getWriteObserver$runtime_release", "closeAndReleasePinning", "closeAndReleasePinning$runtime_release", "closeLocked", "closeLocked$runtime_release", "dispose", "enter", "T", "block", "Lkotlin/Function0;", "(Lkotlin/jvm/functions/Function0;)Ljava/lang/Object;", "hasPendingChanges", "makeCurrent", "nestedActivated", "snapshot", "nestedActivated$runtime_release", "nestedDeactivated", "nestedDeactivated$runtime_release", "notifyObjectsInitialized", "notifyObjectsInitialized$runtime_release", "recordModified", "state", "recordModified$runtime_release", "releasePinnedSnapshotLocked", "releasePinnedSnapshotLocked$runtime_release", "releasePinnedSnapshotsForCloseLocked", "releasePinnedSnapshotsForCloseLocked$runtime_release", "restoreCurrent", "takeNestedSnapshot", "takeoverPinnedSnapshot", "takeoverPinnedSnapshot$runtime_release", "unsafeEnter", "unsafeLeave", "oldSnapshot", "validateNotDisposed", "validateNotDisposed$runtime_release", "Companion", "Landroidx/compose/runtime/snapshots/MutableSnapshot;", "Landroidx/compose/runtime/snapshots/NestedReadonlySnapshot;", "Landroidx/compose/runtime/snapshots/ReadonlySnapshot;", "Landroidx/compose/runtime/snapshots/TransparentObserverSnapshot;", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class Snapshot {
    public static final int PreexistingSnapshotId = 1;
    private boolean disposed;
    private int id;
    private SnapshotIdSet invalid;
    private int pinningTrackingHandle;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;

    public Snapshot(int i, SnapshotIdSet snapshotIdSet, DefaultConstructorMarker defaultConstructorMarker) {
        this(i, snapshotIdSet);
    }

    private static void getPinningTrackingHandle$annotations() {
    }

    public static void getReadObserver$annotations() {
    }

    public abstract MutableScatterSet<StateObject> getModified$runtime_release();

    public abstract Function1<Object, Unit> getReadObserver();

    public abstract boolean getReadOnly();

    public abstract Snapshot getRoot();

    public int getWriteCount$runtime_release() {
        return 0;
    }

    public abstract Function1<Object, Unit> getWriteObserver$runtime_release();

    public abstract boolean hasPendingChanges();

    public abstract void mo4147nestedActivated$runtime_release(Snapshot snapshot);

    public abstract void mo4148nestedDeactivated$runtime_release(Snapshot snapshot);

    public abstract void notifyObjectsInitialized$runtime_release();

    public abstract void mo4150recordModified$runtime_release(StateObject state);

    public abstract Snapshot takeNestedSnapshot(Function1<Object, Unit> readObserver);

    private Snapshot(int i, SnapshotIdSet snapshotIdSet) {
        this.invalid = snapshotIdSet;
        this.id = i;
        this.pinningTrackingHandle = i != 0 ? SnapshotKt.trackPinning(i, getInvalid()) : -1;
    }

    public SnapshotIdSet getInvalid() {
        return this.invalid;
    }

    public void setInvalid$runtime_release(SnapshotIdSet snapshotIdSet) {
        this.invalid = snapshotIdSet;
    }

    public int getId() {
        return this.id;
    }

    public void setId$runtime_release(int i) {
        this.id = i;
    }

    public void setWriteCount$runtime_release(int i) {
        throw new IllegalStateException("Updating write count is not supported for this snapshot".toString());
    }

    public void dispose() {
        this.disposed = true;
        synchronized (SnapshotKt.getLock()) {
            releasePinnedSnapshotLocked$runtime_release();
            Unit unit = Unit.INSTANCE;
        }
    }

    public static Snapshot takeNestedSnapshot$default(Snapshot snapshot, Function1 function1, int i, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: takeNestedSnapshot");
        }
        if ((i & 1) != 0) {
            function1 = null;
        }
        return snapshot.takeNestedSnapshot(function1);
    }

    public final <T> T enter(Function0<? extends T> block) {
        Snapshot snapshotMakeCurrent = makeCurrent();
        try {
            return (T) block.invoke();
        } finally {
            restoreCurrent(snapshotMakeCurrent);
        }
    }

    public Snapshot makeCurrent() {
        Snapshot snapshot = (Snapshot) SnapshotKt.threadSnapshot.get();
        SnapshotKt.threadSnapshot.set(this);
        return snapshot;
    }

    public void restoreCurrent(Snapshot snapshot) {
        SnapshotKt.threadSnapshot.set(snapshot);
    }

    public final Snapshot unsafeEnter() {
        return makeCurrent();
    }

    public final void unsafeLeave(Snapshot oldSnapshot) {
        if (!(SnapshotKt.threadSnapshot.get() == this)) {
            PreconditionsKt.throwIllegalStateException("Cannot leave snapshot; " + this + " is not the current snapshot");
        }
        restoreCurrent(oldSnapshot);
    }

    public final boolean getDisposed() {
        return this.disposed;
    }

    public final void setDisposed$runtime_release(boolean z) {
        this.disposed = z;
    }

    public final boolean isPinned$runtime_release() {
        return this.pinningTrackingHandle >= 0;
    }

    public void closeLocked$runtime_release() {
        SnapshotKt.openSnapshots = SnapshotKt.openSnapshots.clear(getId());
    }

    public void releasePinnedSnapshotsForCloseLocked$runtime_release() {
        releasePinnedSnapshotLocked$runtime_release();
    }

    public final void validateNotDisposed$runtime_release() {
        if (this.disposed) {
            PreconditionsKt.throwIllegalArgumentException("Cannot use a disposed snapshot");
        }
    }

    public final void releasePinnedSnapshotLocked$runtime_release() {
        int i = this.pinningTrackingHandle;
        if (i >= 0) {
            SnapshotKt.releasePinningLocked(i);
            this.pinningTrackingHandle = -1;
        }
    }

    public final int takeoverPinnedSnapshot$runtime_release() {
        int i = this.pinningTrackingHandle;
        this.pinningTrackingHandle = -1;
        return i;
    }

    @Metadata(d1 = {"\u0000l\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\"\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0017\u001a\u00020\u0007H\u0001J\"\u0010\u0018\u001a\u0002H\u0019\"\u0004\b\u0000\u0010\u00192\f\u0010\u001a\u001a\b\u0012\u0004\u0012\u0002H\u00190\u001bH\u0086\b¢\u0006\u0002\u0010\u001cJ\u0012\u0010\u001d\u001a\u00020\u00072\b\u0010\u001e\u001a\u0004\u0018\u00010\u0007H\u0001J\u0006\u0010\u001f\u001a\u00020 JO\u0010!\u001a\u0002H\u0019\"\u0004\b\u0000\u0010\u00192\u0016\b\u0002\u0010\"\u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020 \u0018\u00010#2\u0016\b\u0002\u0010$\u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020 \u0018\u00010#2\f\u0010\u001a\u001a\b\u0012\u0004\u0012\u0002H\u00190\u001b¢\u0006\u0002\u0010%J\b\u0010&\u001a\u00020\u0004H\u0007J&\u0010'\u001a\u00020(2\u001e\u0010)\u001a\u001a\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00010+\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020 0*J\u001a\u0010,\u001a\u00020(2\u0012\u0010)\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020 0#J\n\u0010-\u001a\u0004\u0018\u00010\u0007H\u0001J\u0012\u0010.\u001a\u00020 2\b\u0010\u001e\u001a\u0004\u0018\u00010\u0007H\u0001J0\u0010/\u001a\u00020 2\b\u0010\u001e\u001a\u0004\u0018\u00010\u00072\u0006\u00100\u001a\u00020\u00072\u0014\u0010)\u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020 \u0018\u00010#H\u0001J\u0006\u00101\u001a\u00020 J6\u00102\u001a\u0002032\u0016\b\u0002\u0010\"\u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020 \u0018\u00010#2\u0016\b\u0002\u0010$\u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020 \u0018\u00010#J\u001e\u00104\u001a\u00020\u00072\u0016\b\u0002\u0010\"\u001a\u0010\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020 \u0018\u00010#J\"\u00105\u001a\u0002H6\"\u0004\b\u0000\u001062\f\u0010\u001a\u001a\b\u0012\u0004\u0012\u0002H60\u001bH\u0086\b¢\u0006\u0002\u0010\u001cJ4\u00107\u001a\u0002H\u0019\"\u0004\b\u0000\u0010\u00192\u0011\u0010\u001a\u001a\r\u0012\u0004\u0012\u0002H\u00190\u001b¢\u0006\u0002\b8H\u0086\b\u0082\u0002\n\n\b\b\u0001\u0012\u0002\u0010\u0001 \u0001¢\u0006\u0002\u0010\u001cR\u0014\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\b\n\u0000\u0012\u0004\b\u0005\u0010\u0002R\u0011\u0010\u0006\u001a\u00020\u00078F¢\u0006\u0006\u001a\u0004\b\b\u0010\tR\u001c\u0010\n\u001a\u0004\u0018\u00010\u00078@X\u0081\u0004¢\u0006\f\u0012\u0004\b\u000b\u0010\u0002\u001a\u0004\b\f\u0010\tR\u0011\u0010\r\u001a\u00020\u000e8F¢\u0006\u0006\u001a\u0004\b\r\u0010\u000fR\u0011\u0010\u0010\u001a\u00020\u000e8F¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u000fR\u0019\u0010\u0011\u001a\u00020\u000e*\u00020\u00128Â\u0002X\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0014R\u0019\u0010\u0011\u001a\u00020\u000e*\u00020\u00158Â\u0002X\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0016¨\u00069"}, d2 = {"Landroidx/compose/runtime/snapshots/Snapshot$Companion;", "", "()V", "PreexistingSnapshotId", "", "getPreexistingSnapshotId$annotations", "current", "Landroidx/compose/runtime/snapshots/Snapshot;", "getCurrent", "()Landroidx/compose/runtime/snapshots/Snapshot;", "currentThreadSnapshot", "getCurrentThreadSnapshot$annotations", "getCurrentThreadSnapshot", "isApplyObserverNotificationPending", "", "()Z", "isInSnapshot", "canBeReused", "Landroidx/compose/runtime/snapshots/TransparentObserverMutableSnapshot;", "getCanBeReused", "(Landroidx/compose/runtime/snapshots/TransparentObserverMutableSnapshot;)Z", "Landroidx/compose/runtime/snapshots/TransparentObserverSnapshot;", "(Landroidx/compose/runtime/snapshots/TransparentObserverSnapshot;)Z", "createNonObservableSnapshot", "global", "T", "block", "Lkotlin/Function0;", "(Lkotlin/jvm/functions/Function0;)Ljava/lang/Object;", "makeCurrentNonObservable", "previous", "notifyObjectsInitialized", "", "observe", "readObserver", "Lkotlin/Function1;", "writeObserver", "(Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;)Ljava/lang/Object;", "openSnapshotCount", "registerApplyObserver", "Landroidx/compose/runtime/snapshots/ObserverHandle;", "observer", "Lkotlin/Function2;", "", "registerGlobalWriteObserver", "removeCurrent", "restoreCurrent", "restoreNonObservable", "nonObservable", "sendApplyNotifications", "takeMutableSnapshot", "Landroidx/compose/runtime/snapshots/MutableSnapshot;", "takeSnapshot", "withMutableSnapshot", "R", "withoutReadObservation", "Landroidx/compose/runtime/DisallowComposableCalls;", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void getCurrentThreadSnapshot$annotations() {
        }

        public static void getPreexistingSnapshotId$annotations() {
        }

        private Companion() {
        }

        public final Snapshot getCurrent() {
            return SnapshotKt.currentSnapshot();
        }

        public final boolean isInSnapshot() {
            return SnapshotKt.threadSnapshot.get() != null;
        }

        public final boolean isApplyObserverNotificationPending() {
            return SnapshotKt.pendingApplyObserverCount.get() > 0;
        }

        public static Snapshot takeSnapshot$default(Companion companion, Function1 function1, int i, Object obj) {
            if ((i & 1) != 0) {
                function1 = null;
            }
            return companion.takeSnapshot(function1);
        }

        public final Snapshot takeSnapshot(Function1<Object, Unit> readObserver) {
            return SnapshotKt.currentSnapshot().takeNestedSnapshot(readObserver);
        }

        public static MutableSnapshot takeMutableSnapshot$default(Companion companion, Function1 function1, Function1 function2, int i, Object obj) {
            if ((i & 1) != 0) {
                function1 = null;
            }
            if ((i & 2) != 0) {
                function2 = null;
            }
            return companion.takeMutableSnapshot(function1, function2);
        }

        public final MutableSnapshot takeMutableSnapshot(Function1<Object, Unit> readObserver, Function1<Object, Unit> writeObserver) {
            MutableSnapshot mutableSnapshotTakeNestedMutableSnapshot;
            Snapshot snapshotCurrentSnapshot = SnapshotKt.currentSnapshot();
            MutableSnapshot mutableSnapshot = snapshotCurrentSnapshot instanceof MutableSnapshot ? (MutableSnapshot) snapshotCurrentSnapshot : null;
            if (mutableSnapshot == null || (mutableSnapshotTakeNestedMutableSnapshot = mutableSnapshot.takeNestedMutableSnapshot(readObserver, writeObserver)) == null) {
                throw new IllegalStateException("Cannot create a mutable snapshot of an read-only snapshot".toString());
            }
            return mutableSnapshotTakeNestedMutableSnapshot;
        }

        public final <T> T global(Function0<? extends T> block) {
            Snapshot snapshotRemoveCurrent = removeCurrent();
            T t = (T) block.invoke();
            Snapshot.INSTANCE.restoreCurrent(snapshotRemoveCurrent);
            return t;
        }

        public final <R> R withMutableSnapshot(Function0<? extends R> block) {
            MutableSnapshot mutableSnapshotTakeMutableSnapshot$default = takeMutableSnapshot$default(this, null, null, 3, null);
            try {
                MutableSnapshot mutableSnapshot = mutableSnapshotTakeMutableSnapshot$default;
                Snapshot snapshotMakeCurrent = mutableSnapshot.makeCurrent();
                try {
                    R r = (R) block.invoke();
                    mutableSnapshot.restoreCurrent(snapshotMakeCurrent);
                    mutableSnapshotTakeMutableSnapshot$default.apply().check();
                    mutableSnapshotTakeMutableSnapshot$default.dispose();
                    return r;
                } catch (Throwable th) {
                    mutableSnapshot.restoreCurrent(snapshotMakeCurrent);
                    throw th;
                }
            } catch (Throwable th2) {
                mutableSnapshotTakeMutableSnapshot$default.dispose();
                throw th2;
            }
        }

        public static Object observe$default(Companion companion, Function1 function1, Function1 function2, Function0 function0, int i, Object obj) {
            if ((i & 1) != 0) {
                function1 = null;
            }
            if ((i & 2) != 0) {
                function2 = null;
            }
            return companion.observe(function1, function2, function0);
        }

        public final <T> T observe(Function1<Object, Unit> readObserver, Function1<Object, Unit> writeObserver, Function0<? extends T> block) {
            TransparentObserverMutableSnapshot transparentObserverMutableSnapshot;
            if (readObserver != null || writeObserver != null) {
                Snapshot snapshot = (Snapshot) SnapshotKt.threadSnapshot.get();
                if (snapshot instanceof TransparentObserverMutableSnapshot) {
                    TransparentObserverMutableSnapshot transparentObserverMutableSnapshot2 = (TransparentObserverMutableSnapshot) snapshot;
                    if (transparentObserverMutableSnapshot2.getThreadId() == ActualJvm_jvmKt.currentThreadId()) {
                        Function1<Object, Unit> readObserver$runtime_release = transparentObserverMutableSnapshot2.getReadObserver();
                        Function1<Object, Unit> writeObserver$runtime_release = transparentObserverMutableSnapshot2.getWriteObserver$runtime_release();
                        try {
                            ((TransparentObserverMutableSnapshot) snapshot).setReadObserver(SnapshotKt.mergedReadObserver$default(readObserver, readObserver$runtime_release, false, 4, null));
                            ((TransparentObserverMutableSnapshot) snapshot).setWriteObserver(SnapshotKt.mergedWriteObserver(writeObserver, writeObserver$runtime_release));
                            return (T) block.invoke();
                        } finally {
                            transparentObserverMutableSnapshot2.setReadObserver(readObserver$runtime_release);
                            transparentObserverMutableSnapshot2.setWriteObserver(writeObserver$runtime_release);
                        }
                    }
                }
                if (snapshot == null || (snapshot instanceof MutableSnapshot)) {
                    transparentObserverMutableSnapshot = new TransparentObserverMutableSnapshot(snapshot instanceof MutableSnapshot ? (MutableSnapshot) snapshot : null, readObserver, writeObserver, true, false);
                } else {
                    if (readObserver == null) {
                        return (T) block.invoke();
                    }
                    transparentObserverMutableSnapshot = snapshot.takeNestedSnapshot(readObserver);
                }
                try {
                    Snapshot snapshotMakeCurrent = transparentObserverMutableSnapshot.makeCurrent();
                    try {
                        T t = (T) block.invoke();
                        transparentObserverMutableSnapshot.restoreCurrent(snapshotMakeCurrent);
                        transparentObserverMutableSnapshot.dispose();
                        return t;
                    } catch (Throwable th) {
                        transparentObserverMutableSnapshot.restoreCurrent(snapshotMakeCurrent);
                        throw th;
                    }
                } catch (Throwable th2) {
                    transparentObserverMutableSnapshot.dispose();
                    throw th2;
                }
            }
            return (T) block.invoke();
        }

        public final Snapshot createNonObservableSnapshot() {
            return SnapshotKt.createTransparentSnapshotWithNoParentReadObserver$default((Snapshot) SnapshotKt.threadSnapshot.get(), null, false, 6, null);
        }

        public final Snapshot getCurrentThreadSnapshot() {
            return (Snapshot) SnapshotKt.threadSnapshot.get();
        }

        private final boolean getCanBeReused(TransparentObserverMutableSnapshot transparentObserverMutableSnapshot) {
            return transparentObserverMutableSnapshot.getThreadId() == ActualJvm_jvmKt.currentThreadId();
        }

        private final boolean getCanBeReused(TransparentObserverSnapshot transparentObserverSnapshot) {
            return transparentObserverSnapshot.getThreadId$runtime_release() == ActualJvm_jvmKt.currentThreadId();
        }

        public final Snapshot makeCurrentNonObservable(Snapshot previous) {
            if (previous instanceof TransparentObserverMutableSnapshot) {
                TransparentObserverMutableSnapshot transparentObserverMutableSnapshot = (TransparentObserverMutableSnapshot) previous;
                if (transparentObserverMutableSnapshot.getThreadId() == ActualJvm_jvmKt.currentThreadId()) {
                    transparentObserverMutableSnapshot.setReadObserver(null);
                    return previous;
                }
            }
            if (previous instanceof TransparentObserverSnapshot) {
                TransparentObserverSnapshot transparentObserverSnapshot = (TransparentObserverSnapshot) previous;
                if (transparentObserverSnapshot.getThreadId$runtime_release() == ActualJvm_jvmKt.currentThreadId()) {
                    transparentObserverSnapshot.setReadObserver(null);
                    return previous;
                }
            }
            Snapshot snapshotCreateTransparentSnapshotWithNoParentReadObserver$default = SnapshotKt.createTransparentSnapshotWithNoParentReadObserver$default(previous, null, false, 6, null);
            snapshotCreateTransparentSnapshotWithNoParentReadObserver$default.makeCurrent();
            return snapshotCreateTransparentSnapshotWithNoParentReadObserver$default;
        }

        public final void restoreNonObservable(Snapshot previous, Snapshot nonObservable, Function1<Object, Unit> observer) {
            if (previous == nonObservable) {
                if (previous instanceof TransparentObserverMutableSnapshot) {
                    ((TransparentObserverMutableSnapshot) previous).setReadObserver(observer);
                    return;
                } else if (previous instanceof TransparentObserverSnapshot) {
                    ((TransparentObserverSnapshot) previous).setReadObserver(observer);
                    return;
                } else {
                    throw new IllegalStateException(("Non-transparent snapshot was reused: " + previous).toString());
                }
            }
            nonObservable.restoreCurrent(previous);
            nonObservable.dispose();
        }

        public final <T> T withoutReadObservation(Function0<? extends T> block) {
            Snapshot currentThreadSnapshot = getCurrentThreadSnapshot();
            Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
            Snapshot snapshotMakeCurrentNonObservable = makeCurrentNonObservable(currentThreadSnapshot);
            try {
                return (T) block.invoke();
            } finally {
                restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
            }
        }

        public final ObserverHandle registerApplyObserver(final Function2<? super Set<? extends Object>, ? super Snapshot, Unit> observer) {
            SnapshotKt.advanceGlobalSnapshot(SnapshotKt.emptyLambda);
            synchronized (SnapshotKt.getLock()) {
                SnapshotKt.applyObservers = CollectionsKt.plus(SnapshotKt.applyObservers, observer);
                Unit unit = Unit.INSTANCE;
            }
            return new ObserverHandle() {
                @Override
                public final void dispose() {
                    Snapshot.Companion.registerApplyObserver$lambda$6(observer);
                }
            };
        }

        public final void notifyObjectsInitialized() {
            SnapshotKt.currentSnapshot().notifyObjectsInitialized$runtime_release();
        }

        public final int openSnapshotCount() {
            return CollectionsKt.toList(SnapshotKt.openSnapshots).size();
        }

        public final Snapshot removeCurrent() {
            Snapshot snapshot = (Snapshot) SnapshotKt.threadSnapshot.get();
            if (snapshot != null) {
                SnapshotKt.threadSnapshot.set(null);
            }
            return snapshot;
        }

        public final void restoreCurrent(Snapshot previous) {
            if (previous != null) {
                SnapshotKt.threadSnapshot.set(previous);
            }
        }

        public final ObserverHandle registerGlobalWriteObserver(final Function1<Object, Unit> observer) {
            synchronized (SnapshotKt.getLock()) {
                SnapshotKt.globalWriteObservers = CollectionsKt.plus(SnapshotKt.globalWriteObservers, observer);
                Unit unit = Unit.INSTANCE;
            }
            SnapshotKt.advanceGlobalSnapshot();
            return new ObserverHandle() {
                @Override
                public final void dispose() {
                    Snapshot.Companion.registerGlobalWriteObserver$lambda$9(observer);
                }
            };
        }

        public final void sendApplyNotifications() {
            boolean z;
            synchronized (SnapshotKt.getLock()) {
                MutableScatterSet<StateObject> modified$runtime_release = ((GlobalSnapshot) SnapshotKt.currentGlobalSnapshot.get()).getModified$runtime_release();
                z = false;
                if (modified$runtime_release != null && modified$runtime_release.isNotEmpty()) {
                    z = true;
                }
            }
            if (z) {
                SnapshotKt.advanceGlobalSnapshot();
            }
        }

        public static final void registerApplyObserver$lambda$6(Function2 function2) {
            synchronized (SnapshotKt.getLock()) {
                SnapshotKt.applyObservers = CollectionsKt.minus(SnapshotKt.applyObservers, function2);
                Unit unit = Unit.INSTANCE;
            }
        }

        public static final void registerGlobalWriteObserver$lambda$9(Function1 function1) {
            synchronized (SnapshotKt.getLock()) {
                SnapshotKt.globalWriteObservers = CollectionsKt.minus(SnapshotKt.globalWriteObservers, function1);
                Unit unit = Unit.INSTANCE;
            }
            SnapshotKt.advanceGlobalSnapshot();
        }
    }

    public final void closeAndReleasePinning$runtime_release() {
        synchronized (SnapshotKt.getLock()) {
            closeLocked$runtime_release();
            releasePinnedSnapshotsForCloseLocked$runtime_release();
            Unit unit = Unit.INSTANCE;
        }
    }
}
