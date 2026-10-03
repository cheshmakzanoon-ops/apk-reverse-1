local UIFormationDispatchTaskCtrl = BaseClass("UIFormationDispatchTaskCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local FormationDispatchUtil = require("UI.UIFormation.UIFormationDispatchTask.FormationDispatchUtil")
local WAIT_RALLY = MarchStatus.WAIT_RALLY
local IN_TEAM = MarchStatus.IN_TEAM

function UIFormationDispatchTaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationDispatchTask)
end

function UIFormationDispatchTaskCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIFormationDispatchTaskCtrl:GetHeroList(taskInfo)
  DataCenter.ActDispatchTaskDataManager:ParseTaskCondition(taskInfo)
  local parsed_conditions = taskInfo.cfg.parsed_conditions
  local cond1Param, cond2Param, cond3Param, cond4Param
  for k, v in pairs(parsed_conditions) do
    if k == 1 then
      cond1Param = v[1]
    elseif k == 2 then
      cond2Param = v[1]
    elseif k == 3 then
      cond3Param = v[1]
    elseif k == 4 then
      cond4Param = v[1]
    end
  end
  local heroList = {}
  local usedHeroList = DataCenter.ActDispatchTaskDataManager:GetAllUsedHeroList()
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  for uuid, heroData in pairs(heroDataList) do
    if table.indexof(usedHeroList, uuid) == false then
      if cond1Param and heroData.heroType == cond1Param then
        table.insert(heroList, heroData)
      elseif cond2Param and cond2Param <= heroData.quality then
        table.insert(heroList, heroData)
      elseif cond3Param and cond3Param <= heroData:GetRank() then
        table.insert(heroList, heroData)
      elseif cond4Param and cond4Param <= heroData.level then
        table.insert(heroList, heroData)
      end
    end
  end
  table.sort(heroList, function(a, b)
    return a.power > b.power
  end)
  return heroList
end

function UIFormationDispatchTaskCtrl:GetRecommendHeroList(taskInfo)
  DataCenter.ActDispatchTaskDataManager:ParseTaskCondition(taskInfo)
  local parsed_conditions = taskInfo.cfg.parsed_conditions
  local cond1Param, cond2Param, cond3Param, cond4Param
  local cond_count = 0
  for k, v in pairs(parsed_conditions) do
    if k == 1 then
      cond_count = cond_count + 1
      cond1Param = {
        data = v[1],
        count = v[2],
        heroList = {},
        heroCount = 0
      }
    elseif k == 2 then
      cond_count = cond_count + 1
      cond2Param = {
        data = v[1],
        count = v[2],
        heroList = {},
        heroCount = 0
      }
    elseif k == 3 then
      cond_count = cond_count + 1
      cond3Param = {
        data = v[1],
        count = v[2],
        heroList = {},
        heroCount = 0
      }
    elseif k == 4 then
      cond_count = cond_count + 1
      cond4Param = {
        data = v[1],
        count = v[2],
        heroList = {},
        heroCount = 0
      }
    end
  end
  local usedHeroList = DataCenter.ActDispatchTaskDataManager:GetAllUsedHeroList()
  return FormationDispatchUtil.GetRecommendHeroList(usedHeroList, cond_count, cond1Param, cond2Param, cond3Param, cond4Param)
end

return UIFormationDispatchTaskCtrl
