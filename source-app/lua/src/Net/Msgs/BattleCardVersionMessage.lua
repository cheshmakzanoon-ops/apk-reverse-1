local BattleCardVersionMessage = BaseClass("BattleCardVersionMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardVersionMessage:OnCreate(cardVersion)
  base.OnCreate(self)
  self.sfsObj:PutInt("cardVersion", cardVersion)
end

function BattleCardVersionMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.TacticalCardDataManager:OnCardVersionUpdate(t)
  end
end

return BattleCardVersionMessage
