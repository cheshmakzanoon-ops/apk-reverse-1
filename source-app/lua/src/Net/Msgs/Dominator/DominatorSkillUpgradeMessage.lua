local DominatorSkillUpgradeMessage = BaseClass("DominatorSkillUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("slot", param.slot)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DominatorManager:OnSkillUpgradeCallback(t)
  end
end

DominatorSkillUpgradeMessage.OnCreate = OnCreate
DominatorSkillUpgradeMessage.HandleMessage = HandleMessage
return DominatorSkillUpgradeMessage
