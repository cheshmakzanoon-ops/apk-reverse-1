local WelfareTagInfoSingleActivity = BaseClass("WelfareTagInfoSingleActivity", WelfareTagInfo)
local M = WelfareTagInfoSingleActivity
local Timer = CS.GameEntry.Timer

function M:ctor()
  WelfareTagInfo.ctor(self)
end

function M:parse(data)
  local activityId = data.id
  self._type = WelfareTagType.SingleActivity
  self._id = string.format("%s_%s", self._type, activityId)
  self._activityId = activityId
  self._entryType = data.entry_type
  self._activityOrder = data.order
  self._order = data.order
  self._name = data.name
  self._icon = data.icon
  self._activityType = data.type
end

function M:GetActivityType()
  return self._activityType
end

function M:isShow()
  local info = self:getInfo()
  return info ~= nil and info:IsValid()
end

function M:hasRedPoint()
  local redNum = self:getRedDotNum()
  return 0 < redNum
end

function M:getRedDotNum()
  local actData = self:getInfo()
  if actData ~= nil and actData:IsValid() then
    local num = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(actData.type, actData.id)
    return num
  end
  return 0
end

function M:getInfo()
  local info = DataCenter.ActivityListDataManager:GetActivityDataById(self._activityId)
  if info ~= nil and info:IsValid() then
    return info
  end
  return nil
end

function M:isShowIcon()
  local actData = self:getInfo()
  return actData ~= nil and actData:IsValid()
end

function M:getName()
  local actData = self:getInfo()
  if actData ~= nil and actData:IsValid() then
    local actName = actData.name
    if actData.type == EnumActivity.HeroMonthCard.Type then
      local groupId = actData.subType
      local monthActivityId = DataCenter.HeroMonthCardManager:GetActivityIdByGroupId(groupId)
      if monthActivityId and 0 < monthActivityId then
        local template = DataCenter.HeroMonthCardManager:GetTemplate(monthActivityId)
        if template then
          actName = template.name
        end
      end
    end
    return actName
  end
  return ""
end

function M:getIconName()
  local actData = self:getInfo()
  if actData ~= nil and actData:IsValid() then
    return actData.list_icon
  end
  return ""
end

function M:CheckIfIsToEnd()
  local actData = self:getInfo()
  if actData ~= nil and actData:IsValid() then
    return actData:CheckIfIsToEnd()
  end
  return false
end

function M:CanShowNewTag()
  local actData = self:getInfo()
  if actData ~= nil and actData:IsValid() and actData.CanShowNewTag ~= nil and actData:CanShowNewTag() == true then
    return true
  end
  return false
end

return M
