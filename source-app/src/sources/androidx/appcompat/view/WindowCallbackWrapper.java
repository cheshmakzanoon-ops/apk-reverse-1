package androidx.appcompat.view;

import android.view.KeyEvent;
import android.view.KeyboardShortcutGroup;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SearchEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;
import java.util.List;

public class WindowCallbackWrapper implements Window.Callback {
    final Window.Callback mWrapped;

    public WindowCallbackWrapper(Window.Callback callback) {
        if (callback == null) {
            throw new IllegalArgumentException("Window callback may not be null");
        }
        this.mWrapped = callback;
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent keyEvent) {
        return this.mWrapped.dispatchKeyEvent(keyEvent);
    }

    @Override
    public boolean dispatchKeyShortcutEvent(KeyEvent keyEvent) {
        return this.mWrapped.dispatchKeyShortcutEvent(keyEvent);
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent motionEvent) {
        return this.mWrapped.dispatchTouchEvent(motionEvent);
    }

    @Override
    public boolean dispatchTrackballEvent(MotionEvent motionEvent) {
        return this.mWrapped.dispatchTrackballEvent(motionEvent);
    }

    @Override
    public boolean dispatchGenericMotionEvent(MotionEvent motionEvent) {
        return this.mWrapped.dispatchGenericMotionEvent(motionEvent);
    }

    @Override
    public boolean dispatchPopulateAccessibilityEvent(AccessibilityEvent accessibilityEvent) {
        return this.mWrapped.dispatchPopulateAccessibilityEvent(accessibilityEvent);
    }

    @Override
    public View onCreatePanelView(int i) {
        return this.mWrapped.onCreatePanelView(i);
    }

    @Override
    public boolean onCreatePanelMenu(int i, Menu menu) {
        return this.mWrapped.onCreatePanelMenu(i, menu);
    }

    @Override
    public boolean onPreparePanel(int i, View view, Menu menu) {
        return this.mWrapped.onPreparePanel(i, view, menu);
    }

    @Override
    public boolean onMenuOpened(int i, Menu menu) {
        return this.mWrapped.onMenuOpened(i, menu);
    }

    @Override
    public boolean onMenuItemSelected(int i, MenuItem menuItem) {
        return this.mWrapped.onMenuItemSelected(i, menuItem);
    }

    @Override
    public void onWindowAttributesChanged(WindowManager.LayoutParams layoutParams) {
        this.mWrapped.onWindowAttributesChanged(layoutParams);
    }

    @Override
    public void onContentChanged() {
        this.mWrapped.onContentChanged();
    }

    @Override
    public void onWindowFocusChanged(boolean z) {
        this.mWrapped.onWindowFocusChanged(z);
    }

    @Override
    public void onAttachedToWindow() {
        this.mWrapped.onAttachedToWindow();
    }

    @Override
    public void onDetachedFromWindow() {
        this.mWrapped.onDetachedFromWindow();
    }

    @Override
    public void onPanelClosed(int i, Menu menu) {
        this.mWrapped.onPanelClosed(i, menu);
    }

    @Override
    public boolean onSearchRequested(SearchEvent searchEvent) {
        return Api23Impl.onSearchRequested(this.mWrapped, searchEvent);
    }

    @Override
    public boolean onSearchRequested() {
        return this.mWrapped.onSearchRequested();
    }

    @Override
    public android.view.ActionMode onWindowStartingActionMode(android.view.ActionMode.Callback callback) {
        return this.mWrapped.onWindowStartingActionMode(callback);
    }

    @Override
    public android.view.ActionMode onWindowStartingActionMode(android.view.ActionMode.Callback callback, int i) {
        return Api23Impl.onWindowStartingActionMode(this.mWrapped, callback, i);
    }

    @Override
    public void onActionModeStarted(android.view.ActionMode actionMode) {
        this.mWrapped.onActionModeStarted(actionMode);
    }

    @Override
    public void onActionModeFinished(android.view.ActionMode actionMode) {
        this.mWrapped.onActionModeFinished(actionMode);
    }

    @Override
    public void onProvideKeyboardShortcuts(List<KeyboardShortcutGroup> list, Menu menu, int i) {
        Api24Impl.onProvideKeyboardShortcuts(this.mWrapped, list, menu, i);
    }

    @Override
    public void onPointerCaptureChanged(boolean z) {
        Api26Impl.onPointerCaptureChanged(this.mWrapped, z);
    }

    public final Window.Callback getWrapped() {
        return this.mWrapped;
    }

    static class Api23Impl {
        private Api23Impl() {
        }

        static boolean onSearchRequested(Window.Callback callback, SearchEvent searchEvent) {
            return callback.onSearchRequested(searchEvent);
        }

        static android.view.ActionMode onWindowStartingActionMode(Window.Callback callback, android.view.ActionMode.Callback callback2, int i) {
            return callback.onWindowStartingActionMode(callback2, i);
        }
    }

    static class Api24Impl {
        private Api24Impl() {
        }

        static void onProvideKeyboardShortcuts(Window.Callback callback, List<KeyboardShortcutGroup> list, Menu menu, int i) {
            callback.onProvideKeyboardShortcuts(list, menu, i);
        }
    }

    static class Api26Impl {
        private Api26Impl() {
        }

        static void onPointerCaptureChanged(Window.Callback callback, boolean z) {
            callback.onPointerCaptureChanged(z);
        }
    }
}
