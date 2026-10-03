package com.google.firebase.sessions;

import com.google.android.datatransport.TransportFactory;
import com.google.firebase.FirebaseApp;
import com.google.firebase.annotations.concurrent.Background;
import com.google.firebase.annotations.concurrent.Blocking;
import com.google.firebase.components.Component;
import com.google.firebase.components.ComponentContainer;
import com.google.firebase.components.ComponentFactory;
import com.google.firebase.components.ComponentRegistrar;
import com.google.firebase.components.Dependency;
import com.google.firebase.components.Qualified;
import com.google.firebase.inject.Provider;
import com.google.firebase.installations.FirebaseInstallationsApi;
import com.google.firebase.platforminfo.LibraryVersionComponent;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineDispatcher;

@Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\b\u0001\u0018\u0000 \b2\u00020\u0001:\u0001\bB\u0005¢\u0006\u0002\u0010\u0002J6\u0010\u0003\u001a0\u0012,\u0012*\u0012\u000e\b\u0001\u0012\n \u0007*\u0004\u0018\u00010\u00060\u0006 \u0007*\u0014\u0012\u000e\b\u0001\u0012\n \u0007*\u0004\u0018\u00010\u00060\u0006\u0018\u00010\u00050\u00050\u0004H\u0016¨\u0006\t"}, d2 = {"Lcom/google/firebase/sessions/FirebaseSessionsRegistrar;", "Lcom/google/firebase/components/ComponentRegistrar;", "()V", "getComponents", "", "Lcom/google/firebase/components/Component;", "", "kotlin.jvm.PlatformType", "Companion", "com.google.firebase-firebase-sessions"}, k = 1, mv = {1, 7, 1}, xi = 48)
public final class FirebaseSessionsRegistrar implements ComponentRegistrar {
    private static final String LIBRARY_NAME = "fire-sessions";
    private static final Qualified<FirebaseApp> firebaseApp = Qualified.unqualified(FirebaseApp.class);
    private static final Qualified<FirebaseInstallationsApi> firebaseInstallationsApi = Qualified.unqualified(FirebaseInstallationsApi.class);
    private static final Qualified<CoroutineDispatcher> backgroundDispatcher = Qualified.qualified(Background.class, CoroutineDispatcher.class);
    private static final Qualified<CoroutineDispatcher> blockingDispatcher = Qualified.qualified(Blocking.class, CoroutineDispatcher.class);
    private static final Qualified<TransportFactory> transportFactory = Qualified.unqualified(TransportFactory.class);

    @Override
    public List<Component<? extends Object>> getComponents() {
        return CollectionsKt.listOf(new Component[]{Component.builder(FirebaseSessions.class).name(LIBRARY_NAME).add(Dependency.required(firebaseApp)).add(Dependency.required(firebaseInstallationsApi)).add(Dependency.required((Qualified<?>) backgroundDispatcher)).add(Dependency.required((Qualified<?>) blockingDispatcher)).add(Dependency.requiredProvider((Qualified<?>) transportFactory)).factory(new ComponentFactory() {
            @Override
            public final Object create(ComponentContainer componentContainer) {
                return FirebaseSessionsRegistrar.m783getComponents$lambda0(componentContainer);
            }
        }).build(), LibraryVersionComponent.create(LIBRARY_NAME, BuildConfig.VERSION_NAME)});
    }

    public static final FirebaseSessions m783getComponents$lambda0(ComponentContainer componentContainer) {
        Object obj = componentContainer.get(firebaseApp);
        Intrinsics.checkNotNullExpressionValue(obj, "container.get(firebaseApp)");
        FirebaseApp firebaseApp2 = (FirebaseApp) obj;
        Object obj2 = componentContainer.get(firebaseInstallationsApi);
        Intrinsics.checkNotNullExpressionValue(obj2, "container.get(firebaseInstallationsApi)");
        FirebaseInstallationsApi firebaseInstallationsApi2 = (FirebaseInstallationsApi) obj2;
        Object obj3 = componentContainer.get(backgroundDispatcher);
        Intrinsics.checkNotNullExpressionValue(obj3, "container.get(backgroundDispatcher)");
        CoroutineDispatcher coroutineDispatcher = (CoroutineDispatcher) obj3;
        Object obj4 = componentContainer.get(blockingDispatcher);
        Intrinsics.checkNotNullExpressionValue(obj4, "container.get(blockingDispatcher)");
        CoroutineDispatcher coroutineDispatcher2 = (CoroutineDispatcher) obj4;
        Provider provider = componentContainer.getProvider(transportFactory);
        Intrinsics.checkNotNullExpressionValue(provider, "container.getProvider(transportFactory)");
        return new FirebaseSessions(firebaseApp2, firebaseInstallationsApi2, coroutineDispatcher, coroutineDispatcher2, provider);
    }
}
