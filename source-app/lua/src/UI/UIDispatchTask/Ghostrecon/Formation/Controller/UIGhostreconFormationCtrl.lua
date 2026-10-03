local UIGhostreconFormationCtrl = BaseClass("UIGhostreconFormationCtrl", UIBaseCtrl)
local FormationDispatchUtil = require("UI.UIFormation.UIFormationDispatchTask.FormationDispatchUtil")

local function GetHeroList(self, cfg)
  local parsed_conditions = cfg.conditions
  local cond1Param, cond2Param, cond3Param, cond4Param
  for _, v in pairs(parsed_conditions) do
    local k = v.type
    if k == 1 then
      cond1Param = v.value
    elseif k == 2 then
      cond2Param = v.value
    elseif k == 3 then
      cond3Param = v.value
    elseif k == 4 then
      cond4Param = v.value
    end
  end
  local heroList = {}
  local usedHeroList, usedHeroUUidList = DataCenter.ActGhostreconManager:GetAllUsedHeroList()
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  for uuid, heroData in pairs(heroDataList) do
    local canUse = true
    if 0 < #usedHeroUUidList then
      canUse = table.indexof(usedHeroUUidList, uuid) == false
    else
      canUse = table.indexof(usedHeroList, heroData.heroId) == false
    end
    if canUse then
      if cond1Param and heroData.heroType == cond1Param then
        table.insert(heroList, heroData)
      elseif cond2Param and cond2Param <= heroData.quality then
        table.insert(heroList, heroData)
      elseif cond3Param and cond3Param <= heroData:GetRank() then
        table.insert(heroList, heroData)
      elseif cond4Param and cond4Param <= heroData.level then
        table.insert(heroList, heroData)
      elseif cfg:CheckHeroMeetSuperCondions(heroData) then
        table.insert(heroList, heroData)
      end
    end
  end
  table.sort(heroList, function(a, b)
    return a.power > b.power
  end)
  return heroList
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconFormation)
end

local function GetRecommendHeroList(self, cfg, teamMeetSuperCondionNums)
  local parsed_conditions = cfg.conditions
  local cond1Param, cond2Param, cond3Param, cond4Param
  local cond_count = 0
  for _, v in pairs(parsed_conditions) do
    local k = v.type
    if k == 1 then
      cond_count = cond_count + 1
      cond1Param = {
        data = v.value,
        count = v.num,
        heroList = {},
        heroCount = 0
      }
    elseif k == 2 then
      cond_count = cond_count + 1
      cond2Param = {
        data = v.value,
        count = v.num,
        heroList = {},
        heroCount = 0
      }
    elseif k == 3 then
      cond_count = cond_count + 1
      cond3Param = {
        data = v.value,
        count = v.num,
        heroList = {},
        heroCount = 0
      }
    elseif k == 4 then
      cond_count = cond_count + 1
      cond4Param = {
        data = v.value,
        count = v.num,
        heroList = {},
        heroCount = 0
      }
    end
  end
  local usedHeroList, usedHeroUUidList = DataCenter.ActGhostreconManager:GetAllUsedHeroList()
  if 0 < #usedHeroUUidList then
    return FormationDispatchUtil.GetRecommendHeroList(usedHeroUUidList, cond_count, cond1Param, cond2Param, cond3Param, cond4Param, function(heroData)
      local isMeet = false
      if cfg.superCondions and #cfg.superCondions > 0 then
        for index, value in ipairs(cfg.superCondions) do
          if teamMeetSuperCondionNums and teamMeetSuperCondionNums[index] < value.num and cfg:CheckHeroMeetSuperCondion(index, heroData) then
            isMeet = true
            break
          end
        end
      end
      return isMeet
    end)
  else
    return FormationDispatchUtil.GetRecommendHeroList(usedHeroList, cond_count, cond1Param, cond2Param, cond3Param, cond4Param, function(heroData)
      local isMeet = false
      if cfg.superCondions and #cfg.superCondions > 0 then
        for index, value in ipairs(cfg.superCondions) do
          if teamMeetSuperCondionNums and teamMeetSuperCondionNums[index] < value.num and cfg:CheckHeroMeetSuperCondion(index, heroData) then
            isMeet = true
            break
          end
        end
      end
      return isMeet
    end, true)
  end
end

UIGhostreconFormationCtrl.GetHeroList = GetHeroList
UIGhostreconFormationCtrl.CloseSelf = CloseSelf
UIGhostreconFormationCtrl.GetRecommendHeroList = GetRecommendHeroList
return UIGhostreconFormationCtrl
