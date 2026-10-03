local LWActivityArenaRewardsItemAchieve = BaseClass("LWActivityArenaRewardsItemAchieve", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local compBook = {
  {
    path = "txtTitle1",
    name = "txtTitle1",
    type = UIText,
    textKey = "500266"
  },
  {
    path = "nodeDone",
    name = "nodeDone",
    type = nil
  },
  {
    path = "nodeDone/txtTitle2",
    name = "txtTitle2",
    type = UIText,
    textKey = "500266"
  },
  {
    path = "btnReceive",
    name = "btnReceive",
    type = UIButton,
    onClick = function(self)
      self:OnClickReceive()
    end
  },
  {
    path = "btnReceive/txtReceive",
    name = "txtReceive",
    type = UIText,
    textKey = "129054"
  },
  {
    path = "btnReceive/imgGray",
    name = "imgGray",
    type = nil
  },
  {
    path = "btnReceive/imgGray/txtGray",
    name = "txtGray",
    type = UIText,
    textKey = "129054"
  },
  {
    path = "scrollRewards",
    name = "scroll",
    type = UIScrollRect
  },
  {
    path = "scrollRewards/Viewport/Content",
    name = "scrollContent",
    type = nil
  },
  {
    path = "scrollRewards/rewardTemplate",
    name = "rewardTemplate",
    type = nil,
    active = false
  }
}

function LWActivityArenaRewardsItemAchieve:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWActivityArenaRewardsItemAchieve:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityArenaRewardsItemAchieve:ComponentDefine()
  self.rewardComps = {}
  self:DefineCompsByBook(compBook)
end

function LWActivityArenaRewardsItemAchieve:ComponentDestroy()
  for _, rewardComp in ipairs(self.rewardComps) do
    if rewardComp then
      local go = rewardComp.gameObject
      self:RemoveComponent(rewardComp)
      if not IsNull(go) then
        CS.UnityEngine.GameObject.Destroy(go)
      end
    end
  end
  self.rewardComps = nil
  self:ClearCompsByBook(compBook)
end

function LWActivityArenaRewardsItemAchieve:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityArenaReceiveBack, self.OnSuccess)
end

function LWActivityArenaRewardsItemAchieve:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityArenaReceiveBack, self.OnSuccess)
  base.OnRemoveListener(self)
end

function LWActivityArenaRewardsItemAchieve:Refresh(data)
  self.data = data
  self.txtTitle1:SetText(Localization:GetString("500266", data.targetRank, data.myTopRank, data.targetRank))
  self.txtTitle2:SetText(Localization:GetString("500266", data.targetRank, data.myTopRank, data.targetRank))
  self.nodeDone:SetActive(data.state == 2)
  self.btnReceive:SetInteractable(data.state == 1)
  self.imgGray:SetActive(data.state == 0)
  self.scroll:SetSizeDeltaXY(self.nodeDone.activeSelf and 648 or 473, self.scroll:GetSizeDelta().y)
  local idx = 1
  for _, reward in ipairs(data.rewards) do
    local rewardComp = self.rewardComps[idx]
    if not rewardComp then
      local rewardObj = CS.UnityEngine.GameObject.Instantiate(self.rewardTemplate, self.scrollContent.transform)
      rewardObj.name = "reward_" .. idx
      rewardComp = self:AddComponent(UICommonResItem, rewardObj)
      self.rewardComps[idx] = rewardComp
    end
    rewardComp:SetActive(true)
    rewardComp:ReInit(reward)
    idx = idx + 1
  end
  for i = idx, #self.rewardComps do
    self.rewardComps[i]:SetActive(false)
  end
end

function LWActivityArenaRewardsItemAchieve:OnClickReceive()
  if not self.data then
    return
  end
  if tonumber(self.data.activityId) == DataCenter.LWNewbieArenaV2Manager:GetArenaInfoId() then
    SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2Receive, self.data.activityId, self.data.id)
  else
    SFSNetwork.SendMessage(MsgDefines.ActivityArenaReceive, self.data.activityId, self.data.id)
  end
end

function LWActivityArenaRewardsItemAchieve:OnSuccess(msgTbl)
  if not self.data then
    return
  end
  if self.data.id ~= msgTbl.id then
    return
  end
  self.data.state = 2
  self:Refresh(self.data)
  self.view:ShowAchieveList()
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.data.activityId))
end

return LWActivityArenaRewardsItemAchieve
