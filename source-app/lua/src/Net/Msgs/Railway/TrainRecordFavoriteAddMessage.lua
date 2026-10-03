local TrainRecordFavoriteAddMessage = BaseClass("TrainRecordFavoriteAddMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, train_uuid, train_server)
  base.OnCreate(self)
  self.sfsObj:PutLong("train_uuid", train_uuid)
  local trainServerId = train_server or 0
  self.sfsObj:PutLong("train_server", trainServerId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWTruckRecordDataManager:OnFavoriteAdd(message)
end

TrainRecordFavoriteAddMessage.OnCreate = OnCreate
TrainRecordFavoriteAddMessage.HandleMessage = HandleMessage
return TrainRecordFavoriteAddMessage
