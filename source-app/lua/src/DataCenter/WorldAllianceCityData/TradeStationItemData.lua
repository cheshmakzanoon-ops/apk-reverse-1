local TradeStationItemData = BaseClass("TradeStationItemData")

function TradeStationItemData:__init()
  self.tradeId = 0
  self.uuid = 0
  self.serverId = 0
  self.occupyInfoUserInfo = nil
  self.priority = 0
  self.level = 0
  self.iconPath = nil
  self.posStr = nil
  self.pos = nil
  self.pointId = 0
  self.battleStartTime = 0
  self.battleEndTime = 0
  self.__shopRefreshNum = 0
  self.__taxes = 0
  self.__shopState = 0
  self.__nightShopRefreshNum = 0
  self.__nightShopState = 0
  self.__nightTaxes = 0
end

function TradeStationItemData:__delete()
  self.tradeId = nil
  self.uuid = nil
  self.serverId = nil
  self.occupyInfoUserInfo = nil
  self.priority = nil
  self.level = nil
  self.iconPath = nil
  self.posStr = nil
  self.pos = nil
  self.pointId = nil
  self.battleStartTime = nil
  self.battleEndTime = nil
  self.__shopRefreshNum = 0
  self.__taxes = 0
  self.__shopState = 0
  self.__nightShopRefreshNum = 0
  self.__nightShopState = 0
  self.__nightTaxes = 0
end

function TradeStationItemData:ParseData(msg)
  if msg.uuid then
    self.uuid = msg.uuid
  end
  if msg.serverId then
    self.serverId = msg.serverId
  end
  self.__shopState = msg.shopState or 0
  self.__shopRefreshNum = msg.shopRefreshNum or 0
  self.__taxes = msg.taxes or 0
  self.__nightShopState = msg.nightShopState or 0
  self.__nightShopRefreshNum = msg.nightShopRefreshNum or 0
  self.__nightTaxes = msg.nightTaxes or 0
  self.battleStartTime = msg.battleStartTime or 0
  self.battleEndTime = msg.battleEndTime or 0
  local isMine = 0
  if msg.occupyInfo and msg.occupyInfo.userInfo then
    self.occupyInfoUserInfo = {}
    self.occupyInfoUserInfo.uid = msg.occupyInfo.userInfo.uid
    self.occupyInfoUserInfo.name = msg.occupyInfo.userInfo.name
    self.occupyInfoUserInfo.allianceId = msg.occupyInfo.userInfo.allianceId
    self.occupyInfoUserInfo.allianceName = msg.occupyInfo.userInfo.allianceName
    self.occupyInfoUserInfo.headFrame = msg.occupyInfo.userInfo.headFrame
    self.occupyInfoUserInfo.picVer = msg.occupyInfo.userInfo.picver
    self.occupyInfoUserInfo.pic = msg.occupyInfo.userInfo.pic
    self.occupyInfoUserInfo.headSkinET = msg.occupyInfo.userInfo.headSkinET
    self.occupyInfoUserInfo.headSkinId = msg.occupyInfo.userInfo.headSkinId
    if LuaEntry.Player.uid == self.occupyInfoUserInfo.uid then
      isMine = 1
    end
  else
    self.occupyInfoUserInfo = nil
  end
  if msg.tradeId then
    self.tradeId = msg.tradeId
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(self.tradeId), self.serverId)
    if cityMeta then
      self.level = cityMeta.level
      self.bigMapIndex = cityMeta.bigMapIndex
      self.priority = self.serverId * 1000 + self.level * 10 + isMine
      self.iconPath = cityMeta:GetIconPath(false)
      self.posStr = string.format("X: %s Y: %s", cityMeta.pos.x, cityMeta.pos.y)
      self.pos = {}
      self.pos.x = cityMeta.pos.x
      self.pos.y = cityMeta.pos.y
      self.pointId = cityMeta:GetPointId()
    end
  end
end

function TradeStationItemData:HasLord()
  return self.occupyInfoUserInfo and not string.IsNullOrEmpty(self.occupyInfoUserInfo.uid) and not string.IsNullOrEmpty(self.occupyInfoUserInfo.name)
end

function TradeStationItemData:GetTimeState()
  local curMillisecond = UITimeManager:GetInstance():GetServerTime()
  if curMillisecond < self.battleStartTime then
    return AllianceCityShowTimeState.TradeLock, self.battleStartTime
  elseif curMillisecond >= self.battleStartTime and curMillisecond < self.battleEndTime then
    return AllianceCityShowTimeState.TradeBattle, self.battleEndTime
  else
    return AllianceCityShowTimeState.TradeOver
  end
end

function TradeStationItemData:GetTaxes()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return self.__nightTaxes or 0
  end
  return self.__taxes or 0
end

function TradeStationItemData:GetShopRefreshNum()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return self.__nightShopRefreshNum or 0
  end
  return self.__shopRefreshNum or 0
end

function TradeStationItemData:GetShopState()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return self.__nightShopState or 0
  end
  return self.__shopState or 0
end

return TradeStationItemData
