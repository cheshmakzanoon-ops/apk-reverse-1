local UIParkourBonusResultCtrl = BaseClass("UIParkourBonusResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourBonusResult)
end

UIParkourBonusResultCtrl.CloseSelf = CloseSelf
return UIParkourBonusResultCtrl
