local GetAllianceShareMissionListMessage = BaseClass("GetAllianceShareMissionListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceShareMissionListMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetAllianceShareMissionListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDispatchTaskDataManager:OnGetMarkListCallback(t)
  end
end

return GetAllianceShareMissionListMessage
