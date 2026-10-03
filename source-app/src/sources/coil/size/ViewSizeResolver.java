package coil.size;

import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.exifinterface.media.ExifInterface;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.jvm.functions.Function1;
import kotlinx.coroutines.CancellableContinuation;
import kotlinx.coroutines.CancellableContinuationImpl;

@Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bf\u0018\u0000*\b\b\u0000\u0010\u0001*\u00020\u00022\u00020\u0003J\"\u0010\u000b\u001a\u0004\u0018\u00010\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\u0010\u001a\u00020\u000eH\u0002J\n\u0010\u0011\u001a\u0004\u0018\u00010\fH\u0002J\n\u0010\u0012\u001a\u0004\u0018\u00010\u0013H\u0002J\n\u0010\u0014\u001a\u0004\u0018\u00010\fH\u0002J\u000e\u0010\u0015\u001a\u00020\u0013H\u0096@¢\u0006\u0002\u0010\u0016J\u0014\u0010\u0017\u001a\u00020\u0018*\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0002R\u0014\u0010\u0004\u001a\u00020\u00058VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007R\u0012\u0010\b\u001a\u00028\u0000X¦\u0004¢\u0006\u0006\u001a\u0004\b\t\u0010\nø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u001cÀ\u0006\u0003"}, d2 = {"Lcoil/size/ViewSizeResolver;", ExifInterface.GPS_DIRECTION_TRUE, "Landroid/view/View;", "Lcoil/size/SizeResolver;", "subtractPadding", "", "getSubtractPadding", "()Z", ViewHierarchyConstants.VIEW_KEY, "getView", "()Landroid/view/View;", "getDimension", "Lcoil/size/Dimension;", "paramSize", "", "viewSize", "paddingSize", "getHeight", "getSize", "Lcoil/size/Size;", "getWidth", "size", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removePreDrawListenerSafe", "", "Landroid/view/ViewTreeObserver;", "victim", "Landroid/view/ViewTreeObserver$OnPreDrawListener;", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public interface ViewSizeResolver<T extends View> extends SizeResolver {
    boolean getSubtractPadding();

    T getView();

    @Override
    Object size(Continuation<? super Size> continuation);

    public final class CC {
        public static boolean $default$getSubtractPadding(ViewSizeResolver _this) {
            return true;
        }

        public static <T extends View> Object size$suspendImpl(final ViewSizeResolver<T> viewSizeResolver, Continuation<? super Size> continuation) {
            Size size$private$getSize = $private$getSize(viewSizeResolver);
            if (size$private$getSize != null) {
                return size$private$getSize;
            }
            CancellableContinuation cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted(continuation), 1);
            cancellableContinuationImpl.initCancellability();
            final CancellableContinuation cancellableContinuation = cancellableContinuationImpl;
            final ViewTreeObserver viewTreeObserver = viewSizeResolver.getView().getViewTreeObserver();
            final ?? r3 = new ViewTreeObserver.OnPreDrawListener() {
                private boolean isResumed;

                @Override
                public boolean onPreDraw() {
                    Size size$private$getSize2 = ViewSizeResolver.CC.$private$getSize(viewSizeResolver);
                    if (size$private$getSize2 != null) {
                        ViewSizeResolver.CC.$private$removePreDrawListenerSafe(viewSizeResolver, viewTreeObserver, this);
                        if (!this.isResumed) {
                            this.isResumed = true;
                            Continuation continuation2 = cancellableContinuation;
                            Result.Companion companion = Result.Companion;
                            continuation2.resumeWith(Result.constructor-impl(size$private$getSize2));
                        }
                    }
                    return true;
                }
            };
            viewTreeObserver.addOnPreDrawListener((ViewTreeObserver.OnPreDrawListener) r3);
            cancellableContinuation.invokeOnCancellation(new Function1<Throwable, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((Throwable) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(Throwable th) {
                    ViewSizeResolver.CC.$private$removePreDrawListenerSafe(viewSizeResolver, viewTreeObserver, r3);
                }
            });
            Object result = cancellableContinuationImpl.getResult();
            if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
                DebugProbesKt.probeCoroutineSuspended(continuation);
            }
            return result;
        }

        public static Size $private$getSize(ViewSizeResolver _this) {
            Dimension dimension$private$getHeight;
            Dimension dimension$private$getWidth = $private$getWidth(_this);
            if (dimension$private$getWidth == null || (dimension$private$getHeight = $private$getHeight(_this)) == null) {
                return null;
            }
            return new Size(dimension$private$getWidth, dimension$private$getHeight);
        }

        public static Dimension $private$getWidth(ViewSizeResolver _this) {
            ViewGroup.LayoutParams layoutParams = _this.getView().getLayoutParams();
            return $private$getDimension(_this, layoutParams != null ? layoutParams.width : -1, _this.getView().getWidth(), _this.getSubtractPadding() ? _this.getView().getPaddingLeft() + _this.getView().getPaddingRight() : 0);
        }

        public static Dimension $private$getHeight(ViewSizeResolver _this) {
            ViewGroup.LayoutParams layoutParams = _this.getView().getLayoutParams();
            return $private$getDimension(_this, layoutParams != null ? layoutParams.height : -1, _this.getView().getHeight(), _this.getSubtractPadding() ? _this.getView().getPaddingTop() + _this.getView().getPaddingBottom() : 0);
        }

        public static Dimension $private$getDimension(ViewSizeResolver _this, int i, int i2, int i3) {
            if (i == -2) {
                return Dimension.Undefined.INSTANCE;
            }
            int i4 = i - i3;
            if (i4 > 0) {
                return Dimensions.Dimension(i4);
            }
            int i5 = i2 - i3;
            if (i5 > 0) {
                return Dimensions.Dimension(i5);
            }
            return null;
        }

        public static void $private$removePreDrawListenerSafe(ViewSizeResolver _this, ViewTreeObserver viewTreeObserver, ViewTreeObserver.OnPreDrawListener onPreDrawListener) {
            if (viewTreeObserver.isAlive()) {
                viewTreeObserver.removeOnPreDrawListener(onPreDrawListener);
            } else {
                _this.getView().getViewTreeObserver().removeOnPreDrawListener(onPreDrawListener);
            }
        }
    }

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class DefaultImpls {
        @Deprecated
        public static <T extends View> boolean getSubtractPadding(ViewSizeResolver<T> viewSizeResolver) {
            return CC.$default$getSubtractPadding(viewSizeResolver);
        }

        @Deprecated
        public static <T extends View> Object size(ViewSizeResolver<T> viewSizeResolver, Continuation<? super Size> continuation) {
            return CC.size$suspendImpl(viewSizeResolver, continuation);
        }
    }
}
