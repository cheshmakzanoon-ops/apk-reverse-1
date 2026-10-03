local ActivityOverviewTemplate = BaseClass("ActivityOverviewTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.unlockLv = 0
  self.activityName = ""
  self.activityIcon = ""
  self.rewards = {}
  self.order = 0
  self.unlock_image = ""
  self.invisibleWeekdays = {}
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.unlockLv = nil
  self.activityName = nil
  self.activityIcon = nil
  self.rewards = nil
  self.order = nil
  self.unlock_image = nil
  self.invisibleWeekdays = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id"))
  self.type = tonumber(row:getValue("type"))
  self.unlockLv = tonumber(row:getValue("unlock"))
  self.activityName = row:getValue("name")
  self.activityIcon = row:getValue("image") or ""
  local strRewards = row:getValue("reward_show") or ""
  self.rewards = string.split(strRewards, ";")
  self.order = tonumber(row:getValue("order"))
  local strDays = row:getValue("day_invisible") or ""
  self.unlock_image = row:getValue("unlock_image")
  local arrDays = string.split(strDays, ";")
  self.invisibleWeekdays = {}
  for i, v in ipairs(arrDays) do
    if not string.IsNullOrEmpty(v) then
      table.insert(self.invisibleWeekdays, tonumber(v))
    end
  end
end

local function CheckIfTodayOpen(self)
  local nowT = UITimeManager:GetInstance():GetServerTime()
  local nowWeekday = UITimeManager:GetInstance():GetWeekdayIndex(nowT)
  if table.hasvalue(self.invisibleWeekdays, nowWeekday) then
    return false
  else
    return true
  end
end

ActivityOverviewTemplate.__init = __init
ActivityOverviewTemplate.__delete = __delete
ActivityOverviewTemplate.InitData = InitData
ActivityOverviewTemplate.CheckIfTodayOpen = CheckIfTodayOpen
return ActivityOverviewTemplate
