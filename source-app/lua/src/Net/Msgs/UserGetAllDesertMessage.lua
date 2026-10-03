local UserGetAllDesertMessage = BaseClass("UserGetAllDesertMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  else
    DataCenter.DesertDataManager:UpdateAllDesertData(t)
  end
end

UserGetAllDesertMessage.OnCreate = OnCreate
UserGetAllDesertMessage.HandleMessage = HandleMessage
return UserGetAllDesertMessage
