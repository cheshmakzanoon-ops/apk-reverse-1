package com.im30.aps.debug;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.Context;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import com.unity3d.player.UnityPlayer;
import java.util.ArrayList;
import java.util.List;

public class UnitySplashManager {
    private static final float BASE_RUNNER_HEIGHT_DP = 56.0f;
    private static final float GROUP_WIDTH_RATIO = 0.8f;
    private static final float REFERENCE_HEIGHT = 1440.0f;
    private static final float REFERENCE_WIDTH = 810.0f;
    private static final String TAG = "UnitySplashManager";
    private static UnitySplashManager instance;
    private Context mContext;
    private FrameLayout mMainSplashLayout;
    private final List<AnimatorSet> mAnimators = new ArrayList();
    public boolean showLogOk = false;

    public static UnitySplashManager getInstance() {
        try {
            if (instance == null) {
                instance = new UnitySplashManager();
            }
            return instance;
        } catch (Throwable th) {
            Log.e(TAG, "getInstance failed", th);
            return new UnitySplashManager();
        }
    }

    public void SetMainContext(Context context) {
        try {
            this.mContext = context;
        } catch (Throwable th) {
            Log.e(TAG, "SetMainContext failed", th);
        }
    }

    public void onShowSplashView(ViewGroup viewGroup) {
        try {
            Context context = this.mContext;
            if (context != null && viewGroup != null) {
                float f = context.getResources().getDisplayMetrics().density;
                FrameLayout frameLayout = new FrameLayout(this.mContext);
                this.mMainSplashLayout = frameLayout;
                frameLayout.setBackgroundColor(-16777216);
                this.mMainSplashLayout.setClipChildren(false);
                LinearLayout linearLayout = new LinearLayout(this.mContext);
                linearLayout.setOrientation(0);
                linearLayout.setGravity(17);
                linearLayout.setClipChildren(false);
                FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(-2, -2);
                layoutParams.gravity = 81;
                layoutParams.bottomMargin = (int) (f * 200.0f);
                float fCalculateGroupScale = calculateGroupScale(this.mContext, new String[]{"wxy_jiazai_loading_gouzi", "wxy_jiazai_loading_xiaobing", "wxy_jiazai_loading_zidan", "wxy_jiazai_loading_sangshi"});
                linearLayout.addView(createAnimatedItem(this.mContext, "wxy_jiazai_loading_gouzi", 0L, false, fCalculateGroupScale));
                linearLayout.addView(createAnimatedItem(this.mContext, "wxy_jiazai_loading_xiaobing", 80L, false, fCalculateGroupScale));
                linearLayout.addView(createAnimatedItem(this.mContext, "wxy_jiazai_loading_zidan", 160L, true, fCalculateGroupScale));
                linearLayout.addView(createAnimatedItem(this.mContext, "wxy_jiazai_loading_sangshi", 240L, false, fCalculateGroupScale));
                this.mMainSplashLayout.addView(linearLayout, layoutParams);
                viewGroup.addView(this.mMainSplashLayout, new ViewGroup.LayoutParams(-1, -1));
                viewGroup.setClipChildren(false);
                this.mMainSplashLayout.bringToFront();
                this.showLogOk = true;
            }
        } catch (Throwable th) {
            Log.e(TAG, "onShowSplashView failed", th);
            this.showLogOk = false;
        }
    }

    public void onHideSplashView() {
        try {
            if (UnityPlayer.currentActivity == null) {
                return;
            }
            UnityPlayer.currentActivity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        if (UnitySplashManager.this.mMainSplashLayout != null) {
                            for (AnimatorSet animatorSet : UnitySplashManager.this.mAnimators) {
                                if (animatorSet != null) {
                                    animatorSet.removeAllListeners();
                                    animatorSet.end();
                                    animatorSet.cancel();
                                }
                            }
                            UnitySplashManager.this.mAnimators.clear();
                            ViewGroup viewGroup = (ViewGroup) UnitySplashManager.this.mMainSplashLayout.getParent();
                            if (viewGroup != null) {
                                viewGroup.removeView(UnitySplashManager.this.mMainSplashLayout);
                            }
                            UnitySplashManager.this.mMainSplashLayout = null;
                            UnitySplashManager.this.showLogOk = false;
                        }
                    } catch (Throwable th) {
                        Log.e(UnitySplashManager.TAG, "onHideSplashView.run failed", th);
                    }
                }
            });
        } catch (Throwable th) {
            Log.e(TAG, "onHideSplashView failed", th);
        }
    }

    private View createAnimatedItem(Context context, String str, long j, boolean z, float f) {
        try {
            float f2 = context.getResources().getDisplayMetrics().density;
            float f3 = f2 * f;
            int identifier = context.getResources().getIdentifier(str, "drawable", context.getPackageName());
            if (identifier == 0) {
                return new View(context);
            }
            try {
                float[] fArrResolveDrawableSize = resolveDrawableSize(context, identifier);
                float designScale = getDesignScale(context);
                int iMax = Math.max(1, Math.round(fArrResolveDrawableSize[0] * designScale * f));
                int iMax2 = Math.max(1, Math.round(fArrResolveDrawableSize[1] * designScale * f));
                LinearLayout linearLayout = new LinearLayout(context);
                linearLayout.setOrientation(1);
                linearLayout.setGravity(1);
                linearLayout.setClipChildren(false);
                LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2);
                int i = (int) (15.0f * f3);
                layoutParams.setMargins(i, 0, i, 0);
                linearLayout.setLayoutParams(layoutParams);
                FrameLayout frameLayout = new FrameLayout(context);
                frameLayout.setLayoutParams(new LinearLayout.LayoutParams(-2, Math.max((int) (100.0f * f3), ((int) (20.0f * f3)) + iMax2)));
                frameLayout.setClipChildren(false);
                final ImageView imageView = new ImageView(context);
                imageView.setImageResource(identifier);
                FrameLayout.LayoutParams layoutParams2 = new FrameLayout.LayoutParams(iMax, iMax2);
                layoutParams2.gravity = 81;
                imageView.setLayoutParams(layoutParams2);
                imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
                imageView.post(new Runnable() {
                    @Override
                    public final void run() {
                        ImageView imageView2 = imageView;
                        imageView2.setPivotY(imageView2.getHeight());
                    }
                });
                if (z) {
                    imageView.setTranslationY((-20.0f) * f3);
                }
                frameLayout.addView(imageView);
                View view = new View(context);
                int identifier2 = context.getResources().getIdentifier("loader_shadow", "drawable", context.getPackageName());
                if (identifier2 != 0) {
                    view.setBackgroundResource(identifier2);
                }
                LinearLayout.LayoutParams layoutParams3 = new LinearLayout.LayoutParams((int) (iMax * 0.7f), (int) (6.0f * f3));
                layoutParams3.topMargin = (int) (f3 * 8.0f);
                view.setLayoutParams(layoutParams3);
                view.setAlpha(0.4f);
                linearLayout.addView(frameLayout);
                linearLayout.addView(view);
                startSprintAnimation(imageView, view, j, f2, f);
                return linearLayout;
            } catch (Throwable th) {
                th = th;
            }
        } catch (Throwable th2) {
            th = th2;
        }
        Log.e(TAG, "createAnimatedItem failed", th);
        return new View(context);
    }

    private float calculateGroupScale(Context context, String[] strArr) {
        try {
            DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
            float designScale = getDesignScale(context);
            float f = displayMetrics.density * 15.0f;
            float f2 = 0.0f;
            for (String str : strArr) {
                int identifier = context.getResources().getIdentifier(str, "drawable", context.getPackageName());
                if (identifier != 0) {
                    f2 += (resolveDrawableSize(context, identifier)[0] * designScale) + (2.0f * f);
                }
            }
            if (f2 <= 0.0f) {
                return 1.0f;
            }
            return Math.max(0.1f, Math.min(1.0f, (displayMetrics.widthPixels * GROUP_WIDTH_RATIO) / f2));
        } catch (Throwable th) {
            Log.e(TAG, "calculateGroupScale failed", th);
            return 1.0f;
        }
    }

    private float[] resolveDrawableSize(Context context, int i) {
        try {
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inJustDecodeBounds = true;
            BitmapFactory.decodeResource(context.getResources(), i, options);
            if (options.outWidth > 0 && options.outHeight > 0) {
                return new float[]{options.outWidth, options.outHeight};
            }
        } catch (Throwable th) {
            Log.w(TAG, "resolveDrawableSize bitmap decode failed", th);
        }
        try {
            Drawable drawable = context.getResources().getDrawable(i);
            if (drawable != null && drawable.getIntrinsicWidth() > 0 && drawable.getIntrinsicHeight() > 0) {
                return new float[]{drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight()};
            }
        } catch (Throwable th2) {
            Log.w(TAG, "resolveDrawableSize drawable fallback failed", th2);
        }
        return new float[]{1.0f, 1.0f};
    }

    private float getDesignScale(Context context) {
        try {
            DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
            return Math.max(0.75f, Math.min(displayMetrics.widthPixels / REFERENCE_WIDTH, displayMetrics.heightPixels / REFERENCE_HEIGHT));
        } catch (Throwable th) {
            Log.e(TAG, "getDesignScale failed", th);
            return 1.0f;
        }
    }

    private float dpToPx(Context context, float f) {
        try {
            return f * context.getResources().getDisplayMetrics().density;
        } catch (Throwable th) {
            Log.e(TAG, "dpToPx failed", th);
            return f;
        }
    }

    private void startSprintAnimation(View view, View view2, long j, float f, float f2) {
        try {
            AccelerateDecelerateInterpolator accelerateDecelerateInterpolator = new AccelerateDecelerateInterpolator();
            float translationY = view.getTranslationY();
            ObjectAnimator objectAnimatorOfFloat = ObjectAnimator.ofFloat(view, "translationY", translationY, translationY - ((f * f2) * 10.0f), translationY);
            ObjectAnimator objectAnimatorOfFloat2 = ObjectAnimator.ofFloat(view, "scaleY", 0.9f, 1.1f, 0.9f);
            ObjectAnimator objectAnimatorOfFloat3 = ObjectAnimator.ofFloat(view2, "scaleX", 1.0f, 0.6f, 1.0f);
            ObjectAnimator objectAnimatorOfFloat4 = ObjectAnimator.ofFloat(view2, "alpha", 0.4f, 0.1f, 0.4f);
            final AnimatorSet animatorSet = new AnimatorSet();
            animatorSet.playTogether(objectAnimatorOfFloat, objectAnimatorOfFloat2, objectAnimatorOfFloat3, objectAnimatorOfFloat4);
            animatorSet.setDuration(300L);
            animatorSet.setStartDelay(j);
            animatorSet.setInterpolator(accelerateDecelerateInterpolator);
            animatorSet.addListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animator) {
                    try {
                        animatorSet.setStartDelay(0L);
                        animatorSet.start();
                    } catch (Throwable th) {
                        Log.e(UnitySplashManager.TAG, "startSprintAnimation.onAnimationEnd failed", th);
                    }
                }
            });
            animatorSet.start();
            this.mAnimators.add(animatorSet);
        } catch (Throwable th) {
            Log.e(TAG, "startSprintAnimation failed", th);
        }
    }
}
