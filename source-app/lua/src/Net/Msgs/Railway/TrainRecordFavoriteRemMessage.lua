local TrainRecordFavoriteRemMessage = BaseClass("TrainRecordFavoriteRemMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, train_uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("train_uuid", train_uuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWTruckRecordDataManager:OnFavoriteRemove(message)
end

TrainRecordFavoriteRemMessage.OnCreate = OnCreate
TrainRecordFavoriteRemMessage.HandleMessage = HandleMessage
return TrainRecordFavoriteRemMessage
