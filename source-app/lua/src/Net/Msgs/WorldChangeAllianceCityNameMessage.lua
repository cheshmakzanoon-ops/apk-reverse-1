local WorldChangeAllianceCityNameMessage = BaseClass("WorldChangeAllianceCityNameMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cityName, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutUtfString("name", cityName)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(280032)
    DataCenter.WorldAllianceCityDataManager:UpdateCityName(t)
  end
end

WorldChangeAllianceCityNameMessage.OnCreate = OnCreate
WorldChangeAllianceCityNameMessage.HandleMessage = HandleMessage
return WorldChangeAllianceCityNameMessage
