local WorldGetSuppliesCityInfoMessage = BaseClass("WorldGetSuppliesCityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t then
    DataCenter.WorldAllianceCityDataManager:UpdateSuppliesData(t)
  end
end

WorldGetSuppliesCityInfoMessage.OnCreate = OnCreate
WorldGetSuppliesCityInfoMessage.HandleMessage = HandleMessage
return WorldGetSuppliesCityInfoMessage
