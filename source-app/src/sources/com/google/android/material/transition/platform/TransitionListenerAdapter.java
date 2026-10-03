package com.google.android.material.transition.platform;

import android.transition.Transition;

abstract class TransitionListenerAdapter implements Transition.TransitionListener {
    @Override
    public void onTransitionCancel(Transition transition) {
    }

    @Override
    public void onTransitionEnd(Transition transition) {
    }

    @Override
    public void onTransitionPause(Transition transition) {
    }

    @Override
    public void onTransitionResume(Transition transition) {
    }

    @Override
    public void onTransitionStart(Transition transition) {
    }

    TransitionListenerAdapter() {
    }
}
