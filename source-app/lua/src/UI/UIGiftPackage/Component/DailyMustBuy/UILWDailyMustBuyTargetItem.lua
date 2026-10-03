local UILWDailyMustBuyTargetItem = BaseClass("UILWDailyMustBuyTargetItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DestroyEffect()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.item = self:AddComponent(UICommonResItem, "")
  self.stateFrame = self:AddComponent(UIImage, "StateFrame")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClickSelf()
  end)
  self.stateFrame:SetActive(false)
end

local function ComponentDestroy(self)
  self.item = nil
  self.stateFrame = nil
  self.btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnClickSelf(self)
  if not self.stageData then
    return
  end
  if self.stageData.state == 1 then
    if self.item then
      self.item:OnBtnClick()
    end
    return
  end
  local curScore = DataCenter.DailyMustBuyManager:GetCurScore()
  if curScore < self.stageData.score then
    if self.item then
      self.item:OnBtnClick()
    end
    return
  end
  DataCenter.DailyMustBuyManager:ClaimRewardAtStage(self.stageData.index)
end

local function SetItem(self, stageData)
  if stageData == nil then
    return
  end
  self.stageData = stageData
  self.index = stageData.index
  if not table.IsNullOrEmpty(stageData.showReward) then
    local showData = DeepCopy(stageData.showReward[1])
    self.item:ReInit(showData)
    self.item:SetActive(true)
  else
    self.item:SetActive(false)
  end
  self:RefreshState()
end

local function ShowEffect(self)
  self.effectState = true
  if not self.effectObj then
    self.effectObj = self:GameObjectInstantiateAsync(UIAssets.BattlePassEffect, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local showState = self.effectState
      go.transform:SetParent(self.transform)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_localScale(0.65, 0.65, 0.65)
      go.name = NameCount
      NameCount = NameCount + 1
      local cell = self:AddComponent(UIBaseContainer, go.name)
      showState = showState or false
      cell:SetActive(showState)
      self.effect = cell
    end)
  elseif self.effect then
    self.effect:SetActive(true)
  end
end

local function HideEffect(self)
  if self.effect then
    self.effect:SetActive(false)
  end
  self.effectState = false
end

local function DestroyEffect(self)
  if self.effectObj then
    self:GameObjectDestroy(self.effectObj)
    self.effectObj = nil
    self.effect = nil
  end
end

local function RefreshState(self)
  if self.stageData == nil then
    return
  end
  local canGet = true
  local hasGot = false
  if self.stageData.state == 0 then
    local curScore = DataCenter.DailyMustBuyManager:GetCurScore()
    canGet = curScore >= self.stageData.score
  elseif self.stageData.state == 1 then
    canGet = true
    hasGot = true
  end
  if hasGot then
    UIGray.SetGray(self.transform, true, true)
  else
    UIGray.SetGray(self.transform, false, true)
  end
  if canGet and not hasGot then
    self:ShowEffect()
  else
    self:HideEffect()
  end
end

local function RefreshData(self, stageData)
  if stageData == nil then
    return
  end
  self.stageData = stageData
  RefreshState(self)
end

UILWDailyMustBuyTargetItem.OnCreate = OnCreate
UILWDailyMustBuyTargetItem.OnDestroy = OnDestroy
UILWDailyMustBuyTargetItem.ComponentDefine = ComponentDefine
UILWDailyMustBuyTargetItem.ComponentDestroy = ComponentDestroy
UILWDailyMustBuyTargetItem.DataDefine = DataDefine
UILWDailyMustBuyTargetItem.DataDestroy = DataDestroy
UILWDailyMustBuyTargetItem.OnClickSelf = OnClickSelf
UILWDailyMustBuyTargetItem.RefreshData = RefreshData
UILWDailyMustBuyTargetItem.RefreshState = RefreshState
UILWDailyMustBuyTargetItem.SetItem = SetItem
UILWDailyMustBuyTargetItem.ShowEffect = ShowEffect
UILWDailyMustBuyTargetItem.HideEffect = HideEffect
UILWDailyMustBuyTargetItem.DestroyEffect = DestroyEffect
return UILWDailyMustBuyTargetItem
