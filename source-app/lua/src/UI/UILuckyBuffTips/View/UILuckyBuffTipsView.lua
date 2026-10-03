local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UILuckyBuffTipsView = BaseClass("UILuckyBuffTipsView", base)
local Localization = CS.GameEntry.Localization

function UILuckyBuffTipsView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textRewardTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compItemContent = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
end

function UILuckyBuffTipsView:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textRewardTip = nil
  self.compItemContent = nil
  base.ComponentDestroy(self)
end

function UILuckyBuffTipsView:RefreshShow()
  base.RefreshShow(self)
  if string.IsNullOrEmpty(self.param.icon) then
    self.compItemContent:SetActive(false)
  else
    self.compItemContent:SetActive(true)
    self.imgIcon:LoadSprite(self.param.icon)
  end
  if string.IsNullOrEmpty(self.param.descTip) then
    self.textRewardTip:SetActive(false)
  else
    self.textRewardTip:SetActive(true)
    self.textRewardTip:SetText(self.param.descTip)
  end
end

return UILuckyBuffTipsView
