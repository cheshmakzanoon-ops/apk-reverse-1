local UIParkourTutorialCtrl = BaseClass("UIParkourTutorialCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourTutorial, {anim = false})
end

UIParkourTutorialCtrl.CloseSelf = CloseSelf
return UIParkourTutorialCtrl
