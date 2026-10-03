package zendesk.messaging.android.push;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.SharedPreferences;
import androidx.core.app.NotificationCompat;
import com.unity3d.player.l$a$;
import java.util.Map;
import java.util.Set;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.SupervisorKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import okio.NioSystemFileSystem$$ExternalSyntheticApiModelOutline0;
import zendesk.logger.Logger;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.MessagingBuildConfig;
import zendesk.messaging.android.internal.VisibleScreen;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.conversationscreen.MessageContainerFactory;
import zendesk.messaging.android.push.internal.NotificationBuilder;
import zendesk.messaging.android.push.internal.NotificationProcessor;
import zendesk.messaging.android.push.internal.NotificationProcessorFactory;

@Metadata(m17d1 = {"\u0000`\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u0004H\u0003J$\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\"2\u0012\u0010#\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040$H\u0007J\u0010\u0010%\u001a\u00020 2\u0006\u0010!\u001a\u00020\"H\u0002J\r\u0010&\u001a\u00020 H\u0000¢\u0006\u0002\b'J\u0019\u0010(\u001a\u00020 2\n\b\u0001\u0010)\u001a\u0004\u0018\u00010\u0016H\u0007¢\u0006\u0002\u0010*J\u001c\u0010+\u001a\u00020,2\u0012\u0010#\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040$H\u0007J\u0010\u0010-\u001a\u00020 2\u0006\u0010\u0011\u001a\u00020\u0004H\u0007J$\u0010.\u001a\u00020/2\u0006\u0010!\u001a\u00020\"2\u0012\u0010#\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040$H\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00040\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u000f\u001a\u0004\u0018\u00010\u0010X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00040\u00128@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0014R$\u0010\u0015\u001a\u00020\u00168\u0000@\u0000X\u0081\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b\u0017\u0010\u0002\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001b¨\u00060"}, m18d2 = {"Lzendesk/messaging/android/push/PushNotifications;", "", "()V", "CONVERSATION_ID_KEY", "", "CONVERSATION_KIT_STORAGE", "INTEGRATION_ID_DATA_KEY", "INTEGRATION_ID_KEY", "LOG_TAG", PushNotifications.MESSAGING_NOTIFICATION_CHANNEL_ID, "NOTIFICATION_KEY", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "mutablePushNotificationToken", "Lkotlinx/coroutines/flow/MutableStateFlow;", "notificationProcessor", "Lzendesk/messaging/android/push/internal/NotificationProcessor;", "pushNotificationToken", "Lkotlinx/coroutines/flow/Flow;", "getPushNotificationToken$zendesk_messaging_messaging_android", "()Lkotlinx/coroutines/flow/Flow;", "smallNotificationIconId", "", "getSmallNotificationIconId$zendesk_messaging_messaging_android$annotations", "getSmallNotificationIconId$zendesk_messaging_messaging_android", "()I", "setSmallNotificationIconId$zendesk_messaging_messaging_android", "(I)V", "buildChannel", "Landroid/app/NotificationChannel;", "channelName", "displayNotification", "", "context", "Landroid/content/Context;", "messageData", "", "initialize", "reset", "reset$zendesk_messaging_messaging_android", "setNotificationSmallIconId", "smallIconId", "(Ljava/lang/Integer;)V", "shouldBeDisplayed", "Lzendesk/messaging/android/push/PushResponsibility;", "updatePushNotificationToken", "validatePushIntegration", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class PushNotifications {
    private static final String CONVERSATION_ID_KEY = "conversationId";
    private static final String CONVERSATION_KIT_STORAGE = "zendesk.conversationkit";
    private static final String INTEGRATION_ID_DATA_KEY = "INTEGRATION_ID";
    private static final String INTEGRATION_ID_KEY = "integrationId";
    private static final String LOG_TAG = "PushNotifications";
    private static final String MESSAGING_NOTIFICATION_CHANNEL_ID = "MESSAGING_NOTIFICATION_CHANNEL_ID";
    private static final String NOTIFICATION_KEY = "smoochNotification";
    private static NotificationProcessor notificationProcessor;
    public static final PushNotifications INSTANCE = new PushNotifications();
    private static final CoroutineScope coroutineScope = CoroutineScopeKt.CoroutineScope(Dispatchers.getDefault().plus(SupervisorKt.SupervisorJob$default((Job) null, 1, (Object) null)));
    private static final MutableStateFlow<String> mutablePushNotificationToken = StateFlowKt.MutableStateFlow("");
    private static int smallNotificationIconId = C1256R.drawable.zma_default_notification_icon;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[PushResponsibility.values().length];
            try {
                iArr[PushResponsibility.NOT_FROM_MESSAGING.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[PushResponsibility.MESSAGING_SHOULD_NOT_DISPLAY.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[PushResponsibility.MESSAGING_SHOULD_DISPLAY.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static void m286xec629602() {
    }

    private PushNotifications() {
    }

    public final Flow<String> getPushNotificationToken$zendesk_messaging_messaging_android() {
        final MutableStateFlow<String> mutableStateFlow = mutablePushNotificationToken;
        return new Flow<String>() {

            @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            public static final class C15282<T> implements FlowCollector {
                final FlowCollector $this_unsafeFlow;

                @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.push.PushNotifications$special$$inlined$filter$1$2", m37f = "PushNotifications.kt", m38i = {}, m39l = {MessageContainerFactory.MAXIMUM_FILE_SIZE_IN_MB}, m40m = "emit", m41n = {}, m42s = {})
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
                        return C15282.this.emit(null, this);
                    }
                }

                public C15282(FlowCollector flowCollector) {
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
                        if (((String) obj).length() > 0) {
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
            public Object collect(FlowCollector<? super String> flowCollector, Continuation continuation) {
                Object objCollect = mutableStateFlow.collect(new C15282(flowCollector), continuation);
                return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
            }
        };
    }

    public final int getSmallNotificationIconId$zendesk_messaging_messaging_android() {
        return smallNotificationIconId;
    }

    public final void setSmallNotificationIconId$zendesk_messaging_messaging_android(int i) {
        smallNotificationIconId = i;
    }

    private final void initialize(Context context) {
        if (MessagingBuildConfig.INSTANCE.atLeastAndroid26()) {
            Object systemService = context.getSystemService("notification");
            NotificationManager notificationManager = systemService instanceof NotificationManager ? (NotificationManager) systemService : null;
            if (notificationManager != null) {
                String string = context.getString(C1256R.string.zma_notification_channel_name);
                Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
                l$a$.ExternalSyntheticApiModelOutline0.m(notificationManager, buildChannel(string));
            }
        }
        notificationProcessor = NotificationProcessorFactory.INSTANCE.create();
    }

    public final void reset$zendesk_messaging_messaging_android() {
        smallNotificationIconId = C1256R.drawable.zma_default_notification_icon;
        notificationProcessor = null;
    }

    private final NotificationChannel buildChannel(String channelName) {
        NioSystemFileSystem$$ExternalSyntheticApiModelOutline0.m172m();
        NotificationChannel notificationChannelM = l$a$.ExternalSyntheticApiModelOutline0.m(MESSAGING_NOTIFICATION_CHANNEL_ID, channelName, 4);
        notificationChannelM.enableVibration(true);
        notificationChannelM.enableLights(true);
        return notificationChannelM;
    }

    @JvmStatic
    public static final boolean validatePushIntegration(Context context, Map<String, String> messageData) {
        String string;
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(messageData, "messageData");
        String str = messageData.get(INTEGRATION_ID_KEY);
        Logger.m217d(LOG_TAG, "Push Integration ID: " + str, new Object[0]);
        SharedPreferences sharedPreferences = context.getSharedPreferences(CONVERSATION_KIT_STORAGE, 0);
        if (sharedPreferences.contains(INTEGRATION_ID_DATA_KEY)) {
            string = sharedPreferences.getString(INTEGRATION_ID_DATA_KEY, null);
        } else {
            string = "";
        }
        Logger.m217d(LOG_TAG, "Cached Integration ID: " + string, new Object[0]);
        if (Intrinsics.areEqual(string, str)) {
            return true;
        }
        Logger.m217d(LOG_TAG, "Notification received from Messaging but shouldn't be displayed as the cached cached integration id is different from the push integration id.", new Object[0]);
        return false;
    }

    @JvmStatic
    public static final void updatePushNotificationToken(String pushNotificationToken) {
        Intrinsics.checkNotNullParameter(pushNotificationToken, "pushNotificationToken");
        mutablePushNotificationToken.setValue(pushNotificationToken);
    }

    @JvmStatic
    public static final PushResponsibility shouldBeDisplayed(Map<String, String> messageData) {
        Intrinsics.checkNotNullParameter(messageData, "messageData");
        if (!Boolean.parseBoolean(messageData.get(NOTIFICATION_KEY))) {
            return PushResponsibility.NOT_FROM_MESSAGING;
        }
        Set<VisibleScreen> visibleScreens$zendesk_messaging_messaging_android = VisibleScreenTracker.INSTANCE.getVisibleScreens$zendesk_messaging_messaging_android();
        String str = messageData.get("conversationId");
        if (visibleScreens$zendesk_messaging_messaging_android.contains(VisibleScreen.ConversationListScreen.INSTANCE)) {
            return PushResponsibility.MESSAGING_SHOULD_NOT_DISPLAY;
        }
        Boolean boolValueOf = str != null ? Boolean.valueOf(VisibleScreenTracker.INSTANCE.m228x7fb2d242(str)) : null;
        if (str != null && Intrinsics.areEqual((Object) boolValueOf, (Object) true)) {
            Logger.m217d(LOG_TAG, "Notification received from Messaging but shouldn't be displayed as the Conversation Screen is displayed.", new Object[0]);
            return PushResponsibility.MESSAGING_SHOULD_NOT_DISPLAY;
        }
        return PushResponsibility.MESSAGING_SHOULD_DISPLAY;
    }

    @JvmStatic
    public static final void displayNotification(Context context, Map<String, String> messageData) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(messageData, "messageData");
        PushNotifications pushNotifications = INSTANCE;
        int i = WhenMappings.$EnumSwitchMapping$0[shouldBeDisplayed(messageData).ordinal()];
        if (i == 1) {
            Logger.m225w(LOG_TAG, "Cannot display notification because it doesn't belong to Messaging", new Object[0]);
        } else if (i == 2 || i == 3) {
            pushNotifications.initialize(context);
            BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C15271(context, messageData, null), 3, null);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.push.PushNotifications$displayNotification$1", m37f = "PushNotifications.kt", m38i = {}, m39l = {232}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15271 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Context $context;
        final Map<String, String> $messageData;
        int label;

        C15271(Context context, Map<String, String> map, Continuation<? super C15271> continuation) {
            super(2, continuation);
            this.$context = context;
            this.$messageData = map;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C15271(this.$context, this.$messageData, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C15271) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Unit unit;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                NotificationProcessor notificationProcessor = PushNotifications.notificationProcessor;
                if (notificationProcessor != null) {
                    this.label = 1;
                    if (notificationProcessor.displayPushNotification(this.$context, this.$messageData, new NotificationBuilder(new NotificationCompat.Builder(this.$context, PushNotifications.MESSAGING_NOTIFICATION_CHANNEL_ID), this.$context), PushNotifications.INSTANCE.getSmallNotificationIconId$zendesk_messaging_messaging_android(), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    unit = null;
                }
                if (unit == null) {
                    Logger.m225w(PushNotifications.LOG_TAG, "Cannot display notification because internal push setup has not completed", new Object[0]);
                }
                return Unit.INSTANCE;
            }
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            unit = Unit.INSTANCE;
            if (unit == null) {
                Logger.m225w(PushNotifications.LOG_TAG, "Cannot display notification because internal push setup has not completed", new Object[0]);
            }
            return Unit.INSTANCE;
        }
    }

    @JvmStatic
    public static final void setNotificationSmallIconId(Integer smallIconId) {
        smallNotificationIconId = smallIconId != null ? smallIconId.intValue() : C1256R.drawable.zma_default_notification_icon;
    }
}
