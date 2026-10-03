package net.aihelp.core.net.mqtt.hawtdispatch;

public final class TaskWrapper extends Task {
    private final Runnable runnable;

    public TaskWrapper(Runnable runnable) {
        this.runnable = runnable;
    }

    @Override
    public void run() {
        this.runnable.run();
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        Runnable runnable = this.runnable;
        Runnable runnable2 = ((TaskWrapper) obj).runnable;
        return runnable == null ? runnable2 == null : runnable.equals(runnable2);
    }

    public int hashCode() {
        Runnable runnable = this.runnable;
        if (runnable != null) {
            return runnable.hashCode();
        }
        return 0;
    }

    public String toString() {
        return this.runnable.toString();
    }
}
