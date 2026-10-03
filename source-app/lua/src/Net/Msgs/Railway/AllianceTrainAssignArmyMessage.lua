local AllianceTrainAssignArmyMessage = BaseClass("AllianceTrainAssignArmyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, teamInfoArray)
  base.OnCreate(self)
  self.sfsObj:PutInt("trainPlatformId", 1)
  self.sfsObj:PutSFSArray("teamInfos", teamInfoArray)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.LWAllyStationDataManager:OnFormationGet(message)
  UIUtil.ShowTipsId(801154)
end

AllianceTrainAssignArmyMessage.OnCreate = OnCreate
AllianceTrainAssignArmyMessage.HandleMessage = HandleMessage
return AllianceTrainAssignArmyMessage
