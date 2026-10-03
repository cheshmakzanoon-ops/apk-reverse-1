package androidx.core.view.autofill;

import android.view.autofill.AutofillId;
import androidx.core.app.NotificationCompat$$ExternalSyntheticApiModelOutline0;

public class AutofillIdCompat {
    private final Object mWrappedObj;

    private AutofillIdCompat(AutofillId autofillId) {
        this.mWrappedObj = autofillId;
    }

    public static AutofillIdCompat toAutofillIdCompat(AutofillId autofillId) {
        return new AutofillIdCompat(autofillId);
    }

    public AutofillId toAutofillId() {
        return NotificationCompat$$ExternalSyntheticApiModelOutline0.m40m(this.mWrappedObj);
    }
}
