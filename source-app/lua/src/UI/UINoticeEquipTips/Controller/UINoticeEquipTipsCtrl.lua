local UINoticeHeroTipsCtrl = BaseClass("UINoticeHeroTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINoticeEquipTips, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UINoticeHeroTipsCtrl.CloseSelf = CloseSelf
UINoticeHeroTipsCtrl.Close = Close
return UINoticeHeroTipsCtrl
