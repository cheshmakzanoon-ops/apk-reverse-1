local AlLeaderElectChangeSloganMessage = BaseClass("AlLeaderElectChangeSloganMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, slogan)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("declaration", slogan)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AlLeaderElectManager:AddOrUpdateOneCandidate(t)
  end
end

AlLeaderElectChangeSloganMessage.OnCreate = OnCreate
AlLeaderElectChangeSloganMessage.HandleMessage = HandleMessage
return AlLeaderElectChangeSloganMessage
