package coil.compose;

import android.content.Context;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.runtime.CompositionLocalKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.ProvidedValue;
import androidx.compose.ui.platform.AndroidCompositionLocals_androidKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import coil.Coil;
import coil.ImageLoader;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmInline;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Deprecated(message = "LocalImageLoader was intended to provide a method to overwrite the singleton ImageLoader in local compositions. In practice, it's not clear that `LocalImageLoader.provide` **does not** set the singleton ImageLoader. This can result in accidentally creating multiple ImageLoader instances if you use a combination of `LocalImageLoader.current` and `context.imageLoader`. To maximize performance, apps should create one ImageLoader or use `ImageLoader.newBuilder` to create new ImageLoaders that share the same resources.\n\nAdditionally, as a composition is at most scoped to an Activity, `LocalImageLoader.provide` encourages creating multiple ImageLoaders if the user creates multiple activities that use Compose.\n\nYou should migrate to `ImageLoaderFactory` to set the singleton ImageLoader and `LocalContext.current.imageLoader` to access the singleton ImageLoader in Compose. If you need to use a locally scoped ImageLoader it's recommended to use the `AsyncImage` and `rememberAsyncImagePainter` overloads that have an ImageLoader argument and pass the local ImageLoader as input.")
@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0087@\u0018\u00002\u00020\u0001B\u001b\b\u0000\u0012\u0010\b\u0002\u0010\u0002\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00040\u0003¢\u0006\u0004\b\u0005\u0010\u0006J\u001a\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u000f\u0010\u0010J\u0010\u0010\u0011\u001a\u00020\u0012HÖ\u0001¢\u0006\u0004\b\u0013\u0010\u0014J \u0010\u0015\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00040\u00162\u0006\u0010\u0017\u001a\u00020\u0004H\u0087\u0004¢\u0006\u0004\b\u0018\u0010\u0019J\u0010\u0010\u001a\u001a\u00020\u001bHÖ\u0001¢\u0006\u0004\b\u001c\u0010\u001dR\u001a\u0010\u0007\u001a\u00020\u00048GX\u0087\u0004¢\u0006\f\u0012\u0004\b\b\u0010\t\u001a\u0004\b\n\u0010\u000bR\u0016\u0010\u0002\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\n\u0012\u0006\u0012\u0004\u0018\u00010\u00040\u0003¨\u0006\u001e"}, d2 = {"Lcoil/compose/ImageLoaderProvidableCompositionLocal;", "", "delegate", "Landroidx/compose/runtime/ProvidableCompositionLocal;", "Lcoil/ImageLoader;", "constructor-impl", "(Landroidx/compose/runtime/ProvidableCompositionLocal;)Landroidx/compose/runtime/ProvidableCompositionLocal;", "current", "getCurrent$annotations", "()V", "getCurrent", "(Landroidx/compose/runtime/ProvidableCompositionLocal;Landroidx/compose/runtime/Composer;I)Lcoil/ImageLoader;", "equals", "", "other", "equals-impl", "(Landroidx/compose/runtime/ProvidableCompositionLocal;Ljava/lang/Object;)Z", "hashCode", "", "hashCode-impl", "(Landroidx/compose/runtime/ProvidableCompositionLocal;)I", "provides", "Landroidx/compose/runtime/ProvidedValue;", SDKConstants.PARAM_VALUE, "provides-impl", "(Landroidx/compose/runtime/ProvidableCompositionLocal;Lcoil/ImageLoader;)Landroidx/compose/runtime/ProvidedValue;", "toString", "", "toString-impl", "(Landroidx/compose/runtime/ProvidableCompositionLocal;)Ljava/lang/String;", "coil-compose-singleton_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class ImageLoaderProvidableCompositionLocal {
    private final ProvidableCompositionLocal<ImageLoader> delegate;

    public static final ImageLoaderProvidableCompositionLocal m2286boximpl(ProvidableCompositionLocal providableCompositionLocal) {
        return new ImageLoaderProvidableCompositionLocal(providableCompositionLocal);
    }

    public static ProvidableCompositionLocal<ImageLoader> m2287constructorimpl(ProvidableCompositionLocal<ImageLoader> providableCompositionLocal) {
        return providableCompositionLocal;
    }

    public static boolean m2289equalsimpl(ProvidableCompositionLocal<ImageLoader> providableCompositionLocal, Object obj) {
        return (obj instanceof ImageLoaderProvidableCompositionLocal) && Intrinsics.areEqual(providableCompositionLocal, ((ImageLoaderProvidableCompositionLocal) obj).getDelegate());
    }

    public static final boolean m2290equalsimpl0(ProvidableCompositionLocal<ImageLoader> providableCompositionLocal, ProvidableCompositionLocal<ImageLoader> providableCompositionLocal2) {
        return Intrinsics.areEqual(providableCompositionLocal, providableCompositionLocal2);
    }

    @Deprecated(message = "LocalImageLoader was intended to provide a method to overwrite the singleton ImageLoader in local compositions. In practice, it's not clear that `LocalImageLoader.provide` **does not** set the singleton ImageLoader. This can result in accidentally creating multiple ImageLoader instances if you use a combination of `LocalImageLoader.current` and `context.imageLoader`. To maximize performance, apps should create one ImageLoader or use `ImageLoader.newBuilder` to create new ImageLoaders that share the same resources.\n\nAdditionally, as a composition is at most scoped to an Activity, `LocalImageLoader.provide` encourages creating multiple ImageLoaders if the user creates multiple activities that use Compose.\n\nYou should migrate to `ImageLoaderFactory` to set the singleton ImageLoader and `LocalContext.current.imageLoader` to access the singleton ImageLoader in Compose. If you need to use a locally scoped ImageLoader it's recommended to use the `AsyncImage` and `rememberAsyncImagePainter` overloads that have an ImageLoader argument and pass the local ImageLoader as input.", replaceWith = @ReplaceWith(expression = "LocalContext.current.imageLoader", imports = {"androidx.compose.ui.platform.LocalContext", "coil.imageLoader"}))
    public static void getCurrent$annotations() {
    }

    public static int m2291hashCodeimpl(ProvidableCompositionLocal<ImageLoader> providableCompositionLocal) {
        return providableCompositionLocal.hashCode();
    }

    public static String m2293toStringimpl(ProvidableCompositionLocal<ImageLoader> providableCompositionLocal) {
        return "ImageLoaderProvidableCompositionLocal(delegate=" + providableCompositionLocal + ')';
    }

    public boolean equals(Object obj) {
        return m2289equalsimpl(this.delegate, obj);
    }

    public int hashCode() {
        return m2291hashCodeimpl(this.delegate);
    }

    public String toString() {
        return m2293toStringimpl(this.delegate);
    }

    public final ProvidableCompositionLocal getDelegate() {
        return this.delegate;
    }

    private ImageLoaderProvidableCompositionLocal(ProvidableCompositionLocal providableCompositionLocal) {
        this.delegate = providableCompositionLocal;
    }

    public static ProvidableCompositionLocal m2288constructorimpl$default(ProvidableCompositionLocal providableCompositionLocal, int i, DefaultConstructorMarker defaultConstructorMarker) {
        if ((i & 1) != 0) {
            providableCompositionLocal = CompositionLocalKt.staticCompositionLocalOf(new Function0<ImageLoader>() {
                public final ImageLoader m2295invoke() {
                    return null;
                }
            });
        }
        return m2287constructorimpl(providableCompositionLocal);
    }

    public static final ImageLoader getCurrent(ProvidableCompositionLocal<ImageLoader> providableCompositionLocal, Composer composer, int i) {
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-617597678, i, -1, "coil.compose.ImageLoaderProvidableCompositionLocal.<get-current> (LocalImageLoader.kt:49)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume((CompositionLocal) providableCompositionLocal);
        ComposerKt.sourceInformationMarkerEnd(composer);
        ImageLoader imageLoader = (ImageLoader) objConsume;
        if (imageLoader == null) {
            CompositionLocal localContext = AndroidCompositionLocals_androidKt.getLocalContext();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume2 = composer.consume(localContext);
            ComposerKt.sourceInformationMarkerEnd(composer);
            imageLoader = Coil.imageLoader((Context) objConsume2);
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        return imageLoader;
    }

    @Deprecated(message = "Implement `ImageLoaderFactory` in your `android.app.Application` class.")
    public static final ProvidedValue<ImageLoader> m2292providesimpl(ProvidableCompositionLocal<ImageLoader> providableCompositionLocal, ImageLoader imageLoader) {
        return providableCompositionLocal.provides(imageLoader);
    }
}
