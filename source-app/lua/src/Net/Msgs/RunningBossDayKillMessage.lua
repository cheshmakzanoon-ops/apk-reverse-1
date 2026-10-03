local RunningBossDayKillMessage = BaseClass("RunningBossDayKillMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local flag = t.day_kill or 0
  local mummyFlag = t.day_kill_beetle or 0
  DataCenter.RunningBossDataManager:SetTodaySkill(flag)
  DataCenter.RunningBossDataManager:SetMummyTodaySkill(mummyFlag)
end

RunningBossDayKillMessage.OnCreate = OnCreate
RunningBossDayKillMessage.HandleMessage = HandleMessage
return RunningBossDayKillMessage
