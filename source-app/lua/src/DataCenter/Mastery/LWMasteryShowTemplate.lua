local LWMasteryShowTemplate = BaseClass("LWMasteryShowTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.name = 0
  self.description = 0
  self.mastery_pic = ""
  self.mastery_spine = ""
  self.mastery_img = ""
  self.icon = ""
  self.mastery_head_icon = ""
  self.link_skill = {}
  self.lock = true
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.name = row:getValue("name")
  self.description = row:getValue("description")
  self.mastery_pic = row:getValue("mastery_pic")
  self.mastery_spine = row:getValue("mastery_spine")
  self.mastery_img = row:getValue("mastery_img")
  self.icon = row:getValue("icon")
  self.mastery_head_icon = row:getValue("mastery_head_icon")
  self.mastery_head_icon_width = row:getValue("mastery_head_icon_width")
  self.mastery_head_icon_height = row:getValue("mastery_head_icon_height")
  local skillStr = row:getValue("link_skill")
  local skillList = string.split(skillStr, "|")
  for k, v in pairs(skillList) do
    local skillId = tonumber(v)
    table.insert(self.link_skill, skillId)
  end
  local lockStr = row:getValue("lock")
  self.lock = not string.IsNullOrEmpty(lockStr)
end

local function GetIconFullPath(self)
  return UIUtil.GetFullPath(LoadPath.LWMasterySpritePath, self.icon)
end

local function GetPicFullPath(self)
  return UIUtil.GetFullPath(LoadPath.LWMasteryTexturePath, self.mastery_pic)
end

LWMasteryShowTemplate.__init = __init
LWMasteryShowTemplate.InitData = InitData
LWMasteryShowTemplate.GetIconFullPath = GetIconFullPath
LWMasteryShowTemplate.GetPicFullPath = GetPicFullPath
return LWMasteryShowTemplate
