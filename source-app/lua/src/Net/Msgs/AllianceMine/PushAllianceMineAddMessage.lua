local PushAllianceMineAddMessage = BaseClass("PushAllianceMineAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceMineAddMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceMineAddMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMineManager:AddOneAllianceMineInfo(t)
  end
end

return PushAllianceMineAddMessage
