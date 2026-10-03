local SetHeadPicFromPhotoAlbumMessage = BaseClass("SetHeadPicFromPhotoAlbumMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SetHeadPicFromPhotoAlbumMessage:OnCreate(slotId)
  base.OnCreate(self)
  self.sfsObj:PutInt("slotId", slotId)
end

function SetHeadPicFromPhotoAlbumMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.picVer or t.pic then
      LuaEntry.Player:UpdatePic(t)
      EventManager:GetInstance():Broadcast(EventId.UpdatePlayerHeadIcon)
    else
    end
  end
  SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, LuaEntry.Player.uid)
end

return SetHeadPicFromPhotoAlbumMessage
