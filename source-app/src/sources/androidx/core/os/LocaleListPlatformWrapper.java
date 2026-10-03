package androidx.core.os;

import android.os.LocaleList;
import androidx.activity.ComponentDialog$;
import androidx.compose.ui.graphics.Api26Bitmap$;
import androidx.core.util.HalfKt$$ExternalSyntheticApiModelOutline0;
import java.util.Locale;

final class LocaleListPlatformWrapper implements LocaleListInterface {
    private final LocaleList mLocaleList;

    LocaleListPlatformWrapper(Object obj) {
        this.mLocaleList = HalfKt$$ExternalSyntheticApiModelOutline0.m194m(obj);
    }

    @Override
    public Object getLocaleList() {
        return this.mLocaleList;
    }

    @Override
    public Locale get(int i) {
        return Api26Bitmap$.ExternalSyntheticApiModelOutline0.m(this.mLocaleList, i);
    }

    @Override
    public boolean isEmpty() {
        return ComponentDialog$.ExternalSyntheticApiModelOutline0.m(this.mLocaleList);
    }

    @Override
    public int size() {
        return this.mLocaleList.size();
    }

    @Override
    public int indexOf(Locale locale) {
        return this.mLocaleList.indexOf(locale);
    }

    public boolean equals(Object obj) {
        return ComponentDialog$.ExternalSyntheticApiModelOutline0.m(this.mLocaleList, ((LocaleListInterface) obj).getLocaleList());
    }

    public int hashCode() {
        return this.mLocaleList.hashCode();
    }

    public String toString() {
        return this.mLocaleList.toString();
    }

    @Override
    public String toLanguageTags() {
        return ComponentDialog$.ExternalSyntheticApiModelOutline0.m(this.mLocaleList);
    }

    @Override
    public Locale getFirstMatch(String[] strArr) {
        return this.mLocaleList.getFirstMatch(strArr);
    }
}
