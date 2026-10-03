package coil.request;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000'\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0016J\u0018\u0010\u0006\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0007\u001a\u00020\bH\u0016J\u0010\u0010\t\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0016J\u0018\u0010\n\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0007\u001a\u00020\u000bH\u0016¨\u0006\f"}, d2 = {"coil/request/ImageRequest$Builder$listener$5", "Lcoil/request/ImageRequest$Listener;", "onCancel", "", "request", "Lcoil/request/ImageRequest;", "onError", "result", "Lcoil/request/ErrorResult;", "onStart", "onSuccess", "Lcoil/request/SuccessResult;", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = 176)
public final class ImageRequest$Builder$listener$5 implements ImageRequest.Listener {
    final Function1<ImageRequest, Unit> $onCancel;
    final Function2<ImageRequest, ErrorResult, Unit> $onError;
    final Function1<ImageRequest, Unit> $onStart;
    final Function2<ImageRequest, SuccessResult, Unit> $onSuccess;

    public ImageRequest$Builder$listener$5(Function1<? super ImageRequest, Unit> function1, Function1<? super ImageRequest, Unit> function2, Function2<? super ImageRequest, ? super ErrorResult, Unit> function3, Function2<? super ImageRequest, ? super SuccessResult, Unit> function4) {
        this.$onStart = function1;
        this.$onCancel = function2;
        this.$onError = function3;
        this.$onSuccess = function4;
    }

    @Override
    public void onStart(ImageRequest request) {
        this.$onStart.invoke(request);
    }

    @Override
    public void onCancel(ImageRequest request) {
        this.$onCancel.invoke(request);
    }

    @Override
    public void onError(ImageRequest request, ErrorResult result) {
        this.$onError.invoke(request, result);
    }

    @Override
    public void onSuccess(ImageRequest request, SuccessResult result) {
        this.$onSuccess.invoke(request, result);
    }
}
