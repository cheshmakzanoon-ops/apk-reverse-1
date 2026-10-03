package zendesk.conversationkit.android.internal;

import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import java.util.concurrent.atomic.AtomicBoolean;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationscreen.MessageContainerFactory;

@Metadata(m17d1 = {"\u0000A\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003*\u0001\r\b\u0000\u0018\u0000 \u00192\u00020\u0001:\u0001\u0019B\u000f\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u000f\u001a\u00020\u0010H\u0086@¢\u0006\u0002\u0010\u0011J\u0006\u0010\u0012\u001a\u00020\u0010J\u0006\u0010\u0013\u001a\u00020\u0010J\b\u0010\u0014\u001a\u00020\u0015H\u0002J\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00070\u0017J\b\u0010\u0018\u001a\u00020\u0010H\u0002R\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\b\u001a\u00020\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0010\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u000e¨\u0006\u001a"}, m18d2 = {"Lzendesk/conversationkit/android/internal/ConnectivityObserver;", "", "connectivityManager", "Landroid/net/ConnectivityManager;", "(Landroid/net/ConnectivityManager;)V", "connectionState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lzendesk/conversationkit/android/ConnectionStatus;", "isRegistered", "Ljava/util/concurrent/atomic/AtomicBoolean;", "isRegistered$zendesk_conversationkit_conversationkit_android", "()Ljava/util/concurrent/atomic/AtomicBoolean;", "networkCallback", "zendesk/conversationkit/android/internal/ConnectivityObserver$networkCallback$1", "Lzendesk/conversationkit/android/internal/ConnectivityObserver$networkCallback$1;", "awaitConnection", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "connect", "disconnect", "isNetworkAvailable", "", "observeNetworkState", "Lkotlinx/coroutines/flow/Flow;", "refreshNetworkState", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConnectivityObserver {
    private static final String LOG_TAG = "ConnectivityObserver";
    private final ConnectivityManager connectivityManager;
    private final MutableStateFlow<ConnectionStatus> connectionState = StateFlowKt.MutableStateFlow(ConnectionStatus.DISCONNECTED);
    private final ConnectivityObserver$networkCallback$1 networkCallback = new ConnectivityManager.NetworkCallback() {
        @Override
        public void onAvailable(Network network) {
            Object value;
            Intrinsics.checkNotNullParameter(network, "network");
            MutableStateFlow mutableStateFlow = this.this$0.connectionState;
            do {
                value = mutableStateFlow.getValue();
            } while (!mutableStateFlow.compareAndSet(value, ConnectionStatus.CONNECTED));
        }

        @Override
        public void onLost(Network network) {
            Object value;
            Intrinsics.checkNotNullParameter(network, "network");
            MutableStateFlow mutableStateFlow = this.this$0.connectionState;
            do {
                value = mutableStateFlow.getValue();
            } while (!mutableStateFlow.compareAndSet(value, ConnectionStatus.DISCONNECTED));
        }
    };
    private final AtomicBoolean isRegistered = new AtomicBoolean(false);

    public ConnectivityObserver(ConnectivityManager connectivityManager) {
        this.connectivityManager = connectivityManager;
        refreshNetworkState();
    }

    public final AtomicBoolean getIsRegistered() {
        return this.isRegistered;
    }

    public final Flow<ConnectionStatus> observeNetworkState() {
        return this.connectionState;
    }

    private final void refreshNetworkState() {
        if (isNetworkAvailable()) {
            MutableStateFlow<ConnectionStatus> mutableStateFlow = this.connectionState;
            while (!mutableStateFlow.compareAndSet(mutableStateFlow.getValue(), ConnectionStatus.CONNECTED)) {
            }
        } else {
            MutableStateFlow<ConnectionStatus> mutableStateFlow2 = this.connectionState;
            while (!mutableStateFlow2.compareAndSet(mutableStateFlow2.getValue(), ConnectionStatus.DISCONNECTED)) {
            }
        }
    }

    private final boolean isNetworkAvailable() {
        Network activeNetwork;
        NetworkCapabilities networkCapabilities;
        ConnectivityManager connectivityManager = this.connectivityManager;
        if (connectivityManager == null || (activeNetwork = connectivityManager.getActiveNetwork()) == null || (networkCapabilities = this.connectivityManager.getNetworkCapabilities(activeNetwork)) == null) {
            return false;
        }
        return networkCapabilities.hasTransport(1) || networkCapabilities.hasTransport(0) || networkCapabilities.hasTransport(3) || networkCapabilities.hasTransport(2);
    }

    public final Object awaitConnection(Continuation<? super Unit> continuation) {
        connect();
        if (this.connectionState.getValue() != ConnectionStatus.CONNECTED) {
            final MutableStateFlow<ConnectionStatus> mutableStateFlow = this.connectionState;
            Object objCollect = FlowKt.take(new Flow<ConnectionStatus>() {

                @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                public static final class C09972<T> implements FlowCollector {
                    final FlowCollector $this_unsafeFlow;

                    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConnectivityObserver$awaitConnection$$inlined$filter$1$2", m37f = "ConnectivityObserver.kt", m38i = {}, m39l = {MessageContainerFactory.MAXIMUM_FILE_SIZE_IN_MB}, m40m = "emit", m41n = {}, m42s = {})
                    public static final class AnonymousClass1 extends ContinuationImpl {
                        Object L$0;
                        Object L$1;
                        int label;
                        Object result;

                        public AnonymousClass1(Continuation continuation) {
                            super(continuation);
                        }

                        @Override
                        public final Object invokeSuspend(Object obj) {
                            this.result = obj;
                            this.label |= Integer.MIN_VALUE;
                            return C09972.this.emit(null, this);
                        }
                    }

                    public C09972(FlowCollector flowCollector) {
                        this.$this_unsafeFlow = flowCollector;
                    }

                    @Override
                    public final Object emit(Object obj, Continuation continuation) throws Throwable {
                        AnonymousClass1 anonymousClass1;
                        if (continuation instanceof AnonymousClass1) {
                            anonymousClass1 = (AnonymousClass1) continuation;
                            if ((anonymousClass1.label & Integer.MIN_VALUE) != 0) {
                                anonymousClass1.label -= Integer.MIN_VALUE;
                            } else {
                                anonymousClass1 = new AnonymousClass1(continuation);
                            }
                        } else {
                            anonymousClass1 = new AnonymousClass1(continuation);
                        }
                        Object obj2 = anonymousClass1.result;
                        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        int i = anonymousClass1.label;
                        if (i == 0) {
                            ResultKt.throwOnFailure(obj2);
                            FlowCollector flowCollector = this.$this_unsafeFlow;
                            if (((ConnectionStatus) obj) == ConnectionStatus.CONNECTED) {
                                anonymousClass1.label = 1;
                                if (flowCollector.emit(obj, anonymousClass1) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                            }
                        } else {
                            if (i != 1) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            ResultKt.throwOnFailure(obj2);
                        }
                        return Unit.INSTANCE;
                    }
                }

                @Override
                public Object collect(FlowCollector<? super ConnectionStatus> flowCollector, Continuation continuation2) {
                    Object objCollect2 = mutableStateFlow.collect(new C09972(flowCollector), continuation2);
                    return objCollect2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect2 : Unit.INSTANCE;
                }
            }, 1).collect(new FlowCollector() {
                @Override
                public Object emit(Object obj, Continuation continuation2) {
                    return emit((ConnectionStatus) obj, (Continuation<? super Unit>) continuation2);
                }

                public final Object emit(ConnectionStatus connectionStatus, Continuation<? super Unit> continuation2) {
                    return Unit.INSTANCE;
                }
            }, continuation);
            return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
        }
        return Unit.INSTANCE;
    }

    public final void disconnect() {
        if (this.isRegistered.get()) {
            this.isRegistered.set(false);
            try {
                ConnectivityManager connectivityManager = this.connectivityManager;
                if (connectivityManager != null) {
                    connectivityManager.unregisterNetworkCallback(this.networkCallback);
                }
            } catch (IllegalArgumentException e) {
                Logger.m218e(LOG_TAG, "Error unregistering network callback", e, new Object[0]);
            }
        }
    }

    public final void connect() {
        if (this.connectivityManager == null) {
            Logger.m219e(LOG_TAG, "ConnectivityManager is null, cannot register NetworkCallback", new Object[0]);
        } else {
            if (this.isRegistered.get()) {
                return;
            }
            refreshNetworkState();
            this.isRegistered.set(true);
            this.connectivityManager.registerNetworkCallback(new NetworkRequest.Builder().addCapability(12).build(), this.networkCallback);
        }
    }
}
