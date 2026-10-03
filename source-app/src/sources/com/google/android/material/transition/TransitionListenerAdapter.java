package com.google.android.material.transition;

import androidx.transition.Transition;

abstract class TransitionListenerAdapter implements Transition.TransitionListener {
    public void onTransitionCancel(Transition transition) {
    }

    public void onTransitionEnd(Transition transition) {
    }

    public void onTransitionEnd(Transition transition, boolean z) {
        Transition.TransitionListener.-CC.$default$onTransitionEnd(this, transition, z);
    }

    public void onTransitionPause(Transition transition) {
    }

    public void onTransitionResume(Transition transition) {
    }

    public void onTransitionStart(Transition transition) {
    }

    public void onTransitionStart(Transition transition, boolean z) {
        Transition.TransitionListener.-CC.$default$onTransitionStart(this, transition, z);
    }

    TransitionListenerAdapter() {
    }
}
