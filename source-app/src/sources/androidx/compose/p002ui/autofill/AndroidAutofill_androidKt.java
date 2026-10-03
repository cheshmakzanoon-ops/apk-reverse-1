package androidx.compose.p002ui.autofill;

import android.util.Log;
import android.util.SparseArray;
import android.view.ViewStructure;
import android.view.autofill.AutofillId;
import android.view.autofill.AutofillValue;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.graphics.Api26Bitmap$$ExternalSyntheticApiModelOutline0;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.NotImplementedError;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u001e\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u001a\u001a\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004H\u0001\u001a\u0014\u0010\u0006\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0007\u001a\u00020\bH\u0001¨\u0006\t"}, d2 = {"performAutofill", "", "Landroidx/compose/ui/autofill/AndroidAutofill;", "values", "Landroid/util/SparseArray;", "Landroid/view/autofill/AutofillValue;", "populateViewStructure", "root", "Landroid/view/ViewStructure;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AndroidAutofill_androidKt {
    public static final void populateViewStructure(AndroidAutofill androidAutofill, ViewStructure viewStructure) {
        int iAddChildCount = AutofillApi23Helper.INSTANCE.addChildCount(viewStructure, androidAutofill.getAutofillTree().getChildren().size());
        for (Map.Entry<Integer, AutofillNode> entry : androidAutofill.getAutofillTree().getChildren().entrySet()) {
            int iIntValue = entry.getKey().intValue();
            AutofillNode value = entry.getValue();
            ViewStructure viewStructureNewChild = AutofillApi23Helper.INSTANCE.newChild(viewStructure, iAddChildCount);
            if (viewStructureNewChild != null) {
                AutofillApi26Helper autofillApi26Helper = AutofillApi26Helper.INSTANCE;
                AutofillId autofillId = AutofillApi26Helper.INSTANCE.getAutofillId(viewStructure);
                Intrinsics.checkNotNull(autofillId);
                autofillApi26Helper.setAutofillId(viewStructureNewChild, autofillId, iIntValue);
                AutofillApi23Helper.INSTANCE.setId(viewStructureNewChild, iIntValue, androidAutofill.getView().getContext().getPackageName(), null, null);
                AutofillApi26Helper.INSTANCE.setAutofillType(viewStructureNewChild, ContentDataType.INSTANCE.m4194getTextA48pgw8());
                AutofillApi26Helper autofillApi26Helper2 = AutofillApi26Helper.INSTANCE;
                List<AutofillType> autofillTypes = value.getAutofillTypes();
                ArrayList arrayList = new ArrayList(autofillTypes.size());
                int size = autofillTypes.size();
                for (int i = 0; i < size; i++) {
                    arrayList.add(AndroidAutofillType_androidKt.getAndroidType(autofillTypes.get(i)));
                }
                autofillApi26Helper2.setAutofillHints(viewStructureNewChild, (String[]) arrayList.toArray(new String[0]));
                Rect boundingBox = value.getBoundingBox();
                if (boundingBox == null) {
                    Log.w("Autofill Warning", "Bounding box not set.\n                        Did you call perform autofillTree before the component was positioned? ");
                } else {
                    int iRound = Math.round(boundingBox.getLeft());
                    int iRound2 = Math.round(boundingBox.getTop());
                    int iRound3 = Math.round(boundingBox.getRight());
                    AutofillApi23Helper.INSTANCE.setDimens(viewStructureNewChild, iRound, iRound2, 0, 0, iRound3 - iRound, Math.round(boundingBox.getBottom()) - iRound2);
                }
            }
            iAddChildCount++;
        }
    }

    public static final void performAutofill(AndroidAutofill androidAutofill, SparseArray<AutofillValue> sparseArray) {
        int size = sparseArray.size();
        for (int i = 0; i < size; i++) {
            int iKeyAt = sparseArray.keyAt(i);
            AutofillValue autofillValueM121m = Api26Bitmap$$ExternalSyntheticApiModelOutline0.m121m((Object) sparseArray.get(iKeyAt));
            if (AutofillApi26Helper.INSTANCE.isText(autofillValueM121m)) {
                androidAutofill.getAutofillTree().performAutofill(iKeyAt, AutofillApi26Helper.INSTANCE.textValue(autofillValueM121m).toString());
            } else {
                if (AutofillApi26Helper.INSTANCE.isDate(autofillValueM121m)) {
                    throw new NotImplementedError("An operation is not implemented: b/138604541: Add onFill() callback for date");
                }
                if (AutofillApi26Helper.INSTANCE.isList(autofillValueM121m)) {
                    throw new NotImplementedError("An operation is not implemented: b/138604541: Add onFill() callback for list");
                }
                if (AutofillApi26Helper.INSTANCE.isToggle(autofillValueM121m)) {
                    throw new NotImplementedError("An operation is not implemented: b/138604541:  Add onFill() callback for toggle");
                }
            }
        }
    }
}
