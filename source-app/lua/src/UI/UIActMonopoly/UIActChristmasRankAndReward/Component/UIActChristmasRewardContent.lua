local UIActChristmasRewardContent = BaseClass("UIActChristmasRewardContent", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RankRewardItem = require("UI.UIActBanquetRank.RankReward.Component.RankRewardItem")

function UIActChristmasRewardContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActChristmasRewardContent:OnDestroy()
  self:ClearRewardScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActChristmasRewardContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBanquetRankRewardUpdate, self.OnRefresh)
end

function UIActChristmasRewardContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBanquetRankRewardUpdate, self.OnRefresh)
end

function UIActChristmasRewardContent:ComponentDefine()
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

function UIActChristmasRewardContent:ComponentDestroy()
end

function UIActChristmasRewardContent:DataDefine()
  self.activityId = nil
  self.selectType = nil
  self.activityInfo = nil
end

function UIActChristmasRewardContent:DataDestroy()
  self.activityId = nil
  self.selectType = nil
  self.activityInfo = nil
end

function UIActChristmasRewardContent:SetData(activityId, selectType)
  self.activityId = activityId
  self.selectType = selectType
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
  if self.selectType == ActChristmasTreeBelongType.Personal then
    self.curSegment = BanquetRankType.Personal
    self:RefreshPersonalReward()
  elseif self.selectType == ActChristmasTreeBelongType.Alliance then
    self.curSegment = BanquetRankType.Ally
    self:RefreshAllyReward()
  end
  self:Update1000MS()
end

function UIActChristmasRewardContent:OnRefresh()
  self:OnRefreshReward()
end

function UIActChristmasRewardContent:RefreshPersonalReward()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetData.actBanquetId
  param.type = BanquetRankType.Personal
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyRankRewardInfo, param)
end

function UIActChristmasRewardContent:RefreshAllyReward()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetData.actBanquetId
  param.type = BanquetRankType.Ally
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyRankRewardInfo, param)
end

function UIActChristmasRewardContent:OnRefreshReward()
  local dataReach
  if self.curSegment == BanquetRankType.Personal then
    dataReach = DataCenter.ActBanquetData:IsRankRewardDataReach()
  else
    dataReach = DataCenter.ActBanquetData:IsAllianceRankRewardDataReach()
  end
  if dataReach then
    self:ClearRewardScroll()
    self.rewardArr = DataCenter.ActBanquetData:GetRewardArr(self.curSegment)
    if self.rewardArr and #self.rewardArr > 0 then
      self.scroll_reward_view:SetTotalCount(#self.rewardArr)
      self.scroll_reward_view:RefillCells()
    else
      self._noRank_txt:SetActive(true)
      self._noRank_txt:SetLocalText(110534)
    end
    local selfRank = self.curSegment == BanquetRankType.Personal and DataCenter.ActBanquetData.selfRankReward or DataCenter.ActBanquetData.selfAllyRankReward
    self:RefreshSelfReward(selfRank)
  end
end

function UIActChristmasRewardContent:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_reward_view:AddComponent(RankRewardItem, itemObj)
  local data = {}
  data.beginRank = self.rewardArr[index].startN
  data.endRank = self.rewardArr[index].endN
  data.uid = nil
  cellItem:RefreshData(data, self.rewardArr[index].reward, BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnBeginDrag), BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnEndDrag), BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnDrag))
end

function UIActChristmasRewardContent:OnRewardItemMoveOut(itemObj, index)
  self.scroll_reward_view:RemoveComponent(itemObj.name, RankRewardItem)
end

function UIActChristmasRewardContent:ClearRewardScroll()
  self.scroll_reward_view:ClearCells()
  self.scroll_reward_view:RemoveComponents(RankRewardItem)
end

function UIActChristmasRewardContent:RefreshSelfReward(selfRank)
  if self.selectType == ActChristmasTreeBelongType.Personal then
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
  elseif self.selectType == ActChristmasTreeBelongType.Alliance then
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

function UIActChristmasRewardContent:Update1000MS()
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

return UIActChristmasRewardContent
