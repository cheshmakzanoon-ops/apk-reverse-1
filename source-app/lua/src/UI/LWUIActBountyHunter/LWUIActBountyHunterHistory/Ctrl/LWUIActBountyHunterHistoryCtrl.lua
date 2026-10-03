local LWUIActBountyHunterHistoryCtrl = BaseClass("LWUIActBountyHunterHistoryCtrl", UIBaseCtrl)
local NormalCard = require("UI.LWUIActBountyHunter.LWUIActBountyHunterReward.Component.BountyHunterNormalLogCardComponent")

function LWUIActBountyHunterHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActBountyHunterHistory)
end

function LWUIActBountyHunterHistoryCtrl:GetBatLogData(activityId)
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return
  end
  local batLogDataList = actData:GetBatLogData()
  return batLogDataList
end

function LWUIActBountyHunterHistoryCtrl:ReqBatLogData(activityId)
  SFSNetwork.SendMessage(MsgDefines.BountyHunterGetLogInfo, activityId)
end

function LWUIActBountyHunterHistoryCtrl:GetBatLogDataCnt(activityId)
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return 0
  end
  local realCount = #actData.batLogArr or 0
  local maxLimit = actData:GetBatLogShowCountLimit()
  if 0 <= maxLimit and realCount > maxLimit then
    return maxLimit
  end
  return realCount
end

function LWUIActBountyHunterHistoryCtrl:GetItemByIndex(activityId, index)
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return
  end
  return actData.batLogArr[index]
end

function LWUIActBountyHunterHistoryCtrl:GetPrefabAndScriptName(data)
  if not data then
    return
  end
  local prefabName = "BountyHunterNormalLogCard"
  local scriptName = NormalCard
  local configId = data.confId
  if data.type ~= BountyHunterLogType.SUPER_SHOOT_FREE_CHEST and data.type ~= BountyHunterLogType.SUPER_SHOOT_NORMAL_MONSTER and data.type ~= BountyHunterLogType.SUPER_SHOOT_FLY_MONSTER then
    local lineData = LocalController:instance():tryGetLine(TableName.Bounty_Monster, configId)
    if lineData and lineData.type == BountyMonsterQualityType.Boss then
      prefabName = "BountyHunterBossLogCard"
    end
  end
  return prefabName, scriptName
end

function LWUIActBountyHunterHistoryCtrl:ReqClaimStashReward(activityId)
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return
  end
  local curStashReward = actData:GetCurStashRewardData()
  if not curStashReward or #curStashReward <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BountyHunterReceiveDropReward, activityId)
end

return LWUIActBountyHunterHistoryCtrl
