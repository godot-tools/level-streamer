using Godot;
using System;

public class BoundedCamera : Camera2D
{
    private Vector2 worldSize = new Vector2(6400, 3200);

    [Export]
    public Vector2 WorldSize {
        get { return worldSize; }
        set {
            worldSize = value;
            syncBounds();
        }
    }

    private int getBigMargin(float worldSize, float screenSize, float vscale) {
        float diff = (worldSize * vscale) - screenSize;
        diff /= vscale;
        return (int)Mathf.Ceil(screenSize + diff);
    }

    private void syncBounds() {
        Viewport viewport = GetViewport();
        if (viewport != null) {
            Vector2 vscale = new Vector2(1 / Zoom.x, 1 / Zoom.y);
            Vector2 resolution = viewport.Size;
            if ((worldSize.x * vscale.x) > resolution.x) {
                LimitLeft = 0;
                LimitRight = getBigMargin(worldSize.x, resolution.x, vscale.x);
            } else {
                float margin = (resolution.x - (worldSize.x * vscale.x)) / 2.0f;
                LimitLeft = (int)Mathf.Floor(-margin/vscale.x);
                LimitRight = (int)Mathf.Ceil((margin/vscale.x) - worldSize.x);
            }
            if ((worldSize.y * vscale.y) > resolution.y) {
                LimitTop = 0;
                LimitBottom = getBigMargin(worldSize.y, resolution.y, vscale.y);
            } else {
                float margin = (resolution.y - (worldSize.y * vscale.y)) / 2.0f;
                LimitTop = (int)Mathf.Floor(-margin/vscale.y);
                LimitBottom = (int)Mathf.Ceil((margin/vscale.y) - worldSize.y);
            }
        }
    }

    public override void _Ready() {
        syncBounds();
        GetViewport().Connect("size_changed", this, "syncBounds");
    }
}
