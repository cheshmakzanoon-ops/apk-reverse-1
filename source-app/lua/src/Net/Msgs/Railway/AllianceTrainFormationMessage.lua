local AllianceTrainFormationMessage = BaseClass("AllianceTrainFormationMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:OnFormationGet(message)
end

AllianceTrainFormationMessage.OnCreate = OnCreate
AllianceTrainFormationMessage.HandleMessage = HandleMessage
return AllianceTrainFormationMessage
