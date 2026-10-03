local DailyPackageManager = BaseClass("DailyPackageManager")
local Localization = CS.GameEntry.Localization

function DailyPackageManager:__init()
  self.visibleIds = {}
  self.selectTab = DailyPackageType.Hero
  self.visibleIdListMap = {}
  self.readedIds = nil
end

function DailyPackageManager:__delete()
  self.visibleIds = nil
  self.lastRequestTime = nil
  self.lastReceiveTime = nil
  self.selectTab = nil
  self.readedIds = nil
end

function DailyPackageManager:UpdateData(msg)
  if not msg then
    return
  end
  if not table.IsNullOrEmpty(msg.customPackages) then
    self.visibleIds = msg.customPackages
  end
  if msg.customDailyRedDot then
    local splits = string.split(msg.customDailyRedDot, ",")
    local dict = {}
    for _, id in ipairs(splits) do
      local num_id = tonumber(id)
      if num_id then
        dict[num_id] = true
      end
    end
    self.readedIds = dict
  end
  if self.visibleIds then
    table.clear(self.visibleIdListMap)
    for i, id in ipairs(self.visibleIds) do
      local config = DataCenter.DailyPackageTemplateManager:GetTemplate(id)
      if config then
        local list = self.visibleIdListMap[config.content_type]
        list = list or {}
        table.insert(list, id)
        self.visibleIdListMap[config.content_type] = list
        if msg.selectId and msg.selectId > 0 and msg.selectId == id then
          self.selectTab = config.content_type
        end
      end
    end
  end
  if msg.selectId and msg.selectId > 0 then
    self.selectId = msg.selectId
  end
  if msg.selectState then
    self.selectState = msg.selectState
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.lastReceiveTime = curTime
  EventManager:GetInstance():Broadcast(EventId.UpdateDailyPackage)
end

function DailyPackageManager:IsReaded(id)
  if self.readedIds == nil then
    return true
  end
  if table.IsNullOrEmpty(self.readedIds) then
    return false
  end
  if self.readedIds[id] then
    return true
  end
  return false
end

function DailyPackageManager:MarkAsReaded(id)
  if self:IsReaded(id) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.DailyPackageShow, tostring(id))
end

function DailyPackageManager:UpdateReadedIds(msg)
  if not msg then
    return
  end
  if msg.customDailyRedDot then
    local splits = string.split(msg.customDailyRedDot, ",")
    local dict = {}
    for _, id in ipairs(splits) do
      local num_id = tonumber(id)
      if num_id then
        dict[num_id] = true
      end
    end
    self.readedIds = dict
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
  end
end

function DailyPackageManager:HasRedDot(contentType)
  if self.visibleIdListMap and self.visibleIdListMap[contentType] then
    for _, id in pairs(self.visibleIdListMap[contentType]) do
      if not self:IsReaded(id) then
        return true
      end
    end
  end
  return false
end

function DailyPackageManager:HasTabRedDot()
  return self:HasRedDot(DailyPackageType.Hero) or self:HasRedDot(DailyPackageType.HeroUniqueWeapon) or self:HasRedDot(DailyPackageType.HeroAwaken)
end

function DailyPackageManager:getDailyPackageGroup()
  if self.totalPackId and self.packsId then
    return self.totalPackId, self.packsId
  end
  local k2 = LuaEntry.DataConfig:TryGetStr("aps_dailypackage", "k2", "")
  local k1 = LuaEntry.DataConfig:TryGetStr("aps_dailypackage", "k1", "")
  local totalPacks = string.split(k2, ";")
  local singlePacks = string.split(k1, ";")
  self.totalPackId = totalPacks[1]
  self.packsId = singlePacks
  return self.totalPackId, self.packsId
end

function DailyPackageManager:IsBought()
  local totalPack, packs = self:getDailyPackageGroup()
  if totalPack then
    local info = GiftPackageData.get(totalPack)
    if info == nil or info:isBought() then
      return true
    end
  end
  if packs then
    for _, pack in pairs(packs) do
      local info = GiftPackageData.get(pack)
      if info == nil or info:isBought() then
        return true
      end
    end
  end
  return false
end

function DailyPackageManager:GetSelectId()
  return self.selectId
end

function DailyPackageManager:GetVisibleIds(tabId)
  if tabId and 0 < tabId then
    return self.visibleIdListMap[tabId]
  end
  return self.visibleIdListMap[self.selectTab]
end

function DailyPackageManager:GetTabs()
  local tabCount = 0
  if self.visibleIdListMap then
    for i, v in pairs(self.visibleIdListMap) do
      tabCount = tabCount + 1
    end
  end
  return tabCount
end

function DailyPackageManager:GetVisibleIdsByType(dailyType)
  return self.visibleIdListMap[dailyType]
end

function DailyPackageManager:RequestInfo()
  SFSNetwork.SendMessage(MsgDefines.DailyPackageInfo)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.lastRequestTime = curTime
end

function DailyPackageManager:CheckNeedRequest()
  if self.lastRequestTime == nil then
    self:RequestInfo()
    return
  end
  if self.lastReceiveTime == nil then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if curTime - self.lastRequestTime > 2 then
      self:RequestInfo()
      return
    end
  elseif not UITimeManager:GetInstance():IsSameDayForServer(self.lastRequestTime, UITimeManager:GetInstance():GetServerSeconds()) then
    self:RequestInfo()
  end
end

function DailyPackageManager:GetSelectingTemplate()
  if table.IsNullOrEmpty(self.visibleIds) then
    return nil
  end
  local selectId = self.selectId
  if selectId == nil then
    selectId = self.visibleIds[1]
  end
  local dailyPackageTemplate = DataCenter.DailyPackageTemplateManager:GetTemplate(selectId)
  return dailyPackageTemplate
end

function DailyPackageManager:HasSelect()
  return self.selectId ~= nil
end

function DailyPackageManager:Select(id)
  SFSNetwork.SendMessage(MsgDefines.DailyPackageSelect, tostring(id))
end

function DailyPackageManager:IsUsingNewDailyPackage()
  if self.useNewDailyPackage == nil then
    local serverRange = LuaEntry.DataConfig:TryGetStr("daily_custompackage_horizontal_or_vertical", "k1", "")
    if not string.IsNullOrEmpty(serverRange) then
      local ranges = string.split(serverRange, ",")
      local curServerId = LuaEntry.Player:GetSourceServerId()
      for i, range in pairs(ranges) do
        if string.find(range, "-") then
          local startEnd = string.split(range, "-")
          local start = tonumber(startEnd[1])
          local endId = tonumber(startEnd[2])
          if curServerId >= start and curServerId <= endId then
            self.useNewDailyPackage = true
            return true
          end
        else
          local id = tonumber(range)
          if id ~= nil and curServerId == id then
            self.useNewDailyPackage = true
            return true
          end
        end
      end
    else
      self.useNewDailyPackage = false
      return false
    end
  end
  return self.useNewDailyPackage
end

return DailyPackageManager
