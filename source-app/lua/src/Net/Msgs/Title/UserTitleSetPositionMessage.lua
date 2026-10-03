local UserTitleSetPositionMessage = BaseClass("UserTitleSetPositionMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserTitleSetPositionMessage:OnCreate(position, cfgId, down)
  base.OnCreate(self)
  self.sfsObj:PutInt("cfgId", cfgId)
  self.sfsObj:PutInt("type", down and 2 or 1)
  self.sfsObj:PutInt("position", position)
end

function UserTitleSetPositionMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.PlayerInfoDataManager:ChangeSelfTitlePosition(t.cfgId, t.position)
  SFSNetwork.SendMessage(MsgDefines.UserTitleGetList)
end

return UserTitleSetPositionMessage
