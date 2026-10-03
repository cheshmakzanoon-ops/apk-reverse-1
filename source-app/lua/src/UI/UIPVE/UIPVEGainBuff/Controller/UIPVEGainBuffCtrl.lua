local UIPVEGainBuffCtrl = BaseClass("UIPVEGainBuffCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEGainBuff, {anim = true})
end

UIPVEGainBuffCtrl.CloseSelf = CloseSelf
return UIPVEGainBuffCtrl
