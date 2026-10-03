local PushThumbsUpMessage = BaseClass("PushThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushThumbsUpMessage:OnCreate()
  base.OnCreate(self)
end

function PushThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWPlayerDetail)
    if window ~= nil and window.View ~= nil then
      SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, LuaEntry.Player.uid)
    end
  end
end

return PushThumbsUpMessage
