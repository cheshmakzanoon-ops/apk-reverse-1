local UIPVELoseCtrl = BaseClass("UIPVELoseCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELose, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

UIPVELoseCtrl.CloseSelf = CloseSelf
return UIPVELoseCtrl
