local AllianceTrainAttackMessage = BaseClass("AllianceTrainAttackMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, trainUuid, serverId, teamInfoArray)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", trainUuid)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutSFSArray("teamInfos", teamInfoArray)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  message.type3v3 = Type3v3.Train
  DataCenter.LWMyStationDataManager:On3v3BattleFinish(message)
  DataCenter.LWAllyStationDataManager:On3v3BattleFinish(message)
end

AllianceTrainAttackMessage.OnCreate = OnCreate
AllianceTrainAttackMessage.HandleMessage = HandleMessage
return AllianceTrainAttackMessage
