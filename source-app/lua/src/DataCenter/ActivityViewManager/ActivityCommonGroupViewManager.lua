local ActivityCommonGroupViewManager = BaseClass("ActivityCommonGroupViewManager")
local Localization = CS.GameEntry.Localization
local GOTO_ACTID_MAX_RECORD_NUM = 3

function ActivityCommonGroupViewManager:__init()
  self:Init()
end

function ActivityCommonGroupViewManager:__delete()
  self:Destroy()
end

function ActivityCommonGroupViewManager:Init()
  self.viewLastOpenActId = {}
  self.viewGotoActIdRecordList = {}
  self.viewActIdHaveClickHashSet = {}
end

function ActivityCommonGroupViewManager:Destroy()
  self.viewLastOpenActId = nil
  self.viewGotoActIdRecordList = nil
  self.viewActIdHaveClickHashSet = nil
end

function ActivityCommonGroupViewManager:SetLastVisitedActivityId(groupId, actId)
  self.viewLastOpenActId[groupId] = actId
end

function ActivityCommonGroupViewManager:GetLastVisitedActivityId(groupId)
  return self.viewLastOpenActId[groupId]
end

function ActivityCommonGroupViewManager:ClearAllGotoActIdList()
  self.viewGotoActIdList = {}
end

function ActivityCommonGroupViewManager:SetFirstGotoActIdList(actId)
  self:ClearAllGotoActIdList()
  self.viewGotoActIdList[1] = actId
end

function ActivityCommonGroupViewManager:AddGotoActIdList(actId)
  local curLen = #self.viewGotoActIdList
  if curLen < GOTO_ACTID_MAX_RECORD_NUM then
    self.viewGotoActIdList[curLen + 1] = actId
  else
    for i = 1, curLen - 1 do
      self.viewGotoActIdList[i] = self.viewGotoActIdList[i + 1]
    end
    self.viewGotoActIdList[curLen] = actId
  end
end

function ActivityCommonGroupViewManager:GetGotoActIdList()
  return self.viewGotoActIdList
end

function ActivityCommonGroupViewManager:SetClickActIdRecord(actId)
  self.viewActIdHaveClickHashSet[actId] = true
end

function ActivityCommonGroupViewManager:GetClickActIdRecord(actId)
  local isHaveClick = false
  if self.viewActIdHaveClickHashSet[actId] then
    isHaveClick = true
  end
  return isHaveClick
end

function ActivityCommonGroupViewManager:SetActPanelShowRecord(groupId, actId)
  self:SetClickActIdRecord(actId)
  self:SetLastVisitedActivityId(groupId, actId)
end

return ActivityCommonGroupViewManager
