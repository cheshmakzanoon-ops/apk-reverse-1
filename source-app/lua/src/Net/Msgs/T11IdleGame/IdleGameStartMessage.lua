local IdleGameStartMessage = BaseClass("IdleGameStartMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function IdleGameStartMessage:OnCreate(param)
  base.OnCreate(self)
end

function IdleGameStartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "idle_game_idle_event_limit_new" then
      local timeLimit = LuaEntry.DataConfig:TryGetNum("idle_game_para", "k2", 0)
      if 0 < timeLimit then
        local lang = Localization:GetString("idle_game_idle_event_limit_new", timeLimit)
        UIUtil.ShowTips(lang)
      else
        UIUtil.ShowTipsId(errCode)
      end
    else
      UIUtil.ShowTipsId(errCode)
    end
    EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnStartIdleGameMessageFailed)
  else
    DataCenter.T11IdleGameDataManager:OnStartIdleGameMessage(t)
  end
end

return IdleGameStartMessage
