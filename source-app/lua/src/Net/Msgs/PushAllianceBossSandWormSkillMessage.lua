local PushAllianceBossSandWormSkillMessage = BaseClass("PushAllianceBossSandWormSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.AllyDrillBaseManager:ShowSkillEffect(t)
  end
end

PushAllianceBossSandWormSkillMessage.HandleMessage = HandleMessage
return PushAllianceBossSandWormSkillMessage
