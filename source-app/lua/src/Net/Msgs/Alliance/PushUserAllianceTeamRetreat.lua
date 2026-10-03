local PushUserAllianceTeamRetreat = BaseClass("PushUserAllianceTeamRetreat", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.name ~= nil then
    UIUtil.ShowTips(Localization:GetString("390787", t.name))
  end
end

PushUserAllianceTeamRetreat.OnCreate = OnCreate
PushUserAllianceTeamRetreat.HandleMessage = HandleMessage
return PushUserAllianceTeamRetreat
