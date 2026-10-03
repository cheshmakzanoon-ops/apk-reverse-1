package zendesk.android.settings.internal;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.Url;
import zendesk.android.settings.internal.model.SettingsResponseDto;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b`\u0018\u00002\u00020\u0001J\u0018\u0010\u0002\u001a\u00020\u00032\b\b\u0001\u0010\u0004\u001a\u00020\u0005H§@¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/android/settings/internal/SettingsApi;", "", "getSettings", "Lzendesk/android/settings/internal/model/SettingsResponseDto;", "settingsUrl", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface SettingsApi {
    @Headers({"X-Zendesk-Api-Version:2021-01-01"})
    @GET
    Object getSettings(@Url String str, Continuation<? super SettingsResponseDto> continuation);
}
