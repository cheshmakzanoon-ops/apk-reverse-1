local base = UIBaseContainer
local UILWFormationPanelDominatorTipsComponent = BaseClass("UILWFormationPanelDominatorTipsComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local DominatorUtils = require("DataCenter.Dominator.Main.DominatorUtils")

function UILWFormationPanelDominatorTipsComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWFormationPanelDominatorTipsComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWFormationPanelDominatorTipsComponent:ComponentDefine()
  self.textDominatorTips = self:AddComponent(UIText, "DominatorTipsText")
  self.btnDominatorTipsInfo = self:AddComponent(UIButton, "DominatorTipsText/DominatorTipsInfoBtn")
  self.btnDominatorTipsInfo:SetOnClick(function()
    self:OnBtnDominatorTipsInfoClick()
  end)
  self.compTarget = self:AddComponent(UIBaseContainer, "DominatorTipsText/DominatorTipsInfoBtn/target")
end

function UILWFormationPanelDominatorTipsComponent:ComponentDestroy()
  self.textDominatorTips = nil
  self.btnDominatorTipsInfo = nil
  self.compTarget = nil
end

function UILWFormationPanelDominatorTipsComponent:DataDefine()
end

function UILWFormationPanelDominatorTipsComponent:DataDestroy()
end

function UILWFormationPanelDominatorTipsComponent:ReInit(source, squadIndex, squadData, extraData)
  self.source = source
  self.squadIndex = squadIndex
  self.squadData = squadData
  self.extraData = extraData
  local isShowSelf = false
  if self.source == EnterHeroSquadPanelWay.DetectEventPVE then
    local isTrial = DataCenter.DominatorManager:HasDominatorUnlockBattleForTrial() and not DataCenter.DominatorManager:HasDominatorUnlockBattle()
    if isTrial then
      isShowSelf = true
    end
  elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    if self.extraData and self.extraData.cfgId and self.extraData.pageType == JeepAdventurePageType.Domintor then
      local dominatorUpTemplate = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(self.extraData.cfgId)
      if dominatorUpTemplate then
        local isTrial = DataCenter.DominatorManager:HasDominatorUnlockBattleForTrial() and not DataCenter.DominatorManager:HasDominatorUnlockBattle()
        if isTrial then
          isShowSelf = true
        end
      end
    end
  elseif self.source == EnterHeroSquadPanelWay.HeroTryOut then
    isShowSelf = false
  end
  self.gameObject:SetActive(isShowSelf)
  self.textDominatorTips:SetLocalText("dominator_pve_dec_1")
end

function UILWFormationPanelDominatorTipsComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWFormationPanelDominatorTipsComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWFormationPanelDominatorTipsComponent:OnBtnDominatorTipsInfoClick()
  if self.source and self.squadIndex then
    if self.source == EnterHeroSquadPanelWay.DetectEventPVE then
      local dominatorInfo
      local trainIds = DataCenter.DominatorManager:GetTrainIdsForRadarBattleTrial()
      local squadUsingDominator = DominatorUtils.GetSquadUseDominator(self.source, self.squadIdx, self.squadData)
      if squadUsingDominator then
        dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(squadUsingDominator)
      else
        local defaultMainId = DataCenter.DominatorManager:GetDefaultShowMainId()
        if defaultMainId then
          dominatorInfo = DataCenter.DominatorManager:GetInfoById(defaultMainId)
        end
      end
      if dominatorInfo and trainIds then
        local param = {
          dominatorInfo = dominatorInfo,
          trainIds = trainIds,
          alignObject = self.compTarget
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWFormationPanelDominatorTips, {anim = false}, param)
      end
    elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure and self.extraData and self.extraData.cfgId and self.extraData.pageType == JeepAdventurePageType.Domintor then
      local dominatorUpTemplate = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(self.extraData.cfgId)
      if dominatorUpTemplate then
        local dominatorInfo
        local trainIds = dominatorUpTemplate.dominatorTemporaryUse
        local squadUsingDominator = DominatorUtils.GetSquadUseDominator(self.source, self.squadIdx, self.squadData)
        if squadUsingDominator then
          dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(squadUsingDominator)
        else
          local defaultMainId = DataCenter.DominatorManager:GetDefaultShowMainId()
          if defaultMainId then
            dominatorInfo = DataCenter.DominatorManager:GetInfoById(defaultMainId)
          end
        end
        if dominatorInfo and trainIds then
          local param = {
            dominatorInfo = dominatorInfo,
            trainIds = trainIds,
            alignObject = self.compTarget
          }
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWFormationPanelDominatorTips, {anim = false}, param)
        end
      end
    end
  end
end

return UILWFormationPanelDominatorTipsComponent
