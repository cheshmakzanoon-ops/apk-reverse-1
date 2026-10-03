local UserTitleGetDetailMessage = BaseClass("UserTitleGetDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local __uid

function UserTitleGetDetailMessage:OnCreate(cfgId, uid_)
  base.OnCreate(self)
  uid_ = uid_ or LuaEntry.Player.uid
  self.sfsObj:PutUtfString("uid", uid_)
  self.sfsObj:PutInt("cfgId", cfgId)
  __uid = uid_
end

function UserTitleGetDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.uid == nil then
    t.uid = __uid
  end
  if t.cfgId then
    if not t.endTime or t.endTime <= 0 or t.endTime > UITimeManager:GetInstance():GetServerTime() then
      DataCenter.PlayerInfoDataManager:UpdateTitle(t)
    else
    end
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPlayerTitleDetail) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerTitleDetail, {anim = true}, t.uid, t.cfgId, t)
    end
    EventManager:GetInstance():Broadcast(EventId.UserTitleDetail, t)
  else
    UIUtil.ShowTipsId("lw_title_ui_17")
  end
end

return UserTitleGetDetailMessage
