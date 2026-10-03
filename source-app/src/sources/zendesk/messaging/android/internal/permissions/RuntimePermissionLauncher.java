package zendesk.messaging.android.internal.permissions;

import android.content.Context;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.ActivityResultRegistry;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 \u00162\u00020\u0001:\u0001\u0016B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010\u000e\u001a\u00020\f2\u0006\u0010\u000f\u001a\u00020\tH\u0002J&\u0010\u0010\u001a\u00020\r2\u0006\u0010\u000f\u001a\u00020\t2\u0016\b\u0002\u0010\u0011\u001a\u0010\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\r\u0018\u00010\u000bJ\u0010\u0010\u0012\u001a\u00020\r2\u0006\u0010\u0013\u001a\u00020\u0014H\u0016J\u0010\u0010\u0015\u001a\u00020\r2\u0006\u0010\u0013\u001a\u00020\u0014H\u0002R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\bX\u0082.¢\u0006\u0002\n\u0000R\u001c\u0010\n\u001a\u0010\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\r\u0018\u00010\u000bX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0017"}, m18d2 = {"Lzendesk/messaging/android/internal/permissions/RuntimePermissionLauncher;", "Landroidx/lifecycle/DefaultLifecycleObserver;", "registry", "Landroidx/activity/result/ActivityResultRegistry;", "context", "Landroid/content/Context;", "(Landroidx/activity/result/ActivityResultRegistry;Landroid/content/Context;)V", "singlePermissionLauncher", "Landroidx/activity/result/ActivityResultLauncher;", "", "singlePermissionResultCallback", "Lkotlin/Function1;", "", "", "isPermissionGranted", "permission", "launchSinglePermissionRequest", "onSinglePermissionResult", "onCreate", "owner", "Landroidx/lifecycle/LifecycleOwner;", "setupSinglePermissionLauncher", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class RuntimePermissionLauncher implements DefaultLifecycleObserver {
    public static final String SINGLE_PERMISSION_KEY = "SINGLE_PERMISSION_KEY";
    private final Context context;
    private final ActivityResultRegistry registry;
    private ActivityResultLauncher<String> singlePermissionLauncher;
    private Function1<? super Boolean, Unit> singlePermissionResultCallback;

    public void onDestroy(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onDestroy(this, lifecycleOwner);
    }

    public void onPause(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onPause(this, lifecycleOwner);
    }

    public void onResume(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onResume(this, lifecycleOwner);
    }

    public void onStart(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onStart(this, lifecycleOwner);
    }

    public void onStop(LifecycleOwner lifecycleOwner) {
        DefaultLifecycleObserver.-CC.$default$onStop(this, lifecycleOwner);
    }

    public RuntimePermissionLauncher(ActivityResultRegistry registry, Context context) {
        Intrinsics.checkNotNullParameter(registry, "registry");
        Intrinsics.checkNotNullParameter(context, "context");
        this.registry = registry;
        this.context = context;
    }

    public void onCreate(LifecycleOwner owner) {
        Intrinsics.checkNotNullParameter(owner, "owner");
        DefaultLifecycleObserver.-CC.$default$onCreate(this, owner);
        setupSinglePermissionLauncher(owner);
    }

    private final void setupSinglePermissionLauncher(LifecycleOwner owner) {
        this.singlePermissionLauncher = this.registry.register(SINGLE_PERMISSION_KEY, owner, new ActivityResultContracts.RequestPermission(), new ActivityResultCallback() {
            public final void onActivityResult(Object obj) {
                RuntimePermissionLauncher.setupSinglePermissionLauncher$lambda$0(this.f$0, ((Boolean) obj).booleanValue());
            }
        });
    }

    public static final void setupSinglePermissionLauncher$lambda$0(RuntimePermissionLauncher this$0, boolean z) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Function1<? super Boolean, Unit> function1 = this$0.singlePermissionResultCallback;
        if (function1 != null) {
            function1.invoke(Boolean.valueOf(z));
        }
        this$0.singlePermissionResultCallback = null;
    }

    public static void launchSinglePermissionRequest$default(RuntimePermissionLauncher runtimePermissionLauncher, String str, Function1 function1, int i, Object obj) {
        if ((i & 2) != 0) {
            function1 = null;
        }
        runtimePermissionLauncher.launchSinglePermissionRequest(str, function1);
    }

    public final void launchSinglePermissionRequest(String permission, Function1<? super Boolean, Unit> onSinglePermissionResult) {
        Intrinsics.checkNotNullParameter(permission, "permission");
        if (isPermissionGranted(permission)) {
            if (onSinglePermissionResult != null) {
                onSinglePermissionResult.invoke(true);
            }
        } else {
            this.singlePermissionResultCallback = onSinglePermissionResult;
            ActivityResultLauncher<String> activityResultLauncher = this.singlePermissionLauncher;
            if (activityResultLauncher == null) {
                Intrinsics.throwUninitializedPropertyAccessException("singlePermissionLauncher");
                activityResultLauncher = null;
            }
            activityResultLauncher.launch(permission);
        }
    }

    private final boolean isPermissionGranted(String permission) {
        return ContextCompat.checkSelfPermission(this.context, permission) == 0;
    }
}
