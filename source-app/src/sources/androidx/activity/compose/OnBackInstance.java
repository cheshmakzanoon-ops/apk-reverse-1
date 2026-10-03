package androidx.activity.compose;

import androidx.activity.BackEventCompat;
import androidx.activity.OnBackPressedCallback;
import androidx.autofill.HintConstants;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.channels.BufferOverflow;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.channels.SendChannel;
import kotlinx.coroutines.flow.Flow;

@Metadata(d1 = {"\u0000T\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0002\u0018\u00002\u00020\u0001BV\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u00127\u0010\u0006\u001a3\b\u0001\u0012\u0019\u0012\u0017\u0012\u0004\u0012\u00020\t0\b¢\u0006\f\b\n\u0012\b\b\u000b\u0012\u0004\b\b(\f\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000e0\r\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0007\u0012\u0006\u0010\u000f\u001a\u00020\u0010¢\u0006\u0002\u0010\u0011J\u0006\u0010\u001d\u001a\u00020\u000eJ\u0006\u0010\u001e\u001a\u00020\u0005J!\u0010\u001f\u001a\b\u0012\u0004\u0012\u00020\u000e0 2\u0006\u0010!\u001a\u00020\tø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\"\u0010#R\u0017\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\t0\u0013¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u001a\u0010\u0004\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0004\u0010\u0016\"\u0004\b\u0017\u0010\u0018R\u0011\u0010\u0019\u001a\u00020\u001a¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001c\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006$"}, d2 = {"Landroidx/activity/compose/OnBackInstance;", "", "scope", "Lkotlinx/coroutines/CoroutineScope;", "isPredictiveBack", "", "onBack", "Lkotlin/Function2;", "Lkotlinx/coroutines/flow/Flow;", "Landroidx/activity/BackEventCompat;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "progress", "Lkotlin/coroutines/Continuation;", "", "callback", "Landroidx/activity/OnBackPressedCallback;", "(Lkotlinx/coroutines/CoroutineScope;ZLkotlin/jvm/functions/Function2;Landroidx/activity/OnBackPressedCallback;)V", "channel", "Lkotlinx/coroutines/channels/Channel;", "getChannel", "()Lkotlinx/coroutines/channels/Channel;", "()Z", "setPredictiveBack", "(Z)V", "job", "Lkotlinx/coroutines/Job;", "getJob", "()Lkotlinx/coroutines/Job;", "cancel", "close", "send", "Lkotlinx/coroutines/channels/ChannelResult;", "backEvent", "send-JP2dKIU", "(Landroidx/activity/BackEventCompat;)Ljava/lang/Object;", "activity-compose_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class OnBackInstance {
    private final Channel<BackEventCompat> channel = ChannelKt.Channel$default(-2, BufferOverflow.SUSPEND, (Function1) null, 4, (Object) null);
    private boolean isPredictiveBack;
    private final Job job;

    public OnBackInstance(CoroutineScope coroutineScope, boolean z, Function2<? super Flow<BackEventCompat>, ? super Continuation<? super Unit>, ? extends Object> function2, OnBackPressedCallback onBackPressedCallback) {
        this.isPredictiveBack = z;
        this.job = BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new OnBackInstance$job$1(onBackPressedCallback, function2, this, null), 3, (Object) null);
    }

    public final boolean getIsPredictiveBack() {
        return this.isPredictiveBack;
    }

    public final void setPredictiveBack(boolean z) {
        this.isPredictiveBack = z;
    }

    public final Channel<BackEventCompat> getChannel() {
        return this.channel;
    }

    public final Job getJob() {
        return this.job;
    }

    public final Object m245sendJP2dKIU(BackEventCompat backEvent) {
        return this.channel.trySend-JP2dKIU(backEvent);
    }

    public final boolean close() {
        return SendChannel.DefaultImpls.close$default(this.channel, (Throwable) null, 1, (Object) null);
    }

    public final void cancel() {
        this.channel.cancel(new CancellationException("onBack cancelled"));
        Job.DefaultImpls.cancel$default(this.job, (CancellationException) null, 1, (Object) null);
    }
}
