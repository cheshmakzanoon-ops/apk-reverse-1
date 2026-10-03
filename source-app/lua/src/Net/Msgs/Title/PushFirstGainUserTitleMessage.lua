local PushFirstGainUserTitleMessage = BaseClass("PushFirstGainUserTitleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFirstGainUserTitleMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushFirstGainUserTitleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.PlayerInfoDataManager:ChangeSelfTitlePosition(t.cfg_id, t.position)
  EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc, LuaEntry.Player.uid)
  SFSNetwork.SendMessage(MsgDefines.UserTitleGetList)
end

return PushFirstGainUserTitleMessage
