local GetAllAllianceMineListMessage = BaseClass("GetAllAllianceMineListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllAllianceMineListMessage:OnCreate(needDetail)
  base.OnCreate(self)
  self.sfsObj:PutBool("needDetail", needDetail or false)
end

function GetAllAllianceMineListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMineManager:UpdateAllianceMineInfo(t)
  end
end

return GetAllAllianceMineListMessage
