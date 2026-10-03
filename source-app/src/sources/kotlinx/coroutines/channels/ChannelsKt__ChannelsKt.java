package kotlinx.coroutines.channels;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt__BuildersKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a)\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001\"\u0004\b\u0000\u0010\u0003*\b\u0012\u0004\u0012\u0002H\u00030\u00042\u0006\u0010\u0005\u001a\u0002H\u0003¢\u0006\u0002\u0010\u0006\u001a%\u0010\u0007\u001a\u00020\u0002\"\u0004\b\u0000\u0010\u0003*\b\u0012\u0004\u0012\u0002H\u00030\u00042\u0006\u0010\u0005\u001a\u0002H\u0003H\u0007¢\u0006\u0002\u0010\b¨\u0006\t"}, m18d2 = {"trySendBlocking", "Lkotlinx/coroutines/channels/ChannelResult;", "", "E", "Lkotlinx/coroutines/channels/SendChannel;", "element", "(Lkotlinx/coroutines/channels/SendChannel;Ljava/lang/Object;)Ljava/lang/Object;", "sendBlocking", "(Lkotlinx/coroutines/channels/SendChannel;Ljava/lang/Object;)V", "kotlinx-coroutines-core"}, m19k = 5, m20mv = {2, 0, 0}, m22xi = 48, m23xs = "kotlinx/coroutines/channels/ChannelsKt")
final class ChannelsKt__ChannelsKt {

    @Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001*\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "Lkotlinx/coroutines/channels/ChannelResult;", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__ChannelsKt$trySendBlocking$2", m37f = "Channels.kt", m38i = {}, m39l = {39}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C02102 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ChannelResult<? extends Unit>>, Object> {
        final E $element;
        final SendChannel<E> $this_trySendBlocking;
        private Object L$0;
        int label;

        C02102(SendChannel<? super E> sendChannel, E e, Continuation<? super C02102> continuation) {
            super(2, continuation);
            this.$this_trySendBlocking = sendChannel;
            this.$element = e;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02102 c02102 = new C02102(this.$this_trySendBlocking, this.$element, continuation);
            c02102.L$0 = obj;
            return c02102;
        }

        @Override
        public Object invoke(CoroutineScope coroutineScope, Continuation<? super ChannelResult<? extends Unit>> continuation) {
            return invoke2(coroutineScope, (Continuation<? super ChannelResult<Unit>>) continuation);
        }

        public final Object invoke2(CoroutineScope coroutineScope, Continuation<? super ChannelResult<Unit>> continuation) {
            return ((C02102) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object objM296constructorimpl;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            try {
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    SendChannel<E> sendChannel = this.$this_trySendBlocking;
                    E e = this.$element;
                    Result.Companion companion = Result.INSTANCE;
                    this.label = 1;
                    if (sendChannel.send(e, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                objM296constructorimpl = Result.m296constructorimpl(Unit.INSTANCE);
            } catch (Throwable th) {
                Result.Companion companion2 = Result.INSTANCE;
                objM296constructorimpl = Result.m296constructorimpl(ResultKt.createFailure(th));
            }
            return ChannelResult.m1824boximpl(Result.m303isSuccessimpl(objM296constructorimpl) ? ChannelResult.INSTANCE.m1839successJP2dKIU(Unit.INSTANCE) : ChannelResult.INSTANCE.m1837closedJP2dKIU(Result.m299exceptionOrNullimpl(objM296constructorimpl)));
        }
    }

    public static final <E> Object trySendBlocking(SendChannel<? super E> sendChannel, E e) {
        Object objMo1809trySendJP2dKIU = sendChannel.mo1809trySendJP2dKIU(e);
        if (objMo1809trySendJP2dKIU instanceof ChannelResult.Failed) {
            return ((ChannelResult) BuildersKt__BuildersKt.runBlocking$default(null, new C02102(sendChannel, e, null), 1, null)).getHolder();
        }
        return ChannelResult.INSTANCE.m1839successJP2dKIU(Unit.INSTANCE);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Deprecated in the favour of 'trySendBlocking'. Consider handling the result of 'trySendBlocking' explicitly and rethrow exception if necessary", replaceWith = @ReplaceWith(expression = "trySendBlocking(element)", imports = {}))
    public static final void sendBlocking(SendChannel sendChannel, Object obj) throws InterruptedException {
        if (ChannelResult.m1834isSuccessimpl(sendChannel.mo1809trySendJP2dKIU(obj))) {
            return;
        }
        BuildersKt__BuildersKt.runBlocking$default(null, new C02091(sendChannel, obj, null), 1, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\n"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.ChannelsKt__ChannelsKt$sendBlocking$1", m37f = "Channels.kt", m38i = {}, m39l = {58}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C02091 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final E $element;
        final SendChannel<E> $this_sendBlocking;
        int label;

        C02091(SendChannel<? super E> sendChannel, E e, Continuation<? super C02091> continuation) {
            super(2, continuation);
            this.$this_sendBlocking = sendChannel;
            this.$element = e;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C02091(this.$this_sendBlocking, this.$element, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C02091) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (this.$this_sendBlocking.send(this.$element, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }
}
