local UILWAlGuideCtrl = BaseClass("UILWAlGuideCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWAlGuide, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

UILWAlGuideCtrl.CloseSelf = CloseSelf
return UILWAlGuideCtrl
