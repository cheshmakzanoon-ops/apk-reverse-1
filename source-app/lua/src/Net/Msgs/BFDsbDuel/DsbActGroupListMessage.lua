local DsbActGroupListMessage = BaseClass("DsbActGroupListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActGroupListMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", param.group)
end

function DsbActGroupListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActGroupListMsg(t)
  end
end

return DsbActGroupListMessage
