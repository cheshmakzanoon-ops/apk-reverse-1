local PushUserCardBoxCreateMessage = BaseClass("PushUserCardBoxCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserCardBoxCreateMessage:OnCreate()
  base.OnCreate(self)
end

function PushUserCardBoxCreateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    SFSNetwork.SendMessage(MsgDefines.FetchUserCardBoxList)
  end
end

return PushUserCardBoxCreateMessage
