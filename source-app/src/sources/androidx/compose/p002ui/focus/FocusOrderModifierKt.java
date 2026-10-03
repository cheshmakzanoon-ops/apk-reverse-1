package androidx.compose.p002ui.focus;

import androidx.compose.p002ui.Modifier;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000 \n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a%\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0017\u0010\u0002\u001a\u0013\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003¢\u0006\u0002\b\u0006H\u0007\u001a\u0014\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\u0007\u001a\u00020\bH\u0007\u001a-\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\u0007\u001a\u00020\b2\u0017\u0010\u0002\u001a\u0013\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003¢\u0006\u0002\b\u0006H\u0007¨\u0006\t"}, d2 = {"focusOrder", "Landroidx/compose/ui/Modifier;", "focusOrderReceiver", "Lkotlin/Function1;", "Landroidx/compose/ui/focus/FocusOrder;", "", "Lkotlin/ExtensionFunctionType;", "focusRequester", "Landroidx/compose/ui/focus/FocusRequester;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class FocusOrderModifierKt {
    @Deprecated(message = "Use focusProperties() instead", replaceWith = @ReplaceWith(expression = "this.focusProperties(focusOrderReceiver)", imports = {"androidx.compose.ui.focus.focusProperties"}))
    public static final Modifier focusOrder(Modifier modifier, Function1<? super FocusOrder, Unit> function1) {
        final FocusOrderToProperties focusOrderToProperties = new FocusOrderToProperties(function1);
        return FocusPropertiesKt.focusProperties(modifier, new Function1<FocusProperties, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((FocusProperties) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(FocusProperties focusProperties) {
                focusOrderToProperties.apply(focusProperties);
            }
        });
    }

    @Deprecated(message = "Use focusRequester() instead", replaceWith = @ReplaceWith(expression = "this.focusRequester(focusRequester)", imports = {"androidx.compose.ui.focus.focusRequester"}))
    public static final Modifier focusOrder(Modifier modifier, FocusRequester focusRequester) {
        return FocusRequesterModifierKt.focusRequester(modifier, focusRequester);
    }

    @Deprecated(message = "Use focusProperties() and focusRequester() instead", replaceWith = @ReplaceWith(expression = "this.focusRequester(focusRequester).focusProperties(focusOrderReceiver)", imports = {"androidx.compose.ui.focus.focusProperties, androidx.compose.ui.focus.focusRequester"}))
    public static final Modifier focusOrder(Modifier modifier, FocusRequester focusRequester, Function1<? super FocusOrder, Unit> function1) {
        final FocusOrderToProperties focusOrderToProperties = new FocusOrderToProperties(function1);
        return FocusPropertiesKt.focusProperties(FocusRequesterModifierKt.focusRequester(modifier, focusRequester), new Function1<FocusProperties, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((FocusProperties) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(FocusProperties focusProperties) {
                focusOrderToProperties.apply(focusProperties);
            }
        });
    }
}
