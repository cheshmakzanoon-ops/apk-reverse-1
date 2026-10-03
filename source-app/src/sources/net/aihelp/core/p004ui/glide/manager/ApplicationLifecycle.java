package net.aihelp.core.p004ui.glide.manager;

class ApplicationLifecycle implements Lifecycle {
    ApplicationLifecycle() {
    }

    @Override
    public void addListener(LifecycleListener lifecycleListener) {
        lifecycleListener.onStart();
    }
}
