package zendesk.conversationkit.android.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.TimeUnit;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.rest.model.AppUserResponseDto;
import zendesk.conversationkit.android.internal.rest.model.ConversationDto;
import zendesk.conversationkit.android.internal.rest.model.RealtimeSettingsDto;
import zendesk.conversationkit.android.internal.rest.model.TypingSettingsDto;

@Metadata(m17d1 = {"\u0000:\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u0012\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004\u001a\u001c\u0010\u0005\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\tH\u0000\u001a\f\u0010\u000b\u001a\u00020\f*\u00020\rH\u0000\u001a\u001e\u0010\u000e\u001a\u00020\u0002*\u00020\u000f2\u0006\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\u0010\u001a\u00020\u0011H\u0000¨\u0006\u0012"}, m18d2 = {"isNotAuthoredBySameUser", "", "Lzendesk/conversationkit/android/model/User;", "author", "Lzendesk/conversationkit/android/model/Author;", "toRealtimeSettings", "Lzendesk/conversationkit/android/model/RealtimeSettings;", "Lzendesk/conversationkit/android/internal/rest/model/RealtimeSettingsDto;", "appId", "", "userId", "toTypingSettings", "Lzendesk/conversationkit/android/model/TypingSettings;", "Lzendesk/conversationkit/android/internal/rest/model/TypingSettingsDto;", "toUser", "Lzendesk/conversationkit/android/internal/rest/model/AppUserResponseDto;", "authenticationType", "Lzendesk/conversationkit/android/model/AuthenticationType;", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserKt {
    public static User toUser$default(AppUserResponseDto appUserResponseDto, String str, AuthenticationType authenticationType, int i, Object obj) {
        if ((i & 2) != 0) {
            if (appUserResponseDto.getSessionToken() != null) {
                authenticationType = new AuthenticationType.SessionToken(appUserResponseDto.getSessionToken());
            } else {
                authenticationType = AuthenticationType.Unauthenticated.INSTANCE;
            }
        }
        return toUser(appUserResponseDto, str, authenticationType);
    }

    public static final User toUser(AppUserResponseDto appUserResponseDto, String appId, AuthenticationType authenticationType) {
        Intrinsics.checkNotNullParameter(appUserResponseDto, "<this>");
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(authenticationType, "authenticationType");
        String id = appUserResponseDto.getAppUser().getId();
        String userId = appUserResponseDto.getAppUser().getUserId();
        String givenName = appUserResponseDto.getAppUser().getGivenName();
        String surname = appUserResponseDto.getAppUser().getSurname();
        String email = appUserResponseDto.getAppUser().getEmail();
        String locale = appUserResponseDto.getAppUser().getLocale();
        String signedUpAt = appUserResponseDto.getAppUser().getSignedUpAt();
        List<ConversationDto> conversations = appUserResponseDto.getConversations();
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(conversations, 10));
        Iterator<T> it = conversations.iterator();
        while (it.hasNext()) {
            arrayList.add(ConversationKt.toConversation$default((ConversationDto) it.next(), appUserResponseDto.getAppUser().getId(), appUserResponseDto.getAppUsers(), null, false, null, 28, null));
        }
        ArrayList arrayList2 = arrayList;
        RealtimeSettings realtimeSettings = toRealtimeSettings(appUserResponseDto.getSettings().getRealtime(), appId, appUserResponseDto.getAppUser().getId());
        TypingSettings typingSettings = toTypingSettings(appUserResponseDto.getSettings().getTyping());
        AuthenticationType.Jwt jwt = authenticationType instanceof AuthenticationType.Jwt ? (AuthenticationType.Jwt) authenticationType : null;
        String value = jwt != null ? jwt.getValue() : null;
        AuthenticationType.SessionToken sessionToken = authenticationType instanceof AuthenticationType.SessionToken ? (AuthenticationType.SessionToken) authenticationType : null;
        return new User(id, userId, givenName, surname, email, locale, signedUpAt, arrayList2, realtimeSettings, typingSettings, sessionToken != null ? sessionToken.getValue() : null, value, appUserResponseDto.getConversationsPagination().getHasMore());
    }

    public static final RealtimeSettings toRealtimeSettings(RealtimeSettingsDto realtimeSettingsDto, String appId, String userId) {
        Intrinsics.checkNotNullParameter(realtimeSettingsDto, "<this>");
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(userId, "userId");
        return new RealtimeSettings(realtimeSettingsDto.getEnabled(), realtimeSettingsDto.getBaseUrl(), realtimeSettingsDto.getRetryInterval(), realtimeSettingsDto.getMaxConnectionAttempts(), realtimeSettingsDto.getConnectionDelay(), (TimeUnit) null, appId, userId, 32, (DefaultConstructorMarker) null);
    }

    public static final TypingSettings toTypingSettings(TypingSettingsDto typingSettingsDto) {
        Intrinsics.checkNotNullParameter(typingSettingsDto, "<this>");
        return new TypingSettings(typingSettingsDto.getEnabled());
    }

    public static final boolean isNotAuthoredBySameUser(User user, Author author) {
        Intrinsics.checkNotNullParameter(user, "<this>");
        Intrinsics.checkNotNullParameter(author, "author");
        return !Intrinsics.areEqual(author.getUserId(), user.getId());
    }
}
