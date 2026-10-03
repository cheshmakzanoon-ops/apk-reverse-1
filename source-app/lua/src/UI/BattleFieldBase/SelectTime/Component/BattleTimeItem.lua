local BattleTimeItem = BaseClass("BattleTimeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local time_path = "time"
local checkbox_path = "checkbox"
local last_path = "last"

function BattleTimeItem:OnCreate()
  base.OnCreate(self)
  self.txtTime = self:AddComponent(UIText, time_path)
  self.checkbox = self:AddComponent(UIToggle, checkbox_path)
  self.checkbox:SetOnValueChanged(function(tf)
    self.view:onSelectCell(tf, self.battlePeriod)
  end)
  self.last = self:AddComponent(UIBaseComponent, last_path)
end

function BattleTimeItem:OnDestroy()
  base.OnDestroy(self)
end

function BattleTimeItem:TimeStampToTimeForServer(timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("!*t", time)
  local format_time = string.format("%d-%d-%d %02d:%02d:%02d", format.year, format.month, format.day, format.hour, format.min, format.sec)
  return format_time
end

function BattleTimeItem:TimeStampToTimeForServerSimple(timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("!*t", time)
  local format_time = string.format("%02d:%02d:%02d", format.hour, format.min, format.sec)
  return format_time
end

function BattleTimeItem:TimeStampToTimeForLocal(timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("*t", time)
  local format_time = string.format("%d-%d-%d %02d:%02d:%02d", format.year, format.month, format.day, format.hour, format.min, format.sec)
  return format_time
end

function BattleTimeItem:TimeStampToTimeForLocalSimple(timeStamp)
  local time = math.modf(timeStamp / 1000)
  local format = os.date("*t", time)
  local format_time = string.format("%02d:%02d:%02d", format.hour, format.min, format.sec)
  return format_time
end

function BattleTimeItem:ReInit(data, showLocal)
  self.battlePeriod = data.battlePeriod
  self.data = data
  if showLocal then
    local startTimeLocalStr = self:TimeStampToTimeForLocal(data.startTime)
    local endTimeLocalStr = self:TimeStampToTimeForLocalSimple(data.endTime)
    self.txtTime:SetText(Localization:GetString("458280", " " .. startTimeLocalStr .. " ~ " .. endTimeLocalStr))
  else
    local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(data.startTime)
    local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(data.endTime, true)
    self.txtTime:SetText(Localization:GetString("800811") .. ": " .. startTimeStr .. " ~ " .. endTimeStr)
  end
end

return BattleTimeItem
