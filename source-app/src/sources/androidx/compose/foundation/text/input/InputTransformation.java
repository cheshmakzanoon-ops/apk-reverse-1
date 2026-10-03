package androidx.compose.foundation.text.input;

import androidx.compose.foundation.text.KeyboardOptions;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bç\u0080\u0001\u0018\u0000 \u000b2\u00020\u0001:\u0001\u000bJ\f\u0010\u0006\u001a\u00020\u0007*\u00020\bH\u0016J\f\u0010\t\u001a\u00020\u0007*\u00020\nH&R\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u00038VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\fÀ\u0006\u0001"}, d2 = {"Landroidx/compose/foundation/text/input/InputTransformation;", "", "keyboardOptions", "Landroidx/compose/foundation/text/KeyboardOptions;", "getKeyboardOptions", "()Landroidx/compose/foundation/text/KeyboardOptions;", "applySemantics", "", "Landroidx/compose/ui/semantics/SemanticsPropertyReceiver;", "transformInput", "Landroidx/compose/foundation/text/input/TextFieldBuffer;", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface InputTransformation {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    public final class CC {
        public static void $default$applySemantics(InputTransformation _this, SemanticsPropertyReceiver semanticsPropertyReceiver) {
        }

        public static KeyboardOptions $default$getKeyboardOptions(InputTransformation _this) {
            return null;
        }
    }

    void applySemantics(SemanticsPropertyReceiver semanticsPropertyReceiver);

    KeyboardOptions getKeyboardOptions();

    void transformInput(TextFieldBuffer textFieldBuffer);

    @Metadata(d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\f\u0010\u0003\u001a\u00020\u0004*\u00020\u0005H\u0016¨\u0006\u0006"}, d2 = {"Landroidx/compose/foundation/text/input/InputTransformation$Companion;", "Landroidx/compose/foundation/text/input/InputTransformation;", "()V", "transformInput", "", "Landroidx/compose/foundation/text/input/TextFieldBuffer;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion implements InputTransformation {
        static final Companion $$INSTANCE = new Companion();

        @Override
        public void applySemantics(SemanticsPropertyReceiver semanticsPropertyReceiver) {
            CC.$default$applySemantics(this, semanticsPropertyReceiver);
        }

        @Override
        public KeyboardOptions getKeyboardOptions() {
            return CC.$default$getKeyboardOptions(this);
        }

        @Override
        public void transformInput(TextFieldBuffer textFieldBuffer) {
        }

        private Companion() {
        }
    }
}
