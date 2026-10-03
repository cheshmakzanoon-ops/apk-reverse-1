local UserTitleSetPopUpStateMessage = BaseClass("UserTitleSetPopUpStateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserTitleSetPopUpStateMessage:OnCreate(cfgId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cfgId", cfgId)
end

function UserTitleSetPopUpStateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.PlayerInfoDataManager:UpdateTitle(t)
end

return UserTitleSetPopUpStateMessage
