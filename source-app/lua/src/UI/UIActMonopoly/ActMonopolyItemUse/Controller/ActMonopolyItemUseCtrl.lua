local ActMonopolyItemUseCtrl = BaseClass("ActMonopolyItemUseCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ActMonopolyItemUse, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

ActMonopolyItemUseCtrl.CloseSelf = CloseSelf
ActMonopolyItemUseCtrl.Close = Close
return ActMonopolyItemUseCtrl
