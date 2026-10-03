local TradeData = BaseClass("TradeData")

function TradeData:__init()
  self.tradeId = 0
  self.uuid = 0
  self.battleStartTime = 0
  self.battleEndTime = 0
  self.serverId = 0
  self.__shopRefreshNum = 0
  self.__taxes = 0
  self.__shopState = 0
  self.__nightShopRefreshNum = 0
  self.__nightShopState = 0
  self.__nightTaxes = 0
  self.serverId = 0
  self.uid = ""
  self.name = ""
  self.pic = ""
  self.picVer = 0
  self.abbr = ""
  self.allianceId = ""
  self.headSkinId = 0
  self.headSkinET = 0
end

function TradeData:__delete()
  self.tradeId = 0
  self.uuid = 0
  self.battleStartTime = 0
  self.battleEndTime = 0
  self.serverId = 0
  self.__shopRefreshNum = 0
  self.__taxes = 0
  self.__shopState = 0
  self.__nightShopRefreshNum = 0
  self.__nightShopState = 0
  self.__nightTaxes = 0
  self:CleanUser()
end

function TradeData:CleanUser()
  self.serverId = 0
  self.uid = ""
  self.name = ""
  self.pic = ""
  self.picVer = 0
  self.abbr = ""
  self.allianceId = ""
  self.headSkinId = 0
  self.headSkinET = 0
end

function TradeData:ParseData(t)
  if t == nil then
    return
  end
  self:CleanUser()
  local occupyInfo = t.occupyInfo
  if occupyInfo ~= nil then
    local userInfo = occupyInfo.userInfo
    if userInfo then
      self.srcServerId = userInfo.serverId
      self.uid = userInfo.uid
      self.name = userInfo.name
      self.pic = userInfo.pic
      self.picVer = userInfo.picver
      self.abbr = userInfo.abbr
      self.allianceId = userInfo.allianceId
      self.headSkinId = userInfo.headSkinId
      self.headSkinET = userInfo.headSkinET
    end
  end
  if t.tradeId ~= nil then
    self.tradeId = t.tradeId
  end
  if t.uuid ~= nil then
    self.uuid = t.uuid
  end
  if t.battleStartTime ~= nil then
    self.battleStartTime = t.battleStartTime
  end
  if t.battleEndTime ~= nil then
    self.battleEndTime = t.battleEndTime
  end
  if t.serverId ~= nil then
    self.serverId = t.serverId
  else
    self.serverId = self.srcServerId or 0
  end
  self.__shopState = t.shopState or 0
  self.__shopRefreshNum = t.shopRefreshNum or 0
  self.__taxes = t.taxes or 0
  self.__nightShopState = t.nightShopState or 0
  self.__nightShopRefreshNum = t.nightShopRefreshNum or 0
  self.__nightTaxes = t.nightTaxes or 0
  if t.greenRate then
    self.greenRate = t.greenRate
  end
  if t.suppliesNum then
    self.suppliesNum = t.suppliesNum
  end
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.assistanceList = nil
    self.maxAssistance = t.maxAssistance or 0
    self.assistanceTotalPower = t.assistanceTotalPower or 0
    self.currAssistance = t.currAssistance or 0
    if t.assistanceList then
      self.assistanceList = {}
      for k, v in ipairs(t.assistanceList) do
        local _p = AssistancePlayerInfo.New()
        _p:Parse(v)
        table.insert(self.assistanceList, _p)
      end
    end
  else
    self.assistanceList = nil
  end
end

function TradeData:GetTimeState()
  local curMillisecond = UITimeManager:GetInstance():GetServerTime()
  if curMillisecond < self.battleStartTime then
    return AllianceCityShowTimeState.TradeLock
  elseif curMillisecond >= self.battleStartTime and curMillisecond < self.battleEndTime then
    return AllianceCityShowTimeState.TradeBattle
  else
    return AllianceCityShowTimeState.TradeOver
  end
end

function TradeData:GetTaxes()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return self.__nightTaxes or 0
  end
  return self.__taxes or 0
end

function TradeData:GetShopRefreshNum()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return self.__nightShopRefreshNum or 0
  end
  return self.__shopRefreshNum or 0
end

function TradeData:GetShopState()
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    return self.__nightShopState or 0
  end
  return self.__shopState or 0
end

function TradeData:SetTaxes(value, shopType)
  if shopType == TradeShopType.NIGHT then
    self.__nightTaxes = value
  else
    self.__taxes = value
  end
end

function TradeData:SetShopRefreshNum(value, shopType)
  if shopType == TradeShopType.NIGHT then
    self.__nightShopRefreshNum = value
  else
    self.__shopRefreshNum = value
  end
end

function TradeData:SetShopState(value, shopType)
  if shopType == TradeShopType.NIGHT then
    self.__nightShopState = value
  else
    self.__shopState = value
  end
end

return TradeData
