local ActDetectTreasureDataManager = BaseClass("ActDetectTreasureDataManager")
local Localization = CS.GameEntry.Localization
local ArrExpireTime = 2000

local function __init(self)
  self.dataDict = {}
  self.activity_detect_dig_times = {}
  self.activity_detect_dig_times_expire = 0
  self.off_season_detect_day_times = {}
  self.off_season_detect_dig_times_expire = 0
  self.treasures_num = 0
  self.dailyGot = {}
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDay)
end

local function __delete(self)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
  self.dataDict = nil
  self.activity_detect_dig_times = nil
  self.activity_detect_dig_times_expire = nil
  self.off_season_detect_day_times = nil
  self.off_season_detect_dig_times_expire = nil
  self.treasures_num = nil
  self.dailyGot = nil
end

function ActDetectTreasureDataManager:InitData(msg)
  if msg.treasureDailyLimit then
    for _, v in pairs(msg.treasureDailyLimit) do
      if UITimeManager:GetInstance():IsToday(v.time) then
        self.dailyGot[v.id] = v.num
      end
    end
  end
end

local function OnGetArrDataMsg(self, msg)
  local activityId = msg.activityId
  if msg.treasures_num == nil then
    if not self.dataDict[activityId] then
      self.dataDict[activityId] = {}
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.dataDict[activityId].arr = msg.arr
    self.dataDict[activityId].expireTime = curTime + ArrExpireTime
  end
  if msg.treasures_num then
    self.treasures_num = msg.treasures_num
  end
end

local function OnGetDigTimesMsg(self, msg)
  if msg.activity_detect_dig_times_expire and self.activity_detect_dig_times_expire ~= msg.activity_detect_dig_times_expire then
    self.activity_detect_dig_times_expire = msg.activity_detect_dig_times_expire
    self.activity_detect_dig_times = {}
  end
  if msg.activity_detect_day_times then
    for k, v in pairs(msg.activity_detect_day_times) do
      for k1, v1 in pairs(v) do
        self.activity_detect_dig_times[tonumber(k1)] = v1
      end
    end
  end
  if msg.off_season_detect_dig_times_expire and self.off_season_detect_dig_times_expire ~= msg.off_season_detect_dig_times_expire then
    self.off_season_detect_dig_times_expire = msg.off_season_detect_dig_times_expire
    self.off_season_detect_day_times = {}
  end
  if msg.off_season_detect_day_times then
    for k, v in pairs(msg.off_season_detect_day_times) do
      for k1, v1 in pairs(v) do
        self.off_season_detect_day_times[tonumber(k1)] = v1
      end
    end
  end
  if msg.cfgId then
    local cfgId = msg.cfgId
    self.dailyGot[cfgId] = msg.treasureRewardLimit
    local meta = DataCenter.TreasureTemplateManager:GetTemplate(cfgId)
    if meta and meta.daily_max > 0 and meta.daily_max <= toInt(self.dailyGot[cfgId]) then
      EventManager:GetInstance():Broadcast(EventId.WorldTreasureReachDailyLimit)
    end
  end
end

function ActDetectTreasureDataManager:CheckTreasureReachDailyLimit(cfgId)
  local meta = DataCenter.TreasureTemplateManager:GetTemplate(cfgId)
  if not meta or meta.daily_max <= 0 then
    return false
  end
  if meta.group and 0 < meta.group then
    if not self.dailyGot[meta.group] then
      return false
    end
    return meta.daily_max <= self.dailyGot[meta.group]
  end
  if not self.dailyGot[cfgId] then
    return false
  end
  return meta.daily_max <= self.dailyGot[cfgId]
end

function ActDetectTreasureDataManager:OnPassDay()
  DataCenter.ActDetectTreasureDataManager.dailyGot = {}
end

local function GetArrData(self, activityId)
  local data = {}
  if self.dataDict[activityId] then
    data = self.dataDict[activityId]
  end
  return data
end

local function GetCurDigTimes(self, eventId)
  local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(eventId))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curDigTimes = 0
  if detectEventTemplate.type == DetectEventType.OFF_SEASON_TREASURE then
    if curTime < self.off_season_detect_dig_times_expire and self.off_season_detect_day_times[eventId] then
      curDigTimes = self.off_season_detect_day_times[eventId]
    end
    return curDigTimes
  elseif curTime < self.activity_detect_dig_times_expire and self.activity_detect_dig_times[eventId] then
    curDigTimes = self.activity_detect_dig_times[eventId]
  end
  return curDigTimes
end

local function GetCurDigTimesByActivityId(self, activityId)
  local curDigTimes = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo then
    local detect_para = activityInfo.detect_para
    local paraList = string.string2array_i_oneSep(detect_para, ";")
    if paraList and 2 <= #paraList then
      local eventId = paraList[1]
      curDigTimes = DataCenter.ActDetectTreasureDataManager:GetCurDigTimes(eventId)
    end
  end
  return curDigTimes
end

local function GetMaxDigTimes(self, eventId)
  local maxTimes = 0
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(eventId))
  if template ~= nil then
    local para = template.para3
    local paraList = string.string2array_i_oneSep(para, ";")
    if paraList and #paraList == 2 then
      maxTimes = paraList[2]
    end
  end
  return maxTimes
end

local function GetMaxDigTimesByActivityId(self, activityId)
  local maxTimes = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo then
    local detect_para = activityInfo.detect_para
    local paraList = string.string2array_i_oneSep(detect_para, ";")
    if paraList and 2 <= #paraList then
      local eventId = paraList[1]
      maxTimes = DataCenter.ActDetectTreasureDataManager:GetMaxDigTimes(eventId)
    end
  end
  return maxTimes
end

function ActDetectTreasureDataManager:GetBannerNameByMultiple(multiple)
  if not self.dicMultipleBanner then
    self.dicMultipleBanner = {}
    local str = LuaEntry.DataConfig:TryGetStr("s1_qingdian_detect", "k4")
    if not string.IsNullOrEmpty(str) then
      local dataList = string.split(str, ";")
      for i = 1, #dataList do
        local item = string.split(dataList[i], "|")
        if #item == 2 then
          self.dicMultipleBanner[tonumber(item[1])] = item[2]
        end
      end
    end
  end
  return self.dicMultipleBanner[multiple]
end

ActDetectTreasureDataManager.__init = __init
ActDetectTreasureDataManager.__delete = __delete
ActDetectTreasureDataManager.OnGetArrDataMsg = OnGetArrDataMsg
ActDetectTreasureDataManager.OnGetDigTimesMsg = OnGetDigTimesMsg
ActDetectTreasureDataManager.GetArrData = GetArrData
ActDetectTreasureDataManager.GetCurDigTimes = GetCurDigTimes
ActDetectTreasureDataManager.GetMaxDigTimes = GetMaxDigTimes
ActDetectTreasureDataManager.GetMaxDigTimesByActivityId = GetMaxDigTimesByActivityId
ActDetectTreasureDataManager.GetCurDigTimesByActivityId = GetCurDigTimesByActivityId
return ActDetectTreasureDataManager
