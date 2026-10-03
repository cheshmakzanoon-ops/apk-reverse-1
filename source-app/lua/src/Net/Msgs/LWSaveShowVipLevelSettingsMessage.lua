local LWSaveShowVipLevelSettingsMessage = BaseClass("LWSaveShowVipLevelSettingsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, isVipShow)
  base.OnCreate(self)
  if ChatInterface.GetisTestUid(LuaEntry.Player.uid) then
    Logger.LogError("vipShow Change  ---->  isVipShow:  " .. tostring(isVipShow))
  end
  self.sfsObj:PutInt("isVipShow", isVipShow)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t and t.isVipShow then
    ChatManager2:GetInstance().User:ChangeUserInfo({
      uid = LuaEntry.Player.uid,
      isVipShow = t.isVipShow
    })
  end
end

LWSaveShowVipLevelSettingsMessage.OnCreate = OnCreate
LWSaveShowVipLevelSettingsMessage.HandleMessage = HandleMessage
return LWSaveShowVipLevelSettingsMessage
