local Book = {}
Book[UIMainAnimFlag.TopLeft] = {
  {
    path = "safeArea/leftLayer",
    hidePos = Vector2(-600, 0),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.ArabicTopLeft] = {
  {
    path = "safeArea/leftLayer",
    hidePos = Vector2(600, 0),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.TopRight] = {
  {
    path = "safeArea/topLayer/TopBtnsContainer",
    hidePos = Vector2(1200, -108.1),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.ArabicTopRight] = {
  {
    path = "safeArea/topLayer/TopBtnsContainer",
    hidePos = Vector2(-1200, -108.1),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.TopCenter] = {
  {
    path = "safeArea/topLayer/ResourceBar",
    hidePos = Vector2(1000, -5),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.ArabicTopCenter] = {
  {
    path = "safeArea/topLayer/ResourceBar",
    hidePos = Vector2(-1000, -5),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
if Config.IsPC() then
  Book[UIMainAnimFlag.TopCenter] = {
    {
      path = "safeArea/topLayer/ResourceBar",
      hidePos = Vector2(-5, 200),
      delay = 0,
      duration = 0.5,
      ease = CS.DG.Tweening.Ease.InOutCubic
    }
  }
  Book[UIMainAnimFlag.ArabicTopCenter] = {
    {
      path = "safeArea/topLayer/ResourceBar",
      hidePos = Vector2(-5, 200),
      delay = 0,
      duration = 0.5,
      ease = CS.DG.Tweening.Ease.InOutCubic
    }
  }
end
Book[UIMainAnimFlag.BottomLeft] = {
  {
    path = "safeArea/bottomLayer/LeftBtnLayout",
    hidePos = Vector2(-500, 272),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/questObj",
    hidePos = Vector2(-1000, 193),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/questFingerRoot",
    hidePos = Vector2(-1000, 193),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/LeftTipLayout",
    hidePos = Vector2(-900, 310),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/LeftBottomBtnLayout",
    hidePos = Vector2(-900, 272),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.ArabicBottomLeft] = {
  {
    path = "safeArea/bottomLayer/LeftBtnLayout",
    hidePos = Vector2(500, 272),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/questObj",
    hidePos = Vector2(1000, 193),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/questFingerRoot",
    hidePos = Vector2(1000, 193),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/LeftTipLayout",
    hidePos = Vector2(900, 310),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/LeftBottomBtnLayout",
    hidePos = Vector2(900, 272),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.BottomRight] = {
  {
    path = "safeArea/bottomLayer/RightBtnLayout",
    hidePos = Vector2(500, 260.4),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.ArabicBottomRight] = {
  {
    path = "safeArea/bottomLayer/RightBtnLayout",
    hidePos = Vector2(-500, 260.4),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.BottomCenter] = {
  {
    path = "safeArea/bottomLayer/UIMain_chatCoppaLimit",
    hidePos = Vector2(0, -300),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/chatObj",
    hidePos = Vector2(0, -300),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/heroObj",
    hidePos = Vector2(0, -300),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/WorldBtn",
    hidePos = Vector2(0, -300),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
Book[UIMainAnimFlag.ArabicBottomCenter] = {
  {
    path = "safeArea/bottomLayer/UIMain_chatCoppaLimit",
    hidePos = Vector2(0, -300),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/chatObj",
    hidePos = Vector2(0, -300),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/heroObj",
    hidePos = Vector2(0, -300),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  },
  {
    path = "safeArea/bottomLayer/WorldBtn",
    hidePos = Vector2(0, -300),
    delay = 0,
    duration = 0.5,
    ease = CS.DG.Tweening.Ease.InOutCubic
  }
}
return Book
