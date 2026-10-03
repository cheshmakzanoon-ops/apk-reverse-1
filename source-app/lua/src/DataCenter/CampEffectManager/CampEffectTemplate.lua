local CampEffectTemplate = BaseClass("CampEffectTemplate")

local function __init(self)
  self.id = 0
end

local function __delete(self)
  self.id = nil
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.camp_type = tonumber(row:getValue("camp_type")) or 0
  self.camp_effect = {}
  local para = row:getValue("camp_effect")
  if not string.IsNullOrEmpty(para) then
    local strs = string.split(para, "|")
    for _, str in pairs(strs) do
      local pair = string.split(str, ";")
      self.camp_effect[tonumber(pair[1])] = tonumber(pair[2])
    end
  end
  self.icon = row:getValue("icon")
  self.des = row:getValue("des")
  self.effect_desc = row:getValue("effect_desc")
  self.effect_para = tonumber(row:getValue("effect_para")) or 0
end

CampEffectTemplate.__init = __init
CampEffectTemplate.__delete = __delete
CampEffectTemplate.InitConfig = InitConfig
return CampEffectTemplate
