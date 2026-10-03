local GetTrainListMessage = BaseClass("GetTrainListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, isRefresh)
  base.OnCreate(self)
  self.sfsObj:PutBool("isRefresh", isRefresh)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.ls or message.allianceTrainList then
    DataCenter.LWTrainDataManager:OnTrainListGet(message)
  end
  if message.trainServers then
    DataCenter.LWMyStationDataManager:SetMatchServer(message.trainServers)
  end
end

GetTrainListMessage.OnCreate = OnCreate
GetTrainListMessage.HandleMessage = HandleMessage
return GetTrainListMessage
