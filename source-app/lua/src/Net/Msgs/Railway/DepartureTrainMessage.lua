local DepartureTrainMessage = BaseClass("DepartureTrainMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, trainUuid, heroArray, chipSetId, squadNo, squadNoClient)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", trainUuid)
  self.sfsObj:PutInt("squadNo", squadNo)
  self.sfsObj:PutInt("squadNoClient", squadNoClient)
  self.sfsObj:PutSFSArray("heroInfo", heroArray)
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    if message.uuid then
      UIUtil.ShowTipsId("truck_tips10007")
      local trainData = DataCenter.LWMyStationDataManager:GetMyTruckByUuid(message.uuid)
      if trainData then
        trainData.squadNoClient = 0
      end
    else
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  DataCenter.LWMyStationDataManager:OnMyTrainDeparture(message)
end

DepartureTrainMessage.OnCreate = OnCreate
DepartureTrainMessage.HandleMessage = HandleMessage
return DepartureTrainMessage
