local AttackCityRankRewardContent = BaseClass("AttackCityRankRewardContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIItem = require("UI.UIActivityAttackCity.AttackCityTargetInfo.Component.AttackCityRankRewardContentItem")
local ShowListPath = "ShowListScroll"
local ShowListContentPath = "ShowListScroll/Viewport/Content"

function AttackCityRankRewardContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AttackCityRankRewardContent:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AttackCityRankRewardContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityAttackCityRankRewardDataUpdate, self.RefreshView)
end

function AttackCityRankRewardContent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityAttackCityRankRewardDataUpdate, self.RefreshView)
  base.OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDataList then
    return nil
  end
  local ShowInfo = self.showDataList[index]
  local item = loopScroll:NewListViewItem("AttackCityRankRewardItem")
  local script = self.showListContent:GetComponent(item.gameObject.name, UIItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.showListContent:AddComponent(UIItem, objectName)
  end
  script:SetActive(true)
  script:SetData(ShowInfo)
  return item
end

function AttackCityRankRewardContent:ComponentDefine()
  self.showList = self:AddComponent(UILoopListView2, ShowListPath)
  self.showList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.showListContent = self:AddComponent(UIBaseContainer, ShowListContentPath)
end

function AttackCityRankRewardContent:ComponentDestroy()
  self.showList = nil
  self.showListContent = nil
end

function AttackCityRankRewardContent:DataDefine()
  self.itemIndex = 0
end

function AttackCityRankRewardContent:DataDestroy()
end

function AttackCityRankRewardContent:SetData(activityId)
  self.activityId = activityId
  if self.activityId == nil then
    return
  end
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo == nil then
    return
  end
  local fightStartTime = cityWarInfo.fightStartTime
  local fightEndTime = cityWarInfo.fightEndTime
  self.showData = DataCenter.ActivityAttackCityDataManager:GetRankRewardData(self.activityId)
  local isNeedSend = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.showData == nil then
    isNeedSend = true
  end
  if isNeedSend then
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankReward, self.activityId, -1)
  end
  self:RefreshView()
end

function AttackCityRankRewardContent:RefreshView()
  if self.activityId == nil then
    return
  end
  self.showData = DataCenter.ActivityAttackCityDataManager:GetRankRewardData(self.activityId)
  self.showDataList = {}
  if self.showData ~= nil then
    self.showDataList = self.showData.data
  end
  if #self.showDataList == 0 then
    self.showList:SetActive(false)
  else
    self.showList:SetActive(true)
    self.showList:SetListItemCount(#self.showDataList, false, false)
    self.showList:RefreshAllShownItem()
  end
end

function AttackCityRankRewardContent:ClearScroll()
  self.showListContent:RemoveComponents(UIItem)
  self.showList:ClearAllItems()
end

return AttackCityRankRewardContent
