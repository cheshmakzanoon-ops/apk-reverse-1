local HeroTemplate = BaseClass("HeroTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.is_human = false
  self.hero_effect = 0
  self.angular_speed = 0
  self.type = 0
  self.appearance = 0
  self.team_location = 0
  self.speed_battle = 0
  self.quality = 0
  self.name = ""
  self.nickName = ""
  self.propertyTemplateType = 0
  self.hpFactor = 0
  self.atkFactor = 0
  self.defFactor = 0
  self.accFactor = 0
  self.critFactor = 0
  self.skills = {}
  self.fragId = 0
  self.equip_Img_Path = ""
  self.maxRank = 0
  self.showInHeroList = true
  self.showDays = 0
  self.sound_show = ""
  self.sound_show_delay = 0
  self.sound_talk = ""
  self.hero_promotion_peace_num = ""
  self.unique_weapon_open = {}
  self.backstory_image = ""
  self.backstory_desc = ""
  self.equip_recommend_group = 0
  self.desc = ""
  self.equip_recommend_season = ""
  self.equip_recommend_season_data = nil
  self.bigName = ""
end

local function __delete(self)
  self.id = nil
  self.is_human = nil
  self.hero_effect = nil
  self.angular_speed = nil
  self.type = nil
  self.appearance = nil
  self.team_location = nil
  self.speed_battle = nil
  self.quality = nil
  self.name = nil
  self.propertyTemplateType = nil
  self.hpFactor = nil
  self.atkFactor = nil
  self.defFactor = nil
  self.accFactor = nil
  self.critFactor = nil
  self.skills = nil
  self.skills_unlock_lv = nil
  self.fragId = nil
  self.equip_Img_Path = nil
  self.showDays = nil
  self.max_honorLevel = nil
  self.honor_level_effects = nil
  self.skills_unlock_rank = nil
  self.sound_show = nil
  self.sound_show_delay = nil
  self.sound_talk = nil
  self.hero_promotion_peace_num = nil
  self.unique_weapon_open = nil
  self.backstory_image = nil
  self.backstory_desc = nil
  self.equip_recommend_group = nil
  self.desc = nil
  self.equip_recommend_season = nil
  self.equip_recommend_season_data = nil
  self.bigName = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.is_front = tonumber(row:getValue("is_front")) or 0
  self.is_human = tonumber(row:getValue("is_human")) == 1
  self.hero_effect = tonumber(row:getValue("hero_effect"))
  self.angular_speed = tonumber(row:getValue("angular_speed")) or 4
  self.type = tonumber(row:getValue("army_type")) or 0
  self.appearance = tonumber(row:getValue("appearance")) or 0
  self.team_location = tonumber(row:getValue("team_location")) or 0
  self.speed_battle = tonumber(row:getValue("speed_battle")) or 0
  self.speed_control = tonumber(row:getValue("speed_control")) or 0
  self.quality = tonumber(row:getValue("quality")) or 0
  self.name = row:getValue("first_name") or ""
  self.bigName = row:getValue("last_name") or ""
  self.nickName = row:getValue("title_name") or ""
  self.propertyTemplateType = tonumber(row:getValue("template_id")) or 0
  self.hpFactor = tonumber(row:getValue("base_hp")) or 0
  self.atkFactor = tonumber(row:getValue("base_patk")) or 0
  self.defFactor = tonumber(row:getValue("base_pdef")) or 0
  self.accFactor = tonumber(row:getValue("base_acc")) or 0
  self.critFactor = tonumber(row:getValue("base_crit")) or 0
  self.skills = row:getValue("skills") or {}
  self.skills_unlock_lv = row:getValue("skills_unlock_lv") or {}
  local heroPieces = row:getValue("hero_pieces")
  self.fragId = tonumber(heroPieces[1]) or 0
  self.showDays = row:getValue("show_days") or 0
  self.hero_promotion_peace_num = row:getValue("hero_promotion_peace_num") or nil
  if 0 < self.hpFactor then
    self.hpFactor = self.hpFactor / 10000
  end
  if 0 < self.atkFactor then
    self.atkFactor = self.atkFactor / 10000
  end
  if 0 < self.defFactor then
    self.defFactor = self.defFactor / 10000
  end
  if 0 < self.accFactor then
    self.accFactor = self.accFactor / 10000
  end
  if 0 < self.critFactor then
    self.critFactor = self.critFactor / 10000
  end
  self.equip_Img_Path = row:getValue("equipt_path") or ""
  self.maxRank = tonumber(row:getValue("max_rank")) or 0
  local display_in_hero_list = tonumber(row:getValue("display_in_hero_list")) or 0
  self.showInHeroList = display_in_hero_list == 1
  self.job = tonumber(row:getValue("army_job")) or 1
  self.max_honorLevel = tonumber(row:getValue("max_honorLevel")) or 0
  self.unlockEffectHonorLevel = row:getValue("honor_level_unlock_effect")
  self.honorLevelEffects = row:getValue("honor_level_effect")
  self.skills_unlock_rank = row:getValue("skills_unlock_rank") or {}
  self.sound_show = row:getValue("sound_show")
  self.sound_show_delay = tonumber(row:getValue("sound_show_delay")) or 0
  self.sound_show_delay = self.sound_show_delay / 1000
  self.sound_talk = StringPool.New(row:getValue("sound_talk"), ";")
  self.unique_weapon_open = row:getValue("unique_weapon_open") or {}
  self.backstory_image = row:getValue("backstory_image")
  self.backstory_desc = row:getValue("backstory_desc")
  self.backstory_show_condition_str = row:getValue("backstory_show_condition")
  self.equip_recommend_group = row:getValue("equip_recommend_group") or 0
  self.equip_recommend_season = row:getValue("equip_recommend_season")
  self.desc = row:getValue("desc")
  self.heroData_type = tonumber(row:getValue("type")) or 0
  self.parkourType = row:getValue("parkour_type") or 0
end

local function IsUnqueWeaponShow(self)
  if not self then
    return
  end
  if table.IsNullOrEmpty(self.unique_weapon_open) then
    return false
  end
  local openSeason = self.unique_weapon_open[1]
  local openDay = self.unique_weapon_open[2]
  if -1 < openSeason then
    local seasonId = SeasonUtil.GetSeason()
    if openSeason > seasonId then
      return false
    elseif openSeason < seasonId then
      return true
    end
  end
  if -1 < openDay then
    local serverOpenTime = DataCenter.SeasonDataManager:GetSeasonStartTime() or 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local serverDays = math.ceil((curTime - serverOpenTime) / 86400000)
    if openDay > serverDays then
      return false
    end
  end
  return true
end

local function GetUniqueWeaponMaxLv(self)
  if table.IsNullOrEmpty(self.unique_weapon_open) then
    return 0
  end
  return self.unique_weapon_open[3] or 0
end

local function CheckTemplateBackStoryCanShow(self)
  if self.backstory_show_condition == nil then
    return true
  end
  local conditionFlag = true
  for k, v in pairs(self.backstory_show_condition) do
    if v[1] == HeroBackStoryShowConditionType.GameSeason then
      local curSeason = DataCenter.SeasonDataManager:GetSeason() or 0
      if curSeason < tonumber(v[2]) then
        conditionFlag = false
        break
      end
    end
  end
  return conditionFlag
end

local function GetDescription(self)
  if not string.IsNullOrEmpty(self.desc) then
    return Localization:GetString(self.desc)
  end
  return ""
end

local function GetEquipRecommendGroup(self)
  if not string.IsNullOrEmpty(self.equip_recommend_season) then
    if self.equip_recommend_season_data == nil then
      self.equip_recommend_season_data = {}
      local array1 = string.split(self.equip_recommend_season, "|")
      local tmpList = {}
      for i = 1, #array1 do
        local array2 = string.split(array1[i], ";")
        if #array2 == 3 then
          local data = {
            startSeason = tonumber(array2[1]) or 0,
            startSeasonDay = tonumber(array2[2]) or 0,
            recommendGroup = tonumber(array2[3]) or 0
          }
          table.insert(tmpList, data)
        end
      end
      local count = #tmpList
      for i = count, 1, -1 do
        table.insert(self.equip_recommend_season_data, tmpList[i])
      end
    end
    for i, v in ipairs(self.equip_recommend_season_data) do
      local isSeasonCheckOk = DataCenter.SeasonDataManager:CheckNowSeasonArrive(v.startSeason, v.startSeasonDay)
      if isSeasonCheckOk then
        return v.recommendGroup
      end
    end
  end
  return self.equip_recommend_group
end

function HeroTemplate.getters:honor_level_effects()
  if self._honor_level_effects == nil then
    self._honor_level_effects = {}
    for i = 1, table.count(self.unlockEffectHonorLevel) do
      local unlockLevel = tonumber(self.unlockEffectHonorLevel[i])
      self._honor_level_effects[unlockLevel] = {}
      if not table.IsNullOrEmpty(self.honorLevelEffects) then
        for key, value in pairs(self.honorLevelEffects) do
          self._honor_level_effects[unlockLevel][key] = tonumber(value)
        end
      end
    end
  end
  return self._honor_level_effects
end

function HeroTemplate.getters:backstory_show_condition()
  if self._backstory_show_condition == nil then
    self._backstory_show_condition = {}
    if not string.IsNullOrEmpty(self.backstory_show_condition_str) then
      local showConditionStr1 = string.split(self.backstory_show_condition_str, "|")
      if not table.IsNullOrEmpty(showConditionStr1) then
        for k, v in pairs(showConditionStr1) do
          local condition = string.split(v, ";")
          if table.count(condition) == 2 then
            table.insert(self._backstory_show_condition, {
              tonumber(condition[1]),
              tostring(condition[2])
            })
          end
        end
      end
    end
  end
  return self._backstory_show_condition
end

HeroTemplate.__init = __init
HeroTemplate.__delete = __delete
HeroTemplate.InitData = InitData
HeroTemplate.IsUnqueWeaponShow = IsUnqueWeaponShow
HeroTemplate.GetUniqueWeaponMaxLv = GetUniqueWeaponMaxLv
HeroTemplate.CheckTemplateBackStoryCanShow = CheckTemplateBackStoryCanShow
HeroTemplate.GetDescription = GetDescription
HeroTemplate.GetEquipRecommendGroup = GetEquipRecommendGroup
return HeroTemplate
