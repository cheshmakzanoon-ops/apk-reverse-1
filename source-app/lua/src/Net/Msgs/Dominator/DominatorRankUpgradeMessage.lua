local DominatorRankUpgradeMessage = BaseClass("DominatorRankUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutBool("exchange", param.useCommonItem)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DominatorManager:OnRankUpgradeCallback(t)
  end
end

DominatorRankUpgradeMessage.OnCreate = OnCreate
DominatorRankUpgradeMessage.HandleMessage = HandleMessage
return DominatorRankUpgradeMessage
