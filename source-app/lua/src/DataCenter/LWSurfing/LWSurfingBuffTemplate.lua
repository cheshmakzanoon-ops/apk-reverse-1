local LWSurfingBuffTemplate = BaseClass("LWSurfingBuffTemplate")
local Localization = CS.GameEntry.Localization

function LWSurfingBuffTemplate:__init()
  self.id = 0
  self.type = 0
  self.level = 0
  self.max_level = 0
  self.buff_id = 0
  self.buff_name = ""
  self.buff_desc = ""
  self.buff_icon = ""
  self.para1 = ""
  self.para2 = {}
  self.unlock_time = 0
  self.cost = 0
  self.cultivated = 0
end

function LWSurfingBuffTemplate:__delete()
  self.id = nil
  self.type = nil
  self.level = nil
  self.max_level = nil
  self.buff_id = nil
  self.buff_name = nil
  self.buff_desc = nil
  self.buff_icon = nil
  self.para1 = nil
  self.para2 = nil
  self.unlock_time = nil
  self.cost = nil
  self.cultivated = nil
end

function LWSurfingBuffTemplate:InitData(row)
  self.id = row:getValue("id") or 0
  self.type = row:getValue("type") or 0
  self.level = row:getValue("level") or 0
  self.max_level = row:getValue("max_level") or 0
  self.buff_id = row:getValue("buff_id") or 0
  self.buff_name = row:getValue("buff_name") or ""
  self.buff_desc = row:getValue("buff_desc") or ""
  self.buff_icon = row:getValue("buff_icon") or ""
  self.para1 = row:getValue("para1") or ""
  self.para2 = row:getValue("para2") or {}
  self.unlock_time = row:getValue("unlock_time") or 0
  self.cost = row:getValue("cost") or 0
  self.cultivated = row:getValue("cultivated") or 0
end

return LWSurfingBuffTemplate
