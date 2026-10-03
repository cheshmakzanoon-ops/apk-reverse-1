local LWAccountBindTipCtrl = BaseClass("LWAccountBindTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWAccountBindTip, {anim = false})
end

function LWAccountBindTipCtrl:TryClose()
  self:CloseSelf()
end

function LWAccountBindTipCtrl:OnCustomKeyCodeEscape()
end

LWAccountBindTipCtrl.CloseSelf = CloseSelf
return LWAccountBindTipCtrl
