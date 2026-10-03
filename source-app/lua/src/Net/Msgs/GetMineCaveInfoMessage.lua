local GetMineCaveInfoMessage = BaseClass("GetMineCaveInfoMessage", SFSBaseMessage)
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
    DataCenter.MineCaveManager:UpdateMineCaveInfo(t)
  end
end

GetMineCaveInfoMessage.OnCreate = OnCreate
GetMineCaveInfoMessage.HandleMessage = HandleMessage
return GetMineCaveInfoMessage
