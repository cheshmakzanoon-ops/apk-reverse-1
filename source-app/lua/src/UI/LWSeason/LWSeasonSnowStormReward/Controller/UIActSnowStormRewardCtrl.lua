local UIActSnowStormRewardCtrl = BaseClass("UIActSnowStormRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSnowStormReward)
end

UIActSnowStormRewardCtrl.CloseSelf = CloseSelf

function UIActSnowStormRewardCtrl:OnOpenPanel(panelType, tabType)
  if panelType == UIActSnowStormRewardPanelType.NuclearBuilding then
    local activityId = toInt(DataCenter.SeasonNuclearPowerPlantDataManager:GetBuildNuclearFurnaceActivityId())
    if activityId then
      SFSNetwork.SendMessage(MsgDefines.ViewBehemothTaskList, activityId)
    end
  end
end

function UIActSnowStormRewardCtrl:GetRewardData(panelType, tabType)
  if panelType == UIActSnowStormRewardPanelType.SnowStormReward then
    if tabType == UIActSnowStormRewardTabType.Tab1 then
      local personList = DataCenter.SeasonSnowStormDataManager.personList
      local result = {}
      for key, person in pairs(personList) do
        local isEnd = person.isStormEnd == 1
        local isAlreadyGet = person.allianceReward == 1
        local targetFinish = not (person.failAllianceTime > 0)
        local data = {}
        if isEnd and not isAlreadyGet and targetFinish then
          data.state = TaskState.CanReceive
        elseif isAlreadyGet then
          data.state = TaskState.Received
        else
          data.state = TaskState.NoComplete
          if not isEnd then
            data.reason = 0
          elseif not targetFinish then
            data.reason = 1
          end
        end
        data.configId = person.cfgId
        data.rewardShow = person.allianceRewardPreview
        data.endTime = person.endTime
        data.title = Localization:GetString("season_s2_storm_event_22")
        table.insert(result, data)
      end
      table.sort(result, function(a, b)
        return a.endTime > b.endTime
      end)
      return result
    elseif tabType == UIActSnowStormRewardTabType.Tab2 then
      local personList = DataCenter.SeasonSnowStormDataManager.personList
      local result = {}
      for key, person in pairs(personList) do
        local isEnd = person.isStormEnd == 1
        local isAlreadyGet = person.personReward == 1
        local targetFinish = not (0 < person.freezeTime)
        local data = {}
        if isEnd and not isAlreadyGet and targetFinish then
          data.state = TaskState.CanReceive
        elseif isAlreadyGet then
          data.state = TaskState.Received
        else
          data.state = TaskState.NoComplete
          if not isEnd then
            data.reason = 0
          elseif not targetFinish then
            data.reason = 1
          end
        end
        data.endTime = person.endTime
        data.configId = person.cfgId
        data.rewardShow = person.personRewardPreview
        data.title = Localization:GetString("season_s2_storm_event_21")
        table.insert(result, data)
      end
      table.sort(result, function(a, b)
        return a.endTime > b.endTime
      end)
      return result
    end
  elseif panelType == UIActSnowStormRewardPanelType.NuclearBuilding then
    local result = {}
    local dataList
    if tabType == UIActSnowStormRewardTabType.Tab1 then
      dataList = DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityTaskList(0)
    elseif tabType == UIActSnowStormRewardTabType.Tab2 then
      dataList = DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityTaskList(1)
    end
    if dataList then
      for key, value in pairs(dataList) do
        local data = {}
        data.state = value.state
        data.configId = value.taskId
        data.rewardShow = value.reward
        data.num = value.num
        data.priority = data.configId
        if data.state == TaskState.NoComplete then
          data.reason = 1
          data.priority = data.configId + 100000
        elseif data.state == TaskState.CanReceive then
          data.priority = data.configId
        elseif data.state == TaskState.Received then
          data.priority = data.configId + 200000
        end
        local config = LocalController:instance():getLine(TableName.Season_Congress_Boss_Quest, data.configId)
        local str = string.format("(%s/%s)", data.num, config.para1)
        data.title = Localization:GetString(config.des, config.para1) .. str
        table.insert(result, data)
      end
      table.sort(result, function(a, b)
        return a.priority < b.priority
      end)
    end
    return result
  end
end

function UIActSnowStormRewardCtrl:SendGetRewardMessage(panelType, tabType, cfgId)
  if DataCenter.SeasonSnowStormDataManager.curActivity and panelType == UIActSnowStormRewardPanelType.SnowStormReward then
    if tabType == UIActSnowStormRewardTabType.Tab1 then
      SFSNetwork.SendMessage(MsgDefines.ClaimStormEventAllianceReward, cfgId)
    elseif tabType == UIActSnowStormRewardTabType.Tab2 then
      SFSNetwork.SendMessage(MsgDefines.ClaimStormEventPersonReward, cfgId)
    end
  end
  if panelType == UIActSnowStormRewardPanelType.NuclearBuilding then
    local activityId = toInt(DataCenter.SeasonNuclearPowerPlantDataManager:GetBuildNuclearFurnaceActivityId())
    if 0 < activityId then
      SFSNetwork.SendMessage(MsgDefines.BehemoTaskGetReward, activityId, cfgId)
    end
  end
end

function UIActSnowStormRewardCtrl:GetTabRed(panelType, tabType)
  if DataCenter.SeasonSnowStormDataManager.curActivity and panelType == UIActSnowStormRewardPanelType.SnowStormReward then
    return false
  end
  if panelType == UIActSnowStormRewardPanelType.NuclearBuilding then
    if tabType == UIActSnowStormRewardTabType.Tab1 then
      return DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityPersonalTaskRedState()
    elseif tabType == UIActSnowStormRewardTabType.Tab2 then
      return DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityServerTaskRedState()
    end
  end
  return false
end

return UIActSnowStormRewardCtrl
