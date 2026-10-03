package androidx.compose.p000ui.text.font;

import android.content.Context;
import android.graphics.Typeface;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.res.ResourcesCompat;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CancellableContinuation;
import kotlinx.coroutines.CancellableContinuationImpl;

@Metadata(d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u0014\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0002\u001a\u001a\u0010\u0005\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0082@¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, d2 = {"load", "Landroid/graphics/Typeface;", "Landroidx/compose/ui/text/font/ResourceFont;", "context", "Landroid/content/Context;", "loadAsync", "(Landroidx/compose/ui/text/font/ResourceFont;Landroid/content/Context;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "ui-text_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidFontLoader_androidKt {
    public static final Typeface load(ResourceFont resourceFont, Context context) {
        Typeface font = ResourcesCompat.getFont(context, resourceFont.getResId());
        Intrinsics.checkNotNull(font);
        return font;
    }

    public static final Object loadAsync(final ResourceFont resourceFont, Context context, Continuation<? super Typeface> continuation) {
        CancellableContinuation cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted(continuation), 1);
        cancellableContinuationImpl.initCancellability();
        final CancellableContinuation cancellableContinuation = cancellableContinuationImpl;
        ResourcesCompat.getFont(context, resourceFont.getResId(), new ResourcesCompat.FontCallback() {
            @Override
            public void m78x46c88379(Typeface typeface) {
                Continuation continuation2 = cancellableContinuation;
                Result.Companion companion = Result.Companion;
                continuation2.resumeWith(Result.constructor-impl(typeface));
            }

            @Override
            public void m77xb24343b7(int reason) {
                cancellableContinuation.cancel(new IllegalStateException("Unable to load font " + resourceFont + " (reason=" + reason + ')'));
            }
        }, null);
        Object result = cancellableContinuationImpl.getResult();
        if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
            DebugProbesKt.probeCoroutineSuspended(continuation);
        }
        return result;
    }
}
