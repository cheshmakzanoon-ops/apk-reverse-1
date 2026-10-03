package androidx.compose.p002ui.platform;

import androidx.compose.p002ui.SessionMutex;
import androidx.compose.p002ui.node.Owner;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u0001\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\b\u0003\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0000¢\u0006\u0002\u0010\u0005J?\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112'\u0010\u0012\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000f0\u0015\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0013¢\u0006\u0002\b\u0016H\u0086@¢\u0006\u0002\u0010\u0017J\u000e\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u0007\u001a\u00020\u0003R+\u0010\u0007\u001a\u00020\u00032\u0006\u0010\u0006\u001a\u00020\u00038B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\f\u0010\r\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u0010\u0010\u0004\u001a\u0004\u0018\u00010\u0000X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001a"}, d2 = {"Landroidx/compose/ui/platform/ChainedPlatformTextInputInterceptor;", "", "initialInterceptor", "Landroidx/compose/ui/platform/PlatformTextInputInterceptor;", "parent", "(Landroidx/compose/ui/platform/PlatformTextInputInterceptor;Landroidx/compose/ui/platform/ChainedPlatformTextInputInterceptor;)V", "<set-?>", "interceptor", "getInterceptor", "()Landroidx/compose/ui/platform/PlatformTextInputInterceptor;", "setInterceptor", "(Landroidx/compose/ui/platform/PlatformTextInputInterceptor;)V", "interceptor$delegate", "Landroidx/compose/runtime/MutableState;", "textInputSession", "", "owner", "Landroidx/compose/ui/node/Owner;", "session", "Lkotlin/Function2;", "Landroidx/compose/ui/platform/PlatformTextInputSessionScope;", "Lkotlin/coroutines/Continuation;", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/ui/node/Owner;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateInterceptor", "", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class ChainedPlatformTextInputInterceptor {

    private final MutableState interceptor;
    private final ChainedPlatformTextInputInterceptor parent;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.platform.ChainedPlatformTextInputInterceptor", f = "PlatformTextInputModifierNode.kt", i = {}, l = {229}, m = "textInputSession", n = {}, s = {})
    static final class C17291 extends ContinuationImpl {
        int label;
        Object result;

        C17291(Continuation<? super C17291> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ChainedPlatformTextInputInterceptor.this.textInputSession(null, null, (Continuation) this);
        }
    }

    public ChainedPlatformTextInputInterceptor(PlatformTextInputInterceptor platformTextInputInterceptor, ChainedPlatformTextInputInterceptor chainedPlatformTextInputInterceptor) {
        this.parent = chainedPlatformTextInputInterceptor;
        this.interceptor = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(platformTextInputInterceptor, null, 2, null);
    }

    public final PlatformTextInputInterceptor getInterceptor() {
        return (PlatformTextInputInterceptor) this.interceptor.getValue();
    }

    private final void setInterceptor(PlatformTextInputInterceptor platformTextInputInterceptor) {
        this.interceptor.setValue(platformTextInputInterceptor);
    }

    public final void updateInterceptor(PlatformTextInputInterceptor interceptor) {
        setInterceptor(interceptor);
    }

    public final Object textInputSession(Owner owner, Function2<? super PlatformTextInputSessionScope, ? super Continuation<?>, ? extends Object> function2, Continuation<?> continuation) throws KotlinNothingValueException {
        C17291 c17291;
        if (continuation instanceof C17291) {
            c17291 = (C17291) continuation;
            if ((c17291.label & Integer.MIN_VALUE) != 0) {
                c17291.label -= Integer.MIN_VALUE;
            } else {
                c17291 = new C17291(continuation);
            }
        } else {
            c17291 = new C17291(continuation);
        }
        Object obj = c17291.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c17291.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ChainedPlatformTextInputInterceptor chainedPlatformTextInputInterceptor = this.parent;
            C17302 c17302 = new C17302(function2, this, null);
            c17291.label = 1;
            if (PlatformTextInputModifierNodeKt.interceptedTextInputSession(owner, chainedPlatformTextInputInterceptor, c17302, c17291) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        throw new KotlinNothingValueException();
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0001\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/platform/PlatformTextInputSessionScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.platform.ChainedPlatformTextInputInterceptor$textInputSession$2", f = "PlatformTextInputModifierNode.kt", i = {}, l = {252}, m = "invokeSuspend", n = {}, s = {})
    static final class C17302 extends SuspendLambda implements Function2<PlatformTextInputSessionScope, Continuation<?>, Object> {
        final Function2<PlatformTextInputSessionScope, Continuation<?>, Object> $session;
        private Object L$0;
        int label;
        final ChainedPlatformTextInputInterceptor this$0;

        C17302(Function2<? super PlatformTextInputSessionScope, ? super Continuation<?>, ? extends Object> function2, ChainedPlatformTextInputInterceptor chainedPlatformTextInputInterceptor, Continuation<? super C17302> continuation) {
            super(2, continuation);
            this.$session = function2;
            this.this$0 = chainedPlatformTextInputInterceptor;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c17302 = new C17302(this.$session, this.this$0, continuation);
            c17302.L$0 = obj;
            return c17302;
        }

        public final Object invoke(PlatformTextInputSessionScope platformTextInputSessionScope, Continuation<?> continuation) {
            return create(platformTextInputSessionScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) throws KotlinNothingValueException {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ChainedPlatformTextInputInterceptor$textInputSession$2$scope$1 chainedPlatformTextInputInterceptor$textInputSession$2$scope$1 = new ChainedPlatformTextInputInterceptor$textInputSession$2$scope$1((PlatformTextInputSessionScope) this.L$0, SessionMutex.m4174constructorimpl(), this.this$0);
                Function2<PlatformTextInputSessionScope, Continuation<?>, Object> function2 = this.$session;
                this.label = 1;
                if (function2.invoke(chainedPlatformTextInputInterceptor$textInputSession$2$scope$1, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            throw new KotlinNothingValueException();
        }
    }
}
