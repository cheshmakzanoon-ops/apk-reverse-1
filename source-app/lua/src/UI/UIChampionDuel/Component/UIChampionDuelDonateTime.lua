local UIChampionDuelDonateTime = BaseClass("UIChampionDuelDonateTime", UIBaseContainer)
local base = UIBaseContainer
local MyModf = math.modf
local MyFloor = math.floor
local MyStrFormat = string.format
local MyDate = os.date
local text_time_tip_path = "TimeTipText"
local text_day_path = "TimeGroup/DiDay/DayText"
local text_hour_path = "TimeGroup/DiHour/HourText"
local text_min_path = "TimeGroup/DiMin/MinText"
local text_sec_path = "TimeGroup/DiSec/SecText"

function UIChampionDuelDonateTime:OnCreate()
  base.OnCreate(self)
  self.endTime = 0
  self.retryTime = 0
  self.showEndTime = 0
  self:ComponentDefine()
end

function UIChampionDuelDonateTime:OnDestroy()
  self.endTime = 0
  self.retryTime = 0
  self.showEndTime = 0
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelDonateTime:ComponentDefine()
  local go = self.transform:Find(text_time_tip_path)
  if go ~= nil then
    self.text_time_tip = self:AddComponent(UIText, text_time_tip_path)
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

function UIChampionDuelDonateTime:ComponentDestroy()
  self.text_time_tip = nil
  self.text_day = nil
  self.text_hour = nil
  self.text_min = nil
  self.text_sec = nil
end

function UIChampionDuelDonateTime:ReInit()
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  self.endTime = actInfo ~= nil and actInfo.stageEndTime or 0
  self.group = actInfo ~= nil and actInfo.group or 0
  self.sign = actInfo ~= nil and actInfo.sign or false
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  self.stageId = stageId
  local titleStageId = self.stageId
  if titleStageId == ChampionDuelState.SignInAnnouncement then
    titleStageId = ChampionDuelState.SignIn
  elseif titleStageId == ChampionDuelState.PreStageAnnouncement then
    titleStageId = ChampionDuelState.PreStage
  end
  local strKey = DataCenter.ChampionDuelManager:GetStageStrKey(titleStageId)
  self.text_time_tip:SetLocalText(strKey)
  local showEndTimeStageId = self.stageId
  if showEndTimeStageId == ChampionDuelState.SignIn then
    showEndTimeStageId = ChampionDuelState.SignInAnnouncement
  elseif showEndTimeStageId == ChampionDuelState.PreStage then
    showEndTimeStageId = ChampionDuelState.PreStageAnnouncement
  end
  local sTime, eTime = DataCenter.ChampionDuelManager:GetStageTime(showEndTimeStageId)
  self.showEndTime = eTime
  self:Update1000MS()
end

function UIChampionDuelDonateTime:Update1000MS()
  if self.endTime and self.endTime > 0 then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = self.endTime - curSec
    local commonFlag = remainTime < 0
    if not commonFlag then
      local showRemainTime = self.showEndTime - curSec
      self:UpdateTimeShow(showRemainTime)
    end
    local forceFlag = false
    if self.retryTime < 60 then
      forceFlag = self.stageId == ChampionDuelState.SignInAnnouncement and self.sign and self.group == 0
    end
    if forceFlag or commonFlag then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if self.lastGetActInfoTime == nil or curTime - self.lastGetActInfoTime > 3000 then
        if forceFlag then
          self.retryTime = self.retryTime + 1
        end
        DataCenter.ChampionDuelManager:SendActInfo()
        self.lastGetActInfoTime = curTime
      end
    end
  end
end

function UIChampionDuelDonateTime:UpdateTimeShow(secs)
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

return UIChampionDuelDonateTime
