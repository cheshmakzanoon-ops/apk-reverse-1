local DailyAssistKillGainRemainCountInfoMessage = BaseClass("DailyAssistKillGainRemainCountInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DailyAssistKillGainRemainCountInfoMessage:OnCreate(uid, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("monsterId", uid)
  self.sfsObj:PutLong("uuid", uuid)
end

function DailyAssistKillGainRemainCountInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.result and t.result == 0 then
    local can_assist = t.canGainAssistReward
    local monster_cfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(t.monsterId)
    if monster_cfg then
      DataCenter.AllianceWarDataManager:UpdateWarRallyRewardLimit(monster_cfg.special, not can_assist)
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceJoinRallyLimit, {
      uuid = t.uuid,
      isLimit = not can_assist
    })
  else
    EventManager:GetInstance():Broadcast(EventId.AllianceJoinRallyLimit, {
      uuid = t.uuid,
      isLimit = false
    })
  end
end

return DailyAssistKillGainRemainCountInfoMessage
