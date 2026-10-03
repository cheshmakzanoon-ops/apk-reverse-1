local UIJeepAdventureMainFirstRewardPanel = BaseClass("UIJeepAdventureMainFirstRewardPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")

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
  self.resItem = self:AddComponent(UICommonResItem, "ResItem")
  self.tipText = self:AddComponent(UIText, "TipText")
  self.redPoint = self:AddComponent(UIBaseContainer, "RedPoint")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureFirstRewards, {anim = true}, self.pageType)
  end)
  self.finishedImg = self:AddComponent(UIImage, "FinishedImg")
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.tipText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, pageType)
  self.pageType = pageType
  local curStageId = tonumber(DataCenter.LWJeepAdventureManager:GetCurStageIdByType(pageType))
  local nearlyReward = DataCenter.LWJeepAdventureManager:GetNearlyFirstRewardByType(pageType)
  self.resItem:SetActive(true)
  if nearlyReward then
    local diff = tonumber(nearlyReward.id) - curStageId
    self.tipText:SetLocalText("armed_truck_reward_level_preview", diff)
    local rewardShowDataList = nearlyReward:GetStageRewardShowData()
    if rewardShowDataList and 0 < #rewardShowDataList then
      local showData = rewardShowDataList[1]
      self.resItem:ParseInfo(showData)
    end
    self.finishedImg:SetActive(false)
  else
    self.tipText:SetLocalText("armed_truck_reward_level_down")
    local lastReward = DataCenter.LWJeepAdventureManager:GetLastFirstRewardByType(pageType)
    if lastReward then
      local rewardShowDataList = lastReward:GetStageRewardShowData()
      if rewardShowDataList and 0 < #rewardShowDataList then
        local showData = rewardShowDataList[1]
        self.resItem:ParseInfo(showData)
      else
        self.resItem:SetActive(false)
      end
    end
    self.finishedImg:SetActive(true)
  end
  local needClaimNum = DataCenter.LWJeepAdventureManager:GetUnGetRewardNumByType(curStageId, pageType)
  self.redPoint:SetActive(0 < needClaimNum)
end

UIJeepAdventureMainFirstRewardPanel.OnCreate = OnCreate
UIJeepAdventureMainFirstRewardPanel.OnDestroy = OnDestroy
UIJeepAdventureMainFirstRewardPanel.OnEnable = OnEnable
UIJeepAdventureMainFirstRewardPanel.OnDisable = OnDisable
UIJeepAdventureMainFirstRewardPanel.ComponentDefine = ComponentDefine
UIJeepAdventureMainFirstRewardPanel.ComponentDestroy = ComponentDestroy
UIJeepAdventureMainFirstRewardPanel.DataDefine = DataDefine
UIJeepAdventureMainFirstRewardPanel.DataDestroy = DataDestroy
UIJeepAdventureMainFirstRewardPanel.OnAddListener = OnAddListener
UIJeepAdventureMainFirstRewardPanel.OnRemoveListener = OnRemoveListener
UIJeepAdventureMainFirstRewardPanel.Refresh = Refresh
return UIJeepAdventureMainFirstRewardPanel
