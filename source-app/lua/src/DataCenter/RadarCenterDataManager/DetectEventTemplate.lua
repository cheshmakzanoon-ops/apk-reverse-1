local DetectEventTemplate = BaseClass("DetectEventTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = ""
  self.name = ""
  self.nameValue = ""
  self.description = ""
  self.pic = ""
  self.icon = ""
  self.image = ""
  self.quality = 1
  self.recommend_power = 0
  self.soldiers = {}
  self.res = ""
  self.para = ""
  self.c_para = ""
  self.c_para2 = ""
  self.order = -1
  self.type2 = ""
  self.banner_image = ""
  self.banner_image_1 = ""
  self.appearance_id = 0
  self.plot_id = 0
  self.world_icon_height = 0
  self.para3 = ""
  self.show_reward = ""
  self.chat_share_text = ""
  self.banner_image_2 = ""
  self.share_para = 0
  self.bg_para = ""
  self.panel_image = ""
  self.monsterTypeList = nil
  self.icon_custom_path = ""
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.description = nil
  self.icon = nil
  self.image = nil
  self.nameValue = nil
  self.quality = nil
  self.type = nil
  self.recommend_power = nil
  self.soldiers = nil
  self.pic = nil
  self.res = nil
  self.order = nil
  self.type2 = nil
  self.banner_image = nil
  self.banner_image_1 = nil
  self.banner_image_custom = nil
  self.banner_image_1_custom = nil
  self.appearance_id = nil
  self.plot_id = nil
  self.world_icon_height = nil
  self.c_para2 = nil
  self.chatBubble = nil
  self.para = nil
  self.para3 = nil
  self.show_reward = nil
  self.chat_share_text = nil
  self.banner_image_2 = nil
  self.share_para = nil
  self.bg_para = nil
  self.panel_image = nil
  self.monsterTypeList = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tostring(row:getValue("id"))
  self.name = tostring(row:getValue("name"))
  self.nameValue = tostring(row:getValue("name_value"))
  self.description = tostring(row:getValue("description"))
  self.icon = tostring(row:getValue("icon"))
  self.icon_custom = tostring(row:getValue("icon_custom")) or ""
  self.image = tostring(row:getValue("image"))
  self.quality = row:getValue("quality")
  self.type = row:getValue("type")
  self.type2 = row:getValue("type2")
  local orderStr = row:getValue("order")
  self.chatBubble = row:getValue("chat_bubble") or ""
  self.chat_bubble_custom = row:getValue("chat_bubble_custom") or ""
  self.banner_image_2 = row:getValue("banner_image_2") or ""
  if not string.IsNullOrEmpty(orderStr) then
    self.order = toInt(orderStr)
  else
    self.order = -1
  end
  self.headIcon = row:getValue("para3") or ""
  self.para3 = row:getValue("para3") or ""
  self.pic = row:getValue("pic") or ""
  self.res = row:getValue("res")
  self.para = row:getValue("para") or ""
  if string.IsNullOrEmpty(self.para) then
    self.recommend_power = 0
  else
    self.recommend_power = tonumber(self.para)
  end
  self.c_para = row:getValue("c_para") or ""
  self.c_para2 = row:getValue("c_para2") or ""
  if self.type == DetectEventType.DetectEventTypeBoss and not string.IsNullOrEmpty(self.c_para2) then
    local split = string.split(self.c_para2, ";")
    self.monsterTypeList = {}
    for i, v in ipairs(split) do
      table.insert(self.monsterTypeList, tonumber(v))
    end
  end
  self.banner_image = tostring(row:getValue("banner_image"))
  self.banner_image_1 = tostring(row:getValue("banner_image_1"))
  self.banner_image_custom = row:getValue("banner_image_custom") or ""
  self.banner_image_1_custom = row:getValue("banner_image_1_custom") or ""
  self.appearance_id = row:getValue("appearance_id")
  if string.IsNullOrEmpty(self.appearance_id) then
    self.appearance_id = 0
  else
    self.appearance_id = toInt(self.appearance_id)
  end
  self.plot_id = row:getValue("plot_id")
  if string.IsNullOrEmpty(self.plot_id) then
    self.plot_id = 0
  else
    self.plot_id = toInt(self.plot_id)
  end
  self.world_icon_height = row:getValue("world_icon_height")
  if string.IsNullOrEmpty(self.world_icon_height) then
    self.world_icon_height = 0
  else
    self.world_icon_height = tonumber(self.world_icon_height)
  end
  self.para2 = row:getValue("para2") or ""
  self.show_reward = row:getValue("show_reward") or ""
  self.chat_share_text = row:getValue("chat_share_text") or ""
  self.share_para = tonumber(row:getValue("share_para")) or 0
  self.bg_para = row:getValue("bg_para") or ""
  self.panel_image = row:getValue("panel_image") or ""
end

local function GetRealName(self)
  if self.nameValue == nil or self.nameValue == "" then
    return Localization:GetString(self.name)
  else
    return Localization:GetString(self.name, self.nameValue)
  end
end

local function JudgeIsDroneTreasure(self)
  local id = tonumber(self.c_para2)
  return id == 1
end

function DetectEventTemplate:GetChatBubblePath()
  if not string.IsNullOrEmpty(self.chat_bubble_custom) then
    return self.chat_bubble_custom
  elseif not string.IsNullOrEmpty(self.chatBubble) then
    return "Assets/Main/Sprites/UI/UIMain/UIMainBubble/" .. self.chatBubble
  end
end

local function IsRollTreasure(self)
  return self.type == DetectEventType.CAVE_EXPLORATION and tonumber(self.para) == 400001
end

function DetectEventTemplate:GetDetectRetryTaskObjectPath()
  local path = ""
  local type = tonumber(self.type)
  local image = self.image
  if type == DetectEventType.COLLECT_TASK or type == DetectEventType.OFF_SEASON_COLLECT_TASK then
    path = "Assets/Main/Prefabs/CollectResource/" .. image .. ".prefab"
  elseif type == DetectEventType.AttackCityS0_City_Monster then
    path = "Assets/Main/Prefabs/Monsters/" .. image .. ".prefab"
  else
    path = "Assets/Main/Prefabs/Garbage/" .. image .. ".prefab"
  end
  return path
end

function DetectEventTemplate:GetDetectEventBannerImagePath()
  if not string.IsNullOrEmpty(self.banner_image_custom) then
    return self.banner_image_custom
  elseif not string.IsNullOrEmpty(self.banner_image) then
    return string.format(LoadPath.UIDetectTextureExPath, self.banner_image)
  end
  return ""
end

function DetectEventTemplate:GetDetectEventBannerImage1Path()
  if not string.IsNullOrEmpty(self.banner_image_1_custom) then
    return self.banner_image_1_custom
  elseif not string.IsNullOrEmpty(self.banner_image_1) then
    return string.format(LoadPath.UIDetectTextureExPath, self.banner_image_1)
  end
  return ""
end

DetectEventTemplate.__init = __init
DetectEventTemplate.__delete = __delete
DetectEventTemplate.InitData = InitData
DetectEventTemplate.GetRealName = GetRealName
DetectEventTemplate.JudgeIsDroneTreasure = JudgeIsDroneTreasure
DetectEventTemplate.IsRollTreasure = IsRollTreasure
return DetectEventTemplate
