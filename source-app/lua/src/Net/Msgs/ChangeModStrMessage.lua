local ChangeModStrMessage = BaseClass("ChangeModStrMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, content)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("moodstr", content)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    local uid = LuaEntry.Player.uid
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
    if info ~= nil then
      DataCenter.PlayerInfoDataManager:ChangeSelfMood(t.moodstr)
    end
  end
end

ChangeModStrMessage.OnCreate = OnCreate
ChangeModStrMessage.HandleMessage = HandleMessage
return ChangeModStrMessage
