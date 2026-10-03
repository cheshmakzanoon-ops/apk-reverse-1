package zendesk.messaging.android.internal.messagingscreen.p024di;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import dagger.Module;
import dagger.Provides;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.C1256R;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\b\u0010\u0003\u001a\u00020\u0004H\u0007J\u0010\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0007¨\u0006\t"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/di/MessagingNavigatorModule;", "", "()V", "provideFragmentContainerId", "", "provideFragmentManager", "Landroidx/fragment/app/FragmentManager;", "activity", "Landroidx/appcompat/app/AppCompatActivity;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class MessagingNavigatorModule {
    @Provides
    public final FragmentManager provideFragmentManager(AppCompatActivity activity) {
        Intrinsics.checkNotNullParameter(activity, "activity");
        FragmentManager supportFragmentManager = activity.getSupportFragmentManager();
        Intrinsics.checkNotNullExpressionValue(supportFragmentManager, "getSupportFragmentManager(...)");
        return supportFragmentManager;
    }

    @Provides
    public final int provideFragmentContainerId() {
        return C1256R.id.zma_fragment_container;
    }
}
