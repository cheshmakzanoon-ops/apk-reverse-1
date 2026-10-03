local GetMineCavePlunderLogMessage = BaseClass("GetMineCavePlunderLogMessage", SFSBaseMessage)
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
    DataCenter.MineCaveManager:UpdatePlunderList(t)
  end
end

GetMineCavePlunderLogMessage.OnCreate = OnCreate
GetMineCavePlunderLogMessage.HandleMessage = HandleMessage
return GetMineCavePlunderLogMessage
