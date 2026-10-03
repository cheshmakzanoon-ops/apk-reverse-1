local LWActMeteoriteGenNoticeCtrl = BaseClass("LWActMeteoriteGenNoticeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMeteoriteGenNoticeNotice, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWActMeteoriteGenNoticeCtrl.CloseSelf = CloseSelf
LWActMeteoriteGenNoticeCtrl.Close = Close
return LWActMeteoriteGenNoticeCtrl
