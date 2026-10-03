package androidx.compose.runtime.snapshots;

import java.util.List;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\b\u0010\u0007\u001a\u00020\bH\u0016J\b\u0010\t\u001a\u00020\nH\u0016J\u0015\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eH\u0010¢\u0006\u0002\b\u000fJ\u0015\u0010\u0010\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eH\u0010¢\u0006\u0002\b\u0011J\r\u0010\u0012\u001a\u00020\nH\u0010¢\u0006\u0002\b\u0013J4\u0010\u0014\u001a\u00020\u00012\u0014\u0010\u0015\u001a\u0010\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\n\u0018\u00010\u00162\u0014\u0010\u0018\u001a\u0010\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\n\u0018\u00010\u0016H\u0016J\u001e\u0010\u0019\u001a\u00020\u000e2\u0014\u0010\u0015\u001a\u0010\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\n\u0018\u00010\u0016H\u0016¨\u0006\u001a"}, d2 = {"Landroidx/compose/runtime/snapshots/GlobalSnapshot;", "Landroidx/compose/runtime/snapshots/MutableSnapshot;", "id", "", "invalid", "Landroidx/compose/runtime/snapshots/SnapshotIdSet;", "(ILandroidx/compose/runtime/snapshots/SnapshotIdSet;)V", "apply", "Landroidx/compose/runtime/snapshots/SnapshotApplyResult;", "dispose", "", "nestedActivated", "", "snapshot", "Landroidx/compose/runtime/snapshots/Snapshot;", "nestedActivated$runtime_release", "nestedDeactivated", "nestedDeactivated$runtime_release", "notifyObjectsInitialized", "notifyObjectsInitialized$runtime_release", "takeNestedMutableSnapshot", "readObserver", "Lkotlin/Function1;", "", "writeObserver", "takeNestedSnapshot", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class GlobalSnapshot extends MutableSnapshot {
    public static final int $stable = 0;

    @Override
    public Snapshot takeNestedSnapshot(final Function1<Object, Unit> readObserver) {
        return SnapshotKt.takeNewSnapshot(new Function1<SnapshotIdSet, ReadonlySnapshot>() {
            {
                super(1);
            }

            public final ReadonlySnapshot invoke(SnapshotIdSet snapshotIdSet) {
                int i;
                synchronized (SnapshotKt.getLock()) {
                    i = SnapshotKt.nextSnapshotId;
                    SnapshotKt.nextSnapshotId = i + 1;
                }
                return new ReadonlySnapshot(i, snapshotIdSet, readObserver);
            }
        });
    }

    @Override
    public MutableSnapshot takeNestedMutableSnapshot(final Function1<Object, Unit> readObserver, final Function1<Object, Unit> writeObserver) {
        return (MutableSnapshot) SnapshotKt.takeNewSnapshot(new Function1<SnapshotIdSet, MutableSnapshot>() {
            {
                super(1);
            }

            public final MutableSnapshot invoke(SnapshotIdSet snapshotIdSet) {
                int i;
                synchronized (SnapshotKt.getLock()) {
                    i = SnapshotKt.nextSnapshotId;
                    SnapshotKt.nextSnapshotId = i + 1;
                }
                return new MutableSnapshot(i, snapshotIdSet, readObserver, writeObserver);
            }
        });
    }

    @Override
    public void notifyObjectsInitialized$runtime_release() {
        SnapshotKt.advanceGlobalSnapshot();
    }

    @Override
    public Void mo4148nestedDeactivated$runtime_release(Snapshot snapshot) throws KotlinNothingValueException {
        SnapshotStateMapKt.unsupported();
        throw new KotlinNothingValueException();
    }

    @Override
    public Void mo4147nestedActivated$runtime_release(Snapshot snapshot) throws KotlinNothingValueException {
        SnapshotStateMapKt.unsupported();
        throw new KotlinNothingValueException();
    }

    @Override
    public SnapshotApplyResult apply() {
        throw new IllegalStateException("Cannot apply the global snapshot directly. Call Snapshot.advanceGlobalSnapshot".toString());
    }

    public GlobalSnapshot(int i, SnapshotIdSet snapshotIdSet) {
        Function1<Object, Unit> function1;
        synchronized (SnapshotKt.getLock()) {
            final List list = SnapshotKt.globalWriteObservers;
            function1 = (Function1) CollectionsKt.singleOrNull(list);
            function1 = function1 == null ? new Function1<Object, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    m4149invoke(obj);
                    return Unit.INSTANCE;
                }

                public final void m4149invoke(Object obj) {
                    List<Function1<Object, Unit>> list2 = list;
                    int size = list2.size();
                    for (int i2 = 0; i2 < size; i2++) {
                        list2.get(i2).invoke(obj);
                    }
                }
            } : function1;
        }
        super(i, snapshotIdSet, null, function1);
    }

    @Override
    public void dispose() {
        synchronized (SnapshotKt.getLock()) {
            releasePinnedSnapshotLocked$runtime_release();
            Unit unit = Unit.INSTANCE;
        }
    }
}
