local AlDismissMessage = BaseClass("AlDismissMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if LuaEntry.Player ~= nil then
      LuaEntry.Player:SetFirstJoinAlliance(0)
    end
    DataCenter.AllianceBaseDataManager:ResetAllianceData(t)
  end
end

AlDismissMessage.OnCreate = OnCreate
AlDismissMessage.HandleMessage = HandleMessage
return AlDismissMessage
