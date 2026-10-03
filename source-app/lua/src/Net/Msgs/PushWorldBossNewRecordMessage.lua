local PushWorldBossNewRecoredMessage = BaseClass("PushWorldBossNewRecoredMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushWorldBossNewRecoredMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldBossNewRecoredMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.totalDamage ~= nil and t.totalHistoryDamage ~= nil and t.historyDamage ~= nil and t.march ~= nil then
    local title = Localization:GetString(456014)
    local content = Localization:GetString(456015, string.GetFormattedSeparatorNum(t.totalDamage))
    local _delayShowTimer = TimerManager:GetInstance():DelayInvoke(function()
      local param = {}
      param.todayDamage = tonumber(t.totalHistoryDamage)
      param.historyDamage = tonumber(t.historyDamage)
      param.nowDamage = tonumber(t.totalDamage)
      param.march = t.march
      param.monsterInfo = t.monsterInfo
      param.monsterId = t.monsterCfgId
      local window = UIWindowNames.LWUIWorldBossDamageTip
      if DataCenter.LWSeasonBossLoginDataManager:IsVail() then
        window = UIWindowNames.LWSeasonBossDamageTip
      end
      if UIManager:GetInstance():IsWindowOpen(window) then
        EventManager:GetInstance():Broadcast(EventId.WorldBossDamageRefresh, param)
      else
        UIManager:GetInstance():OpenWindow(window, {anim = true}, param)
      end
    end, 3)
    _delayShowTimer:Start()
  end
end

return PushWorldBossNewRecoredMessage
