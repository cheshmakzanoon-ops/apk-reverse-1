local LWUICityBreachCtrl = BaseClass("LWUICityBreachCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, uuid)
  SFSNetwork.SendMessage(MsgDefines.RecCityBrokenReward, uuid)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUICityBreach)
end

local function GetNameStr(severId, abbr, name)
  local nameStr = "#%s %s"
  if string.IsNullOrEmpty(abbr) then
    nameStr = string.format(nameStr, severId, name)
  else
    nameStr = "#%s[%s]%s"
    nameStr = string.format(nameStr, severId, abbr, name)
  end
  return nameStr
end

local function GetViewInfo(param)
  local viewInfo = {}
  if param.createTime then
    viewInfo.timeInfoText = Localization:GetString("801332", UITimeManager:GetInstance():TimeStampToTimeForLocal(param.createTime))
  end
  viewInfo.acttackInfoList = {}
  local info = {}
  if param.enemyNum and param.atkCount then
    info = {}
    info.isShow = true
    info.text = Localization:GetString("801333", param.enemyNum, param.atkCount)
    info.type = "allActtack"
    table.insert(viewInfo.acttackInfoList, info)
    info.index = #viewInfo.acttackInfoList
  end
  if param.atkUser then
    info = {}
    info.type = "acttack"
    local nameStr = GetNameStr(param.atkUser.serverId, param.atkUser.abbr, param.atkUser.name)
    info.text = Localization:GetString("801334", nameStr, param.atkUser.atkCount)
    table.insert(viewInfo.acttackInfoList, info)
    info.index = #viewInfo.acttackInfoList
  end
  if param.winDefCount and param.winDefCount > 0 then
    info = {}
    info.type = "win"
    info.text = Localization:GetString("801335", param.winDefCount)
    table.insert(viewInfo.acttackInfoList, info)
    info.index = #viewInfo.acttackInfoList
  end
  if param.defUsers and 0 < #param.defUsers then
    info = {}
    info.type = "assistance"
    info.text = Localization:GetString("801336", #param.defUsers)
    info.assistanceDatas = param.defUsers
    table.insert(viewInfo.acttackInfoList, info)
    info.index = #viewInfo.acttackInfoList
  end
  if not string.IsNullOrEmpty(param.leaderName) then
    local name = GetNameStr(param.leaderServerId, param.leaderAbbr, param.leaderName)
    viewInfo.comfortText = Localization:GetString("801337", name)
  else
    viewInfo.comfortText = Localization:GetString("801342")
  end
  viewInfo.uuid = param.uuid
  viewInfo.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(param.reward)
  return viewInfo
end

LWUICityBreachCtrl.CloseSelf = CloseSelf
LWUICityBreachCtrl.GetViewInfo = GetViewInfo
return LWUICityBreachCtrl
