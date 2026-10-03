package zendesk.messaging.android.internal.validation;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.validation.ConversationFieldValidator", m37f = "ConversationFieldValidator.kt", m38i = {0, 0}, m39l = {28}, m40m = "getValidationErrorsOrEmpty$zendesk_messaging_messaging_android", m41n = {"this", "fieldsToValidate"}, m42s = {"L$0", "L$1"})
final class ConversationFieldValidator$getValidationErrorsOrEmpty$1 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    int label;
    Object result;
    final ConversationFieldValidator this$0;

    ConversationFieldValidator$getValidationErrorsOrEmpty$1(ConversationFieldValidator conversationFieldValidator, Continuation<? super ConversationFieldValidator$getValidationErrorsOrEmpty$1> continuation) {
        super(continuation);
        this.this$0 = conversationFieldValidator;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.getValidationErrorsOrEmpty$zendesk_messaging_messaging_android(null, this);
    }
}
