local UIActBanquetRankingRewardView = BaseClass("UIActBanquetRankingRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RankRewardItem = require("UI.UIActBanquetRank.RankReward.Component.RankRewardItem")
local SegmentName = {
  [BanquetRankType.Personal] = "thanksactivity_UI039",
  [BanquetRankType.Ally] = "thanksactivity_UI040"
}

function UIActBanquetRankingRewardView:OnCreate()
  base.OnCreate(self)
  self.panel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/safearea/BtnClose")
  self._close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title = self:AddComponent(UIText, "UICommonPopUpTitle/safearea/TopBar/TextTitle")
  self.title:SetLocalText("2000237")
  self.segmentN = self:AddComponent(UIBaseContainer, "tabSv/Viewport/Content")
  self.segmentTbN = {}
  for i = 0, 1 do
    local segment = self:AddComponent(UIBaseContainer, "tabSv/Viewport/Content/Tab" .. i + 1)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickSegment(i)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local selectTxt = segment:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(SegmentName[i])
    local unselectTxt = segment:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(SegmentName[i])
    local red = segment:AddComponent(UIBaseContainer, "RedDot1")
    local newSeg = {
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      redN = red,
      btnN = btn
    }
    table.insert(self.segmentTbN, newSeg)
  end
  self._self_reward = self:AddComponent(RankRewardItem, "RankObj/SelfPlayer")
  self.scroll_reward_view = self:AddComponent(UIScrollView, "RankObj/ScrollView")
  self.scroll_reward_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scroll_reward_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self._noRank_txt = self:AddComponent(UIText, "RankObj/TxtEmpty")
  local actId = self:GetUserData()
  self:SetData(actId)
end

function UIActBanquetRankingRewardView:OnDestroy()
  self.actEnd = nil
  self.curSegment = nil
  self:ClearRewardScroll()
  base.OnDestroy(self)
end

function UIActBanquetRankingRewardView:OnEnable()
  base.OnEnable(self)
  self._noRank_txt:SetActive(false)
end

function UIActBanquetRankingRewardView:OnDisable()
  base.OnDisable(self)
end

function UIActBanquetRankingRewardView:SetData(actId)
  self.activityId = actId
  self.actData = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(self.activityId))
  self:SelectSegment(BanquetRankType.Personal)
end

function UIActBanquetRankingRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBanquetRankRewardUpdate, self.OnRefresh)
end

function UIActBanquetRankingRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBanquetRankRewardUpdate, self.OnRefresh)
end

function UIActBanquetRankingRewardView:OnRefresh()
  self:OnRefreshReward()
end

function UIActBanquetRankingRewardView:RefreshPersonalReward()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetData.actBanquetId
  param.type = BanquetRankType.Personal
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyRankRewardInfo, param)
end

function UIActBanquetRankingRewardView:RefreshAllyReward()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetData.actBanquetId
  param.type = BanquetRankType.Ally
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyRankRewardInfo, param)
end

function UIActBanquetRankingRewardView:OnRefreshReward()
  local dataReach = DataCenter.ActBanquetData:IsRankRewardDataReach()
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

function UIActBanquetRankingRewardView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_reward_view:AddComponent(RankRewardItem, itemObj)
  local data = {}
  data.beginRank = self.rewardArr[index].startN
  data.endRank = self.rewardArr[index].endN
  data.uid = nil
  cellItem:RefreshData(data, self.rewardArr[index].reward, BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnBeginDrag), BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnEndDrag), BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnDrag))
end

function UIActBanquetRankingRewardView:OnRewardItemMoveOut(itemObj, index)
  self.scroll_reward_view:RemoveComponent(itemObj.name, RankRewardItem)
end

function UIActBanquetRankingRewardView:ClearRewardScroll()
  self.scroll_reward_view:ClearCells()
  self.scroll_reward_view:RemoveComponents(RankRewardItem)
end

function UIActBanquetRankingRewardView:RefreshSelfReward(selfRank)
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
  self._self_reward:RefreshData({
    uid = LuaEntry.Player.uid,
    beginRank = -1,
    endRank = -1
  }, nil)
end

function UIActBanquetRankingRewardView:OnClickSegment(index)
  if index == BanquetRankType.Personal or LuaEntry.Player:IsInAlliance() then
    self:SelectSegment(index)
  else
    UIUtil.ShowTipsId(800935)
  end
end

function UIActBanquetRankingRewardView:SelectSegment(seg)
  if self.curSegment == seg then
    return
  end
  self.curSegment = seg
  for i, v in ipairs(self.segmentTbN) do
    if i - 1 == seg then
      v.selectN:SetActive(true)
    else
      v.selectN:SetActive(false)
    end
  end
  self:ShowPanel()
end

function UIActBanquetRankingRewardView:ShowPanel()
  if self.curSegment == BanquetRankType.Personal then
    self:RefreshPersonalReward()
  elseif self.curSegment == BanquetRankType.Ally then
    self:RefreshAllyReward()
  end
end

return UIActBanquetRankingRewardView
