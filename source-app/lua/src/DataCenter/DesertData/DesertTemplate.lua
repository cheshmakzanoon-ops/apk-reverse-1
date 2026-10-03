local DesertTemplate = BaseClass("DesertTemplate")

function DesertTemplate:__init()
  self.id = 0
  self.level = 0
  self.name = ""
  self.icon = ""
  self.desert_type = 0
  self.desert_level = 0
  self.desert_name = ""
  self.force = 0
  self.level_up_id = 0
  self.desert_army = 0
end

function DesertTemplate:__delete()
  self.id = nil
  self.desert_type = nil
  self.desert_level = nil
  self.desert_army = nil
end

function DesertTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("desert_name")
  self.desert_name = self.name
  self.desert_type = row:getValue("desert_type")
  self.icon = row:getValue("icon")
  self.level = tonumber(row:getValue("desert_level"))
  self.desert_level = self.level
  self.force = row:getValue("force")
  self.level_up_id = toInt(row:getValue("level_up_id"))
  self.firstRewardStr = row:getValue("first_showreward")
  self.showRewardStr = row:getValue("showreward")
  self.desert_army = row:getValue("desert_army")
end

return DesertTemplate
