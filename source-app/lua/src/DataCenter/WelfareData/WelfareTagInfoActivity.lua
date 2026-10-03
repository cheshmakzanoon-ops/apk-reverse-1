local WelfareTagInfoActivity = BaseClass("WelfareTagInfoActivity", WelfareTagInfo)
local M = WelfareTagInfoActivity
local Timer = CS.GameEntry.Timer

function M:ctor()
  WelfareTagInfo.ctor(self)
  self.activityList = {}
  self.nowActivity = nil
end

function M:parse(data)
  WelfareTagInfo.parse(self, data)
  local _para1 = data.para1
  if _para1 ~= nil and _para1 ~= "" then
    self.activityList = string.split(_para1, "|")
  end
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
  if self.nowActivity ~= nil and self.nowActivity:IsValid() then
    return self.nowActivity
  end
  if not table.IsNullOrEmpty(self.activityList) then
    for _, v in pairs(self.activityList) do
      local info = DataCenter.ActivityListDataManager:GetActivityDataById(v)
      if info ~= nil and info:IsValid() then
        self.nowActivity = info
        break
      end
    end
  end
  return self.nowActivity
end

function M:isShowIcon()
  local actData = self:getInfo()
  return actData ~= nil and actData:IsValid()
end

function M:getName()
  local actData = self:getInfo()
  if actData ~= nil and actData:IsValid() then
    return actData.name
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

return M
