package zendesk.guidekit.android.internal.data;

import java.util.LinkedHashMap;
import java.util.Map;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;
import zendesk.guidekit.android.model.Brand;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0007\b\u0000\u0018\u00002\u00020\u0001B\u0007\b\u0007¢\u0006\u0002\u0010\u0002J\u0006\u0010\n\u001a\u00020\u000bJ\u0018\u0010\f\u001a\u0004\u0018\u00010\u00072\u0006\u0010\r\u001a\u00020\u0005H\u0086@¢\u0006\u0002\u0010\u000eJ\u0016\u0010\u000f\u001a\u00020\u000b2\u0006\u0010\u0010\u001a\u00020\u0007H\u0086@¢\u0006\u0002\u0010\u0011R\u001e\u0010\u0003\u001a\u0012\u0012\b\u0012\u00060\u0005j\u0002`\u0006\u0012\u0004\u0012\u00020\u00070\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, m18d2 = {"Lzendesk/guidekit/android/internal/data/BrandsInMemoryDataSource;", "", "()V", "brands", "", "", "Lzendesk/guidekit/android/internal/data/ChannelId;", "Lzendesk/guidekit/android/model/Brand;", "persistenceMutex", "Lkotlinx/coroutines/sync/Mutex;", "clear", "", "getBrand", "channelId", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "saveBrand", "brand", "(Lzendesk/guidekit/android/model/Brand;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class BrandsInMemoryDataSource {
    private final Map<String, Brand> brands = new LinkedHashMap();
    private final Mutex persistenceMutex = MutexKt.Mutex$default(false, 1, null);

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.BrandsInMemoryDataSource", m37f = "BrandsInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {36}, m40m = "getBrand", m41n = {"this", "channelId", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C12471 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12471(Continuation<? super C12471> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return BrandsInMemoryDataSource.this.getBrand(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.BrandsInMemoryDataSource", m37f = "BrandsInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {36}, m40m = "saveBrand", m41n = {"this", "brand", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C12481 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12481(Continuation<? super C12481> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return BrandsInMemoryDataSource.this.saveBrand(null, this);
        }
    }

    @Inject
    public BrandsInMemoryDataSource() {
    }

    public final Object getBrand(String str, Continuation<? super Brand> continuation) throws Throwable {
        C12471 c12471;
        Mutex mutex;
        BrandsInMemoryDataSource brandsInMemoryDataSource;
        if (continuation instanceof C12471) {
            c12471 = (C12471) continuation;
            if ((c12471.label & Integer.MIN_VALUE) != 0) {
                c12471.label -= Integer.MIN_VALUE;
            } else {
                c12471 = new C12471(continuation);
            }
        } else {
            c12471 = new C12471(continuation);
        }
        Object obj = c12471.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12471.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            mutex = this.persistenceMutex;
            c12471.L$0 = this;
            c12471.L$1 = str;
            c12471.L$2 = mutex;
            c12471.label = 1;
            if (mutex.lock(null, c12471) == coroutine_suspended) {
                return coroutine_suspended;
            }
            brandsInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Mutex mutex2 = (Mutex) c12471.L$2;
            String str2 = (String) c12471.L$1;
            brandsInMemoryDataSource = (BrandsInMemoryDataSource) c12471.L$0;
            ResultKt.throwOnFailure(obj);
            mutex = mutex2;
            str = str2;
        }
        try {
            return brandsInMemoryDataSource.brands.get(str);
        } finally {
            mutex.unlock(null);
        }
    }

    public final Object saveBrand(Brand brand, Continuation<? super Unit> continuation) throws Throwable {
        C12481 c12481;
        Mutex mutex;
        BrandsInMemoryDataSource brandsInMemoryDataSource;
        if (continuation instanceof C12481) {
            c12481 = (C12481) continuation;
            if ((c12481.label & Integer.MIN_VALUE) != 0) {
                c12481.label -= Integer.MIN_VALUE;
            } else {
                c12481 = new C12481(continuation);
            }
        } else {
            c12481 = new C12481(continuation);
        }
        Object obj = c12481.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12481.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            mutex = this.persistenceMutex;
            c12481.L$0 = this;
            c12481.L$1 = brand;
            c12481.L$2 = mutex;
            c12481.label = 1;
            if (mutex.lock(null, c12481) == coroutine_suspended) {
                return coroutine_suspended;
            }
            brandsInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Mutex mutex2 = (Mutex) c12481.L$2;
            Brand brand2 = (Brand) c12481.L$1;
            brandsInMemoryDataSource = (BrandsInMemoryDataSource) c12481.L$0;
            ResultKt.throwOnFailure(obj);
            mutex = mutex2;
            brand = brand2;
        }
        try {
            brandsInMemoryDataSource.brands.put(brand.getChannelId(), brand);
            return Unit.INSTANCE;
        } finally {
            mutex.unlock(null);
        }
    }

    public final void clear() {
        this.brands.clear();
    }
}
