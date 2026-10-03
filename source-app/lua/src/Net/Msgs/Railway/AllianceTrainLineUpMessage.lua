local AllianceTrainLineUpMessage = BaseClass("AllianceTrainLineUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, carriageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("trainPlatformId", 1)
  self.sfsObj:PutInt("carriageId", carriageId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
end

AllianceTrainLineUpMessage.OnCreate = OnCreate
AllianceTrainLineUpMessage.HandleMessage = HandleMessage
return AllianceTrainLineUpMessage
