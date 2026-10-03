local GetLastWarActivityRewardMessage = BaseClass("GetLastWarActivityRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetLastWarActivityRewardMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", toInt(activityId))
  self.sfsObj:PutUtfString("taskId", tostring(taskId))
end

function GetLastWarActivityRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    DataCenter.ActivityListDataManager:UpdateExtraData(EVE_DECISIVE_BATTLE_TASK, nil)
  end
  if t.resources ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
  if t.gold ~= nil then
    LuaEntry.Player.gold = t.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  SFSNetwork.SendMessage(MsgDefines.GetLastWarActivityInfo)
  EventManager:GetInstance():Broadcast(EventId.EveDecisiveBattleReward, t)
end

return GetLastWarActivityRewardMessage
