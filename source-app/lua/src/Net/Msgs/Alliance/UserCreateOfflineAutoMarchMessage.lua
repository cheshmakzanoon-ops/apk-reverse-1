local UserCreateOfflineAutoMarchMessage = BaseClass("UserCreateOfflineAutoMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SiegeDataManager:SetAllOutReadyTS(t)
  end
end

UserCreateOfflineAutoMarchMessage.OnCreate = OnCreate
UserCreateOfflineAutoMarchMessage.HandleMessage = HandleMessage
return UserCreateOfflineAutoMarchMessage
