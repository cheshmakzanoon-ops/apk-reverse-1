package kotlinx.coroutines.sync;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.FunctionReferenceImpl;
import kotlinx.coroutines.selects.SelectInstance;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
class MutexImpl$onLock$1 extends FunctionReferenceImpl implements Function3<MutexImpl, SelectInstance<?>, Object, Unit> {
    public static final MutexImpl$onLock$1 INSTANCE = new MutexImpl$onLock$1();

    MutexImpl$onLock$1() {
        super(3, MutexImpl.class, "onLockRegFunction", "onLockRegFunction(Lkotlinx/coroutines/selects/SelectInstance;Ljava/lang/Object;)V", 0);
    }

    @Override
    public Unit invoke(MutexImpl mutexImpl, SelectInstance<?> selectInstance, Object obj) {
        invoke2(mutexImpl, selectInstance, obj);
        return Unit.INSTANCE;
    }

    public final void invoke2(MutexImpl mutexImpl, SelectInstance<?> selectInstance, Object obj) {
        mutexImpl.onLockRegFunction(selectInstance, obj);
    }
}
