local PushMonthCardMessage = BaseClass("PushMonthCardMessage", SFSBaseMessage)
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
    DataCenter.MonthCardNewManager:UpdateMonthCardData(t)
    if t.lastUpdateTime then
      LuaEntry.Player:SetLastUpdateTime(t.lastUpdateTime)
    end
    if not t.oldActive then
      DataCenter.MonthCardNewManager:SetExpiredFormationData(t)
    end
  end
end

PushMonthCardMessage.OnCreate = OnCreate
PushMonthCardMessage.HandleMessage = HandleMessage
return PushMonthCardMessage
