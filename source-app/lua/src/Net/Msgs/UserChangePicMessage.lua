local UserChangePicMessage = BaseClass("UserChangePicMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local localPic

local function OnCreate(self, pic)
  base.OnCreate(self)
  localPic = pic
  self.sfsObj:PutUtfString("pic", pic)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    if t.lastUpdateTime then
      LuaEntry.Player:SetLastUpdateTime(t.lastUpdateTime)
    end
    UIUtil.ShowTipsId(128135)
    LuaEntry.Player:SetPic(localPic)
    EventManager:GetInstance():Broadcast(EventId.UpdatePlayerHeadIcon, localPic)
    local uid = LuaEntry.Player.uid
    local userMgr = ChatManager2:GetInstance().User
    local userInfo = userMgr:getChatUserInfo(uid)
    userInfo.info_ok = false
    userMgr:requestSingleUserInfo(uid)
  else
    print(errCode)
  end
end

UserChangePicMessage.OnCreate = OnCreate
UserChangePicMessage.HandleMessage = HandleMessage
return UserChangePicMessage
