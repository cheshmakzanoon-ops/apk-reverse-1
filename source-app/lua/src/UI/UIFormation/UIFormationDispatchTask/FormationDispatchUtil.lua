local FormationDispatchUtil = BaseClass("FormationDispatchUtil")

local function CalcMatchCount(hero, cond1Param, cond2Param, cond3Param, cond4Param)
  local matchCount = 0
  if hero.ok1 and cond1Param then
    matchCount = matchCount + 1
  end
  if hero.ok2 and cond2Param then
    matchCount = matchCount + 1
  end
  if hero.ok3 and cond3Param then
    matchCount = matchCount + 1
  end
  if hero.ok4 and cond4Param then
    matchCount = matchCount + 1
  end
  return matchCount
end

local function IsMatch(hero, cond1Param, cond2Param, cond3Param, cond4Param)
  if hero.ok1 ~= true and cond1Param then
    return false
  end
  if hero.ok2 ~= true and cond2Param then
    return false
  end
  if hero.ok3 ~= true and cond3Param then
    return false
  end
  if hero.ok4 ~= true and cond4Param then
    return false
  end
  return true
end

local function CleanData2(hero, cond1Param, cond2Param, cond3Param, cond4Param)
  if hero.ok1 and cond1Param then
    cond1Param.count = cond1Param.count - 1
    cond1Param.heroCount = cond1Param.heroCount - 1
    cond1Param.heroList[hero.uuid] = nil
    if cond1Param.count == 0 then
      cond1Param = nil
    end
  end
  if hero.ok2 and cond2Param then
    cond2Param.count = cond2Param.count - 1
    cond2Param.heroCount = cond2Param.heroCount - 1
    cond2Param.heroList[hero.uuid] = nil
    if cond2Param.count == 0 then
      cond2Param = nil
    end
  end
  if hero.ok3 and cond3Param then
    cond3Param.count = cond3Param.count - 1
    cond3Param.heroCount = cond3Param.heroCount - 1
    cond3Param.heroList[hero.uuid] = nil
    if cond3Param.count == 0 then
      cond3Param = nil
    end
  end
  if hero.ok4 and cond4Param then
    cond4Param.count = cond4Param.count - 1
    cond4Param.heroCount = cond4Param.heroCount - 1
    cond4Param.heroList[hero.uuid] = nil
    if cond4Param.count == 0 then
      cond4Param = nil
    end
  end
  return cond1Param, cond2Param, cond3Param, cond4Param
end

local function CleanData2Tmp(hero, cond1Param, cond2Param, cond3Param, cond4Param)
  if hero.ok1 and cond1Param then
    local count = cond1Param.count - 1
    if count == 0 then
      cond1Param = nil
    end
  end
  if hero.ok2 and cond2Param then
    local count = cond2Param.count - 1
    if count == 0 then
      cond2Param = nil
    end
  end
  if hero.ok3 and cond3Param then
    local count = cond3Param.count - 1
    if count == 0 then
      cond3Param = nil
    end
  end
  if hero.ok4 and cond4Param then
    local count = cond4Param.count - 1
    if count == 0 then
      cond4Param = nil
    end
  end
  return cond1Param, cond2Param, cond3Param, cond4Param
end

local function CleanData1(ret, condParam, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList)
  local uuidList = table.keys(condParam.heroList)
  for _, uuid in ipairs(uuidList) do
    if ret[uuid] == nil then
      ret[uuid] = condParam.heroList[uuid]
      okHeroList[uuid] = nil
      cond1Param, cond2Param, cond3Param, cond4Param = CleanData2(ret[uuid], cond1Param, cond2Param, cond3Param, cond4Param)
    end
  end
  return ret, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList
end

function FormationDispatchUtil.GetRecommendHeroList(usedHeroList, cond_count, cond1Param, cond2Param, cond3Param, cond4Param, checkSpecialFunc, checkHeroId)
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  local okHeroList = {}
  for uuid, heroData in pairs(heroDataList) do
    local checkUse = false
    if checkHeroId then
      checkUse = table.indexof(usedHeroList, heroData.heroId)
    else
      checkUse = table.indexof(usedHeroList, uuid)
    end
    if checkUse == false then
      local heroWithScore = {
        score = 0,
        uuid = uuid,
        quality = heroData.quality,
        power = heroData.power,
        heroId = heroData,
        ok1 = false,
        ok2 = false,
        ok3 = false,
        ok4 = false,
        checkSpecial = false
      }
      if cond1Param and heroData.heroType == cond1Param.data then
        heroWithScore.score = heroWithScore.score + 1
        heroWithScore.ok1 = true
        cond1Param.heroList[uuid] = heroWithScore
        cond1Param.heroCount = cond1Param.heroCount + 1
      end
      if cond2Param and heroData.quality >= cond2Param.data then
        heroWithScore.score = heroWithScore.score + 1
        heroWithScore.ok2 = true
        cond2Param.heroList[uuid] = heroWithScore
        cond2Param.heroCount = cond2Param.heroCount + 1
      end
      if cond3Param and heroData:GetRank() >= cond3Param.data then
        heroWithScore.score = heroWithScore.score + 1
        heroWithScore.ok3 = true
        cond3Param.heroList[uuid] = heroWithScore
        cond3Param.heroCount = cond3Param.heroCount + 1
      end
      if cond4Param and heroData.level >= cond4Param.data then
        heroWithScore.score = heroWithScore.score + 1
        heroWithScore.ok4 = true
        cond4Param.heroList[uuid] = heroWithScore
        cond4Param.heroCount = cond4Param.heroCount + 1
      end
      if checkSpecialFunc and checkSpecialFunc(heroData) then
        heroWithScore.checkSpecial = true
      end
      if heroWithScore.score ~= 0 then
        okHeroList[uuid] = heroWithScore
      end
    end
  end
  if cond1Param and cond1Param.heroCount < cond1Param.count then
    return nil, false
  end
  if cond2Param and cond2Param.heroCount < cond2Param.count then
    return nil, false
  end
  if cond3Param and cond3Param.heroCount < cond3Param.count then
    return nil, false
  end
  if cond4Param and cond4Param.heroCount < cond4Param.count then
    return nil, false
  end
  local ret = {}
  if cond1Param and cond1Param.heroCount == cond1Param.count then
    ret, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList = CleanData1(ret, cond1Param, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList)
    cond1Param = nil
  end
  if cond2Param and cond2Param.heroCount == cond2Param.count then
    ret, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList = CleanData1(ret, cond2Param, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList)
    cond2Param = nil
  end
  if cond3Param and cond3Param.heroCount == cond3Param.count then
    ret, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList = CleanData1(ret, cond3Param, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList)
    cond3Param = nil
  end
  if cond4Param and cond4Param.heroCount == cond4Param.count then
    ret, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList = CleanData1(ret, cond4Param, cond1Param, cond2Param, cond3Param, cond4Param, okHeroList)
    cond4Param = nil
  end
  local find_count = table.count(ret)
  if 3 < find_count then
    return nil, false
  end
  if cond1Param == nil and cond2Param == nil and cond3Param == nil and cond4Param == nil and find_count < 4 then
    return table.keys(ret), true
  end
  local tmpHeroList = table.values(okHeroList)
  table.sort(tmpHeroList, function(a, b)
    if checkSpecialFunc and a.checkSpecial ~= b.checkSpecial then
      return a.checkSpecial
    end
    if a.score == b.score then
      if a.quality == b.quality then
        return a.power < b.power
      end
      return a.quality < b.quality
    end
    return a.score > b.score
  end)
  local offset = 0
  repeat
    cond_count = (cond1Param and 1 or 0) + (cond2Param and 1 or 0) + (cond3Param and 1 or 0) + (cond4Param and 1 or 0)
    if 0 < cond_count then
      for index, hero in ipairs(tmpHeroList) do
        if ret[hero.uuid] == nil then
          local match_count = hero.score
          if match_count + offset == cond_count and IsMatch(hero, cond1Param, cond2Param, cond3Param, cond4Param) then
            ret[hero.uuid] = hero
            okHeroList[hero.uuid] = nil
            cond1Param, cond2Param, cond3Param, cond4Param = CleanData2(hero, cond1Param, cond2Param, cond3Param, cond4Param)
            cond_count = (cond1Param and 1 or 0) + (cond2Param and 1 or 0) + (cond3Param and 1 or 0) + (cond4Param and 1 or 0)
            if cond_count == 0 then
              break
            end
          end
        end
      end
    end
    cond_count = (cond1Param and 1 or 0) + (cond2Param and 1 or 0) + (cond3Param and 1 or 0) + (cond4Param and 1 or 0)
    find_count = table.count(ret)
    if 3 < find_count then
      return nil, false
    end
    if cond_count == 0 and find_count < 4 then
      return table.keys(ret), true
    end
    offset = offset - 1
  until offset < -4
  cond_count = (cond1Param and 1 or 0) + (cond2Param and 1 or 0) + (cond3Param and 1 or 0) + (cond4Param and 1 or 0)
  if 0 < cond_count then
    local cur_count = table.count(ret)
    for i = 1, 4 do
      local _, topScoreHero = FormationDispatchUtil.GetTopScoreHero(tmpHeroList, ret, cond1Param, cond2Param, cond3Param, cond4Param)
      if topScoreHero ~= nil then
        local cond1ParamTmp, cond2ParamTmp, cond3ParamTmp, cond4ParamTmp = CleanData2Tmp(topScoreHero, cond1Param, cond2Param, cond3Param, cond4Param)
        local cond_count_tmp = (cond1ParamTmp and 1 or 0) + (cond2ParamTmp and 1 or 0) + (cond3ParamTmp and 1 or 0) + (cond4ParamTmp and 1 or 0)
        if cond_count_tmp == 0 then
          ret[topScoreHero.uuid] = topScoreHero
          okHeroList[topScoreHero.uuid] = nil
          cond1Param, cond2Param, cond3Param, cond4Param = CleanData2(topScoreHero, cond1Param, cond2Param, cond3Param, cond4Param)
          cond_count = cond_count_tmp
          break
        end
        if cur_count < 2 and cur_count < 2 then
          if cur_count < 2 then
            cur_count = cur_count + 1
            ret[topScoreHero.uuid] = topScoreHero
            okHeroList[topScoreHero.uuid] = nil
            cond1Param, cond2Param, cond3Param, cond4Param = CleanData2(topScoreHero, cond1Param, cond2Param, cond3Param, cond4Param)
            cond_count = cond_count_tmp
            cond_count = cond_count_tmp
          end
          cond_count = cond_count_tmp
        end
      end
    end
  end
  cond_count = (cond1Param and 1 or 0) + (cond2Param and 1 or 0) + (cond3Param and 1 or 0) + (cond4Param and 1 or 0)
  find_count = table.count(ret)
  if 3 < find_count then
    return nil, false
  end
  if cond_count == 0 and find_count < 4 then
    return table.keys(ret), true
  end
  return nil, false
end

function FormationDispatchUtil.GetTopScoreHero(tmpHeroList, exclude, cond1Param, cond2Param, cond3Param, cond4Param)
  local topScore = 0
  local topScoreHero
  for _, hero in ipairs(tmpHeroList) do
    if exclude[hero.uuid] == nil then
      local score = CalcMatchCount(hero, cond1Param, cond2Param, cond3Param, cond4Param)
      if topScore < score then
        topScoreHero = hero
        topScore = score
      end
    end
  end
  return topScore, topScoreHero
end

return FormationDispatchUtil
