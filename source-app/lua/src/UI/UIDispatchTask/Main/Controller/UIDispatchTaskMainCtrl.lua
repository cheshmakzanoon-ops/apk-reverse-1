local UIDispatchTaskMainCtrl = BaseClass("UIDispatchTaskMainCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIDispatchTaskMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispatchTaskMain, {anim = false})
end

function UIDispatchTaskMainCtrl:InitData()
  self:SetCurrentActivityId("")
end

function UIDispatchTaskMainCtrl:SetCurrentActivityId(id)
  self.activityId = id
end

function UIDispatchTaskMainCtrl:GetCurrentActivityId()
  return self.activityId
end

function UIDispatchTaskMainCtrl:GetGroupList()
  return DataCenter.ActivityListDataManager:GetDispatchGroupList()
end

function UIDispatchTaskMainCtrl:GetDefaultFocusActivity(groupList, goId)
  local targetActId
  local targetActivityDaily = 0
  if goId then
    targetActId = tostring(goId)
    local tempInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(goId))
    if tempInfo and tempInfo.activity_daily then
      targetActivityDaily = tempInfo.activity_daily
    end
  else
    local firstActId
    for i, v in ipairs(groupList) do
      if targetActId then
        break
      end
      if not firstActId then
        firstActId = v.id
        break
      end
    end
    targetActId = targetActId or firstActId
  end
  local isTrigger, actId = DataCenter.ActGhostreconManager:GetNeedShowGuide()
  if isTrigger then
    targetActId = actId
  end
  for i, v in ipairs(groupList) do
    if v.id == targetActId then
      return v.id, i
    end
  end
end

function UIDispatchTaskMainCtrl:GetActivityDataById(id)
  local oneData = {}
  oneData.id = id
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(id)
  if data ~= nil then
    oneData.name = Localization:GetString(data.name)
    oneData.type = data.type
    local total, rewardCount, tipCount = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(data.type, data.id)
    oneData.canGet = total
    oneData.rewardCount = rewardCount
    oneData.tipCount = tipCount
    oneData.activityId = data.activityId == "" and data.id or data.activityId
    oneData.list_icon = data.list_icon
    oneData.tabGroup = data.tabGroup
    oneData.tabGroupOrder = data.tabGroupOrder
    oneData.subViewType = data.subViewType
  end
  return oneData
end

function UIDispatchTaskMainCtrl:GetCurrentActivity()
  local actId = self:GetCurrentActivityId()
  local data = self:GetActivityDataById(actId)
  return data
end

function UIDispatchTaskMainCtrl:GetGhostMainShow()
  return self.ghostMainShow
end

function UIDispatchTaskMainCtrl:SetGhostMainShow(isShow)
  self.ghostMainShow = isShow
end

return UIDispatchTaskMainCtrl
