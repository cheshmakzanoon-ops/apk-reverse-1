local LWUIHeroSuggestTipsCtrl = BaseClass("LWUIHeroSuggestTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIHeroSuggestTips)
end

LWUIHeroSuggestTipsCtrl.CloseSelf = CloseSelf
return LWUIHeroSuggestTipsCtrl
