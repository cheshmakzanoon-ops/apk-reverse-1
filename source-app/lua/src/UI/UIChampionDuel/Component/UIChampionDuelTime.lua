local UIChampionDuelTime = BaseClass("UIChampionDuelTime", UIBaseContainer)
local base = UIBaseContainer
local MyModf = math.modf
local MyFloor = math.floor
local MyStrFormat = string.format
local MyDate = os.date
local text_time_tip_path = "TimeTipText"
local text_time_day_path = "TimeDayText"
local text_day_path = "TimeGroup/DiDay/DayText"
local text_hour_path = "TimeGroup/DiHour/HourText"
local text_min_path = "TimeGroup/DiMin/MinText"
local text_sec_path = "TimeGroup/DiSec/SecText"

function UIChampionDuelTime:OnCreate()
  base.OnCreate(self)
  self.endTime = 0
  self.retryTime = 0
  self.autoReq = true
  self:ComponentDefine()
end

function UIChampionDuelTime:OnDestroy()
  self.endTime = 0
  self.retryTime = 0
  self.autoReq = true
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelTime:ComponentDefine()
  local go = self.transform:Find(text_time_tip_path)
  if go ~= nil then
    self.text_time_tip = self:AddComponent(UIText, text_time_tip_path)
  end
  go = self.transform:Find(text_time_day_path)
  if go ~= nil then
    self.text_time_day = self:AddComponent(UIText, text_time_day_path)
  end
  go = self.transform:Find(text_day_path)
  if go ~= nil then
    self.text_day = self:AddComponent(UIText, text_day_path)
  end
  go = self.transform:Find(text_hour_path)
  if go ~= nil then
    self.text_hour = self:AddComponent(UIText, text_hour_path)
  end
  go = self.transform:Find(text_min_path)
  if go ~= nil then
    self.text_min = self:AddComponent(UIText, text_min_path)
  end
  go = self.transform:Find(text_sec_path)
  if go ~= nil then
    self.text_sec = self:AddComponent(UIText, text_sec_path)
  end
end

function UIChampionDuelTime:ComponentDestroy()
  self.text_time_tip = nil
  self.text_time_day = nil
  self.text_day = nil
  self.text_hour = nil
  self.text_min = nil
  self.text_sec = nil
end

function UIChampionDuelTime:SetAutoReq(bAuto)
  self.autoReq = bAuto
end

function UIChampionDuelTime:ReInit()
  self.retryTime = 0
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  self.endTime = actInfo ~= nil and actInfo.stageEndTime or 0
  self.sign = actInfo ~= nil and actInfo.sign or false
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  self.stageId = stageId
  local strKey = DataCenter.ChampionDuelManager:GetStageStrKey(stageId, true)
  local sTime, eTime = DataCenter.ChampionDuelManager:GetStageTime(stageId)
  local dayTime = 86400
  local maxDay = math.floor((eTime - sTime) / dayTime)
  local curDay = 1
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  while curSec > sTime + curDay * dayTime do
    curDay = curDay + 1
  end
  local dayStr = curDay .. "/" .. maxDay
  self.text_time_tip:SetLocalText(strKey, dayStr)
  self:UpdateDayShow(actInfo)
  self:Update1000MS()
end

function UIChampionDuelTime:UpdateDayShow(actInfo)
  if self.text_time_day == nil then
    return
  end
  local starTime = actInfo ~= nil and actInfo.stageBeginTime or 0
  local endTime = actInfo ~= nil and actInfo.stageEndTime or 0
  if 0 < starTime and 0 < endTime then
    local offSet = MyModf(UITimeManager:GetInstance():GetTimezoneOffset() / 1000)
    local dateStart = MyDate("!*t", starTime + offSet)
    local dateEnd = MyDate("!*t", endTime + offSet)
    local timeStr = MyStrFormat("%d.%02d--%d.%02d", dateStart.month, dateStart.day, dateEnd.month, dateEnd.day)
    self.text_time_day:SetText(timeStr)
    self.text_time_day:SetActive(true)
  else
    self.text_time_day:SetActive(false)
  end
end

function UIChampionDuelTime:Update1000MS()
  if self.endTime and self.endTime > 0 then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = self.endTime - curSec
    local commonFlag = remainTime < 0
    if not commonFlag then
      self:UpdateTimeShow(remainTime)
    end
    if self.autoReq and self.stageId ~= ChampionDuelState.FinalShow and self.retryTime < 60 and commonFlag then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if self.lastGetActInfoTime == nil or curTime - self.lastGetActInfoTime > 3000 then
        self.retryTime = self.retryTime + 1
        DataCenter.ChampionDuelManager:SendActInfo()
        self.lastGetActInfoTime = curTime
      end
    end
  end
end

function UIChampionDuelTime:UpdateTimeShow(secs)
  if self.text_day == nil or self.text_hour == nil or self.text_min == nil or self.text_sec == nil then
    return
  end
  local day = MyModf(secs / OneDayTime)
  self.text_day:SetText(MyStrFormat("%dd", day))
  local hour = MyModf(secs / 3600) % 24
  self.text_hour:SetText(MyStrFormat("%02d", hour))
  local minute = MyModf(secs / 60) % 60
  self.text_min:SetText(MyStrFormat("%02d", minute))
  local second = MyFloor(secs % 60)
  self.text_sec:SetText(MyStrFormat("%02d", second))
end

return UIChampionDuelTime
