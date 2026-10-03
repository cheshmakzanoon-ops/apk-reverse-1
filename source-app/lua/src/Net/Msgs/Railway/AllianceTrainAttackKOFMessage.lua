local AllianceTrainAttackKOFMessage = BaseClass("AllianceTrainAttackKOFMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainAttackKOFMessage:OnCreate(trainUuid, serverId, teamInfoArray)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", trainUuid)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutSFSArray("teamInfos", teamInfoArray)
end

function AllianceTrainAttackKOFMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    EventManager:GetInstance():Broadcast(EventId.KOFBattleFinishError)
    return
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  message.typeKOF = TypeKOF.Train
  DataCenter.LWMyStationDataManager:On3v3BattleFinish(message)
  DataCenter.LWAllyStationDataManager:OnKOFBattleFinish(message)
end

return AllianceTrainAttackKOFMessage
