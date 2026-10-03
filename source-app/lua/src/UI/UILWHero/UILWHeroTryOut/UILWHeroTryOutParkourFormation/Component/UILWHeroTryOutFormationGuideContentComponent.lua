local base = UIBaseContainer
local UILWHeroTryOutFormationGuideContentComponent = BaseClass("UILWHeroTryOutFormationGuideContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWHeroTryOutFormationGuideContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWHeroTryOutFormationGuideContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWHeroTryOutFormationGuideContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnHeroTryOutGuide = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnHeroTryOutGuide:SetOnClick(function()
    self:OnBtnHeroTryOutGuideClick()
  end)
  self.compBubble = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compDialog = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textDialog = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function UILWHeroTryOutFormationGuideContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnHeroTryOutGuide = nil
  self.compBubble = nil
  self.compDialog = nil
  self.textDialog = nil
end

function UILWHeroTryOutFormationGuideContentComponent:DataDefine()
  self.isShowGuide = false
end

function UILWHeroTryOutFormationGuideContentComponent:DataDestroy()
  self.isShowGuide = nil
end

function UILWHeroTryOutFormationGuideContentComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWHeroTryOutFormationGuideContentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWHeroTryOutFormationGuideContentComponent:ReInit(heroTryOudId)
  if heroTryOudId == nil then
    return
  end
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(heroTryOudId)
  if tryOutTemplate == nil then
    return
  end
  self.textDialog:SetLocalText(tryOutTemplate.desc or "")
  self.compBubble:SetActive(self.isShowGuide == false)
  self.compDialog:SetActive(self.isShowGuide == true)
end

function UILWHeroTryOutFormationGuideContentComponent:OnBtnHeroTryOutGuideClick()
  self.isShowGuide = not self.isShowGuide
  self.compBubble:SetActive(self.isShowGuide == false)
  self.compDialog:SetActive(self.isShowGuide == true)
end

return UILWHeroTryOutFormationGuideContentComponent
