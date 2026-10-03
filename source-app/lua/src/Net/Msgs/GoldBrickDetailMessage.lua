local GoldBrickDetailMessage = BaseClass("GoldBrickDetailMessage", SFSBaseMessage)
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
    DataCenter.PlayerInfoDataManager:OnGetGoldBrickDetail(t)
  end
end

GoldBrickDetailMessage.OnCreate = OnCreate
GoldBrickDetailMessage.HandleMessage = HandleMessage
return GoldBrickDetailMessage
