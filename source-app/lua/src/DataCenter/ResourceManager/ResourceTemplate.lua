local ResourceTemplate = BaseClass("ResourceTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.description = ""
  self.icon = ""
  self.big_icon = ""
  self.out_building = {}
  self.protect_effect_number = ""
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.description = nil
  self.icon = nil
  self.big_icon = nil
  self.out_building = nil
  self.protect_effect_number = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.description = row:getValue("description")
  self.icon = row:getValue("icon")
  self.big_icon = row:getValue("big_icon")
  self.out_building = {}
  local ob = row:getValue("out_building")
  if type(ob) == "string" and ob ~= "" then
    for _, str in ipairs(string.split(ob, ";")) do
      table.insert(self.out_building, tonumber(str))
    end
  elseif type(ob) == "table" then
    self.out_building = ob
  end
  self.protect_effect_number = row:getValue("protect_effect_number")
end

ResourceTemplate.__init = __init
ResourceTemplate.__delete = __delete
ResourceTemplate.InitData = InitData
return ResourceTemplate
