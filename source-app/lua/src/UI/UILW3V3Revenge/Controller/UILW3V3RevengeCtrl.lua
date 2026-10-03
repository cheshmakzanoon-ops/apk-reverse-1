local UILW3V3RevengeCtrl = BaseClass("UILW3V3RevengeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILW3V3Revenge, {anim = false})
end

function UILW3V3RevengeCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

UILW3V3RevengeCtrl.CloseSelf = CloseSelf
return UILW3V3RevengeCtrl
