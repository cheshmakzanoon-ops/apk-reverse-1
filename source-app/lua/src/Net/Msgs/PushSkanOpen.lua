local PushSkanOpen = BaseClass("PushSkanOpen", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  Logger.Log("check skan...")
  if t.isOpen ~= nil then
    local isOpen = t.isOpen
    if not isOpen then
      CS.GameEntry.Sdk:SendDataToNative("AF_SKAN_DISABLE", "")
    end
  end
end

PushSkanOpen.OnCreate = OnCreate
PushSkanOpen.HandleMessage = HandleMessage
return PushSkanOpen
