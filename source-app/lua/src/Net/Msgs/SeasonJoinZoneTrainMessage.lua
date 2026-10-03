local SeasonJoinZoneTrainMessage = BaseClass("SeasonJoinZoneTrainMessage", SFSBaseMessage)
local base = SFSBaseMessage
local sellType
local HSRUuid = 0

function SeasonJoinZoneTrainMessage:OnCreate(price, num, trainUuid, heroArray, chipSetId, squadNo)
  base.OnCreate(self)
  if price then
    self.sfsObj:PutInt("expectPrice", price)
    self.sfsObj:PutInt("sellType", 2)
    sellType = HSRSellType.Dump
  else
    self.sfsObj:PutInt("sellType", 1)
    sellType = HSRSellType.Consign
  end
  self.sfsObj:PutInt("num", num)
  HSRUuid = trainUuid
  self.sfsObj:PutLong("uuid", trainUuid)
  self.sfsObj:PutInt("squadNo", squadNo)
  self.sfsObj:PutSFSArray("heroInfo", heroArray)
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
end

function SeasonJoinZoneTrainMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(sellType == HSRSellType.Dump and "activity_1200044_tips97" or "activity_1200044_tips96")
    EventManager:GetInstance():Broadcast(EventId.HSRGetOnSuccess)
    DataCenter.HSRDataManager:FetchActivityData()
    CommonUtil.PlayerPrefsSetLong(SettingKeys.HSR_GET_ON_SUCCESS, HSRUuid)
  end
end

return SeasonJoinZoneTrainMessage
