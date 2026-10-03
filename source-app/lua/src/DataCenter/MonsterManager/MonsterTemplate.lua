local MonsterTemplate = BaseClass("MonsterTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.desc = ""
  self.level = 0
  self.size = 0
  self.boss = 0
  self.is_stop = 0
  self.model_name = ""
  self.exp = 0
  self.first_reward_show = {}
  self.show_reward = {}
  self.possible_reward = {}
  self.effect_show_reward = {}
  self.recommend_power = 0
  self.pic = ""
  self.needArmy = {level = 0, count = 0}
  self.needHero = {level = 0, count = 0}
  self.limit = 0
  self.power_tip = 0
  self.enter_limit = false
  self.type = 0
  self.processed_show_reward = {}
  self.daily_first_reward_show = ""
  self.restricted_reward_show = ""
  self.attacked_plot = ""
  self.recommendType = 0
  self.first_reward_type = 0
  self.first_reward_condition = nil
  self.time_limit_4_season = 0
  self.time_limit_4_passDay = 0
  self.armor_chest = ""
  self.blood_chest = ""
  self.kill_world_treasure = ""
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.desc = nil
  self.level = nil
  self.size = nil
  self.boss = nil
  self.is_stop = nil
  self.model_name = nil
  self.exp = nil
  self.first_reward_show = nil
  self.show_reward = nil
  self.possible_reward = nil
  self.effect_show_reward = nil
  self.recommend_power = nil
  self.pic = nil
  self.needArmy = nil
  self.needHero = nil
  self.limit = nil
  self.power_tip = nil
  self.enter_limit = nil
  self.type = nil
  self.processed_show_reward = nil
  self.daily_first_reward_show = nil
  self.restricted_reward_show = nil
  self.attacked_plot = nil
  self.first_reward_type = nil
  self.first_reward_condition = nil
  self.time_limit_4_season = nil
  self.time_limit_4_passDay = nil
  self.special_info = nil
  self.blood_buff = nil
  self.dark_buff = nil
  self.armor_chest = nil
  self.blood_chest = nil
  self.kill_world_treasure = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.blood_monster = row:getIntValue("blood_monster")
  self.type = tonumber(row:getValue("type")) or 0
  self.name = row:getValue("name")
  self.desc = row:getValue("desc")
  self.special_info = row:getValue("special_info")
  self.level = row:getValue("level")
  self.size = row:getValue("size")
  self.boss = row:getValue("boss")
  self.is_stop = row:getValue("is_stop")
  self.model_name = row:getValue("model_name")
  self.exp = row:getValue("exp") or 0
  self.special = row:getIntValue("special")
  self.season = row:getIntValue("season")
  self.expire = row:getIntValue("expire")
  self.monster_resistance = toInt(row:getIntValue("monster_resistance"))
  self.resistance_type = toInt(row:getIntValue("resistance_type", 0))
  self.discover_reward_show = row:getValue("discover_reward_show")
  self.world_treasure_show = row:getValue("world_treasure_show")
  self.poison_para = row:getValue("poison_para")
  if not string.IsNullOrEmpty(self.poison_para) then
    local virusProbability, virusLayer = string.match(self.poison_para, "([^;]+);([^;]+)")
    if virusProbability and virusLayer then
      self.virusProbability = tonumber(virusProbability)
      self.virusLayer = tonumber(virusLayer)
    end
  end
  self.first_reward_show = row:getValue("first_reward_show")
  self.show_reward = row:getValue("show_reward")
  self.possible_reward = row:getValue("possible_reward")
  self.with_extra_reward_id = row:getValue("excess_Reward")
  self.with_extra_reward_show = row:getValue("excess_show_Reward")
  self.with_activity_type = row:getValue("activity")
  self.recommendType = tonumber(row:getValue("recommendType")) or 0
  local esr = row:getValue("effect_show_reward")
  if type(esr) == "string" then
    self.effect_show_reward = string.split(esr, "|")
  else
    self.effect_show_reward = esr
  end
  self.recommend_power = tonumber(row:getValue("recommend_power")) or 0
  self.pic = row:getValue("pic_name")
  local needArmyStrs = string.split(row:getValue("recommend_troops") or "", ";")
  if #needArmyStrs == 2 then
    self.needArmy = {
      level = tonumber(needArmyStrs[1]) or 0,
      count = tonumber(needArmyStrs[2]) or 0
    }
  end
  local needHeroStrs = string.split(row:getValue("recommend_hero") or "", ";")
  if #needHeroStrs == 2 then
    self.needHero = {
      level = tonumber(needHeroStrs[1]) or 0,
      count = tonumber(needHeroStrs[2]) or 0
    }
  end
  self.limit = tonumber(row:getValue("limit")) or 0
  self.power_tip = tonumber(row:getValue("power_tip")) or 0
  self.enter_limit = tonumber(row:getValue("enter_limit")) == 1
  if self.with_extra_reward_show ~= nil and not string.IsNullOrEmpty(self.with_activity_type) and 0 < #self.with_extra_reward_show then
    local extraRewardIdList1 = {}
    local extraRewardIdList2 = {}
    local nList1 = 0
    local nList2 = 0
    for _, v in ipairs(self.with_extra_reward_show) do
      if v ~= nil and v ~= "" then
        local show_info, id, rewardType, num = string.match(v, "(%d+)[,;](%d+)[,;](%d+)[,;](%d+)")
        if show_info == "1" then
          extraRewardIdList1[id] = num
          nList1 = nList1 + 1
        elseif show_info == "2" then
          extraRewardIdList2[id] = num
          nList2 = nList2 + 1
        end
      end
    end
    if 0 < nList1 then
      self.extraRewardIdList1 = extraRewardIdList1
    end
    if 0 < nList2 then
      self.extraRewardIdList2 = extraRewardIdList2
    end
  end
  self.daily_first_reward_show = row:getValue("daily_first_reward_show")
  self.restricted_reward_show = row:getValue("restricted_Reward_show")
  if self.restricted_reward_show ~= nil then
    self.restricted_reward_show = string.split(self.restricted_reward_show, "|")
  end
  self.attacked_plot = row:getValue("attacked_plot")
  self.attack_plot = toInt(row:getValue("attack_plot"))
  self.first_reward_type = toInt(row:getValue("first_reward_type"))
  self.first_reward_condition = toInt(row:getValue("first_reward_condition"))
  self.time_limit_4_season = 0
  self.time_limit_4_passDay = 0
  local time_limit_info = row:getValue("time_limit")
  if not string.IsNullOrEmpty(time_limit_info) then
    local time_limit_arr = string.split(time_limit_info, ";")
    if time_limit_arr and 2 <= #time_limit_arr then
      self.time_limit_4_season = toInt(time_limit_arr[1])
      self.time_limit_4_passDay = toInt(time_limit_arr[2])
    end
  end
  local dark_buff = row:getValue("dark_buff")
  if dark_buff and 0 < #dark_buff then
    self.dark_buff = dark_buff
  end
  local blood_buff = row:getValue("blood_buff")
  if blood_buff and 0 < #blood_buff then
    self.blood_buff = blood_buff
  end
  self.armor_chest = row:getValue("armor_chest")
  self.blood_chest = row:getValue("blood_chest")
  self.kill_world_treasure = row:getValue("kill_world_treasure")
  self.initiative_share = row:getValue("initiative_share") == 1
end

function MonsterTemplate:GetAttackPlot()
  return self.attack_plot
end

local function ParserRewardShow(defaultList, strList)
  if strList ~= nil and 0 < #strList then
    local mgr = DataCenter.RewardManager
    local item
    for _, v in ipairs(strList) do
      if v ~= nil and v ~= "" then
        item = mgr:ParseOneRewardStr(v)
        if item ~= nil then
          table.insert(defaultList, item)
        end
      end
    end
  end
  return defaultList
end

local function ConcatStrList(theList, extra_show_info)
  local dict = {}
  for _, strList in ipairs(theList) do
    for _, str in ipairs(strList) do
      if str ~= nil and str ~= "" then
        local _extra_show_info, id, rewardType, num = string.match(str, "(%d+)[,;](%d+)[,;](%d+)[,;](%d+)")
        if _extra_show_info ~= nil and extra_show_info == _extra_show_info then
          local k = id .. ";" .. rewardType
          local v = tonumber(num)
          dict[k] = (dict[k] or 0) + v
        elseif _extra_show_info == nil then
          id, rewardType, num = string.match(str, "(%d+)[,;](%d+)[,;](%d+)")
          if id ~= nil then
            local k = id .. ";" .. rewardType
            local v = tonumber(num)
            dict[k] = (dict[k] or 0) + v
          end
        end
      end
    end
  end
  local t = {}
  for k, v in pairs(dict) do
    table.insert(t, k .. ";" .. v)
  end
  return t
end

function MonsterTemplate:ExistAssociateActivity()
  if self.extraRewardIdList1 == nil and self.extraRewardIdList2 == nil then
    return false
  end
  if self.with_extra_reward_show ~= nil and not string.IsNullOrEmpty(self.with_activity_type) and #self.with_extra_reward_show > 0 then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(self.with_activity_type)
    if 0 < #dataList then
      return true
    end
  end
  return false
end

local function GetFirstRewardShow(self)
  if self.type == LWWorldMonsterType.RunningMonster then
    return self.daily_first_reward_show
  end
  return self.first_reward_show
end

local function GetRestrictedRewardShow(self)
  return self.restricted_reward_show
end

function MonsterTemplate:GetRewardList(columnNameStr)
  return ParserRewardShow({}, self[columnNameStr])
end

local function GetProcessedFirstRewardShow(self)
  local ret = ParserRewardShow({}, self:GetFirstRewardShow())
  if 0 < #ret then
    local activityRewardList = self:CheckActivityDrop(false)
    table.insertto(ret, activityRewardList)
  end
  return ret
end

local function GetProcessedRestrictedRewardShow(self)
  local ret = ParserRewardShow({}, self:GetRestrictedRewardShow())
  local activityRewardList = self:CheckActivityDrop(false)
  table.insertto(ret, activityRewardList)
  return ret
end

local function GetShowReward(self)
  local exist_activity = self:ExistAssociateActivity()
  if self.boss == 0 and LuaEntry.Effect:GetGameEffect(EffectDefine.MONSTER_EXTRA_REWARD) == 1 or self.boss == 1 and LuaEntry.Effect:GetGameEffect(EffectDefine.BOSS_EXTRA_REWARD) == 1 then
    if exist_activity then
      return ConcatStrList({
        self.show_reward,
        self.effect_show_reward,
        self.with_extra_reward_show
      }, "1")
    end
    return ConcatStrList({
      self.show_reward,
      self.effect_show_reward
    }, nil)
  end
  if self.show_reward == nil or #self.show_reward == 0 then
    return {}
  end
  if exist_activity then
    return ConcatStrList({
      self.show_reward,
      self.with_extra_reward_show
    }, "1")
  end
  return self.show_reward
end

local function CheckActivityDrop(self, isPossibleReward)
  local ret = {}
  local activityList = DataCenter.ActivityListDataManager:GetActivityList()
  for _, v in pairs(activityList) do
    local isCanDrop = self:CheckActivityCanDrop(v)
    if isCanDrop then
      local dropId = v.subType
      local templateList = DataCenter.ActivityDropTemplateManager:GetTemplatesByDropId(tonumber(dropId))
      for __, v1 in pairs(templateList) do
        local isPassCrossServerShow = v1:CheckPassCrossServerShowReward()
        local isCanDrop = false
        local isMonsterDrop = false
        if v1.drop_way == DropWayEnum.InvadeZombie or v1.drop_way == DropWayEnum.DoomBoss or v1.drop_way == DropWayEnum.AllyDrill or v1.drop_way == DropWayEnum.BossZombie or v1.drop_way == DropWayEnum.NormalZombie or v1.drop_way == DropWayEnum.HeroTrail or v1.drop_way == DropWayEnum.Lockhart or v1.drop_way == DropWayEnum.FLowerCar or v1.drop_way == DropWayEnum.BloodyMoonZombie or v1.drop_way == DropWayEnum.BloodyMoonAssemble or v1.drop_way == DropWayEnum.HeTong or v1.drop_way == DropWayEnum.GoldenBeetleBoss or v1.drop_way == DropWayEnum.BigSandWorm or v1.drop_way == DropWayEnum.StrayChicken then
          isMonsterDrop = true
        end
        if isMonsterDrop then
          if v1.type_para_sepc then
            if v1.type_para_sepc[self.type] and v1.type_para_sepc[self.type][self.special] then
              isCanDrop = true
            end
          else
            local containType = false
            local containSpecial = false
            if v1.type_para1 and table.count(v1.type_para1) then
              for i = 1, table.count(v1.type_para1) do
                if v1.type_para1[i] == self.type then
                  containType = true
                  break
                end
              end
            end
            if v1.type_para2 and table.count(v1.type_para2) then
              for i = 1, table.count(v1.type_para2) do
                if v1.type_para2[i] == self.special then
                  containSpecial = true
                  break
                end
              end
            end
            if containType and containSpecial then
              isCanDrop = true
            end
          end
        end
        if isCanDrop then
          local ifTreasureBoxExist = true
          if v1.drop_way == DropWayEnum.FLowerCar or v1.drop_way == DropWayEnum.BigSandWorm then
            ifTreasureBoxExist = v1:CheckTreasureBoxExist(self)
          end
          local isPass = v1:CheckDropConditionPass() and ifTreasureBoxExist
          if not isPass then
            isCanDrop = false
          end
        end
        if isPassCrossServerShow and isCanDrop and not isPossibleReward then
          local drop_show = v1.drop_show
          if not table.IsNullOrEmpty(drop_show) then
            for _, v in ipairs(drop_show) do
              local rewardInfo = {}
              rewardInfo.itemId = v.id
              rewardInfo.rewardType = RewardType.GOODS
              local count
              local minCount = v.minNum
              local maxCount = v.maxNum
              if maxCount and maxCount ~= minCount then
                count = string.format("%d-%d", minCount, maxCount)
              else
                count = minCount
              end
              rewardInfo.count = count
              table.insert(ret, rewardInfo)
            end
          end
        end
      end
    end
  end
  return ret
end

local function CheckActivityCanDrop(self, activityInfo)
  local isCanDrop = UIUtil.CheckActivityCanDrop(activityInfo)
  return isCanDrop
end

local function GetProcessedShowReward(self)
  local IdList = self.extraRewardIdList1
  local itemList = ParserRewardShow({}, self:GetShowReward())
  if IdList ~= nil and self:ExistAssociateActivity() then
    table.sort(itemList, function(a, b)
      if IdList[a.itemId] ~= nil and IdList[a.itemId] ~= nil then
        return a.itemId > a.itemId
      end
      if IdList[a.itemId] ~= nil then
        return true
      end
      if IdList[b.itemId] ~= nil then
        return false
      end
      return a.itemId > b.itemId
    end)
  end
  local activityRewardList = CheckActivityDrop(self, false)
  table.insertto(itemList, activityRewardList)
  return itemList
end

local function GetShowPossibleReward(self)
  return self.possible_reward
end

local function GetProcessedShowPossibleReward(self)
  local itemList
  local IdList = self.extraRewardIdList2
  if self.possible_reward == nil or #self.possible_reward == 0 then
    return {}
  end
  if IdList ~= nil and self:ExistAssociateActivity() then
    itemList = ParserRewardShow({}, ConcatStrList({
      self.possible_reward,
      self.with_extra_reward_show
    }, "2"))
    if IdList ~= nil then
      table.sort(itemList, function(a, b)
        if IdList[a.itemId] ~= nil and IdList[a.itemId] ~= nil then
          return a.itemId > a.itemId
        end
        if IdList[a.itemId] ~= nil then
          return true
        end
        if IdList[b.itemId] ~= nil then
          return false
        end
        return a.itemId > b.itemId
      end)
    end
  else
    itemList = ParserRewardShow({}, self.possible_reward)
  end
  local activityRewardList = CheckActivityDrop(self, true)
  table.insertto(itemList, activityRewardList)
  return itemList
end

function MonsterTemplate:GetIcon()
  return UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, self.pic)
end

function MonsterTemplate:GetSmallIcon()
  return UIUtil.GetFullPath(LoadPath.HeroIconsSmallPath, self.pic)
end

MonsterTemplate.__init = __init
MonsterTemplate.__delete = __delete
MonsterTemplate.InitData = InitData
MonsterTemplate.GetFirstRewardShow = GetFirstRewardShow
MonsterTemplate.GetRestrictedRewardShow = GetRestrictedRewardShow
MonsterTemplate.GetProcessedFirstRewardShow = GetProcessedFirstRewardShow
MonsterTemplate.GetProcessedRestrictedRewardShow = GetProcessedRestrictedRewardShow
MonsterTemplate.GetShowReward = GetShowReward
MonsterTemplate.GetProcessedShowReward = GetProcessedShowReward
MonsterTemplate.GetShowPossibleReward = GetShowPossibleReward
MonsterTemplate.GetProcessedShowPossibleReward = GetProcessedShowPossibleReward
MonsterTemplate.CheckActivityDrop = CheckActivityDrop
MonsterTemplate.CheckActivityCanDrop = CheckActivityCanDrop
return MonsterTemplate
