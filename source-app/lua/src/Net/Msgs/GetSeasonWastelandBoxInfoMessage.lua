local GetSeasonWastelandBoxInfoMessage = BaseClass("GetSeasonWastelandBoxInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSeasonWastelandDataManager:WastelandBoxInfoMessage(t)
  end
end

GetSeasonWastelandBoxInfoMessage.OnCreate = OnCreate
GetSeasonWastelandBoxInfoMessage.HandleMessage = HandleMessage
return GetSeasonWastelandBoxInfoMessage
