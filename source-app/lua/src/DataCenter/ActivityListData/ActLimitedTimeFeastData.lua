local ActLimitedTimeFeastData = BaseClass("ActLimitedTimeFeastData")
local ActLimitedTimeFeastServerData = require("DataCenter.ActivityListData.ActLimitedTimeFeastServerData")
local ActLimitedTimeFeastDropData = require("DataCenter.ActivityListData.ActLimitedTimeFeastDropData")

local function __init(self)
  self.actDataDict = {}
  self.actDropLimitDict = nil
  self.dropHistoryDic = nil
end

local function __delete(self)
  self.actDataDict = nil
  self.actDropLimitDict = nil
end

local function RefreshActDetailData(self, serverData)
  if not serverData then
    return
  end
  local activityId = serverData.id
  if activityId == nil then
    return
  end
  local activityIdNum = tonumber(activityId)
  if self.actDataDict[activityIdNum] == nil then
    self.actDataDict[activityIdNum] = ActLimitedTimeFeastServerData.New()
  end
  self.actDataDict[activityIdNum]:RefreshActDetailData(serverData)
end

local function RefreshDropNumData(self, serverData)
  local activityId = serverData.activityId
  if self.actDataDict[activityId] == nil then
    self.actDataDict[activityId] = ActLimitedTimeFeastServerData.New()
  end
  local oldVal = self.actDataDict[activityId]:GetCurValue()
  self.actDataDict[activityId]:RefreshDropNumData(serverData)
  local newVal = self.actDataDict[activityId]:GetCurValue()
  if oldVal ~= newVal then
    self:OpenLimitDropTipView(activityId, self.actDataDict[activityId])
  end
end

local function GetDropInfoById(self, activityId, templateId)
  if self.actDataDict[activityId] then
    return self.actDataDict[activityId]:GetDropInfoById(templateId)
  end
end

local function GetCurAndMax(self, activityId)
  if self.actDataDict[activityId] then
    return self.actDataDict[activityId]:GetCurAndMax()
  end
  return 0, 0
end

local function GetDataAddServerTime(self, activityId)
  if self.actDataDict[activityId] then
    return self.actDataDict[activityId]:GetDataAddServerTime()
  end
  return 0
end

local function TryRefreshActDropLimitDict(self)
  if self.actDropLimitDict == nil then
    self.actDropLimitDict = {}
    local configStr = LuaEntry.DataConfig:TryGetStr("activity_drop_limit", "k1")
    if not string.IsNullOrEmpty(configStr) then
      local configArr = string.split(configStr, "|")
      for i, v in ipairs(configArr) do
        local arr = string.split(v, ";")
        if #arr == 3 then
          local activityId = tonumber(arr[1]) or 0
          local limitType = tonumber(arr[2]) or 0
          local param = tonumber(arr[3]) or 0
          if self.actDropLimitDict[activityId] == nil then
            self.actDropLimitDict[activityId] = {}
          end
          self.actDropLimitDict[activityId][limitType] = param
        end
      end
    end
  end
end

local function GetActDropLimitData(self, actId)
  self:TryRefreshActDropLimitDict()
  if self.actDropLimitDict[actId] then
    return self.actDropLimitDict[actId]
  end
  return {}
end

local function CheckActDropLimitPass(self, actId)
  local isPass = true
  self:TryRefreshActDropLimitDict()
  if self.actDropLimitDict[actId] then
    for k, v in pairs(self.actDropLimitDict[actId]) do
      local limitType = k
      local param = v
      if limitType == 1 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local regTime = tonumber(LuaEntry.Player.regTime) or 0
        if 0 < regTime then
          local diff = curTime - regTime
          if diff < param * 24 * 60 * 60 * 1000 then
            isPass = false
            break
          end
        else
          isPass = false
          break
        end
      elseif limitType == 2 then
        local curLv = LuaEntry.Player.level or 0
        if param > curLv then
          isPass = false
          break
        end
      end
    end
  end
  return isPass
end

function ActLimitedTimeFeastData:OpenLimitDropTipView(activityId, data)
  local isInDragon = BattleFieldUtil.InBattleField()
  if isInDragon then
    return
  end
  self.limitDropCacheDic = self.limitDropCacheDic or {}
  self.limitDropCacheDic[activityId] = data
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILimitDropTipView) then
    EventManager:GetInstance():Broadcast(EventId.ActLimitedTimeFeastTipViewUpdate, data)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILimitDropTipView, {anim = true}, data)
end

function ActLimitedTimeFeastData:GetCurLimitDropCacheDic()
  return self.limitDropCacheDic or {}
end

function ActLimitedTimeFeastData:PopFirstLimitDropData()
  if not self.limitDropCacheDic or table.count(self.limitDropCacheDic) <= 0 then
    return nil
  end
  for k, v in pairs(self.limitDropCacheDic) do
    self.limitDropCacheDic[k] = nil
    return v
  end
  return nil
end

function ActLimitedTimeFeastData:ReqActivityDropHistory(activityId, dayNum, type)
  SFSNetwork.SendMessage(MsgDefines.DropActivityLogs, activityId, dayNum, type)
end

function ActLimitedTimeFeastData:UpdateActivityDropHistory(t)
  self.dropHistoryDic = self.dropHistoryDic or {}
  if not t.activityId then
    return
  end
  local activityId = toInt(t.activityId)
  local data = self.dropHistoryDic[activityId]
  if not data then
    data = ActLimitedTimeFeastDropData.New()
    self.dropHistoryDic[activityId] = data
  end
  data:UpdateData(t)
end

function ActLimitedTimeFeastData:GetActivityDropHistory(activityId)
  if not self.dropHistoryDic then
    return nil
  end
  return self.dropHistoryDic[activityId]
end

ActLimitedTimeFeastData.__init = __init
ActLimitedTimeFeastData.__delete = __delete
ActLimitedTimeFeastData.RefreshActDetailData = RefreshActDetailData
ActLimitedTimeFeastData.GetDropInfoById = GetDropInfoById
ActLimitedTimeFeastData.GetCurAndMax = GetCurAndMax
ActLimitedTimeFeastData.GetDataAddServerTime = GetDataAddServerTime
ActLimitedTimeFeastData.RefreshDropNumData = RefreshDropNumData
ActLimitedTimeFeastData.TryRefreshActDropLimitDict = TryRefreshActDropLimitDict
ActLimitedTimeFeastData.CheckActDropLimitPass = CheckActDropLimitPass
ActLimitedTimeFeastData.GetActDropLimitData = GetActDropLimitData
return ActLimitedTimeFeastData
