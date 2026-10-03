local base = UIAsyncContainer
local ActDownloadNodeBase = BaseClass("ActDownloadNodeBase", base)

function ActDownloadNodeBase:OnCreate()
  base.OnCreate(self)
end

function ActDownloadNodeBase:SetData(activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self:EntranceReEnter()
  self:RefreshView()
end

function ActDownloadNodeBase:EntranceReEnter()
  local actType = self:GetActType()
  RaceEntranceUtil.SignUnlock(actType)
  RaceEntranceUtil.SignNew(actType)
  self:OnEnterNode()
end

function ActDownloadNodeBase:GetActType()
  return 0
end

function ActDownloadNodeBase:OnEnterNode()
end

return ActDownloadNodeBase
