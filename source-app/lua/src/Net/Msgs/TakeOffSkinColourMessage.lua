local TakeOffSkinColourMessage = BaseClass("TakeOffSkinColourMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TakeOffSkinColourMessage:OnCreate(skinId)
  base.OnCreate(self)
  self.sfsObj:PutInt("skinId", skinId)
end

function TakeOffSkinColourMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if not t.skin then
      return
    end
    DataCenter.DecorationDataManager:UpdateOnUserSkin(t.skin)
    DataCenter.DecorationDataManager:DoWhenCitySkinChange()
    EventManager:GetInstance():Broadcast(EventId.UserSkinUpdate, toInt(t.skin.type))
  end
end

return TakeOffSkinColourMessage
