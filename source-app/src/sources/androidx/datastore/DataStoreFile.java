package androidx.datastore;

import android.content.Context;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.io.File;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0012\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\u001a\u0012\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004¨\u0006\u0005"}, d2 = {"dataStoreFile", "Ljava/io/File;", "Landroid/content/Context;", "fileName", "", "datastore_release"}, k = 2, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class DataStoreFile {
    public static final File dataStoreFile(Context context, String str) {
        Intrinsics.checkNotNullParameter(context, "<this>");
        Intrinsics.checkNotNullParameter(str, "fileName");
        return new File(context.getApplicationContext().getFilesDir(), Intrinsics.stringPlus("datastore/", str));
    }
}
