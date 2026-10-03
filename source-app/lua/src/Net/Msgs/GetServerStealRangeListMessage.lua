local GetServerStealRangeListMessage = BaseClass("GetServerStealRangeListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetServerStealRangeListMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetServerStealRangeListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActGhostreconManager:OnStealRangeUpdate(t)
  end
end

return GetServerStealRangeListMessage
