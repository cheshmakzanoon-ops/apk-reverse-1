local StageFeatureBuildingTemplate = BaseClass("StageFeatureBuildingTemplate")

local function __init(self)
  self.id = ""
  self.caty = {}
  self.stages = {}
  self.limit_hero = {}
  self.winType = {}
  self.winNeedCount = {}
  self.image = ""
  self.icon = ""
  self.stage_icons = {}
  self.dissolve = ""
  self.victory = ""
  self.reward_show = ""
  self.title = ""
  self.simple_city_event = 0
  self.banner_pic = ""
  self.title_pic = ""
  self.tabPic = {}
  self.tabPicScale = {}
  self.tabBg = {}
end

local function __delete(self)
  self.id = ""
  self.caty = {}
  self.stages = {}
  self.limit_hero = {}
  self.winType = {}
  self.winNeedCount = {}
  self.image = ""
  self.icon = ""
  self.stage_icons = {}
  self.dissolve = ""
  self.victory = ""
  self.reward_show = ""
  self.title = ""
  self.simple_city_event = 0
  self.banner_pic = ""
  self.title_pic = ""
  self.tabPic = {}
  self.tabPicScale = {}
  self.tabBg = {}
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  local caty = row:getValue("caty") or ""
  self.caty = string.split(caty, ",")
  local stagesStr = row:getValue("stages") or ""
  if not string.IsNullOrEmpty(stagesStr) then
    local strList = string.split_ss_array(stagesStr, ",")
    for i, v in ipairs(strList) do
      self.stages[i] = tonumber(v)
    end
  end
  local limitHeroStr = row:getValue("limit_hero") or ""
  if not string.IsNullOrEmpty(limitHeroStr) then
    local strList = string.split_ss_array(limitHeroStr, ",")
    for i, v in ipairs(strList) do
      self.limit_hero[i] = tonumber(v)
    end
  end
  self.image = row:getValue("image") or ""
  self.icon = row:getValue("icon") or ""
  local iconsStr = row:getValue("stage_icons") or ""
  if not string.IsNullOrEmpty(iconsStr) then
    local strList = string.split_ss_array(iconsStr, ",")
    for i, v in ipairs(strList) do
      self.stage_icons[i] = v
    end
  end
  self.dissolve = row:getValue("dissolve") or ""
  self.victory = row:getValue("victory") or ""
  self.reward_show = row:getValue("reward_show") or ""
  self.title = row:getValue("title") or ""
  self.simple_city_event = row:getValue("simple_city_event") or 0
  self.banner_pic = row:getValue("banner_pic") or ""
  self.title_pic = row:getValue("title_pic") or ""
  local winStr = row:getValue("win_condition") or ""
  if not string.IsNullOrEmpty(winStr) then
    local strList = string.split_ss_array(winStr, ",")
    for i, v in ipairs(strList) do
      local winStrArr = string.split_ss_array(v, "|")
      table.insert(self.winType, tonumber(winStrArr[1]))
      table.insert(self.winNeedCount, tonumber(winStrArr[2]))
    end
  end
  local tabPicStr = row:getValue("tab_pic") or ""
  if not string.IsNullOrEmpty(tabPicStr) then
    local strList = string.split_ss_array(tabPicStr, ",")
    for i, v in ipairs(strList) do
      self.tabPic[i] = v
    end
  end
  local tabPicScaleStr = row:getValue("tab_pic_scale") or ""
  if not string.IsNullOrEmpty(tabPicScaleStr) then
    local strList = string.split_ss_array(tabPicScaleStr, ",")
    for i, v in ipairs(strList) do
      self.tabPicScale[i] = tonumber(v)
    end
  end
  local tabBgStr = row:getValue("tab_bg") or ""
  if not string.IsNullOrEmpty(tabBgStr) then
    local strList = string.split_ss_array(tabBgStr, ",")
    for i, v in ipairs(strList) do
      self.tabBg[i] = v
    end
  end
end

StageFeatureBuildingTemplate.__init = __init
StageFeatureBuildingTemplate.__delete = __delete
StageFeatureBuildingTemplate.InitData = InitData
return StageFeatureBuildingTemplate
