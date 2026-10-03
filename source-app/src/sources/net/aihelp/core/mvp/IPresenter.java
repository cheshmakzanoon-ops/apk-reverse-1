package net.aihelp.core.mvp;

import net.aihelp.core.mvp.IView;

public interface IPresenter<V extends IView> {
    void attachView(V v);

    void detachView();
}
