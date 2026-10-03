package zendesk.messaging.android.internal.validation;

import java.util.List;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import retrofit2.http.GET;
import zendesk.messaging.android.internal.rest.model.ConversationFieldDto;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\ba\u0018\u00002\u00020\u0001J\u0014\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H§@¢\u0006\u0002\u0010\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/ConversationFieldService;", "", "getConversationFields", "", "Lzendesk/messaging/android/internal/rest/model/ConversationFieldDto;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationFieldService {
    @GET("/embeddable/messaging/custom_ticket_fields")
    Object getConversationFields(Continuation<? super List<ConversationFieldDto>> continuation);
}
