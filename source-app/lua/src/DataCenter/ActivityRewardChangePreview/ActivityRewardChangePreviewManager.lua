local ActivityRewardChangePreviewManager = BaseClass("ActivityRewardChangePreviewManager")
local Localization = CS.GameEntry.Localization
local ActivityRewardChangeTemplate = require("DataCenter/ActivityRewardChangePreview/ActivityRewardChangeTemplate")
ActivityRewardChangePreviewManager.ShowCondition2Type = {
  Type_8 = 8,
  Type_9 = 9,
  Type_144 = 144,
  Type_149 = 149,
  Type_150 = 150
}
ActivityRewardChangePreviewManager.ChangeType = {
  New = 1,
  Update = 2,
  DailyAct_Update = 4,
  DailyAct_New = 5,
  WeekCard_New = 6
}
ActivityRewardChangePreviewManager.PrefKey = "activity_reward_change_review_has_shown_"
ActivityRewardChangePreviewManager.AnimPrefKey = "activity_reward_change_review_has_shown_anim_"

function ActivityRewardChangePreviewManager:__init()
end

function ActivityRewardChangePreviewManager:__delete()
end

function ActivityRewardChangePreviewManager:IsHasShownDetailByActivityInfo(activityInfo)
  local key = self.PrefKey .. tostring(activityInfo.id) .. "_" .. tostring(activityInfo:GetShowStartTime())
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function ActivityRewardChangePreviewManager:SetHasShownDetailByActivityInfo(activityInfo)
  local key = self.PrefKey .. tostring(activityInfo.id) .. "_" .. tostring(activityInfo:GetShowStartTime())
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():Broadcast(EventId.RefreshMainUIDailyPackBtnNewTag)
end

function ActivityRewardChangePreviewManager:IsHasShownAnimByActivityInfo(activityInfo)
  if activityInfo == nil then
    return true
  end
  local showTemplates = self:GetRewardChangeTemplatesByActivityInfo(activityInfo)
  local key
  if not table.IsNullOrEmpty(showTemplates) then
    local type = showTemplates[1].change_type
    if type == ActivityRewardChangePreviewManager.ChangeType.DailyAct_Update or type == ActivityRewardChangePreviewManager.ChangeType.DailyAct_New then
      key = self.AnimPrefKey .. tostring(activityInfo.id)
    else
      key = self.AnimPrefKey .. tostring(activityInfo.id) .. "_" .. tostring(activityInfo:GetShowStartTime())
    end
  else
    key = self.AnimPrefKey .. tostring(activityInfo.id) .. "_" .. tostring(activityInfo:GetShowStartTime())
  end
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function ActivityRewardChangePreviewManager:SetHasShownAnimByActivityInfo(activityInfo)
  if activityInfo == nil then
    return
  end
  local showTemplates = self:GetRewardChangeTemplatesByActivityInfo(activityInfo)
  local key
  if not table.IsNullOrEmpty(showTemplates) then
    local type = showTemplates[1].change_type
    if type == ActivityRewardChangePreviewManager.ChangeType.DailyAct_Update or type == ActivityRewardChangePreviewManager.ChangeType.DailyAct_New then
      key = self.AnimPrefKey .. tostring(activityInfo.id)
    else
      key = self.AnimPrefKey .. tostring(activityInfo.id) .. "_" .. tostring(activityInfo:GetShowStartTime())
    end
  else
    key = self.AnimPrefKey .. tostring(activityInfo.id) .. "_" .. tostring(activityInfo:GetShowStartTime())
  end
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function ActivityRewardChangePreviewManager:IsShowNewTagByActivityInfo(activityInfo)
  if activityInfo == nil then
    return false
  end
  local showTemplates = self:GetRewardChangeTemplatesByActivityInfo(activityInfo)
  if not table.IsNullOrEmpty(showTemplates) and not self:IsHasShownDetailByActivityInfo(activityInfo) then
    return true
  end
  return false
end

function ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByChangeType(activityInfo, changeType)
  if activityInfo == nil or activityInfo.GetRewardChangeGroup == nil then
    return nil
  end
  local group = activityInfo:GetRewardChangeGroup()
  if group <= 0 then
    return nil
  end
  local res = {}
  local allTemplates = self:GetAllRewardChargeTemplatesByGroup(group)
  for i, v in ipairs(allTemplates) do
    if v.change_type == changeType and v:IsShowActivity(activityInfo) then
      table.insert(res, v)
    end
  end
  return res
end

function ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByActivityInfo(activityInfo)
  if activityInfo == nil or activityInfo.GetRewardChangeGroup == nil then
    return nil
  end
  local group = activityInfo:GetRewardChangeGroup()
  if group <= 0 then
    return nil
  end
  local res = {}
  local allTemplates = self:GetAllRewardChargeTemplatesByGroup(group)
  for i, v in ipairs(allTemplates) do
    if v:IsShowActivity(activityInfo) then
      table.insert(res, v)
    end
  end
  return res
end

function ActivityRewardChangePreviewManager:GetAllRewardChargeTemplatesByGroup(group)
  local res = {}
  LocalController:instance():visitTable(TableName.ACTIVITY_REWARD_CHANGE, function(id, lineData)
    if lineData ~= nil and lineData.group == group then
      local template = ActivityRewardChangeTemplate.New()
      template:UpdateData(lineData)
      table.insert(res, template)
    end
  end)
  return res
end

return ActivityRewardChangePreviewManager
