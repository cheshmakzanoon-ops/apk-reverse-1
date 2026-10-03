local BattlefieldTimeCtrlTemplate = BaseClass("BattlefieldTimeCtrlTemplate")

function BattlefieldTimeCtrlTemplate:__init()
  self.id = 0
  self.type = 0
  self.trigger_time = 0
  self.alert_time = 0
  self.icon = ""
  self.alert_tips = ""
  self.alert_finish_tips = ""
  self.para = ""
end

function BattlefieldTimeCtrlTemplate:__delete()
  self.id = 0
  self.type = 0
  self.trigger_time = 0
  self.alert_time = 0
  self.icon = ""
  self.alert_tips = ""
  self.alert_finish_tips = ""
  self.para = ""
end

function BattlefieldTimeCtrlTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.trigger_time = tonumber(row:getValue("trigger_time")) or 0
  self.alert_time = tonumber(row:getValue("alert_time")) or 0
  self.icon = row:getValue("icon") or ""
  self.alert_tips = row:getValue("alert_tips") or ""
  self.alert_finish_tips = row:getValue("alert_finish_tips") or ""
  self.para = row:getValue("para") or ""
end

return BattlefieldTimeCtrlTemplate
