local UILayer = {
  World = {
    Name = "WorldUIContainer",
    PlaneDistance = 1000,
    OrderInLayer = 0
  },
  Scene = {
    Name = "UIContainer/Scene",
    PlaneDistance = 1000,
    OrderInLayer = 0,
    OrderNew = -300
  },
  HpBar = {
    Name = "UIContainer/HpBar",
    PlaneDistance = 1000,
    OrderInLayer = 0,
    OrderNew = -250
  },
  Background = {
    Name = "UIContainer/Background",
    PlaneDistance = 900,
    OrderInLayer = 1000,
    OrderNew = -200
  },
  UIResource = {
    Name = "UIContainer/UIResource",
    PlaneDistance = 900,
    OrderInLayer = 1000
  },
  NormalBg = {
    Name = "UIContainer/NormalBg",
    PlaneDistance = 801,
    OrderInLayer = 1999
  },
  Normal = {
    Name = "UIContainer/Normal",
    PlaneDistance = 800,
    OrderInLayer = 2000
  },
  Info = {
    Name = "UIContainer/Info",
    PlaneDistance = 700,
    OrderInLayer = 3000
  },
  Dialog = {
    Name = "UIContainer/Dialog",
    PlaneDistance = 700,
    OrderInLayer = 3000
  },
  Guide = {
    Name = "UIContainer/Guide",
    PlaneDistance = 600,
    OrderInLayer = 4000
  },
  TopMost = {
    Name = "UIContainer/TopMost",
    PlaneDistance = 500,
    OrderInLayer = 5000
  },
  TimelineInteraction = {
    Name = "UIContainer/TimelineInteraction",
    PlaneDistance = 400,
    OrderInLayer = 6000
  }
}
return UILayer
