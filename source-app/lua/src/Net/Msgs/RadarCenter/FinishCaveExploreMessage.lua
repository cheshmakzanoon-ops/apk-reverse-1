local FinishCaveExploreMessage = BaseClass("FinishCaveExploreMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, index)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CaveExplorationManager:DeleteSyncMsgUuid(t.uuid)
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:AddRewards(t.pathReward)
    local showTip = "cave_exploration_tips_4"
    local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(t.uuid)
    local showShare
    if event ~= nil and event.cavePath ~= nil and #event.cavePath > 0 then
      local currentConfigId = event.cavePath[#event.cavePath]
      local templateConfig = DataCenter.CaveExplorationManager:GetTempData(currentConfigId)
      showTip = string.IsNullOrEmpty(templateConfig.reward_tips) and showTip or templateConfig.reward_tips
      if templateConfig.share_components == 0 then
      end
      showShare = templateConfig.share_components
    end
    t.showTip = showTip
    if t.caveExploreType == 4 then
      DataCenter.RewardManager:ShowTwoLinesRewards(t.reward, t.pathReward, "128027", t.showTip)
      EventManager:GetInstance():Broadcast(EventId.DetectCaveExplorationFinish, t)
    elseif t.caveExploreType == 3 then
      EventManager:GetInstance():Broadcast(EventId.DetectCaveExplorationFinish, t)
      DataCenter.CaveExplorationManager:SetShareInfo(showShare)
    elseif t.caveExploreType == 2 then
      DataCenter.CaveExplorationManager:TempCacheRewards(t.uuid, t.reward, t.pathReward, t.showTip)
    end
  end
end

FinishCaveExploreMessage.OnCreate = OnCreate
FinishCaveExploreMessage.HandleMessage = HandleMessage
return FinishCaveExploreMessage
