package zendesk.p009ui.android.compose.utils;

import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0003\u001a\u00020\u0004¨\u0006\u0005"}, d2 = {"Lzendesk/ui/android/compose/utils/EnvironmentUtil;", "", "()V", "isUnderTest", "", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class EnvironmentUtil {
    public static final int $stable = 0;
    public static final EnvironmentUtil INSTANCE = new EnvironmentUtil();

    private EnvironmentUtil() {
    }

    public final boolean isUnderTest() {
        try {
            Class.forName("org.robolectric.Robolectric");
            return true;
        } catch (ClassNotFoundException unused) {
            return false;
        }
    }
}
