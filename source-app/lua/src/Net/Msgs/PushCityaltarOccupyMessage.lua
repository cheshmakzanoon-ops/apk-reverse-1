local PushCityaltarOccupyMessage = BaseClass("PushCityaltarOccupyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCityaltarOccupyMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushCityaltarOccupyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonCityAltarManager:OnOccupyAltar(t)
  end
end

return PushCityaltarOccupyMessage
