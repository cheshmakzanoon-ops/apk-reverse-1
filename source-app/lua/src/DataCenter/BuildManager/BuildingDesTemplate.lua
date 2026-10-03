local BuildingDesTemplate = BaseClass("BuildingDesTemplate")
local Localization = CS.GameEntry.Localization

function BuildingDesTemplate:__init()
  self.id = 0
  self.name = ""
  self.max_level = 1
  self.des = ""
  self.tab_type = 1
  self.preBuilds = {}
  self.gift_id = ""
  self.month_card = 0
  self.item = {}
  self.needResource = {}
  self.time = 0
  self.effect_Local_dialog = {}
  self.effect_Local_type = {}
  self.open_arms = ""
  self.build_type = BuildType.Normal
  self.main_sup_build_id = ""
  self.sup_main_build_id = 0
  self.building_inside = BuildInside.In
  self.unlockBuildInfo = {}
  self.order = 0
  self.needScience = {}
  self.red_dot = BuildRedDotType.No
  self.no_queue = BuildNoQueue.No
  self.long_description = ""
  self.para2 = ""
  self.para1 = ""
  self.para3 = ""
  self.para4 = ""
  self.scan = BuildScanAnim.No
  self.building_show = 0
  self.recommended_location = ""
  self.unlock_player_level = 0
  self.disrecommend = 0
  self.zone = ""
  self.zoneType = BuildZoneType.No
  self.zoneMainType = BuildZoneMainType.Sub
  self.is_stationed = ""
  self.guard = 0
  self.feature = {}
  self.need_pve = 0
  self.upgrade_notice = ""
  self.need_talent = ""
  self.need_boot = {}
  self.put = 0
  self.needResourceItem = {}
  self.need_quest = {}
  self.need_chapter = {}
  self.need_people = {}
  self.tileX = 1
  self.tileY = 1
  self.hero_slots = 0
  self.mono_condition = 0
  self.reward_show = ""
  self.display_order_gallery = 0
  self.direct_exchange = {}
  self.display_gallery_condition = {}
  self.glue_exchange_id = {}
  self.effect_condition = 0
  self.play_music_para = ""
  self.time_condition = nil
  self.detail_desc = ""
  self.helpBuildAniPath = nil
  self.season_preview_unlock = nil
end

function BuildingDesTemplate:__delete()
  self.id = 0
  self.name = ""
  self.max_level = 1
  self.des = ""
  self.tab_type = 1
  self.preBuilds = {}
  self.gift_id = ""
  self.month_card = 0
  self.item = {}
  self.needResource = {}
  self.time = 0
  self.effect_Local_dialog = {}
  self.effect_Local_type = {}
  self.open_arms = ""
  self.build_type = BuildType.Normal
  self.main_sup_build_id = ""
  self.sup_main_build_id = 0
  self.building_inside = BuildInside.In
  self.unlockBuildInfo = {}
  self.order = 0
  self.needScience = {}
  self.red_dot = BuildRedDotType.No
  self.no_queue = BuildNoQueue.No
  self.long_description = ""
  self.para2 = ""
  self.para1 = ""
  self.para3 = ""
  self.para4 = ""
  self.scan = BuildScanAnim.No
  self.building_show = 0
  self.recommended_location = ""
  self.unlock_player_level = 0
  self.disrecommend = 0
  self.zone = ""
  self.zoneType = BuildZoneType.No
  self.zoneMainType = BuildZoneMainType.Sub
  self.is_stationed = ""
  self.guard = 0
  self.feature = {}
  self.need_pve = 0
  self.upgrade_notice = ""
  self.need_talent = ""
  self.need_boot = {}
  self.put = 0
  self.needResourceItem = {}
  self.need_quest = {}
  self.need_chapter = {}
  self.need_people = {}
  self.tileX = 1
  self.tileY = 1
  self.mono_condition = 0
  self.reward_show = ""
  self.display_order_gallery = 0
  self.direct_exchange = {}
  self.display_gallery_condition = {}
  self.glue_exchange_id = {}
  self.effect_condition = nil
  self.play_music_para = ""
  self.time_condition = nil
  self.detail_desc = nil
  self.helpBuildAniPath = nil
  self.season_preview_unlock = nil
end

function BuildingDesTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.pic = row:getValue("pic")
  self.pic_full_path = row:getValue("pic_path")
  self.level = 1
  self.max_level = row:getValue("max_level")
  self.des = row:getValue("description")
  self.gift_id = row:getValue("gift_id")
  self.month_card = row:getValue("month_card") or 0
  self.tab_type = row:getValue("tab_type")
  self.order = row:getValue("order")
  self.need_talent = row:getValue("need_talent") or ""
  local resource = row:getValue("cost_consume")
  self.guard = row:getValue("guard")
  self.upgrade_notice = row:getValue("upgrade_notice") or ""
  self.clickAudio = row:getValue("click_sfx") or ""
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    table.walk(vec, function(k, v)
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.resourceType = vec1[1]
        need.count = vec1[2]
        if need.count > 0 then
          table.insert(self.needResource, need)
        end
      end
    end)
  end
  resource = row:getValue("building")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    table.walk(vec, function(k, v)
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.buildId = vec1[1]
        need.level = vec1[2]
        table.insert(self.preBuilds, need)
      end
    end)
  end
  self.open_arms = row:getValue("open_arms")
  resource = row:getValue("unlock_num")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split_ss_array(v, ";")
      if 2 <= #vec1 then
        local condition = {}
        condition.canBuildNun = tonumber(vec1[1])
        condition.needbuild = {}
        table.insert(self.unlockBuildInfo, condition)
        for k1, v1 in ipairs(vec1) do
          local vec2 = string.split_ss_array(v1, ":")
          for k2, v2 in ipairs(vec2) do
            local vec3 = string.split_ii_array(v2, ",")
            if 2 <= #vec3 then
              local need = {}
              need.buildId = vec3[1]
              need.level = vec3[2]
              table.insert(condition.needbuild, need)
            end
          end
        end
      end
    end
    table.sort(self.unlockBuildInfo, function(a, b)
      return a.canBuildNun < b.canBuildNun
    end)
  end
  self.item = {}
  local item = row:getValue("item")
  if item ~= nil and item ~= "" then
    local vec = string.split_ss_array(item, "|")
    table.walk(vec, function(k, v)
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.itemId = vec1[1]
        need.num = vec1[2]
        if need.num > 0 then
          table.insert(self.item, need)
        end
      end
    end)
  end
  self.time = row:getValue("time")
  self.build_type = row:getValue("build_type")
  self.main_sup_build_id = row:getValue("main_sup_build_id")
  self.sup_main_build_id = row:getValue("sup_main_build_id")
  self.building_inside = row:getValue("building_inside")
  resource = row:getValue("effect_local")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, ";")
    table.walk(vec, function(k, v)
      local vec1 = string.split_ss_array(v, ",")
      if 2 <= #vec1 then
        table.insert(self.effect_Local_dialog, vec1[1])
        table.insert(self.effect_Local_type, tonumber(vec1[2]))
      end
    end)
  end
  local red_dot = row:getValue("red_dot")
  if red_dot ~= nil and red_dot ~= "" then
    self.red_dot = tonumber(red_dot)
  end
  self.no_queue = row:getValue("no_queue")
  self.long_description = row:getValue("long_description")
  self.para2 = row:getValue("para2")
  self.para1 = row:getValue("para1")
  self.para3 = row:getValue("para3")
  self.para4 = row:getValue("para4")
  resource = row:getValue("need_science")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, ";")
    table.walk(vec, function(k, v)
      local need = {}
      local num = tonumber(v)
      need.scienceId = CommonUtil.GetScienceBaseType(num)
      need.level = CommonUtil.GetScienceLv(num)
      table.insert(self.needScience, need)
    end)
  end
  self.scan = row:getValue("scan")
  self.building_show = row:getValue("building_show")
  self.recommended_location = row:getValue("recommended_location")
  self.unlock_player_level = row:getValue("unlock_player_level") or 0
  self.disrecommend = tonumber(row:getValue("disrecommend")) or 0
  self.zone = row:getValue("zone")
  if self.zone ~= nil and self.zone ~= "" then
    local vec = string.split_ii_array(self.zone, ";")
    if table.count(vec) > 1 then
      self.zoneType = vec[1]
      self.zoneMainType = vec[2]
    end
  end
  self.is_stationed = row:getValue("is_stationed")
  resource = row:getValue("feature")
  if resource ~= nil and resource ~= "" then
    self.feature = string.split_ii_array(resource, ";")
  end
  self.need_pve = row:getValue("need_pve") or 0
  resource = row:getValue("need_boot")
  if resource ~= nil and resource ~= "" then
    self.need_boot = {}
    local vec = string.split_ss_array(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local condition = {}
        condition.canBuildNun = vec1[1]
        condition.needGuideId = vec1[2]
        table.insert(self.need_boot, condition)
      end
    end
  end
  self.put = tonumber(row:getValue("put")) or 0
  resource = row:getValue("cost_resource")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.itemId = vec1[1]
        need.count = vec1[2]
        if 0 < need.count then
          table.insert(self.needResourceItem, need)
        end
      end
    end
  end
  self.need_quest = {}
  resource = row:getValue("need_quest")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split_ss_array(v, ";")
      if 2 <= #vec1 then
        local condition = {}
        condition.canBuildNun = tonumber(vec1[1])
        condition.needQuestId = vec1[2]
        table.insert(self.need_quest, condition)
      end
    end
  end
  self.need_chapter = {}
  resource = row:getValue("need_chapter")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local condition = {}
        condition.canBuildNun = vec1[1]
        condition.needChapterId = vec1[2]
        table.insert(self.need_chapter, condition)
      end
    end
  end
  self.need_people = {}
  resource = row:getValue("people")
  if resource ~= nil and resource ~= "" then
    local vec1 = string.split_ii_array(resource, ";")
    for k, v in ipairs(vec1) do
      local condition = {}
      condition.canBuildNun = k
      condition.needPeople = v
      table.insert(self.need_people, condition)
    end
  end
  self.ban_move = row:getValue("ban_move")
  resource = row:getValue("tiles_2")
  if resource ~= nil and resource ~= "" then
    local vec1 = string.split_ii_array(resource, ";")
    if 2 <= #vec1 then
      self.tileX = vec1[1]
      self.tileY = vec1[2]
    end
  end
  self.mono_condition = tonumber(row:getValue("mono_condition")) or 0
  self.reward_show = row:getValue("reward_show")
  self.hero_slots = tonumber(row:getValue("hero_slots")) or 0
  self.display_order_gallery = tonumber(row:getValue("display_order_gallery")) or 0
  local rechargeIdList = row:getValue("direct_exchange")
  if not string.IsNullOrEmpty(rechargeIdList) and rechargeIdList ~= "0" then
    self.direct_exchange = string.split_ii_array(rechargeIdList, ";")
  end
  local condition = row:getValue("display_gallery_condition")
  if not string.IsNullOrEmpty(condition) then
    local singleCondition = string.split(condition, "|")
    if singleCondition then
      for k, v in pairs(singleCondition) do
        local conditionStr = string.split(v, ";")
        table.insert(self.display_gallery_condition, conditionStr)
      end
    end
  end
  self.finish_quest = row:getValue("finish_quest")
  self.quest_condition = row:getValue("quest_condition")
  self.upgrade_type = row:getValue("upgrade_type")
  self.season_score = row:getValue("season_score")
  self.season_mastery = row:getValue("season_mastery")
  self.season_group = row:getValue("season_group")
  self.default_army = row:getValue("default_army")
  self.effect_condition = toInt(row:getValue("effect_condition"))
  local effect_number_condition = row:getValue("effect_number_condition")
  if not string.IsNullOrEmpty(effect_number_condition) then
    local KeyStr, ValueStr = string.match(effect_number_condition, "(.*)[;,](.*)")
    if KeyStr ~= nil and ValueStr ~= nil then
      self.effectCondition = {
        effectId = tonumber(KeyStr),
        effectValue = tonumber(ValueStr)
      }
    end
  end
  local glue_exchange_id = row:getValue("glue_exchange_id")
  if glue_exchange_id ~= nil and glue_exchange_id ~= "" then
    local vec = string.split_ii_array(glue_exchange_id, ";")
    if table.count(vec) > 2 then
      self.glue_exchange_id = vec
    end
  end
  self.play_music_para = tonumber(row:getValue("play_music_para")) or 0
  local time_condition = row:getValue("time_condition")
  if not string.IsNullOrEmpty(time_condition) then
    local spl = string.split(time_condition, ";")
    if table.count(spl) == 2 then
      self.time_condition = {
        tonumber(spl[1]),
        tonumber(spl[2])
      }
    end
  end
  local season_preview_unlock = row:getValue("season_preview_unlock")
  if not string.IsNullOrEmpty(season_preview_unlock) then
    local spl = string.split(season_preview_unlock, ",")
    if table.count(spl) == 2 then
      self.season_preview_unlock = {
        tonumber(spl[1]),
        tonumber(spl[2])
      }
    end
  end
  self.detail_desc = row:getValue("detail_desc")
  self.building_prerequisites = row:getValue("building_prerequisites")
  self.helpBuildAniPath = row:getValue("help_build_ani_path")
end

function BuildingDesTemplate:GetNeedResource()
  return self.needResource
end

function BuildingDesTemplate:GetPreBuild()
  return self.preBuilds
end

function BuildingDesTemplate:GetNeedScience()
  return self.needScience
end

function BuildingDesTemplate:GetNeedItem()
  return self.item
end

function BuildingDesTemplate:GetMaxCanBuildNum()
  local result = 0
  local count = table.count(self.unlockBuildInfo)
  if 0 < count then
    result = self.unlockBuildInfo[count].canBuildNun
  end
  return result
end

function BuildingDesTemplate:GetCurMaxCanBuildNum()
  local result = 0
  for k, v in ipairs(self.unlockBuildInfo) do
    local own = true
    local needBuild = v.needbuild
    for k1, v1 in ipairs(needBuild) do
      if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1.buildId, v1.level) then
        own = false
      end
    end
    if own then
      result = v.canBuildNun
    else
      return result
    end
  end
  return result
end

function BuildingDesTemplate:GetCurNoBuildUnlockBuildInfo()
  for k, v in ipairs(self.unlockBuildInfo) do
    for k1, v1 in pairs(v.needbuild) do
      if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1.buildId, v1.level) then
        local result = {}
        result.buildId = v1.buildId
        result.level = v1.level
        result.canBuildNun = v.canBuildNun
        return result
      end
    end
  end
  return nil
end

function BuildingDesTemplate:GetOutResourceMaxColorPercent()
  if self.para2 ~= nil and self.para2 ~= "" then
    local num = tonumber(self.para2)
    if 100 < num then
      num = 100
    end
    return num / 100
  end
  return 1
end

function BuildingDesTemplate:GetBuildIconOutCity()
  if self.id == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or self.id == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or self.id == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or self.id == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4 then
    return "Assets/Main/SeasonRes/S4/Textures/PowerHouse/ljq_S4_fadianji.png"
  end
  if string.IsNullOrEmpty(self.pic_full_path) then
    if string.IsNullOrEmpty(self.pic) then
      return DefaultImage
    end
    return string.format(LoadPath.BuildIconOutCity, self.pic)
  end
  return self.pic_full_path
end

function BuildingDesTemplate:GetBuildTime()
  if self.id == BuildingTypes.FUN_BUILD_ROAD then
    return self.time * 1000
  end
  local effectAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_SPEED_ADD)
  return math.floor(self.time * 1000 / (1 + effectAdd / 100))
end

function BuildingDesTemplate:GetReCommendPosition()
  local result = {}
  if self.recommended_location ~= nil and self.recommended_location ~= "" then
    local temp = string.split_ss_array(self.recommended_location, "|")
    for k, v in ipairs(temp) do
      local spl = string.split_ii_array(v, ",")
      if 1 < #spl then
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
        vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
        table.insert(result, SceneUtils.TilePosToIndex(vec))
      end
    end
  end
  return result
end

function BuildingDesTemplate:GetShowLevel(level)
  local result = -1
  local count = #self.feature
  if 0 < count then
    for i = count, 1, -1 do
      local lv = self.feature[i]
      if level > lv then
        result = level - lv
        break
      end
    end
  end
  if result < 0 then
    result = level
  end
  return result
end

function BuildingDesTemplate:GetLevelRange(level)
  local max = self.max_level
  local min = 1
  local count = #self.feature
  if 0 < count then
    for i = count, 1, -1 do
      local lv = self.feature[i]
      if level > lv then
        min = lv + 1
        break
      else
        max = lv
      end
    end
  end
  return min, max
end

function BuildingDesTemplate:GetGuideCanBuildMaxNum()
  local result = 999
  if LuaEntry.DataConfig:CheckSwitch("building_boot_switch") and table.count(self.need_boot) > 0 then
    for k, v in ipairs(self.need_boot) do
      if not DataCenter.GuideManager:IsDoneThisGuide(v.needGuideId) then
        return v.canBuildNun - 1
      else
        result = v.canBuildNun
      end
    end
  end
  return result
end

function BuildingDesTemplate:GetNeedResourceItem()
  return self.needResourceItem
end

function BuildingDesTemplate:GetQuestCanBuildMaxNum()
  local result = 999
  if table.count(self.need_quest) > 0 then
    for k, v in ipairs(self.need_quest) do
      if not DataCenter.TaskManager:IsFinishTask(v.needQuestId) then
        return v.canBuildNun - 1
      else
        result = v.canBuildNun
      end
    end
  end
  return result
end

function BuildingDesTemplate:GetChapterCanBuildMaxNum()
  local result = 999
  if table.count(self.need_chapter) > 0 and DataCenter.ChapterTaskManager:IsCompleteAllChapter() == false then
    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    for k, v in ipairs(self.need_chapter) do
      if chapterId < v.needChapterId then
        return v.canBuildNun - 1
      else
        result = v.canBuildNun
      end
    end
  end
  return result
end

function BuildingDesTemplate:GetNeedPeopleNumByBuildNum(buildNum)
  if self.need_people[buildNum] ~= nil then
    return self.need_people[buildNum].needPeople
  end
  return 0
end

function BuildingDesTemplate:GetNeedPeopleNum()
  local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(self.id)
  return self:GetNeedPeopleNumByBuildNum(buildNum + 1)
end

function BuildingDesTemplate:CanMove()
  if self.ban_move == BuildBanMoveType.No then
    return false
  end
  return true
end

function BuildingDesTemplate:IsSeasonBuild()
  return self.tab_type == UIBuildListTabType.SeasonBuild
end

function BuildingDesTemplate:IsTimeConditionValid()
  if not self.time_condition then
    return true
  end
  local seasonNum = SeasonUtil.GetSeason()
  if seasonNum > self.time_condition[1] then
    return true
  elseif seasonNum < self.time_condition[1] then
    return false
  end
  return self.time_condition[2] <= SeasonUtil.GetSeasonDayByOpenServerZero()
end

function BuildingDesTemplate:IsTimePreConditionValid()
  if not self.season_preview_unlock then
    return true
  end
  local curSeason = SeasonUtil.GetSeason()
  local configSeason = self.season_preview_unlock[1]
  if curSeason >= configSeason then
    return true
  elseif curSeason + 1 == configSeason then
    if SeasonUtil.IsInSeasonPrepareMode(true) then
      return SeasonUtil.GetSeasonPrepareDay() >= self.season_preview_unlock[2]
    end
    return false
  else
    return false
  end
end

function BuildingDesTemplate:IsPreBuildConditionValid()
  if string.IsNullOrEmpty(self.building_prerequisites) then
    local thePreBuilds = self:GetPreBuild()
    if thePreBuilds then
      for k, v in ipairs(thePreBuilds) do
        if not DataCenter.BuildManager:IsExistBuildByTypeLv(v.buildId, v.level) then
          return false
        end
      end
    end
    return true
  end
  local data_list = string.split(self.building_prerequisites, "|")
  for k, v in ipairs(data_list) do
    local tmp = string.split_ii_array(v, ";")
    if 2 <= #tmp and DataCenter.BuildManager:IsExistBuildByTypeLv(tmp[1], tmp[2]) then
      return true
    end
  end
  return false
end

function BuildingDesTemplate:CheckQuestConditionStatus(buildData, openSelfUI, openPrevUI, delayTime, showTip)
  local taskStatus, taskId = self:GetQuestConditionStatus(buildData)
  if taskStatus == TaskState.NotStart then
    local need_build, exist_build
    local thePreBuilds = self:GetPreBuild()
    if table.count(thePreBuilds) > 0 then
      for k, v in ipairs(thePreBuilds) do
        if not DataCenter.BuildManager:IsExistBuildByTypeLv(v.buildId, v.level) then
          local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(v.buildId)
          if dataList then
            for k1, v1 in pairs(dataList) do
              if v.level > v1.level then
                exist_build = v1
                need_build = v
                break
              end
            end
          end
        end
      end
    end
    if exist_build == nil or need_build == nil then
      local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskId)
      if questTemplate ~= nil then
        local buildId = toInt(questTemplate.accept2)
        local need_level = buildId % 1000
        need_build = {
          buildId = buildId - need_level,
          level = need_level
        }
        if not DataCenter.BuildManager:IsExistBuildByTypeLv(need_build.buildId, need_level) then
          local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(need_build.buildId)
          if dataList then
            for k, v in pairs(dataList) do
              if need_level > v.level then
                exist_build = v
                break
              end
            end
          end
        end
      end
    end
    if exist_build ~= nil and need_build ~= nil then
      if openSelfUI then
        local worldPointPos = buildData:GetCenterVec()
        local pointId = tostring(buildData:GetCenterIndex())
        GoToUtil.CloseAllWindows()
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, pointId, true)
        end, (delayTime or 0.2) + 0.05)
      elseif openPrevUI then
        local worldPointPos = exist_build:GetCenterVec()
        local pointId = tostring(exist_build:GetCenterIndex())
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(need_build.buildId)
        if buildTemplate ~= nil and showTip then
          local buildName = Localization:GetString(buildTemplate.name)
          UIUtil.ShowTips(Localization:GetString("s1_buid_tips01", buildName, need_build.level))
        end
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, delayTime or 0.2)
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, pointId, true)
        end, (delayTime or 0.2) + 0.05)
      end
      return true
    end
  end
  return false
end

function BuildingDesTemplate:GetQuestConditionStatus(buildData)
  if string.IsNullOrEmpty(self.quest_condition) then
    return TaskState.NotExist
  end
  local taskId = tostring(self.quest_condition)
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
  if taskInfo ~= nil then
    return taskInfo.state, taskId
  end
  if buildData ~= nil and buildData.completeTask ~= nil then
    local task_id_vec = string.split_ss_array(buildData.completeTask or "", ",")
    for _, _taskId in ipairs(task_id_vec) do
      if _taskId == taskId then
        return TaskState.Received, taskId
      end
    end
  end
  return TaskState.NotStart, taskId
end

return BuildingDesTemplate
