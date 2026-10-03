local UIPermanentTipsCtrl = BaseClass("UIPermanentTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINoticeTips, {anim = true, playEffect = false})
end

UIPermanentTipsCtrl.CloseSelf = CloseSelf
return UIPermanentTipsCtrl
