local UILWTorchRelayRankRewardItemComponent = BaseClass("UILWTorchRelayRankRewardItemComponent", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RankRewardItem = require("UI.UIActBanquetRank.RankReward.Component.RankRewardItem")

function UILWTorchRelayRankRewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTorchRelayRankRewardItemComponent:OnDestroy()
  self:ClearRewardScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayRankRewardItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayActRankRewardUpdate, self.OnRefresh)
end

function UILWTorchRelayRankRewardItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActivityTorchRelayActRankRewardUpdate, self.OnRefresh)
end

function UILWTorchRelayRankRewardItemComponent:ComponentDefine()
  self._self_reward = self:AddComponent(RankRewardItem, "SelfPlayer")
  self.scroll_reward_view = self:AddComponent(UIScrollView, "ScrollView")
  self.scroll_reward_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scroll_reward_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self._noRank_txt = self:AddComponent(UIText, "TxtEmpty")
  self.refreshTime = self:AddComponent(UIText, "refreshTime")
end

function UILWTorchRelayRankRewardItemComponent:ComponentDestroy()
end

function UILWTorchRelayRankRewardItemComponent:DataDefine()
  self.activityId = nil
  self.selectType = nil
  self.activityInfo = nil
end

function UILWTorchRelayRankRewardItemComponent:DataDestroy()
  self.activityId = nil
  self.selectType = nil
  self.activityInfo = nil
end

function UILWTorchRelayRankRewardItemComponent:SetData(activityId, selectType)
  self.activityId = activityId
  self.selectType = selectType
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
  if self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    self:RefreshPersonalReward()
  elseif self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Alliance then
    self:RefreshAllyReward()
  end
  self:Update1000MS()
end

function UILWTorchRelayRankRewardItemComponent:OnRefresh()
  self:OnRefreshReward()
end

function UILWTorchRelayRankRewardItemComponent:RefreshPersonalReward()
  local param = {}
  param.aid = self.activityId
  param.type = DataCenter.ActivityTorchRelayManager.RankType.Personal - 1
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayRankRewardInfo, param)
end

function UILWTorchRelayRankRewardItemComponent:RefreshAllyReward()
  local param = {}
  param.aid = self.activityId
  param.type = DataCenter.ActivityTorchRelayManager.RankType.Alliance - 1
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayRankRewardInfo, param)
end

function UILWTorchRelayRankRewardItemComponent:OnRefreshReward()
  self:ClearRewardScroll()
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil then
    return
  end
  self.rewardArr = data:GetRankRewardData(self.selectType)
  local hasData = self.rewardArr and #self.rewardArr > 0
  self._noRank_txt:SetActive(not hasData)
  if hasData then
    self.scroll_reward_view:SetTotalCount(#self.rewardArr)
    self.scroll_reward_view:RefillCells()
  else
    self._noRank_txt:SetLocalText(110534)
  end
  self:RefreshSelfReward(data:GetSelfRankRewardData(self.selectType))
end

function UILWTorchRelayRankRewardItemComponent:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_reward_view:AddComponent(RankRewardItem, itemObj)
  local data = {}
  data.beginRank = self.rewardArr[index].startN
  data.endRank = self.rewardArr[index].endN
  data.uid = nil
  cellItem:RefreshData(data, self.rewardArr[index].reward, BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnBeginDrag), BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnEndDrag), BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnDrag))
end

function UILWTorchRelayRankRewardItemComponent:OnRewardItemMoveOut(itemObj, index)
  self.scroll_reward_view:RemoveComponent(itemObj.name, RankRewardItem)
end

function UILWTorchRelayRankRewardItemComponent:ClearRewardScroll()
  self.scroll_reward_view:ClearCells()
  self.scroll_reward_view:RemoveComponents(RankRewardItem)
end

function UILWTorchRelayRankRewardItemComponent:RefreshSelfReward(selfRank)
  if self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    for k, v in ipairs(self.rewardArr) do
      if selfRank >= v.startN and selfRank <= v.endN then
        self._self_reward:RefreshData({
          uid = LuaEntry.Player.uid,
          beginRank = v.startN,
          endRank = v.endN
        }, v.reward)
        return
      end
    end
  elseif self.selectType == DataCenter.ActivityTorchRelayManager.RankType.Alliance then
    for k, v in ipairs(self.rewardArr) do
      if selfRank >= v.startN and selfRank <= v.endN then
        self._self_reward:RefreshData({
          uid = LuaEntry.Player.uid,
          beginRank = v.startN,
          endRank = v.endN
        }, v.reward)
        return
      end
    end
  end
  self._self_reward:RefreshData({
    uid = LuaEntry.Player.uid,
    beginRank = -1,
    endRank = -1
  }, nil)
end

function UILWTorchRelayRankRewardItemComponent:Update1000MS()
  if self.activityInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.activityInfo.endTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.refreshTime:SetLocalText("thanksactivity_UI041", countDownTimeStr)
  end
end

return UILWTorchRelayRankRewardItemComponent
