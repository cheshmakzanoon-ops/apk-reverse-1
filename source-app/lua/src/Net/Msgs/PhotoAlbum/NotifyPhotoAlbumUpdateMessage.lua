local NotifyPhotoAlbumUpdateMessage = BaseClass("NotifyPhotoAlbumUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function NotifyPhotoAlbumUpdateMessage:OnCreate(slotId, photoVer)
  base.OnCreate(self)
  self.sfsObj:PutInt("slotId", slotId)
  self.sfsObj:PutInt("photoVer", photoVer)
end

function NotifyPhotoAlbumUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.expireTime then
      local second = UITimeManager:GetInstance():SecondToFmtString(tonumber(t.expireTime))
      local lang = Localization:GetString(errCode, second)
      UIUtil.ShowTips(lang or errCode)
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    if t.photoAlbumStrDes then
    else
    end
  end
  SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, LuaEntry.Player.uid)
end

return NotifyPhotoAlbumUpdateMessage
