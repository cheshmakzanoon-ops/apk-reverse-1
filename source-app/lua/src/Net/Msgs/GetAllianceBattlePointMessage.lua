local GetAllianceBattlePointMessage = BaseClass("GetAllianceBattlePointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceBattlePointMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetAllianceBattlePointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.pointArr then
    DataCenter.AllianceCompeteDataManager:HandleGetAllianceBattlePointMessage(t.pointArr)
  end
end

return GetAllianceBattlePointMessage
