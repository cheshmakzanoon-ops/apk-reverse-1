local CityaltarBoxesCreateMessage = BaseClass("CityaltarBoxesCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityaltarBoxesCreateMessage:OnCreate(uuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", serverId)
end

function CityaltarBoxesCreateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonCityAltarManager:OnFishCallback(t)
  end
end

return CityaltarBoxesCreateMessage
