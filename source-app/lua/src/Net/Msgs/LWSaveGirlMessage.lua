local LWSaveGirlMessage = BaseClass("LWSaveGirlMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.LWSaveGirlManager:HandleSaveGirlMessage(t)
  end
end

LWSaveGirlMessage.OnCreate = OnCreate
LWSaveGirlMessage.HandleMessage = HandleMessage
return LWSaveGirlMessage
