local QuitWolfMessage = BaseClass("QuitWolfMessage", SFSBaseMessage)
local base = SFSBaseMessage

function QuitWolfMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutBool("success", true)
end

function QuitWolfMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

function QuitWolfMessage:GetTestData()
  SFSNetwork.SendMessage(MsgDefines.PushSeasonHunterBattleResult)
  return {success = true}
end

return QuitWolfMessage
