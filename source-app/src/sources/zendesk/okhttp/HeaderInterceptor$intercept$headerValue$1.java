package zendesk.okhttp;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u000e\n\u0002\u0018\u0002\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.okhttp.HeaderInterceptor$intercept$headerValue$1", m37f = "HeaderInterceptor.kt", m38i = {}, m39l = {30}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class HeaderInterceptor$intercept$headerValue$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super String>, Object> {
    final Function1<Continuation<? super String>, Object> $headerValueProvider;
    int label;

    HeaderInterceptor$intercept$headerValue$1(Function1<? super Continuation<? super String>, ? extends Object> function1, Continuation<? super HeaderInterceptor$intercept$headerValue$1> continuation) {
        super(2, continuation);
        this.$headerValueProvider = function1;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new HeaderInterceptor$intercept$headerValue$1(this.$headerValueProvider, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super String> continuation) {
        return ((HeaderInterceptor$intercept$headerValue$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Function1<Continuation<? super String>, Object> function1 = this.$headerValueProvider;
            this.label = 1;
            obj = function1.invoke(this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return obj;
    }
}
