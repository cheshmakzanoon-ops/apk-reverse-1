package zendesk.guidekit.android.internal.data;

import java.util.LinkedHashMap;
import java.util.Map;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;
import zendesk.guidekit.android.model.GuideArticle;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0010\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\u0007\b\u0007¢\u0006\u0002\u0010\u0002J\u001c\u0010\n\u001a\u0004\u0018\u00010\u00072\n\u0010\u000b\u001a\u00060\u0005j\u0002`\u0006H\u0086@¢\u0006\u0002\u0010\fJ\u0016\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0007H\u0086@¢\u0006\u0002\u0010\u0010R\u001e\u0010\u0003\u001a\u0012\u0012\b\u0012\u00060\u0005j\u0002`\u0006\u0012\u0004\u0012\u00020\u00070\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lzendesk/guidekit/android/internal/data/ArticleInMemoryDataSource;", "", "()V", "articlesMap", "", "", "Lzendesk/guidekit/android/internal/data/ArticleId;", "Lzendesk/guidekit/android/model/GuideArticle;", "persistenceMutex", "Lkotlinx/coroutines/sync/Mutex;", "getArticle", "id", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "saveArticle", "", "article", "(Lzendesk/guidekit/android/model/GuideArticle;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleInMemoryDataSource {
    private final Map<Long, GuideArticle> articlesMap = new LinkedHashMap();
    private final Mutex persistenceMutex = MutexKt.Mutex$default(false, 1, null);

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.ArticleInMemoryDataSource", m37f = "ArticleInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {47}, m40m = "getArticle", m41n = {"this", "$this$withLock_u24default$iv", "id"}, m42s = {"L$0", "L$1", "J$0"})
    static final class C12451 extends ContinuationImpl {
        long J$0;
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C12451(Continuation<? super C12451> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ArticleInMemoryDataSource.this.getArticle(0L, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.guidekit.android.internal.data.ArticleInMemoryDataSource", m37f = "ArticleInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {47}, m40m = "saveArticle", m41n = {"this", "article", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C12461 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12461(Continuation<? super C12461> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ArticleInMemoryDataSource.this.saveArticle(null, this);
        }
    }

    @Inject
    public ArticleInMemoryDataSource() {
    }

    public final Object saveArticle(GuideArticle guideArticle, Continuation<? super Unit> continuation) throws Throwable {
        C12461 c12461;
        Mutex mutex;
        ArticleInMemoryDataSource articleInMemoryDataSource;
        if (continuation instanceof C12461) {
            c12461 = (C12461) continuation;
            if ((c12461.label & Integer.MIN_VALUE) != 0) {
                c12461.label -= Integer.MIN_VALUE;
            } else {
                c12461 = new C12461(continuation);
            }
        } else {
            c12461 = new C12461(continuation);
        }
        Object obj = c12461.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12461.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            mutex = this.persistenceMutex;
            c12461.L$0 = this;
            c12461.L$1 = guideArticle;
            c12461.L$2 = mutex;
            c12461.label = 1;
            if (mutex.lock(null, c12461) == coroutine_suspended) {
                return coroutine_suspended;
            }
            articleInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Mutex mutex2 = (Mutex) c12461.L$2;
            GuideArticle guideArticle2 = (GuideArticle) c12461.L$1;
            articleInMemoryDataSource = (ArticleInMemoryDataSource) c12461.L$0;
            ResultKt.throwOnFailure(obj);
            mutex = mutex2;
            guideArticle = guideArticle2;
        }
        try {
            articleInMemoryDataSource.articlesMap.put(Boxing.boxLong(guideArticle.getId()), guideArticle);
            return Unit.INSTANCE;
        } finally {
            mutex.unlock(null);
        }
    }

    public final Object getArticle(long j, Continuation<? super GuideArticle> continuation) throws Throwable {
        C12451 c12451;
        ArticleInMemoryDataSource articleInMemoryDataSource;
        Mutex mutex;
        if (continuation instanceof C12451) {
            c12451 = (C12451) continuation;
            if ((c12451.label & Integer.MIN_VALUE) != 0) {
                c12451.label -= Integer.MIN_VALUE;
            } else {
                c12451 = new C12451(continuation);
            }
        } else {
            c12451 = new C12451(continuation);
        }
        Object obj = c12451.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12451.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c12451.L$0 = this;
            c12451.L$1 = mutex2;
            c12451.J$0 = j;
            c12451.label = 1;
            if (mutex2.lock(null, c12451) == coroutine_suspended) {
                return coroutine_suspended;
            }
            articleInMemoryDataSource = this;
            mutex = mutex2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            j = c12451.J$0;
            mutex = (Mutex) c12451.L$1;
            articleInMemoryDataSource = (ArticleInMemoryDataSource) c12451.L$0;
            ResultKt.throwOnFailure(obj);
        }
        try {
            return articleInMemoryDataSource.articlesMap.get(Boxing.boxLong(j));
        } finally {
            mutex.unlock(null);
        }
    }
}
