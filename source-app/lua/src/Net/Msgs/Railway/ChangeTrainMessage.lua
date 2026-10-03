local ChangeTrainMessage = BaseClass("ChangeTrainMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  EventManager:GetInstance():Broadcast(EventId.ChangeTrainCallback)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.myTrain then
    DataCenter.LWMyStationDataManager:OnTrainChanged(message.myTrain)
  end
end

ChangeTrainMessage.OnCreate = OnCreate
ChangeTrainMessage.HandleMessage = HandleMessage
return ChangeTrainMessage
