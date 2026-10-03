package zendesk.messaging.android.internal.validation;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.events.ZendeskEvent;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.internal.metadata.ConversationMetadataService;
import zendesk.core.android.internal.app.FeatureFlagManager;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001BC\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\"\u0010\u0006\u001a\u001e\b\u0001\u0012\u0004\u0012\u00020\b\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0007\u0012\u0006\u0010\u000b\u001a\u00020\f¢\u0006\u0002\u0010\rJ\"\u0010\u000f\u001a\u00020\n2\u0012\u0010\u0010\u001a\u000e\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00010\u0011H\u0086@¢\u0006\u0002\u0010\u0013R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R,\u0010\u0006\u001a\u001e\b\u0001\u0012\u0004\u0012\u00020\b\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0007X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u000eR\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/ConversationFieldManager;", "", "conversationFieldValidator", "Lzendesk/messaging/android/internal/validation/ConversationFieldValidator;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "dispatchEvent", "Lkotlin/Function2;", "Lzendesk/android/events/ZendeskEvent;", "Lkotlin/coroutines/Continuation;", "", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "(Lzendesk/messaging/android/internal/validation/ConversationFieldValidator;Lzendesk/conversationkit/android/ConversationKit;Lkotlin/jvm/functions/Function2;Lzendesk/core/android/internal/app/FeatureFlagManager;)V", "Lkotlin/jvm/functions/Function2;", "handleConversationFields", "conversationFields", "", "", "(Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationFieldManager {
    private final ConversationFieldValidator conversationFieldValidator;
    private final ConversationKit conversationKit;
    private final Function2<ZendeskEvent, Continuation<? super Unit>, Object> dispatchEvent;
    private final FeatureFlagManager featureFlagManager;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.validation.ConversationFieldManager", m37f = "ConversationFieldManager.kt", m38i = {0, 0, 1, 1, 1}, m39l = {23, 25, 32}, m40m = "handleConversationFields", m41n = {"this", "conversationFields", "this", "conversationFields", "result"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$2"})
    static final class C15261 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C15261(Continuation<? super C15261> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationFieldManager.this.handleConversationFields(null, this);
        }
    }

    @Inject
    public ConversationFieldManager(ConversationFieldValidator conversationFieldValidator, ConversationKit conversationKit, Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ? extends Object> dispatchEvent, FeatureFlagManager featureFlagManager) {
        Intrinsics.checkNotNullParameter(conversationFieldValidator, "conversationFieldValidator");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(dispatchEvent, "dispatchEvent");
        Intrinsics.checkNotNullParameter(featureFlagManager, "featureFlagManager");
        this.conversationFieldValidator = conversationFieldValidator;
        this.conversationKit = conversationKit;
        this.dispatchEvent = dispatchEvent;
        this.featureFlagManager = featureFlagManager;
    }

    public final Object handleConversationFields(Map<String, ? extends Object> map, Continuation<? super Unit> continuation) throws Throwable {
        C15261 c15261;
        ConversationFieldManager conversationFieldManager;
        List list;
        ConversationFieldManager conversationFieldManager2;
        Map<String, ? extends Object> map2;
        List list2;
        ConversationMetadataService conversationMetadataService;
        if (continuation instanceof C15261) {
            c15261 = (C15261) continuation;
            if ((c15261.label & Integer.MIN_VALUE) != 0) {
                c15261.label -= Integer.MIN_VALUE;
            } else {
                c15261 = new C15261(continuation);
            }
        } else {
            c15261 = new C15261(continuation);
        }
        Object validationErrorsOrEmpty$zendesk_messaging_messaging_android = c15261.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15261.label;
        if (i == 0) {
            ResultKt.throwOnFailure(validationErrorsOrEmpty$zendesk_messaging_messaging_android);
            if (this.featureFlagManager.getEnableConversationFieldValidator()) {
                ConversationFieldValidator conversationFieldValidator = this.conversationFieldValidator;
                c15261.L$0 = this;
                c15261.L$1 = map;
                c15261.label = 1;
                validationErrorsOrEmpty$zendesk_messaging_messaging_android = conversationFieldValidator.getValidationErrorsOrEmpty$zendesk_messaging_messaging_android(map, c15261);
                if (validationErrorsOrEmpty$zendesk_messaging_messaging_android == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationFieldManager = this;
            } else {
                conversationFieldManager = this;
            }
            conversationMetadataService = conversationFieldManager.conversationKit.conversationMetadataService();
            c15261.L$0 = conversationMetadataService;
            c15261.L$1 = null;
            c15261.L$2 = null;
            c15261.label = 3;
            if (conversationMetadataService.addConversationFields(map, c15261) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
        if (i == 1) {
            map = (Map) c15261.L$1;
            conversationFieldManager = (ConversationFieldManager) c15261.L$0;
            ResultKt.throwOnFailure(validationErrorsOrEmpty$zendesk_messaging_messaging_android);
        } else if (i == 2) {
            list2 = (List) c15261.L$2;
            map2 = (Map) c15261.L$1;
            conversationFieldManager2 = (ConversationFieldManager) c15261.L$0;
            ResultKt.throwOnFailure(validationErrorsOrEmpty$zendesk_messaging_messaging_android);
            list = list2;
            map = map2;
            conversationFieldManager = conversationFieldManager2;
            map = ConversationFieldValidatorKt.getOnlyValidFields(list, map);
            conversationMetadataService = conversationFieldManager.conversationKit.conversationMetadataService();
            c15261.L$0 = conversationMetadataService;
            c15261.L$1 = null;
            c15261.L$2 = null;
            c15261.label = 3;
            if (conversationMetadataService.addConversationFields(map, c15261) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 3) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(validationErrorsOrEmpty$zendesk_messaging_messaging_android);
        }
        return Unit.INSTANCE;
        list = (List) validationErrorsOrEmpty$zendesk_messaging_messaging_android;
        if (!list.isEmpty()) {
            Function2<ZendeskEvent, Continuation<? super Unit>, Object> function2 = conversationFieldManager.dispatchEvent;
            ZendeskEvent.FieldValidationFailed fieldValidationFailed = new ZendeskEvent.FieldValidationFailed(list);
            c15261.L$0 = conversationFieldManager;
            c15261.L$1 = map;
            c15261.L$2 = list;
            c15261.label = 2;
            if (function2.invoke(fieldValidationFailed, c15261) == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationFieldManager2 = conversationFieldManager;
            map2 = map;
            list2 = list;
            list = list2;
            map = map2;
            conversationFieldManager = conversationFieldManager2;
        }
        map = ConversationFieldValidatorKt.getOnlyValidFields(list, map);
        conversationMetadataService = conversationFieldManager.conversationKit.conversationMetadataService();
        c15261.L$0 = conversationMetadataService;
        c15261.L$1 = null;
        c15261.L$2 = null;
        c15261.label = 3;
        if (conversationMetadataService.addConversationFields(map, c15261) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }
}
