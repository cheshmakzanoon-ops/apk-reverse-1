local ClaimSeasonWastelandBoxMessage = BaseClass("ClaimSeasonWastelandBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, chestId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("chestId", chestId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSeasonWastelandDataManager:ClaimWastelandBoxMessage(t)
  end
end

ClaimSeasonWastelandBoxMessage.OnCreate = OnCreate
ClaimSeasonWastelandBoxMessage.HandleMessage = HandleMessage
return ClaimSeasonWastelandBoxMessage
