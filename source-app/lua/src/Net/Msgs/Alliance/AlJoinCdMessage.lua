local AlJoinCdMessage = BaseClass("AlJoinCdMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.joinCdTime then
    DataCenter.AllianceBaseDataManager:UpdateJoinAllianceCdTimeData(t.joinCdTime)
  end
end

AlJoinCdMessage.OnCreate = OnCreate
AlJoinCdMessage.HandleMessage = HandleMessage
return AlJoinCdMessage
