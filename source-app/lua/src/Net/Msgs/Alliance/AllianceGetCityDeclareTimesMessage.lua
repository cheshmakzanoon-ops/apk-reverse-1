local AllianceGetCityDeclareTimesMessage = BaseClass("AllianceGetCityDeclareTimesMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId, cityId)
  base.OnCreate(self)
  if serverId then
    self.sfsObj:PutInt("serverId", serverId)
  end
  if cityId then
    self.sfsObj:PutInt("cityId", cityId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceDeclareWarManager:CheckIsCanDeclare(t)
  end
end

AllianceGetCityDeclareTimesMessage.OnCreate = OnCreate
AllianceGetCityDeclareTimesMessage.HandleMessage = HandleMessage
return AllianceGetCityDeclareTimesMessage
