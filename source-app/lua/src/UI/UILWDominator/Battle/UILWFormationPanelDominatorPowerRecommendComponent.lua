local base = UIBaseContainer
local UILWFormationPanelDominatorPowerRecommendComponent = BaseClass("UILWFormationPanelDominatorPowerRecommendComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local DominatorUtils = require("DataCenter.Dominator.Main.DominatorUtils")

function UILWFormationPanelDominatorPowerRecommendComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWFormationPanelDominatorPowerRecommendComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWFormationPanelDominatorPowerRecommendComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "RecommendDominatorPowerTitleText")
  self.textPower = self:AddComponent(UIText, "PowerLayout/RecommendDominatorPowerNumberText")
end

function UILWFormationPanelDominatorPowerRecommendComponent:ComponentDestroy()
  self.textTitle = nil
  self.textPower = nil
end

function UILWFormationPanelDominatorPowerRecommendComponent:DataDefine()
end

function UILWFormationPanelDominatorPowerRecommendComponent:DataDestroy()
end

function UILWFormationPanelDominatorPowerRecommendComponent:ReInit(source, extraData)
  self.source = source
  self.extraData = extraData
  local isShowSelf = false
  if self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    if self.extraData and self.extraData.cfgId and self.extraData.pageType == JeepAdventurePageType.Domintor then
      local dominatorUpTemplate = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(self.extraData.cfgId)
      if dominatorUpTemplate then
        local data = dominatorUpTemplate:GetPowerRecommendData()
        if data and #data == 2 then
          isShowSelf = true
          self.textTitle:SetText(Localization:GetString(data[1]))
          self.textPower:SetText(data[2])
        end
      end
    end
  elseif self.source == EnterHeroSquadPanelWay.HeroTryOut then
    isShowSelf = false
  end
  self.gameObject:SetActive(isShowSelf)
end

function UILWFormationPanelDominatorPowerRecommendComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWFormationPanelDominatorPowerRecommendComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWFormationPanelDominatorPowerRecommendComponent
