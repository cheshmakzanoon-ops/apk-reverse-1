local UIParkourThreeChoicesCtrl = BaseClass("UIParkourThreeChoices", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourThreeChoices, {anim = false})
end

UIParkourThreeChoicesCtrl.CloseSelf = CloseSelf
return UIParkourThreeChoicesCtrl
