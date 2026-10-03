package coil.request;

import android.graphics.drawable.Drawable;
import coil.target.Target;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u0012\u0010\u0002\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005H\u0016J\u0012\u0010\u0006\u001a\u00020\u00032\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005H\u0016J\u0010\u0010\b\u001a\u00020\u00032\u0006\u0010\t\u001a\u00020\u0005H\u0016¨\u0006\n"}, d2 = {"coil/request/ImageRequest$Builder$target$4", "Lcoil/target/Target;", "onError", "", "error", "Landroid/graphics/drawable/Drawable;", "onStart", "placeholder", "onSuccess", "result", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = 176)
public final class ImageRequest$Builder$target$4 implements Target {
    final Function1<Drawable, Unit> $onError;
    final Function1<Drawable, Unit> $onStart;
    final Function1<Drawable, Unit> $onSuccess;

    public ImageRequest$Builder$target$4(Function1<? super Drawable, Unit> function1, Function1<? super Drawable, Unit> function2, Function1<? super Drawable, Unit> function3) {
        this.$onStart = function1;
        this.$onError = function2;
        this.$onSuccess = function3;
    }

    @Override
    public void onStart(Drawable placeholder) {
        this.$onStart.invoke(placeholder);
    }

    @Override
    public void onError(Drawable error) {
        this.$onError.invoke(error);
    }

    @Override
    public void onSuccess(Drawable result) {
        this.$onSuccess.invoke(result);
    }
}
