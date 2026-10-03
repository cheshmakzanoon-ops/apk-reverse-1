local GoldDetailMessage = BaseClass("GoldDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, index)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  else
    DataCenter.PlayerInfoDataManager:OnGetGoldDetail(t)
  end
end

GoldDetailMessage.OnCreate = OnCreate
GoldDetailMessage.HandleMessage = HandleMessage
return GoldDetailMessage
