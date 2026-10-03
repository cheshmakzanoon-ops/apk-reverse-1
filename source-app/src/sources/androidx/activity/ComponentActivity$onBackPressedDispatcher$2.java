package androidx.activity;

import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001H\n¢\u0006\u0002\b\u0002"}, d2 = {"<anonymous>", "Landroidx/activity/OnBackPressedDispatcher;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 48)
final class ComponentActivity$onBackPressedDispatcher$2 extends Lambda implements Function0<OnBackPressedDispatcher> {
    final ComponentActivity this$0;

    ComponentActivity$onBackPressedDispatcher$2(ComponentActivity componentActivity) {
        super(0);
        this.this$0 = componentActivity;
    }

    public final OnBackPressedDispatcher m230invoke() {
        final ComponentActivity componentActivity = this.this$0;
        final OnBackPressedDispatcher onBackPressedDispatcher = new OnBackPressedDispatcher(new Runnable() {
            @Override
            public final void run() {
                ComponentActivity$onBackPressedDispatcher$2.invoke$lambda$0(componentActivity);
            }
        });
        final ComponentActivity componentActivity2 = this.this$0;
        if (Build.VERSION.SDK_INT >= 33) {
            if (Intrinsics.areEqual(Looper.myLooper(), Looper.getMainLooper())) {
                componentActivity2.addObserverForBackInvoker(onBackPressedDispatcher);
            } else {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public final void run() {
                        ComponentActivity$onBackPressedDispatcher$2.invoke$lambda$2$lambda$1(componentActivity2, onBackPressedDispatcher);
                    }
                });
            }
        }
        return onBackPressedDispatcher;
    }

    public static final void invoke$lambda$0(ComponentActivity componentActivity) {
        Intrinsics.checkNotNullParameter(componentActivity, "this$0");
        try {
            super/*androidx.core.app.ComponentActivity*/.onBackPressed();
        } catch (IllegalStateException e) {
            if (!Intrinsics.areEqual(e.getMessage(), "Can not perform this action after onSaveInstanceState")) {
                throw e;
            }
        } catch (NullPointerException e2) {
            if (!Intrinsics.areEqual(e2.getMessage(), "Attempt to invoke virtual method 'android.os.Handler android.app.FragmentHostCallback.getHandler()' on a null object reference")) {
                throw e2;
            }
        }
    }

    public static final void invoke$lambda$2$lambda$1(ComponentActivity componentActivity, OnBackPressedDispatcher onBackPressedDispatcher) {
        Intrinsics.checkNotNullParameter(componentActivity, "this$0");
        Intrinsics.checkNotNullParameter(onBackPressedDispatcher, "$dispatcher");
        componentActivity.addObserverForBackInvoker(onBackPressedDispatcher);
    }
}
