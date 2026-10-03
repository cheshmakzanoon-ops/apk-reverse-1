package zendesk.messaging.android.internal.validation;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.validation.model.ConversationField;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010!\n\u0002\b\u0002\b\u0000\u0018\u0000 \u00192\u00020\u0001:\u0001\u0019B\u0017\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J*\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n2\u0012\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u00010\rH\u0080@¢\u0006\u0004\b\u000f\u0010\u0010J4\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u00012\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00160\n2\f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u000b0\u0018H\u0002R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001a"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/ConversationFieldValidator;", "", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "conversationFieldRepository", "Lzendesk/messaging/android/internal/validation/ConversationFieldRepository;", "(Lzendesk/messaging/android/internal/validation/ValidationRules;Lzendesk/messaging/android/internal/validation/ConversationFieldRepository;)V", "getConversationFieldRepository", "()Lzendesk/messaging/android/internal/validation/ConversationFieldRepository;", "getValidationErrorsOrEmpty", "", "Lzendesk/messaging/android/internal/validation/ValidationError;", "fieldsToValidate", "", "", "getValidationErrorsOrEmpty$zendesk_messaging_messaging_android", "(Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "runFieldValidation", "", "id", "providedValue", "fetchedConversationFields", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "listOfErrors", "", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationFieldValidator {
    public static final String LOG_TAG = "ConversationFieldValidator";
    private final ConversationFieldRepository conversationFieldRepository;
    private final ValidationRules rules;

    @Inject
    public ConversationFieldValidator(ValidationRules rules, ConversationFieldRepository conversationFieldRepository) {
        Intrinsics.checkNotNullParameter(rules, "rules");
        Intrinsics.checkNotNullParameter(conversationFieldRepository, "conversationFieldRepository");
        this.rules = rules;
        this.conversationFieldRepository = conversationFieldRepository;
    }

    public final ConversationFieldRepository getConversationFieldRepository() {
        return this.conversationFieldRepository;
    }

    public final Object getValidationErrorsOrEmpty$zendesk_messaging_messaging_android(Map<String, ? extends Object> map, Continuation<? super List<? extends ValidationError>> continuation) throws Throwable {
        ConversationFieldValidator$getValidationErrorsOrEmpty$1 conversationFieldValidator$getValidationErrorsOrEmpty$1;
        ConversationFieldValidator conversationFieldValidator;
        if (continuation instanceof ConversationFieldValidator$getValidationErrorsOrEmpty$1) {
            conversationFieldValidator$getValidationErrorsOrEmpty$1 = (ConversationFieldValidator$getValidationErrorsOrEmpty$1) continuation;
            if ((conversationFieldValidator$getValidationErrorsOrEmpty$1.label & Integer.MIN_VALUE) != 0) {
                conversationFieldValidator$getValidationErrorsOrEmpty$1.label -= Integer.MIN_VALUE;
            } else {
                conversationFieldValidator$getValidationErrorsOrEmpty$1 = new ConversationFieldValidator$getValidationErrorsOrEmpty$1(this, continuation);
            }
        } else {
            conversationFieldValidator$getValidationErrorsOrEmpty$1 = new ConversationFieldValidator$getValidationErrorsOrEmpty$1(this, continuation);
        }
        Object objFetchConversationFields$zendesk_messaging_messaging_android = conversationFieldValidator$getValidationErrorsOrEmpty$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = conversationFieldValidator$getValidationErrorsOrEmpty$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objFetchConversationFields$zendesk_messaging_messaging_android);
            ConversationFieldRepository conversationFieldRepository = this.conversationFieldRepository;
            conversationFieldValidator$getValidationErrorsOrEmpty$1.L$0 = this;
            conversationFieldValidator$getValidationErrorsOrEmpty$1.L$1 = map;
            conversationFieldValidator$getValidationErrorsOrEmpty$1.label = 1;
            objFetchConversationFields$zendesk_messaging_messaging_android = conversationFieldRepository.fetchConversationFields$zendesk_messaging_messaging_android(conversationFieldValidator$getValidationErrorsOrEmpty$1);
            if (objFetchConversationFields$zendesk_messaging_messaging_android == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationFieldValidator = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            map = (Map) conversationFieldValidator$getValidationErrorsOrEmpty$1.L$1;
            conversationFieldValidator = (ConversationFieldValidator) conversationFieldValidator$getValidationErrorsOrEmpty$1.L$0;
            ResultKt.throwOnFailure(objFetchConversationFields$zendesk_messaging_messaging_android);
        }
        ConversationFieldResult conversationFieldResult = (ConversationFieldResult) objFetchConversationFields$zendesk_messaging_messaging_android;
        if (conversationFieldResult instanceof ConversationFieldResult.Error) {
            return CollectionsKt.listOf(((ConversationFieldResult.Error) conversationFieldResult).getError());
        }
        if (conversationFieldResult instanceof ConversationFieldResult.Success) {
            ArrayList arrayList = new ArrayList();
            for (Map.Entry<String, ? extends Object> entry : map.entrySet()) {
                conversationFieldValidator.runFieldValidation(entry.getKey(), entry.getValue(), (List) ((ConversationFieldResult.Success) conversationFieldResult).getData(), arrayList);
            }
            return arrayList;
        }
        throw new NoWhenBranchMatchedException();
    }

    private final void runFieldValidation(String id, Object providedValue, List<? extends ConversationField> fetchedConversationFields, List<ValidationError> listOfErrors) {
        Object next;
        Iterator<T> it = fetchedConversationFields.iterator();
        do {
            if (!it.hasNext()) {
                next = null;
                break;
            }
            next = it.next();
        } while (!Intrinsics.areEqual(((ConversationField) next).getId(), id));
        ConversationField conversationField = (ConversationField) next;
        if (conversationField != null) {
            String strValidate = conversationField.validate(providedValue, this.rules);
            if (strValidate != null) {
                listOfErrors.add(new ValidationError.FieldValidationFailed(id, strValidate));
                Logger.m219e(LOG_TAG, strValidate, new Object[0]);
                return;
            }
            return;
        }
        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
        String str = String.format(ValidationRules.FIELD_ID_NOT_FOUND_ERROR, Arrays.copyOf(new Object[]{id}, 1));
        Intrinsics.checkNotNullExpressionValue(str, "format(...)");
        listOfErrors.add(new ValidationError.FieldValidationFailed(id, str));
        Logger.m219e(LOG_TAG, str, new Object[0]);
    }
}
