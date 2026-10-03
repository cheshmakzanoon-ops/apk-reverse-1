local base = UIBaseContainer
local UILWT11IdleGameBattleMain_EntranceMapItemComponent = BaseClass("UILWT11IdleGameBattleMain_EntranceMapItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUILWT11IdleGameBattleMainEntranceMapItem = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUILWT11IdleGameBattleMainEntranceMapItem:SetOnClick(function()
    self:OnBtnUILWT11IdleGameBattleMainEntranceMapItemClick()
  end)
  self.compBgOn = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compStroke = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compNow = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compLocked = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compComplete = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compEffUiT11IdleUnlock = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compBgOff = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compEffUiT11IdleUnlock:SetActive(false)
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnUILWT11IdleGameBattleMainEntranceMapItem = nil
  self.compBgOn = nil
  self.compStroke = nil
  self.compNow = nil
  self.compLocked = nil
  self.compComplete = nil
  self.compEffUiT11IdleUnlock = nil
  self.compBgOff = nil
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:DataDefine()
  self.level = 0
  self.levelTemplate = nil
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:DataDestroy()
  if self.delayRefreshTimer then
    self.delayRefreshTimer:Stop()
    self.delayRefreshTimer = nil
  end
  self.level = nil
  self.levelTemplate = nil
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:ReInit(level, param)
  self.level = level
  self.levelTemplate = DataCenter.T11IdleGameTemplateManager:GetLevelTemplateByLevel(self.level)
  if self.levelTemplate == nil then
    return
  end
  local state = self.levelTemplate:GetState()
  local isShowUnlockEffect = param ~= nil and param.newLevelId == self.levelTemplate.id
  if isShowUnlockEffect then
    self:RefreshUI(Const.LevelState.Locked)
    if self.delayRefreshTimer then
      self.delayRefreshTimer:Stop()
      self.delayRefreshTimer = nil
    end
    self.delayRefreshTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.compEffUiT11IdleUnlock:SetActive(true)
      self:RefreshUI(Const.LevelState.Current)
    end, 1.5)
  else
    self:RefreshUI(state)
    self.compEffUiT11IdleUnlock:SetActive(false)
  end
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:RefreshUI(state)
  self.compBgOff:SetActive(state == Const.LevelState.Finished)
  self.compBgOn:SetActive(state == Const.LevelState.Current)
  self.compNow:SetActive(state == Const.LevelState.Current)
  self.compComplete:SetActive(state == Const.LevelState.Finished)
  self.compLocked:SetActive(state == Const.LevelState.Locked)
end

function UILWT11IdleGameBattleMain_EntranceMapItemComponent:OnBtnUILWT11IdleGameBattleMainEntranceMapItemClick()
end

return UILWT11IdleGameBattleMain_EntranceMapItemComponent
