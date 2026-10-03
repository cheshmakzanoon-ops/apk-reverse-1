local UIActBountyHunterRulesCtrl = BaseClass("UIActBountyHunterRulesCtrl", UIBaseCtrl)
local Const = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/LWUIActBountyHunterRulesConstant")
local Localization = CS.GameEntry.Localization

function UIActBountyHunterRulesCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BountyHunterRules)
end

function UIActBountyHunterRulesCtrl:GetStoryText(activityInfo)
  if not activityInfo then
    return ""
  end
  local bountyHunterData = DataCenter.BountyHunterActDataManager:GetActData(tonumber(activityInfo.activityId))
  if not bountyHunterData then
    return ""
  end
  local param0 = self:GetStoryParam0(bountyHunterData)
  local param1 = self:GetStoryParam1(bountyHunterData)
  local param2 = self:GetStoryParam2(bountyHunterData)
  local param3 = self:GetStoryParam3(bountyHunterData)
  local param4 = self:GetStoryParam4(bountyHunterData)
  local param5 = self:GetStoryParam5(bountyHunterData)
  local param6 = self:GetStoryParam6(bountyHunterData)
  local param7 = self:GetStoryParam7(bountyHunterData)
  local param8 = self:GetStoryParam8(bountyHunterData)
  local param9 = self:GetStoryParam9(bountyHunterData)
  return Localization:GetString(activityInfo.story, param0, param1, param2, param3, param4, param5, param6, param7, param8, param9)
end

function UIActBountyHunterRulesCtrl:GetStoryParam0(data)
  local dropShowTemplates = data:GetAllDropShowTemplates()
  for _, v in ipairs(dropShowTemplates) do
    if v.type == Const.Type.Event_Refresh and not string.IsNullOrEmpty(v.para1) then
      local para1Split1 = string.split(v.para1, "|")
      for index, str in ipairs(para1Split1) do
        local para1Split2 = string.split(str, ";")
        if #para1Split2 == 2 and tonumber(para1Split2[1]) == 999 and tonumber(para1Split2[2]) == 1 then
          local dropShowData = v:GetPara3ProbabilityData()
          if dropShowData and dropShowData[index] then
            return string.formatDecimalDown(dropShowData[index] / 10000 * 100, 1)
          end
        end
      end
    end
  end
  return ""
end

function UIActBountyHunterRulesCtrl:GetStoryParam1(data)
  local dropShowTemplates = data:GetAllDropShowTemplates()
  for _, v in ipairs(dropShowTemplates) do
    if v.type == Const.Type.Event_Refresh and not string.IsNullOrEmpty(v.para1) then
      local para1Split1 = string.split(v.para1, "|")
      for index, str in ipairs(para1Split1) do
        local para1Split2 = string.split(str, ";")
        if #para1Split2 == 2 and tonumber(para1Split2[1]) == 999 and tonumber(para1Split2[2]) == 7 then
          local dropShowData = v:GetPara3ProbabilityData()
          if dropShowData and dropShowData[index] then
            return string.formatDecimalDown(dropShowData[index] / 10000 * 100, 1)
          end
        end
      end
    end
  end
  return ""
end

function UIActBountyHunterRulesCtrl:GetStoryParam2(data)
  local eventLimitDic = data.hunterActTmpParaData and data.hunterActTmpParaData.event_daily_maxnum
  if not eventLimitDic then
    return ""
  end
  return eventLimitDic[BountyHunterEventType4Server.Shop] or ""
end

function UIActBountyHunterRulesCtrl:GetStoryParam3(data)
  if data.hunterActTmpData and data.hunterActTmpData.refresh_item then
    return DataCenter.ItemTemplateManager:GetName(data.hunterActTmpData.refresh_item)
  end
  return ""
end

function UIActBountyHunterRulesCtrl:GetStoryParam4(data)
  if data.hunterActTmpData and data.hunterActTmpData.time_recoverytimes then
    return tostring(data.hunterActTmpData.time_recoverytimes)
  end
  return ""
end

function UIActBountyHunterRulesCtrl:GetStoryParam5(data)
  return self:GetStoryParam3(data)
end

function UIActBountyHunterRulesCtrl:GetStoryParam6(data)
  if data.hunterActTmpData and data.hunterActTmpData.max_times then
    return tostring(data.hunterActTmpData.max_times)
  end
  return ""
end

function UIActBountyHunterRulesCtrl:GetStoryParam7(data)
  return self:GetStoryParam3(data)
end

function UIActBountyHunterRulesCtrl:GetStoryParam8(data)
  if data.hunterActTmpData and data.hunterActTmpData.cost_num and data.hunterActTmpData.add_score then
    return tostring(data.hunterActTmpData.cost_num * data.hunterActTmpData.add_score)
  end
  return ""
end

function UIActBountyHunterRulesCtrl:GetStoryParam9(data)
  local nextBossCount = data:GetNextBossCount()
  return tostring(nextBossCount)
end

return UIActBountyHunterRulesCtrl
