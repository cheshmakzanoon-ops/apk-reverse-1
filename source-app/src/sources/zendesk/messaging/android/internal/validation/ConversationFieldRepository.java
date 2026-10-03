package zendesk.messaging.android.internal.validation;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.SerializationException;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.rest.model.ConversationFieldDto;
import zendesk.messaging.android.internal.rest.model.ConversationFieldDtoKt;
import zendesk.messaging.android.internal.validation.model.ConversationField;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000 \u000b2\u00020\u0001:\u0001\u000bB\u000f\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u001c\u0010\u0005\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u0006H\u0080@¢\u0006\u0004\b\t\u0010\nR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\f"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/ConversationFieldRepository;", "", "conversationFieldService", "Lzendesk/messaging/android/internal/validation/ConversationFieldService;", "(Lzendesk/messaging/android/internal/validation/ConversationFieldService;)V", "fetchConversationFields", "Lzendesk/messaging/android/internal/validation/ConversationFieldResult;", "", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "fetchConversationFields$zendesk_messaging_messaging_android", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationFieldRepository {
    public static final String LOG_TAG = "MessagingFieldRepository";
    private final ConversationFieldService conversationFieldService;

    @Inject
    public ConversationFieldRepository(ConversationFieldService conversationFieldService) {
        Intrinsics.checkNotNullParameter(conversationFieldService, "conversationFieldService");
        this.conversationFieldService = conversationFieldService;
    }

    public final Object fetchConversationFields$zendesk_messaging_messaging_android(Continuation<? super ConversationFieldResult<? extends List<? extends ConversationField>>> continuation) throws Throwable {
        ConversationFieldRepository$fetchConversationFields$1 conversationFieldRepository$fetchConversationFields$1;
        if (continuation instanceof ConversationFieldRepository$fetchConversationFields$1) {
            conversationFieldRepository$fetchConversationFields$1 = (ConversationFieldRepository$fetchConversationFields$1) continuation;
            if ((conversationFieldRepository$fetchConversationFields$1.label & Integer.MIN_VALUE) != 0) {
                conversationFieldRepository$fetchConversationFields$1.label -= Integer.MIN_VALUE;
            } else {
                conversationFieldRepository$fetchConversationFields$1 = new ConversationFieldRepository$fetchConversationFields$1(this, continuation);
            }
        } else {
            conversationFieldRepository$fetchConversationFields$1 = new ConversationFieldRepository$fetchConversationFields$1(this, continuation);
        }
        Object conversationFields = conversationFieldRepository$fetchConversationFields$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = conversationFieldRepository$fetchConversationFields$1.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(conversationFields);
                ConversationFieldService conversationFieldService = this.conversationFieldService;
                conversationFieldRepository$fetchConversationFields$1.label = 1;
                conversationFields = conversationFieldService.getConversationFields(conversationFieldRepository$fetchConversationFields$1);
                if (conversationFields == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(conversationFields);
            }
            ArrayList arrayList = new ArrayList();
            Iterator it = ((Iterable) conversationFields).iterator();
            while (it.hasNext()) {
                ConversationField conversationField = ConversationFieldDtoKt.toConversationField((ConversationFieldDto) it.next());
                if (conversationField != null) {
                    arrayList.add(conversationField);
                }
            }
            Logger.m217d(LOG_TAG, "Received response for conversation fields.", new Object[0]);
            return new ConversationFieldResult.Success(arrayList);
        } catch (SerializationException e) {
            Logger.m218e(LOG_TAG, "GET request for conversation fields failed to decode malformed JSON response.", e, new Object[0]);
            return new ConversationFieldResult.Error(new ValidationError.FieldRetrievalFailed(ValidationRules.UNABLE_VALIDATE_ERROR));
        } catch (Throwable th) {
            Logger.m218e(LOG_TAG, "Failed to get conversation fields.", th, new Object[0]);
            return new ConversationFieldResult.Error(new ValidationError.FieldRetrievalFailed(ValidationRules.UNABLE_VALIDATE_ERROR));
        }
    }
}
