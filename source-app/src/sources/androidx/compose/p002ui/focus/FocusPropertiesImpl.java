package androidx.compose.p002ui.focus;

import kotlin.Metadata;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u001c\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002R\u001a\u0010\u0003\u001a\u00020\u0004X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\bR\u001a\u0010\t\u001a\u00020\nX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u001a\u0010\u000f\u001a\u00020\nX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0010\u0010\f\"\u0004\b\u0011\u0010\u000eR,\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\n0\u0013X\u0096\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b\u0015\u0010\u0002\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R,\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\n0\u0013X\u0096\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b\u001b\u0010\u0002\u001a\u0004\b\u001c\u0010\u0017\"\u0004\b\u001d\u0010\u0019R\u001a\u0010\u001e\u001a\u00020\nX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001f\u0010\f\"\u0004\b \u0010\u000eR\u001a\u0010!\u001a\u00020\nX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\"\u0010\f\"\u0004\b#\u0010\u000eR\u001a\u0010$\u001a\u00020\nX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b%\u0010\f\"\u0004\b&\u0010\u000eR\u001a\u0010'\u001a\u00020\nX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b(\u0010\f\"\u0004\b)\u0010\u000eR\u001a\u0010*\u001a\u00020\nX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b+\u0010\f\"\u0004\b,\u0010\u000eR\u001a\u0010-\u001a\u00020\nX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b.\u0010\f\"\u0004\b/\u0010\u000e¨\u00060"}, d2 = {"Landroidx/compose/ui/focus/FocusPropertiesImpl;", "Landroidx/compose/ui/focus/FocusProperties;", "()V", "canFocus", "", "getCanFocus", "()Z", "setCanFocus", "(Z)V", "down", "Landroidx/compose/ui/focus/FocusRequester;", "getDown", "()Landroidx/compose/ui/focus/FocusRequester;", "setDown", "(Landroidx/compose/ui/focus/FocusRequester;)V", "end", "getEnd", "setEnd", "enter", "Lkotlin/Function1;", "Landroidx/compose/ui/focus/FocusDirection;", "getEnter$annotations", "getEnter", "()Lkotlin/jvm/functions/Function1;", "setEnter", "(Lkotlin/jvm/functions/Function1;)V", "exit", "getExit$annotations", "getExit", "setExit", "left", "getLeft", "setLeft", "next", "getNext", "setNext", "previous", "getPrevious", "setPrevious", "right", "getRight", "setRight", "start", "getStart", "setStart", "up", "getUp", "setUp", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class FocusPropertiesImpl implements FocusProperties {
    public static final int $stable = 8;
    private boolean canFocus = true;
    private FocusRequester next = FocusRequester.INSTANCE.getDefault();
    private FocusRequester previous = FocusRequester.INSTANCE.getDefault();
    private FocusRequester up = FocusRequester.INSTANCE.getDefault();
    private FocusRequester down = FocusRequester.INSTANCE.getDefault();
    private FocusRequester left = FocusRequester.INSTANCE.getDefault();
    private FocusRequester right = FocusRequester.INSTANCE.getDefault();
    private FocusRequester start = FocusRequester.INSTANCE.getDefault();
    private FocusRequester end = FocusRequester.INSTANCE.getDefault();
    private Function1<? super FocusDirection, FocusRequester> enter = new Function1<FocusDirection, FocusRequester>() {
        public Object invoke(Object obj) {
            return m4284invoke3ESFkO8(((FocusDirection) obj).getValue());
        }

        public final FocusRequester m4284invoke3ESFkO8(int i) {
            return FocusRequester.INSTANCE.getDefault();
        }
    };
    private Function1<? super FocusDirection, FocusRequester> exit = new Function1<FocusDirection, FocusRequester>() {
        public Object invoke(Object obj) {
            return m4285invoke3ESFkO8(((FocusDirection) obj).getValue());
        }

        public final FocusRequester m4285invoke3ESFkO8(int i) {
            return FocusRequester.INSTANCE.getDefault();
        }
    };

    public static void getEnter$annotations() {
    }

    public static void getExit$annotations() {
    }

    @Override
    public boolean getCanFocus() {
        return this.canFocus;
    }

    @Override
    public void setCanFocus(boolean z) {
        this.canFocus = z;
    }

    @Override
    public FocusRequester getNext() {
        return this.next;
    }

    @Override
    public void setNext(FocusRequester focusRequester) {
        this.next = focusRequester;
    }

    @Override
    public FocusRequester getPrevious() {
        return this.previous;
    }

    @Override
    public void setPrevious(FocusRequester focusRequester) {
        this.previous = focusRequester;
    }

    @Override
    public FocusRequester getUp() {
        return this.up;
    }

    @Override
    public void setUp(FocusRequester focusRequester) {
        this.up = focusRequester;
    }

    @Override
    public FocusRequester getDown() {
        return this.down;
    }

    @Override
    public void setDown(FocusRequester focusRequester) {
        this.down = focusRequester;
    }

    @Override
    public FocusRequester getLeft() {
        return this.left;
    }

    @Override
    public void setLeft(FocusRequester focusRequester) {
        this.left = focusRequester;
    }

    @Override
    public FocusRequester getRight() {
        return this.right;
    }

    @Override
    public void setRight(FocusRequester focusRequester) {
        this.right = focusRequester;
    }

    @Override
    public FocusRequester getStart() {
        return this.start;
    }

    @Override
    public void setStart(FocusRequester focusRequester) {
        this.start = focusRequester;
    }

    @Override
    public FocusRequester getEnd() {
        return this.end;
    }

    @Override
    public void setEnd(FocusRequester focusRequester) {
        this.end = focusRequester;
    }

    @Override
    public Function1<FocusDirection, FocusRequester> getEnter() {
        return this.enter;
    }

    @Override
    public void setEnter(Function1<? super FocusDirection, FocusRequester> function1) {
        this.enter = function1;
    }

    @Override
    public Function1<FocusDirection, FocusRequester> getExit() {
        return this.exit;
    }

    @Override
    public void setExit(Function1<? super FocusDirection, FocusRequester> function1) {
        this.exit = function1;
    }
}
