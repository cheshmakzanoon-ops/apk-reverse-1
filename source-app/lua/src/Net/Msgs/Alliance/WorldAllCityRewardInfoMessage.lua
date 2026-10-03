local WorldAllCityRewardInfoMessage = BaseClass("WorldAllCityRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.cityArr then
    DataCenter.WorldAllianceCityDataManager:SetAllOccupyReward(t.cityArr)
  end
end

WorldAllCityRewardInfoMessage.OnCreate = OnCreate
WorldAllCityRewardInfoMessage.HandleMessage = HandleMessage
return WorldAllCityRewardInfoMessage
