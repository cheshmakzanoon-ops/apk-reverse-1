package androidx.compose.p002ui.node;

import androidx.compose.p002ui.focus.FocusDirection;
import androidx.compose.p002ui.focus.FocusProperties;
import androidx.compose.p002ui.focus.FocusRequester;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\t\n\u0002\u0010\u0002\n\u0000\bÂ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0006\u0010\f\u001a\u00020\u0004J\u0006\u0010\r\u001a\u00020\u000eR$\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00048V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\tR\u0012\u0010\n\u001a\u0004\u0018\u00010\u0004X\u0082\u000e¢\u0006\u0004\n\u0002\u0010\u000b¨\u0006\u000f"}, d2 = {"Landroidx/compose/ui/node/CanFocusChecker;", "Landroidx/compose/ui/focus/FocusProperties;", "()V", "value", "", "canFocus", "getCanFocus", "()Z", "setCanFocus", "(Z)V", "canFocusValue", "Ljava/lang/Boolean;", "isCanFocusSet", "reset", "", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class CanFocusChecker implements FocusProperties {
    public static final CanFocusChecker INSTANCE = new CanFocusChecker();
    private static Boolean canFocusValue;

    @Override
    public FocusRequester getDown() {
        return FocusRequester.INSTANCE.getDefault();
    }

    @Override
    public FocusRequester getEnd() {
        return FocusRequester.INSTANCE.getDefault();
    }

    @Override
    public Function1 getEnter() {
        return new Function1<FocusDirection, FocusRequester>() {
            public Object invoke(Object obj) {
                return m4282invoke3ESFkO8(((FocusDirection) obj).getValue());
            }

            public final FocusRequester m4282invoke3ESFkO8(int i) {
                return FocusRequester.INSTANCE.getDefault();
            }
        };
    }

    @Override
    public Function1 getExit() {
        return new Function1<FocusDirection, FocusRequester>() {
            public Object invoke(Object obj) {
                return m4283invoke3ESFkO8(((FocusDirection) obj).getValue());
            }

            public final FocusRequester m4283invoke3ESFkO8(int i) {
                return FocusRequester.INSTANCE.getDefault();
            }
        };
    }

    @Override
    public FocusRequester getLeft() {
        return FocusRequester.INSTANCE.getDefault();
    }

    @Override
    public FocusRequester getNext() {
        return FocusRequester.INSTANCE.getDefault();
    }

    @Override
    public FocusRequester getPrevious() {
        return FocusRequester.INSTANCE.getDefault();
    }

    @Override
    public FocusRequester getRight() {
        return FocusRequester.INSTANCE.getDefault();
    }

    @Override
    public FocusRequester getStart() {
        return FocusRequester.INSTANCE.getDefault();
    }

    @Override
    public FocusRequester getUp() {
        return FocusRequester.INSTANCE.getDefault();
    }

    @Override
    public void setDown(FocusRequester focusRequester) {
        FocusProperties.CC.$default$setDown(this, focusRequester);
    }

    @Override
    public void setEnd(FocusRequester focusRequester) {
        FocusProperties.CC.$default$setEnd(this, focusRequester);
    }

    @Override
    public void setEnter(Function1 function1) {
        FocusProperties.CC.$default$setEnter(this, function1);
    }

    @Override
    public void setExit(Function1 function1) {
        FocusProperties.CC.$default$setExit(this, function1);
    }

    @Override
    public void setLeft(FocusRequester focusRequester) {
        FocusProperties.CC.$default$setLeft(this, focusRequester);
    }

    @Override
    public void setNext(FocusRequester focusRequester) {
        FocusProperties.CC.$default$setNext(this, focusRequester);
    }

    @Override
    public void setPrevious(FocusRequester focusRequester) {
        FocusProperties.CC.$default$setPrevious(this, focusRequester);
    }

    @Override
    public void setRight(FocusRequester focusRequester) {
        FocusProperties.CC.$default$setRight(this, focusRequester);
    }

    @Override
    public void setStart(FocusRequester focusRequester) {
        FocusProperties.CC.$default$setStart(this, focusRequester);
    }

    @Override
    public void setUp(FocusRequester focusRequester) {
        FocusProperties.CC.$default$setUp(this, focusRequester);
    }

    private CanFocusChecker() {
    }

    @Override
    public boolean getCanFocus() throws KotlinNothingValueException {
        Boolean bool = canFocusValue;
        if (bool == null) {
            InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("canFocus is read before it is written");
            throw new KotlinNothingValueException();
        }
        return bool.booleanValue();
    }

    @Override
    public void setCanFocus(boolean z) {
        canFocusValue = Boolean.valueOf(z);
    }

    public final boolean isCanFocusSet() {
        return canFocusValue != null;
    }

    public final void reset() {
        canFocusValue = null;
    }
}
