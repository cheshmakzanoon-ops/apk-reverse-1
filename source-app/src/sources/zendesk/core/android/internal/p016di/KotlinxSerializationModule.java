package zendesk.core.android.internal.p016di;

import dagger.Module;
import dagger.Provides;
import j$.time.LocalDateTime;
import java.util.Date;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonBuilder;
import kotlinx.serialization.json.JsonKt;
import kotlinx.serialization.modules.SerializersModuleBuilder;
import zendesk.core.android.internal.InternalZendeskApi;
import zendesk.core.android.internal.serializer.AnySerializer;
import zendesk.core.android.internal.serializer.DateSerializer;
import zendesk.core.android.internal.serializer.LocalDateTimeSerializer;

@InternalZendeskApi
@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0003\u001a\u00020\u0004H\u0007¨\u0006\u0005"}, m18d2 = {"Lzendesk/core/android/internal/di/KotlinxSerializationModule;", "", "()V", "provideJson", "Lkotlinx/serialization/json/Json;", "zendesk.core_core-utilities"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class KotlinxSerializationModule {
    public static final KotlinxSerializationModule INSTANCE = new KotlinxSerializationModule();

    private KotlinxSerializationModule() {
    }

    @Provides
    public final Json provideJson() {
        return JsonKt.Json$default(null, new Function1<JsonBuilder, Unit>() {
            @Override
            public Unit invoke(JsonBuilder jsonBuilder) {
                invoke2(jsonBuilder);
                return Unit.INSTANCE;
            }

            public final void invoke2(JsonBuilder Json) {
                Intrinsics.checkNotNullParameter(Json, "$this$Json");
                Json.setEncodeDefaults(true);
                Json.setIgnoreUnknownKeys(true);
                Json.setExplicitNulls(false);
                Json.setLenient(true);
                SerializersModuleBuilder serializersModuleBuilder = new SerializersModuleBuilder();
                serializersModuleBuilder.contextual(Reflection.getOrCreateKotlinClass(LocalDateTime.class), LocalDateTimeSerializer.INSTANCE);
                serializersModuleBuilder.contextual(Reflection.getOrCreateKotlinClass(Date.class), DateSerializer.INSTANCE);
                serializersModuleBuilder.contextual(Reflection.getOrCreateKotlinClass(Object.class), AnySerializer.INSTANCE);
                Json.setSerializersModule(serializersModuleBuilder.build());
            }
        }, 1, null);
    }
}
