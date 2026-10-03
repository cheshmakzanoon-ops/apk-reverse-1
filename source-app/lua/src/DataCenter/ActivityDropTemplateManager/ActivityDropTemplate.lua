local ActivityDropTemplate = BaseClass("ActivityDropTemplate")

function ActivityDropTemplate:__init()
  self.id = 0
  self.activity = 0
  self.isRecommend = false
  self.order = 0
  self.name = ""
  self.desc = ""
  self.showGoto = 0
  self.goType = 0
  self.goPara = {}
  self.icon = ""
  self.drop_show = {}
  self.boss_id = {}
  self.monster_model = {}
  self.monster_vfx = {}
  self.type_para1 = {}
  self.type_para2 = {}
  self.type_para_sepc = nil
  self.extra_display = 0
  self.extra_desc = ""
  self.drop_info_para = 0
  self.cross_alert = 0
  self.cross_drop_notshow = -1
  self.drop_condition = {}
  self.common_para1 = ""
  self.client_condition = {}
end

function ActivityDropTemplate:__delete()
  self.id = nil
  self.activity = nil
  self.isRecommend = nil
  self.order = nil
  self.name = nil
  self.desc = nil
  self.showGoto = nil
  self.goType = nil
  self.goPara = nil
  self.icon = nil
  self.drop_show = nil
  self.boss_id = nil
  self.monster_model = nil
  self.monster_vfx = nil
  self.type_para1 = nil
  self.type_para2 = nil
  self.type_para_sepc = nil
  self.extra_display = nil
  self.extra_desc = nil
  self.drop_info_para = nil
  self.cross_alert = nil
  self.cross_drop_notshow = nil
  self.drop_condition = nil
  self.common_para1 = nil
  self.client_condition = {}
end

function ActivityDropTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.activity = row:getValue("activity")
  self.drop_way = row:getValue("drop_way") or 0
  self.rate = row:getValue("rate") or 0
  local dropInfoId = row:getValue("drop_desc") or 0
  if 0 < dropInfoId then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Activity_Drop_Info, dropInfoId)
    if oneTemplate then
      self.name = oneTemplate:getValue("way_name") or ""
      self.desc = oneTemplate:getValue("way_desc") or ""
      self.showGoto = oneTemplate:getValue("show_goto") or 0
      self.goType = oneTemplate:getValue("gotype2") or 0
      self.goPara = oneTemplate:getValue("gopara") or {}
      self.icon = oneTemplate:getValue("icon") or ""
      self.cross_alert = tonumber(oneTemplate:getValue("cross_alert")) or 0
      self.cross_drop_notshow = tonumber(oneTemplate:getValue("cross_drop_notshow")) or -1
      local boss_id = oneTemplate:getValue("boss_id") or ""
      self.boss_id = {}
      if not string.IsNullOrEmpty(boss_id) then
        local bossIdStrPair = string.split(boss_id, "|")
        for i = 1, #bossIdStrPair do
          if not string.IsNullOrEmpty(bossIdStrPair[i]) then
            local bossIdStr = string.split(bossIdStrPair[i], ";")
            if 2 <= #bossIdStr then
              table.insert(self.boss_id, {
                tonumber(bossIdStr[1]),
                tonumber(bossIdStr[2])
              })
            end
          end
        end
      end
      local monster_model = oneTemplate:getValue("monster_model") or ""
      self.monster_model = {}
      if not string.IsNullOrEmpty(monster_model) then
        local bossNameStr = string.split(monster_model, "|")
        for i = 1, #bossNameStr do
          table.insert(self.monster_model, bossNameStr[i])
        end
      end
      local monster_vfx = oneTemplate:getValue("monster_vfx") or ""
      self.monster_vfx = {}
      if not string.IsNullOrEmpty(monster_vfx) then
        local monsterVfx = string.split(monster_vfx, "|")
        for i = 1, #monsterVfx do
          table.insert(self.monster_vfx, monsterVfx[i])
        end
      end
    end
  end
  self.extra_display = tonumber(row:getValue("extra_display")) or 0
  self.extra_desc = row:getValue("extra_desc") or ""
  self.order = tonumber(row:getValue("order") or 1)
  self.drop_info_para = tonumber(row:getValue("drop_info_para")) or 0
  local drop_show = row:getValue("drop_show") or ""
  self.drop_show = {}
  if not string.IsNullOrEmpty(drop_show) then
    local dropArr = string.split(drop_show, "|")
    for i = 1, #dropArr do
      local dropInfo = {}
      local dropInfoArr = string.split(dropArr[i], ";")
      if 2 <= #dropInfoArr then
        dropInfo.id = tonumber(dropInfoArr[1])
        dropInfo.minNum = tonumber(dropInfoArr[2])
        dropInfo.maxNum = tonumber(dropInfoArr[3])
        table.insert(self.drop_show, dropInfo)
      end
    end
  end
  local type_para1 = row:getValue("type_para1") or ""
  self.type_para1 = {}
  if not string.IsNullOrEmpty(type_para1) then
    local typePara1Str = string.split(type_para1, "|")
    for i = 1, table.count(typePara1Str) do
      table.insert(self.type_para1, tonumber(typePara1Str[i]))
    end
  end
  local type_para2 = row:getValue("type_para2") or ""
  self.type_para2 = {}
  if not string.IsNullOrEmpty(type_para2) then
    local typePara2Str = string.split(type_para2, "|")
    for i = 1, table.count(typePara2Str) do
      table.insert(self.type_para2, tonumber(typePara2Str[i]))
    end
  end
  local type_para_sepc = row:getValue("type_para_sepc") or ""
  if not string.IsNullOrEmpty(type_para_sepc) then
    local dataArr = string.string2array_num(type_para_sepc, "|", ";")
    self.type_para_sepc = {}
    for k, v in ipairs(dataArr) do
      if #v == 2 then
        local type1 = v[1]
        local type2 = v[2]
        if self.type_para_sepc[type1] == nil then
          self.type_para_sepc[type1] = {}
        end
        self.type_para_sepc[type1][type2] = true
      end
    end
  end
  self.builders_alliance = tonumber(row:getValue("builders_alliance"))
  local drop_condition = row:getValue("drop_condition") or ""
  self.drop_condition = {}
  if not string.IsNullOrEmpty(drop_condition) then
    self.drop_condition = string.string2array_num(drop_condition, ";", "|")
  end
  local client_condition = row:getValue("client_condition") or ""
  self.client_condition = {}
  if not string.IsNullOrEmpty(client_condition) then
    self.client_condition = string.string2array_num(client_condition, ";", "|")
  end
  self.common_para1 = row:getValue("common_para1") or ""
  self.dropLogKeyList = row:getValue("drop_record_desc") or {}
end

function ActivityDropTemplate:TryGotoFunc()
  local isPassCrossServerCheck = true
  if self.cross_alert > 0 then
    local isInCrossServer = CrossServerUtil.CheckCrossServerWithWatchAndJoinType()
    if isInCrossServer then
      isPassCrossServerCheck = false
    end
  end
  if isPassCrossServerCheck then
    if 0 < self.goType then
      GoToUtil.GoToByTypeAndParam(self.goType, self.goPara)
    end
  else
    UIUtil.ShowTipsId("bp_goto_alert1")
  end
end

function ActivityDropTemplate:CheckPassCrossServerShowReward()
  local isPass = true
  if self.cross_drop_notshow == 0 then
    local isInCrossServer = CrossServerUtil.CheckCrossServerWithWatchAndJoinType()
    if isInCrossServer then
      isPass = false
    end
  end
  return isPass
end

local function CheckConditionPass(drop_condition)
  local isPass = true
  for i, v in ipairs(drop_condition) do
    if v[1] == 1 then
      if #v == 3 then
        local needSeason = v[2]
        local needSeasonDay = v[3]
        local isSeasonOpen = SeasonUtil.IsOpen()
        if needSeason == 0 then
          if isSeasonOpen then
            isPass = false
            break
          end
        else
          local seasonNum = SeasonUtil.GetSeason()
          local seasonDay = SeasonUtil.GetSeasonDay()
          if seasonNum ~= needSeason or not (needSeasonDay <= seasonDay) then
            isPass = false
            break
          end
        end
      end
    elseif v[1] == 2 then
      if #v == 2 then
        local activityId = v[2]
        local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(activityId))
        if activityData == nil or not activityData:IsValid() then
          isPass = false
          break
        end
      end
    elseif v[1] == 3 then
      if #v ~= 3 then
        Logger.LogError("CheckDropConditionPass fail, drop_condition format error, condition:" .. tostring(v))
        isPass = false
        break
      end
      local result = true
      local seasonRequest = v[2]
      local seasonDayRequest = v[3]
      local curSeason = SeasonUtil.GetSeason()
      if seasonRequest > curSeason then
        result = false
      else
        local curSeasonDay = SeasonUtil.GetSeasonDay()
        if curSeason == seasonRequest and seasonDayRequest > curSeasonDay then
          result = false
        end
      end
      isPass = result
      if not isPass then
        break
      end
    elseif v[1] == 4 then
      if #v ~= 3 then
        Logger.LogError("CheckDropConditionPass fail, drop_condition format error, condition:" .. tostring(v))
        isPass = false
        break
      end
      local result = true
      local seasonRequest = v[2]
      local seasonDayRequest = v[3]
      local curSeason = SeasonUtil.GetSeason()
      if seasonRequest < curSeason then
        result = false
      else
        local curSeasonDay = SeasonUtil.GetSeasonDay()
        if curSeason == seasonRequest and seasonDayRequest < curSeasonDay then
          result = false
        end
      end
      isPass = result
      if not isPass then
        break
      end
    elseif v[1] == 5 then
      if #v ~= 3 then
        Logger.LogError("CheckDropConditionPass fail, drop_condition format error, condition:" .. tostring(v))
        isPass = false
        break
      end
      local result = true
      local seasonRequestStart = v[2]
      local seasonRequestEnd = v[3]
      local curSeason = SeasonUtil.GetSeason()
      if seasonRequestEnd < curSeason or seasonRequestStart > curSeason then
        result = false
      end
      isPass = result
      if not isPass then
        break
      end
    elseif v[1] == 6 then
      if #v ~= 3 then
        Logger.LogError("CheckDropConditionPass fail, drop_condition format error, condition:" .. tostring(v))
        isPass = false
        break
      end
      local result = true
      local seasonRequestStart = v[2]
      local seasonRequestEnd = v[3]
      local isSeasonTypeNone = SeasonUtil.GetSourceSeasonType() == SeasonMapType.Nothing
      local curSeason = SeasonUtil.GetSeason()
      if not isSeasonTypeNone or seasonRequestEnd < curSeason or seasonRequestStart > curSeason then
        result = false
      end
      isPass = result
      if not isPass then
        break
      end
    elseif v[1] == 7 then
      if #v ~= 2 then
        Logger.LogError("CheckDropConditionPass fail, drop_condition format error, condition:" .. tostring(v))
        isPass = false
        break
      end
      local result = true
      local seasonRequest = v[2]
      local curSeason = SeasonUtil.GetSeason()
      local isSeasonTypeNone = SeasonUtil.GetSourceSeasonType() == SeasonMapType.Nothing
      if seasonRequest < curSeason or curSeason == seasonRequest and isSeasonTypeNone then
        result = false
      end
      isPass = result
      if not isPass then
        break
      end
    elseif v[1] == 8 then
      if #v ~= 2 then
        Logger.LogError("CheckDropConditionPass fail, drop_condition format error, condition:" .. tostring(v))
        isPass = false
        break
      end
      local result = true
      local seasonRequest = v[2]
      local curSeason = SeasonUtil.GetSeason()
      local isSeasonTypeNone = SeasonUtil.GetSourceSeasonType() == SeasonMapType.Nothing
      if seasonRequest >= curSeason or curSeason == seasonRequest and isSeasonTypeNone then
        result = false
      end
      isPass = result
      if not isPass then
        break
      end
    end
  end
  return isPass
end

function ActivityDropTemplate:CheckDropConditionPass()
  return CheckConditionPass(self.drop_condition)
end

function ActivityDropTemplate:CheckClientConditionPass()
  return CheckConditionPass(self.client_condition)
end

function ActivityDropTemplate:CheckTreasureBoxExist(monsterTemplate)
  local result = false
  if not monsterTemplate then
    return false
  end
  if self.drop_way == DropWayEnum.BigSandWorm then
    local commonParaArr = string.split(self.common_para1, "|")
    for i = 1, #commonParaArr do
      local killWorldTreasure = monsterTemplate.kill_world_treasure
      local treasureBox = string.split(killWorldTreasure, "|")
      local boxId = treasureBox[2]
      local commonPara = commonParaArr[i]
      if boxId and commonPara and tonumber(boxId) and tonumber(commonPara) and tonumber(boxId) == tonumber(commonPara) then
        result = true
        break
      end
    end
  end
  if self.drop_way == DropWayEnum.FLowerCar then
    local armorChest = monsterTemplate.armor_chest
    local armorTreasureBox = string.split(armorChest, "|")
    local armorBoxId = armorTreasureBox[2]
    local bloodChest = monsterTemplate.blood_chest
    local bloodTreasureBox = string.split(bloodChest, "|")
    local bloodBoxId = bloodTreasureBox[2]
    local commonParaArr = string.split(self.common_para1, "|")
    for i = 1, #commonParaArr do
      local commonPara = commonParaArr[i]
      local hasArmorChestBox = armorBoxId and commonPara and tonumber(armorBoxId) and tonumber(commonPara) and tonumber(armorBoxId) == tonumber(commonPara)
      local hasBloodBox = bloodBoxId and commonPara and tonumber(bloodBoxId) and tonumber(commonPara) and tonumber(bloodBoxId) == tonumber(commonPara)
      if hasArmorChestBox or hasBloodBox then
        result = true
        break
      end
    end
  end
  return result
end

function ActivityDropTemplate:GetLogKeyByIndex(index)
  if not self.dropLogKeyList or index > #self.dropLogKeyList then
    return ""
  end
  return self.dropLogKeyList[index]
end

function ActivityDropTemplate:CheckTypeAndSpecial(type, special)
  if self.type_para_sepc == nil then
    return false
  end
  if self.type_para_sepc[type] == nil then
    return false
  end
  return self.type_para_sepc[type][special] or false
end

return ActivityDropTemplate
