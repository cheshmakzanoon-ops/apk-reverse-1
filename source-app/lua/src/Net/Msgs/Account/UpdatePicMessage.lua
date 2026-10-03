local UpdatePicMessage = BaseClass("UpdatePicMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local second = UITimeManager:GetInstance():SecondToFmtString(tonumber(message.expireTime))
    local lang = Localization:GetString(message.errorCode, second)
    UIUtil.ShowTips(lang or message.errorCode)
    LuaEntry.Player:UploadPicEnd()
    return
  end
  if LuaEntry.Player == nil then
    Logger.LogError("UpdatePicMessage LuaEntry.Player is nil!")
    UIUtil.ShowTipsId(120239)
    LuaEntry.Player:UploadPicEnd()
    return
  end
  LuaEntry.Player:UpdatePic(message)
  local picVer = LuaEntry.Player.picVer
  LuaEntry.Player:UploadPicEnd()
  if picVer < 1000000 then
    UIUtil.ShowTipsId(280100)
    EventManager:GetInstance():Broadcast(EventId.UpdatePlayerHeadIcon)
  elseif 2000000 < picVer and picVer <= 3000000 then
    UIUtil.ShowTipsId(120100)
  end
end

UpdatePicMessage.OnCreate = OnCreate
UpdatePicMessage.HandleMessage = HandleMessage
return UpdatePicMessage
