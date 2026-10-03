package zendesk.messaging.android.internal.validation.p025di;

import dagger.Module;
import dagger.Provides;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import retrofit2.Retrofit;
import zendesk.messaging.android.internal.validation.ConversationFieldService;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/di/ConversationFieldModule;", "", "()V", "provideConversationFieldService", "Lzendesk/messaging/android/internal/validation/ConversationFieldService;", "retrofit", "Lretrofit2/Retrofit;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class ConversationFieldModule {
    @Provides
    public final ConversationFieldService provideConversationFieldService(Retrofit retrofit) {
        Intrinsics.checkNotNullParameter(retrofit, "retrofit");
        Object objCreate = retrofit.create(ConversationFieldService.class);
        Intrinsics.checkNotNullExpressionValue(objCreate, "create(...)");
        return (ConversationFieldService) objCreate;
    }
}
