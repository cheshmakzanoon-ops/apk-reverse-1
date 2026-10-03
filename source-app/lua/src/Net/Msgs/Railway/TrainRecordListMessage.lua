local TrainRecordListMessage = BaseClass("TrainRecordListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type, startN, endN)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("start", startN)
  self.sfsObj:PutInt("end", endN)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWTruckRecordDataManager:OnGetTruckRecordList(message)
end

TrainRecordListMessage.OnCreate = OnCreate
TrainRecordListMessage.HandleMessage = HandleMessage
return TrainRecordListMessage
