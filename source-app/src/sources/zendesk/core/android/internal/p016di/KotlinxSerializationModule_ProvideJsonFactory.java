package zendesk.core.android.internal.p016di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import kotlinx.serialization.json.Json;

public final class KotlinxSerializationModule_ProvideJsonFactory implements Factory<Json> {
    @Override
    public Json get() {
        return provideJson();
    }

    public static KotlinxSerializationModule_ProvideJsonFactory create() {
        return InstanceHolder.INSTANCE;
    }

    public static Json provideJson() {
        return (Json) Preconditions.checkNotNullFromProvides(KotlinxSerializationModule.INSTANCE.provideJson());
    }

    private static final class InstanceHolder {
        private static final KotlinxSerializationModule_ProvideJsonFactory INSTANCE = new KotlinxSerializationModule_ProvideJsonFactory();

        private InstanceHolder() {
        }
    }
}
