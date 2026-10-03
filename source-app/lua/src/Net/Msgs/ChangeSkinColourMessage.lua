local ChangeSkinColourMessage = BaseClass("ChangeSkinColourMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ChangeSkinColourMessage:OnCreate(skinId, colourId)
  base.OnCreate(self)
  self.sfsObj:PutInt("skinId", skinId)
  self.sfsObj:PutInt("colourId", colourId)
end

function ChangeSkinColourMessage:HandleMessage(t)
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

return ChangeSkinColourMessage
