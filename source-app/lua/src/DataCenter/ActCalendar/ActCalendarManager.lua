local ActCalendarManager = BaseClass("ActCalendarManager")
local ActCalendarActivityData = require("DataCenter.ActCalendar.ActCalendarActivityData")
ActCalendarManager.CUR_DAY_INDEX = 3
ActCalendarManager.WEEK_DAYS = 7
local RED_DOT_FLAG = "ActCalendar_RED_DOT_RECORD"
local NEW_FLAG = "ActCalendar_NEW_FLAG"

function ActCalendarManager:__init()
end

function ActCalendarManager:__delete()
  self:_clearAllCacheData()
end

function ActCalendarManager:_initAllCacheData()
  self.dataList = {}
  self.dataGroup = {}
  self.dataGroupSort = {}
  self.maxGroupId = 0
  self.weekBegin = 0
  self.weekEnd = 0
end

function ActCalendarManager:_clearAllCacheData()
  self.dataList = nil
  self.dataGroup = nil
  self.dataGroupSort = nil
  self.maxGroupId = nil
  self.weekBegin = nil
  self.weekEnd = nil
end

function ActCalendarManager:OnUpdateActServerData(message)
  if not message then
    return
  end
  self:_initAllCacheData()
  self:_refreshWeekDuration()
  for i, v in ipairs(message.dataArr) do
    self:_saveNewData(v)
  end
  self.dataGroupSort = self:_sortGroup(self.dataGroupSort)
  EventManager:GetInstance():Broadcast(EventId.ActCalendarDataUpdate)
end

function ActCalendarManager:GetGroupDataSortList()
  if not self.dataGroupSort then
    Logger.LogError("dataGroupSort is nil")
    return
  end
  return self.dataGroupSort
end

function ActCalendarManager:GetGroupData(group)
  if not self.dataGroup then
    Logger.LogError("dataGroup is nil")
    return
  end
  if not self.dataGroup[group] then
    Logger.LogError("group not exist!  group:" .. tostring(group))
    return
  end
  return self.dataGroup[group]
end

function ActCalendarManager:GetListByGroup(group)
  local groupData = self:GetGroupData(group)
  if not groupData then
    return
  end
  return groupData.list
end

function ActCalendarManager:GetAllDataList()
  if not self.dataList then
    Logger.LogError("dataList is nil")
    return
  end
  return self.dataList
end

function ActCalendarManager:GetGroupDataSortListByProps(props)
  local groupDic = {}
  local groupList = {}
  local dataList = DataCenter.ActCalendarManager:GetAllDataList()
  for i, v in ipairs(dataList) do
    if v and v:HasProps(props.itemId) then
      local groupData = groupDic[v.calendarAddGroup]
      if not groupData then
        groupData = self:_createGroupData(v.calendarAddGroup)
        table.insert(groupList, groupData)
      end
      table.insert(groupData.list, v)
      groupDic[v.calendarAddGroup] = groupData
    end
  end
  groupList = self:_sortGroup(groupList)
  return groupList
end

function ActCalendarManager:GetAllProps()
  local dataList = self:GetAllDataList()
  if not dataList then
    return
  end
  local propsDic = {}
  local propsList = {}
  for i, data in ipairs(dataList) do
    if data.propsList ~= nil then
      for j, props in ipairs(data.propsList) do
        if not propsDic[props.itemId] then
          table.insert(propsList, props)
        end
        propsDic[props.itemId] = props
      end
    end
  end
  table.sort(propsList, function(a, b)
    if a.itemColor ~= b.itemColor then
      return a.itemColor > b.itemColor
    end
    return a.itemId > b.itemId
  end)
  return propsList
end

function ActCalendarManager:GetGroupTemplate(id)
  local lineData = LocalController:instance():getLine(TableName.ACTIVITY_CALENDARGROUP, id)
  return lineData
end

function ActCalendarManager:GetBanner()
  local dataList = DataCenter.ActCalendarManager:GetAllDataList()
  local maxOrder = 0
  local bannerName
  for i, v in ipairs(dataList) do
    if v and v.calendarBannerPriority and not string.IsNullOrEmpty(v.calendarBanner) and maxOrder < v.calendarBannerPriority then
      maxOrder = v.calendarBannerPriority
      bannerName = v.calendarBanner
    end
  end
  local fullName
  if bannerName == nil then
    fullName = LuaEntry.DataConfig:TryGetStr("calendar_countdown_base", "k2") or ""
  else
    fullName = string.format(LoadPath.ActCalendarTexture, bannerName)
  end
  return fullName
end

function ActCalendarManager:SetLocalRedDotRecord(aid)
  local key = RED_DOT_FLAG .. aid .. LuaEntry.Player.uid
  Setting:SetBool(key, true)
end

function ActCalendarManager:GetLocalRedDotRecord(aid)
  local key = RED_DOT_FLAG .. aid .. LuaEntry.Player.uid
  local result = Setting:GetBool(key, false)
  return result
end

function ActCalendarManager:SetLocalNewFlagRecord(aid)
  local key = NEW_FLAG .. aid .. LuaEntry.Player.uid
  Setting:SetBool(key, true)
end

function ActCalendarManager:GetLocalNewFlagRecord(aid)
  local key = NEW_FLAG .. aid .. LuaEntry.Player.uid
  local result = Setting:GetBool(key, false)
  return result
end

function ActCalendarManager:GetWeekBegin()
  return self.weekBegin
end

function ActCalendarManager:GetWeekEnd()
  return self.weekEnd
end

function ActCalendarManager:GetDurationDays(beginTimestamp, endTimestamp)
  local days = math.floor((endTimestamp - beginTimestamp) / 86400000 + 0.5)
  return days
end

function ActCalendarManager:IsBeforeWeekBegin(timestamp)
  return timestamp < self.weekBegin
end

function ActCalendarManager:IsLaterWeekEnd(timestamp)
  return timestamp >= self.weekEnd
end

function ActCalendarManager:GetToWeekEndDays(timestamp)
  local timeZero
  if self:IsBeforeWeekBegin(timestamp) then
    timeZero = self.weekBegin
  else
    local timeZeroSeconds = UITimeManager:GetInstance():GetTodayZeroServerTime(timestamp * 0.001)
    timeZero = math.floor(timeZeroSeconds * 1000 + 0.5)
  end
  local days = math.floor((self.weekEnd - timeZero) / 86400000 + 0.5)
  return days
end

function ActCalendarManager:_saveNewData(serverData)
  local data = ActCalendarActivityData.New()
  data:OnUpdateServerData(serverData)
  table.insert(self.dataList, data)
  local groupData = self.dataGroup[data.calendarAddGroup]
  if not groupData then
    groupData = self:_createGroupData(data.calendarAddGroup)
    table.insert(self.dataGroupSort, groupData)
  end
  table.insert(groupData.list, data)
  self.dataGroup[data.calendarAddGroup] = groupData
  return data
end

function ActCalendarManager:_createGroupData(groupId)
  local groupData = {}
  groupData.id = groupId
  groupData.template = self:GetGroupTemplate(groupId)
  groupData.list = {}
  return groupData
end

function ActCalendarManager:_sortGroup(groupList)
  if not groupList then
    return
  end
  if 1 < #groupList then
    table.sort(groupList, function(a, b)
      if a.template.group_priority ~= b.template.group_priority then
        return a.template.group_priority < b.template.group_priority
      end
      return a.id < b.id
    end)
  end
  for i, v in ipairs(groupList) do
    v.list = self:_sortList(v.list)
  end
  return groupList
end

function ActCalendarManager:_sortList(list)
  if not list or #list <= 1 then
    return list
  end
  table.sort(list, function(a, b)
    if a:GetOrder() ~= b:GetOrder() then
      return a:GetOrder() < b:GetOrder()
    end
    return a.aid < b.aid
  end)
  return list
end

function ActCalendarManager:_refreshWeekDuration()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local nowZeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(serverTime * 0.001)
  nowZeroTime = math.floor(nowZeroTime * 1000 + 0.5)
  local oneDay = 86400000
  self.weekBegin = nowZeroTime + oneDay * (1 - ActCalendarManager.CUR_DAY_INDEX)
  self.weekEnd = nowZeroTime + oneDay * (ActCalendarManager.WEEK_DAYS - ActCalendarManager.CUR_DAY_INDEX + 1)
end

return ActCalendarManager
