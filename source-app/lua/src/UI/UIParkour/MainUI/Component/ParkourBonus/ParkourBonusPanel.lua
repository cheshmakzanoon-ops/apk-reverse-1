local ParkourBonusPanel = BaseClass("ParkourBonusPanel", UIAsyncContainer)
local Const = require("Scene.LWBattle.Const")
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local ParkourBonusTimeConditionPanel = require("UI.UIParkour.MainUI.Component.ParkourBonus.ParkourBonusTimeConditionPanel")
local ParkourBonusGoldPanel = require("UI.UIParkour.MainUI.Component.ParkourBonus.ParkourBonusGoldPanel")
local ParkourBonusProgressPanel = require("UI.UIParkour.MainUI.Component.ParkourBonus.ParkourBonusProgressPanel")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compTimeConditionPanel = self:AddComponent(ParkourBonusTimeConditionPanel, "TimeConditionPanel")
  self.compGoldPanel = self:AddComponent(ParkourBonusGoldPanel, "GoldPanel")
  self.compProgressPanel = self:AddComponent(ParkourBonusProgressPanel, "ProgressPanel")
  self.compTimeConditionPanel:SetActive(false)
  self.compGoldPanel:SetActive(false)
  self.compProgressPanel:SetActive(false)
end

local function ComponentDestroy(self)
  self.compTimeConditionPanel = nil
  self.compGoldPanel = nil
  self.compProgressPanel = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.bonusType = nil
  self.conditions = nil
  self.cacheInitParam = nil
  self.cacheRefreshParam = nil
  self.cacheRefreshConditionsParam = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, param)
  if self:AsyncLoadDone() then
    self:SetDataOnDone(param)
  else
    self.cacheInitParam = param
  end
end

local function SetDataOnDone(self, param)
  self.bonusType = param.bonusType
  self.conditions = param.conditions
  self.compGoldPanel:SetActive(false)
  self.compProgressPanel:SetActive(false)
  if self.bonusType == Const.ParkourBattleBonusType.GoldMonster then
    self.compGoldPanel:SetActive(true)
    self.compGoldPanel:SetData(param.extendData)
  elseif self.bonusType == Const.ParkourBattleBonusType.ProgressMonster then
    self.compProgressPanel:SetActive(true)
    self.compProgressPanel:SetData(param.extendData)
  end
  self.compTimeConditionPanel:SetActive(false)
  if param.conditions then
    local timeCondition = param.conditions[Const.ParkourWinType.Time]
    if timeCondition then
      self.compTimeConditionPanel:SetActive(true)
      self.compTimeConditionPanel:SetData(param.useTime, timeCondition)
    end
  end
end

local function Refresh(self, param)
  if self:AsyncLoadDone() then
    self:RefreshOnDone(param)
  else
    self.cacheRefreshParam = param
  end
end

local function RefreshOnDone(self, param)
  if param.goodsId then
    if param.goodsId == ResourceType.Wood then
      self.compGoldPanel:SetActive(true)
      self.compGoldPanel:Refresh(param)
    elseif param.goodsId == ResourceType.GoldProgress then
      self.compProgressPanel:SetActive(true)
      self.compProgressPanel:Refresh(param)
    end
  end
end

local function RefreshConditions(self, param)
  if self:AsyncLoadDone() then
    self:RefreshConditionsOnDone(param)
  else
    self.cacheRefreshConditionsParam = param
  end
end

local function RefreshConditionsOnDone(self, param)
  if self.conditions then
    local timeCondition = self.conditions[Const.ParkourWinType.Time]
    if timeCondition then
      self.compTimeConditionPanel:Refresh(param.useTime)
    end
  end
end

local function UpdateData(self)
  if self.cacheInitParam then
    self:SetDataOnDone(self.cacheInitParam)
    self.cacheInitParam = nil
  end
  if self.cacheRefreshParam then
    self:RefreshOnDone(self.cacheRefreshParam)
    self.cacheRefreshParam = nil
  end
  if self.cacheRefreshConditionsParam then
    self:RefreshConditionsOnDone(self.cacheRefreshConditionsParam)
    self.cacheRefreshConditionsParam = nil
  end
end

ParkourBonusPanel.OnCreate = OnCreate
ParkourBonusPanel.OnDestroy = OnDestroy
ParkourBonusPanel.OnEnable = OnEnable
ParkourBonusPanel.OnDisable = OnDisable
ParkourBonusPanel.ComponentDefine = ComponentDefine
ParkourBonusPanel.ComponentDestroy = ComponentDestroy
ParkourBonusPanel.DataDefine = DataDefine
ParkourBonusPanel.DataDestroy = DataDestroy
ParkourBonusPanel.OnAddListener = OnAddListener
ParkourBonusPanel.OnRemoveListener = OnRemoveListener
ParkourBonusPanel.SetData = SetData
ParkourBonusPanel.SetDataOnDone = SetDataOnDone
ParkourBonusPanel.Refresh = Refresh
ParkourBonusPanel.RefreshOnDone = RefreshOnDone
ParkourBonusPanel.RefreshConditions = RefreshConditions
ParkourBonusPanel.RefreshConditionsOnDone = RefreshConditionsOnDone
ParkourBonusPanel.UpdateData = UpdateData
return ParkourBonusPanel
