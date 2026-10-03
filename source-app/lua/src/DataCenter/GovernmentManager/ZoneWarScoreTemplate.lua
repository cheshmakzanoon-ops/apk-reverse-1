local ZoneWarScoreTemplate = BaseClass("ZoneWarScoreTemplate")

function ZoneWarScoreTemplate:__init()
  self.id = 0
  self.name = ""
  self.type = 0
  self.type2 = 0
  self.score = nil
  self.icon = nil
end

function ZoneWarScoreTemplate:__delete()
end

function ZoneWarScoreTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id", 0)
  self.type = row:getIntValue("type", 0)
  self.type2 = row:getIntValue("type2", 0)
  self.score = row:getIntValue("score", 0)
  self.name = row:getValue("name")
  self.icon = row:getValue("icon")
  self.is_show = row:getIntValue("is_show", 0) == 1
  self.on_off = row:getIntValue("on_off", 1) == 1
end

return ZoneWarScoreTemplate
