local AllyDuelConditionTipManager = BaseClass("AllyDuelConditionTip")

function AllyDuelConditionTipManager:__init()
  self.groupId2IdList = {}
  self.conditionTipMap = nil
end

function AllyDuelConditionTipManager:__delete()
  self.groupId2IdList = nil
  self.conditionTipMap = nil
end

function AllyDuelConditionTipManager:GetTip(day)
  if self.conditionTipMap == nil then
    local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
    local seasonNum = SeasonUtil.GetSeason()
    local seasonDay = SeasonUtil.GetSeasonDay()
    local openServerWeek = UITimeManager:GetInstance():GetOpenServerWeek()
    LocalController:instance():visitTable(TableName.HeroActivity, function(id, lineData)
      local type = tonumber(lineData:getValue("type")) or 0
      if type == 15 and self.conditionTipMap == nil then
        self.conditionTipMap = {}
        local activity = lineData:getValue("activity")
        local activityList = string.split(activity, "|")
        for i, v in ipairs(activityList) do
          local eventId = tonumber(v)
          local data = LocalController:instance():getLine(TableName.HeroEvent, eventId)
          if data then
            local scoreList = string.split(data:getValue("score"), "|")
            local condition_score = string.split(data:getValue("condition_score"), ";")
            for _, condition in ipairs(condition_score) do
              local spl = string.split(condition, ",")
              if #spl == 3 then
                local condi = tonumber(spl[1])
                local param
                if condi == 2 then
                  param = string.split(spl[2], "#")
                  param[1] = tonumber(param[1])
                  if param[2] then
                    param[2] = tonumber(param[2])
                  else
                    param[2] = 1
                  end
                else
                  param = tonumber(spl[2])
                end
                local sco = spl[3]
                if condi == 1 and param <= openServerDay or condi == 2 and (param[1] < seasonNum or param[1] == seasonNum and param[2] <= seasonDay) or condi == 3 and param <= openServerWeek then
                  sco = string.split(sco, "|")
                  for _, s in pairs(sco) do
                    table.insert(scoreList, s)
                  end
                end
              end
            end
            local scoreIdListNew = {}
            self.conditionTipMap[i] = scoreIdListNew
            for index, value in ipairs(scoreList) do
              local scoreId = tonumber(value)
              local scoreTable = LocalController:instance():getLine("score", scoreId)
              if scoreTable ~= nil then
                local points = scoreTable:getValue("points")
                local tipsArr = scoreTable:getValue("tips")
                local idData = {}
                idData.id = scoreId
                idData.points = points
                idData.tipsArr = tipsArr
                idData.tips = scoreTable:getValue("tips")
                idData.pic = scoreTable:getValue("pic")
                local effectInfo = scoreTable:getValue("effect_list")
                if effectInfo ~= nil and effectInfo ~= "" then
                  idData.effectList = {}
                  local effects = string.split(effectInfo, ";")
                  for i = 1, #effects do
                    idData.effectList[i] = effects[i]
                  end
                end
                local group = scoreTable:getValue("group")
                local groupId = string.IsNullOrEmpty(group) and 0 or tonumber(group)
                idData.groupId = groupId
                if groupId ~= 0 then
                  if not self.groupId2IdList[groupId] then
                    self.groupId2IdList[groupId] = {}
                  end
                  table.insert(self.groupId2IdList[groupId], idData)
                end
                local name = scoreTable:getValue("name")
                local params = scoreTable:getValue("point")
                local value = scoreTable:getValue("value")
                idData.name = name
                idData.value = value
                table.insert(scoreIdListNew, idData)
              end
            end
          end
        end
      end
    end)
    if self.conditionTipMap == nil then
      self.conditionTipMap = {}
    end
  end
  return self.conditionTipMap[day]
end

function AllyDuelConditionTipManager.ParseEffectShow(heroEventMeta)
  if not heroEventMeta then
    return {}
  end
  local effectShowList = {}
  local effectParam = string.split(heroEventMeta.effect_show, ";")
  for i = 1, #effectParam do
    local effectInfo = string.split(effectParam[i], "|")
    effectShowList[i] = {}
    effectShowList[i].id = effectInfo[1]
    effectShowList[i].languageId = effectInfo[2]
  end
  local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
  local seasonNum = SeasonUtil.GetSeason()
  local seasonDay = SeasonUtil.GetSeasonDay()
  local openServerWeek = UITimeManager:GetInstance():GetOpenServerWeek()
  effectParam = string.split(heroEventMeta:getValue("effect_show_addition"), ";")
  for _, condition in ipairs(effectParam) do
    local pair = string.split(condition, "|")
    local spl = string.split(pair[1], ",")
    if #spl == 3 then
      local condi = tonumber(spl[1])
      local param
      if condi == 2 then
        param = string.split(spl[2], "#")
        param[1] = tonumber(param[1])
        if param[2] then
          param[2] = tonumber(param[2])
        else
          param[2] = 1
        end
      else
        param = tonumber(spl[2])
      end
      local effectNo = tonumber(spl[3])
      if condi == 1 and openServerDay >= param or condi == 2 and (seasonNum > param[1] or param[1] == seasonNum and seasonDay >= param[2]) or condi == 3 and openServerWeek >= param then
        local effectShow = {}
        effectShow.id = effectNo
        effectShow.languageId = pair[2]
        table.insert(effectShowList, effectShow)
      end
    end
  end
  return effectShowList
end

function AllyDuelConditionTipManager:GetEffectShow(day)
  if self.effectShowMap then
    return self.effectShowMap[day]
  end
  self.effectShowMap = {}
  LocalController:instance():visitTable(TableName.HeroActivity, function(id, lineData)
    local type = tonumber(lineData:getValue("type")) or 0
    if type ~= 15 then
      return
    end
    local activity = lineData:getValue("activity")
    local activityList = string.split(activity, "|")
    for i, v in ipairs(activityList) do
      local eventId = tonumber(v)
      local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, eventId)
      self.effectShowMap[i] = self.ParseEffectShow(heroEventMeta)
    end
  end)
  return self.effectShowMap[day]
end

function AllyDuelConditionTipManager:GetGroupListByGroupId(groupId)
  return self.groupId2IdList[groupId]
end

return AllyDuelConditionTipManager
