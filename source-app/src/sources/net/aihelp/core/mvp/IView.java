package net.aihelp.core.mvp;

import android.view.View;

public interface IView {
    void restoreViewState();

    void showEmpty(View view);

    void showEmpty(int... iArr);

    void showError(String str);

    void showLoading();

    void showNetError();
}
