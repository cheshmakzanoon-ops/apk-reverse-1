local BuildingCampTraining = BaseClass("BuildingCampTraining", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, type, sLevel, sNum, fromLevel, itemIds, goldForTime, goldForResource)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("sLevel", sLevel)
  self.sfsObj:PutInt("sNum", sNum)
  if fromLevel then
    self.sfsObj:PutInt("fromLevel", fromLevel)
  end
  if itemIds then
    local itemIdStr = ""
    for i = 1, #itemIds do
      if string.IsNullOrEmpty(itemIdStr) then
        itemIdStr = itemIds[i].item.itemId .. ";" .. itemIds[i].item.count
      else
        itemIdStr = itemIdStr .. "|" .. itemIds[i].item.itemId .. ";" .. itemIds[i].item.count
      end
    end
    self.sfsObj:PutUtfString("itemId", itemIdStr)
  end
  if goldForTime then
    self.sfsObj:PutInt("goldForTime", goldForTime)
  end
  if goldForResource then
    self.sfsObj:PutInt("goldForResource", goldForResource)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  EventManager:GetInstance():Broadcast(EventId.UnLockBuildingCampTrainingMsg)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.itemId or message.goldForTime or message.goldForResource then
      EventManager:GetInstance():Broadcast(EventId.InstantTrainingFinish)
      if not message.fromLevel then
        local itemId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(message.sLevel)
        DataCenter.LWCityPerformNpcManager:GetUtil():MilitaryCampCollectSolder(message.buildInfo.uuid, itemId, message.sNum)
      end
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.StartCollectSoldier, false)
    DataCenter.BuildManager:HandleProduceBuildingUpgrade(message)
    EventManager:GetInstance():Broadcast(EventId.GF_building_training_begin, message.buildInfo)
  end
end

BuildingCampTraining.OnCreate = OnCreate
BuildingCampTraining.HandleMessage = HandleMessage
return BuildingCampTraining
