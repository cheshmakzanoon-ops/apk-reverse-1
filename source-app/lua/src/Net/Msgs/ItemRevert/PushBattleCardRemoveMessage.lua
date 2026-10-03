local PushBattleCardRemoveMessage = BaseClass("PushBattleCardRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBattleCardRemoveMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBattleCardRemoveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local removeUuids = t.uuids
    if removeUuids then
      for i = 1, #removeUuids do
        DataCenter.TacticalCardDataManager:RemoveOneCard(removeUuids[i])
      end
    end
  end
end

return PushBattleCardRemoveMessage
