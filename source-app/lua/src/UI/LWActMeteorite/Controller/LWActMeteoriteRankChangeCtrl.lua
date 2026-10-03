local LWActMeteoriteRankChangeCtrl = BaseClass("LWActMeteoriteRankChangeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActMeteoriteRankChangedNotice, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWActMeteoriteRankChangeCtrl.CloseSelf = CloseSelf
LWActMeteoriteRankChangeCtrl.Close = Close
return LWActMeteoriteRankChangeCtrl
