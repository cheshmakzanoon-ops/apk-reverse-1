local Get3V3ArenaRankListMessage = BaseClass("Get3V3ArenaRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local _requestRecords

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LW3V3ArenaManager:ParseRankingData(t)
  end
end

Get3V3ArenaRankListMessage.OnCreate = OnCreate
Get3V3ArenaRankListMessage.HandleMessage = HandleMessage
return Get3V3ArenaRankListMessage
