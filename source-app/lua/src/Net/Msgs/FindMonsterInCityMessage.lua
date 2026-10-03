local FindMonsterInCityMessage = BaseClass("FindMonsterInCityMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, level)
  base.OnCreate(self)
  self.sfsObj:PutInt("level", level)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  elseif t.cityPoint ~= nil then
    local param = {}
    param.pointId = t.cityPoint.pointId
    param.uuid = t.cityPoint.uuid
    DataCenter.CityPointDataManager:SetPointDataByUuid(t.cityPoint.uuid, t.cityPoint)
    EventManager:GetInstance():Broadcast(EventId.END_SEARCH, param)
  end
end

FindMonsterInCityMessage.OnCreate = OnCreate
FindMonsterInCityMessage.HandleMessage = HandleMessage
return FindMonsterInCityMessage
