local GmBattleCardMessage = BaseClass("GmBattleCardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GmBattleCardMessage:OnCreate(funcName)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("func", funcName)
end

function GmBattleCardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("2010807")
  end
end

return GmBattleCardMessage
