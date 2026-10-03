local LWActivityAlarmClockTemplate = BaseClass("LWActivityAlarmClockTemplate")

function LWActivityAlarmClockTemplate:__init()
  self.id = 0
  self.title = ""
  self.active = 0
  self.type = 0
  self.para1 = 0
  self.top_timer = 0
  self.reminder = 0
  self.timer_dialog = ""
  self.icon = ""
  self.sub_icon = ""
  self.event_group = 0
  self.calendar_id = 0
end

function LWActivityAlarmClockTemplate:__delete()
  self.id = nil
  self.title = nil
  self.active = nil
  self.type = nil
  self.para1 = nil
  self.top_timer = nil
  self.reminder = nil
  self.timer_dialog = nil
  self.icon = nil
  self.sub_icon = nil
  self.event_group = nil
  self.calendar_id = nil
end

function LWActivityAlarmClockTemplate:Init(row)
  self.id = row:getValue("id") or 0
  self.title = row:getValue("title") or ""
  self.active = row:getValue("active") or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.para1 = row:getValue("para1") or 0
  self.top_timer = row:getIntValue("top_timer") or 0
  self.reminder = row:getIntValue("reminder") or 0
  self.timer_dialog = row:getValue("timer_dialog") or ""
  self.icon = row:getValue("icon") or ""
  self.sub_icon = row:getValue("sub_icon") or ""
  self.event_group = row:getValue("event_group") or 0
  self.calendar_id = tonumber(row:getValue("calendar_id")) or 0
end

return LWActivityAlarmClockTemplate
