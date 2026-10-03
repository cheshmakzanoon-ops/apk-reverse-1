local DsbOperateLogListMessage = BaseClass("DsbOperateLogListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbOperateLogListMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbOperateLogListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActOperatorLogListMsg(t)
  end
end

return DsbOperateLogListMessage
