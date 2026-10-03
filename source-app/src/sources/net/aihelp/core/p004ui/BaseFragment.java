package net.aihelp.core.p004ui;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import java.lang.ref.WeakReference;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import net.aihelp.common.Const;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.mvp.IPresenter;
import net.aihelp.core.mvp.IView;
import net.aihelp.core.net.monitor.NetworkState;
import net.aihelp.core.p004ui.loading.helper.VaryViewHelperController;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.Subscribe;
import net.aihelp.core.util.bus.ThreadMode;
import net.aihelp.core.util.bus.event.EventCenter;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.p007ui.SupportFragment;
import net.aihelp.p007ui.faq.IFaqEventListener;
import net.aihelp.p007ui.helper.FragmentHelper;
import net.aihelp.p007ui.wrapper.FaqEventListenerWrapper;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.TLog;
import net.aihelp.utils.ToastUtil;

public abstract class BaseFragment<P extends IPresenter> extends Fragment implements IView {
    private static boolean shouldRetainChildFragmentManager;
    private boolean isInflateFinished;
    protected View mInflateView;
    protected P mPresenter;
    private FragmentManager retainedChildFragmentManager;
    protected MyHandler mHandler = new MyHandler(this);
    protected VaryViewHelperController mVaryViewHelperController = null;

    protected void getBundleAfterDataPrepared(Bundle bundle) {
    }

    protected void getBundleBeforeDataPrepared(Bundle bundle) {
    }

    protected abstract int getLayout();

    protected int getLoadingTargetViewId() {
        return 0;
    }

    protected void handleMsg(Message message) {
    }

    protected abstract void initEventAndData(View view);

    protected boolean isBindEventBus() {
        return false;
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventComing(EventCenter eventCenter) {
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onNetworkStateChanged(NetworkState networkState) {
    }

    protected int dip2px(Context context, double d) {
        return context == null ? (int) d : (int) ((d * ((double) context.getResources().getDisplayMetrics().density)) + 0.5d);
    }

    public IFaqEventListener getFaqFlowListener() {
        SupportFragment supportFragment = FragmentHelper.getSupportFragment(this);
        if (supportFragment != null) {
            return supportFragment.getFaqEventListener();
        }
        return new FaqEventListenerWrapper();
    }

    public FragmentManager getRetainedChildFragmentManager() {
        if (shouldRetainChildFragmentManager) {
            if (this.retainedChildFragmentManager != null) {
                this.retainedChildFragmentManager = getChildFragmentManager();
            }
            return this.retainedChildFragmentManager;
        }
        return getChildFragmentManager();
    }

    public Context getContext() {
        Context context = super.getContext();
        return context != null ? context : AIHelpContext.getInstance().getContext();
    }

    private void initPresenter() {
        Type genericSuperclass = getClass().getGenericSuperclass();
        if (genericSuperclass instanceof ParameterizedType) {
            Class cls = (Class) ((ParameterizedType) genericSuperclass).getActualTypeArguments()[0];
            if (cls == IPresenter.class) {
                return;
            }
            try {
                this.mPresenter = (P) cls.getDeclaredConstructor(Context.class).newInstance(getContext());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        P p = this.mPresenter;
        if (p != null) {
            p.attachView(this);
        }
    }

    public void onAttach(Context context) {
        Const.isNestedFragmentOnResume = false;
        super.onAttach(AIHelpContext.getLocaleUpdatedContext(context, Const.CORRECT_LANGUAGE));
        if (isBindEventBus()) {
            EventBus.getDefault().register(this);
        }
        try {
            setRetainInstance(true);
        } catch (Exception unused) {
            shouldRetainChildFragmentManager = true;
        }
        if (!shouldRetainChildFragmentManager || this.retainedChildFragmentManager == null) {
            return;
        }
        try {
            Field declaredField = Fragment.class.getDeclaredField("mChildFragmentManager");
            declaredField.setAccessible(true);
            declaredField.set(this, this.retainedChildFragmentManager);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void onResume() {
        super.onResume();
        this.mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Const.isNestedFragmentOnResume = true;
            }
        }, 300L);
    }

    public Animation onCreateAnimation(int i, boolean z, int i2) {
        if (!z && !isRemoving()) {
            AlphaAnimation alphaAnimation = new AlphaAnimation(1.0f, 1.0f);
            alphaAnimation.setDuration(200L);
            return alphaAnimation;
        }
        return super.onCreateAnimation(i, z, i2);
    }

    public View onCreateView(LayoutInflater layoutInflater, ViewGroup viewGroup, Bundle bundle) {
        ViewGroup viewGroup2;
        if (this.mInflateView == null && !this.isInflateFinished) {
            if (getLayout() != 0) {
                this.mInflateView = layoutInflater.inflate(getLayout(), (ViewGroup) null);
            } else {
                return super.onCreateView(layoutInflater, viewGroup, bundle);
            }
        }
        View view = this.mInflateView;
        if (view != null && (viewGroup2 = (ViewGroup) view.getParent()) != null) {
            viewGroup2.removeView(this.mInflateView);
        }
        return this.mInflateView;
    }

    public void onViewCreated(View view, Bundle bundle) {
        super.onViewCreated(view, bundle);
        if (this.isInflateFinished) {
            return;
        }
        initPresenter();
        View viewFindViewById = view.findViewById(getLoadingTargetViewId());
        if (viewFindViewById != null && this.mVaryViewHelperController == null) {
            this.mVaryViewHelperController = new VaryViewHelperController(viewFindViewById);
        }
        this.mInflateView = view;
        if (getArguments() != null) {
            getBundleBeforeDataPrepared(getArguments());
        }
        initEventAndData(view);
        if (getArguments() != null) {
            getBundleAfterDataPrepared(getArguments());
        }
        this.isInflateFinished = true;
    }

    public void onDetach() {
        super.onDetach();
        this.mHandler.removeCallbacksAndMessages(null);
        if (isBindEventBus()) {
            EventBus.getDefault().unregister(this);
        }
        this.isInflateFinished = false;
        this.mInflateView = null;
    }

    public <T extends View> T get(String str) {
        return (T) this.mInflateView.findViewById(ResResolver.getViewId(str));
    }

    public Activity getActivity(Fragment fragment) {
        if (fragment == null) {
            return null;
        }
        while (fragment.getParentFragment() != null) {
            fragment = fragment.getParentFragment();
        }
        return fragment.getActivity();
    }

    @Override
    public void showLoading() {
        if (checkVaryViewHelper()) {
            ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    BaseFragment.this.mVaryViewHelperController.showLoading("");
                }
            });
        }
    }

    @Override
    public void showEmpty(final int... iArr) {
        if (checkVaryViewHelper()) {
            ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    BaseFragment.this.mVaryViewHelperController.showEmpty(iArr);
                }
            });
        }
    }

    @Override
    public void showEmpty(final View view) {
        if (checkVaryViewHelper()) {
            ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    BaseFragment.this.mVaryViewHelperController.showEmpty(view);
                }
            });
        }
    }

    @Override
    public void restoreViewState() {
        if (checkVaryViewHelper()) {
            ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    BaseFragment.this.mVaryViewHelperController.restore();
                }
            });
        }
    }

    @Override
    public void showError(final String str) {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ToastUtil.INSTANCE.makeRawToast(BaseFragment.this.getContext(), str);
            }
        });
    }

    @Override
    public void showNetError() {
        if (checkVaryViewHelper()) {
            ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    BaseFragment.this.mVaryViewHelperController.showNetworkError();
                }
            });
        }
    }

    private boolean checkVaryViewHelper() {
        if (this.mVaryViewHelperController != null) {
            return true;
        }
        TLog.m138d("You must return a right target view for loading");
        return false;
    }

    public static class MyHandler extends Handler {
        private WeakReference<BaseFragment> mActivity;

        public MyHandler(BaseFragment baseFragment) {
            this.mActivity = new WeakReference<>(baseFragment);
        }

        @Override
        public void handleMessage(Message message) {
            if (this.mActivity.get() != null) {
                this.mActivity.get().handleMsg(message);
            }
        }
    }
}
