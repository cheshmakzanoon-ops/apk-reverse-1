local PushSandWormPopupMessage = BaseClass("PushSandWormPopupMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    local monsterMeta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(t.monsterId)
    if not monsterMeta then
      return
    end
    local isWrap = monsterMeta.special == WorldMonsterSpecialType.SmallSandWorm
    if isWrap then
      local windowName = DataCenter.JungleTrialDataManager:IsChomper(t.monsterId) and UIWindowNames.UIJungleTrialPopup or UIWindowNames.UISandWormPopup
      local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
      if 0 < mainWorldPos and CS.SceneManager.World ~= nil then
        local worldPos = SceneUtils.TileIndexToWorld(mainWorldPos, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(worldPos, 240, 0.2)
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(windowName, {anim = true}, t.monsterId)
        end, 3)
      else
        DataCenter.UIPopWindowManager:Push(windowName, {anim = true}, t.monsterId)
      end
    elseif CS.SceneManager.World ~= nil then
      TimerManager:GetInstance():DelayInvoke(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISandWormPopup, {anim = true}, t.monsterId, t.oldPointId)
      end, 7.5)
    else
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UISandWormPopup, {anim = true}, t.monsterId, t.oldPointId)
    end
  end
end

PushSandWormPopupMessage.HandleMessage = HandleMessage
return PushSandWormPopupMessage
