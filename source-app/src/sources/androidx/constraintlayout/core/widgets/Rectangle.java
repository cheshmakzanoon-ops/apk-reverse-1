package androidx.constraintlayout.core.widgets;

public class Rectangle {
    public int height;
    public int width;

    public int f28x;

    public int f29y;

    public void setBounds(int i, int i2, int i3, int i4) {
        this.f28x = i;
        this.f29y = i2;
        this.width = i3;
        this.height = i4;
    }

    void grow(int i, int i2) {
        this.f28x -= i;
        this.f29y -= i2;
        this.width += i * 2;
        this.height += i2 * 2;
    }

    boolean intersects(Rectangle rectangle) {
        int i;
        int i2;
        int i3 = this.f28x;
        int i4 = rectangle.f28x;
        return i3 >= i4 && i3 < i4 + rectangle.width && (i = this.f29y) >= (i2 = rectangle.f29y) && i < i2 + rectangle.height;
    }

    public boolean contains(int i, int i2) {
        int i3;
        int i4 = this.f28x;
        return i >= i4 && i < i4 + this.width && i2 >= (i3 = this.f29y) && i2 < i3 + this.height;
    }

    public int getCenterX() {
        return (this.f28x + this.width) / 2;
    }

    public int getCenterY() {
        return (this.f29y + this.height) / 2;
    }
}
