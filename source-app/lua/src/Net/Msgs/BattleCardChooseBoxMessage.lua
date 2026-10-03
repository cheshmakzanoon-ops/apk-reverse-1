local BattleCardChooseBoxMessage = BaseClass("BattleCardChooseBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardChooseBoxMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", param.itemId)
  self.sfsObj:PutInt("num", param.num)
  self.sfsObj:PutInt("findIndex", param.findIndex)
end

function BattleCardChooseBoxMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.TacticalCardDataManager:UpdateDataFromServerData(t)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITCChoiceBoxRewardGet, {anim = true}, t.userBattleCards)
  end
end

return BattleCardChooseBoxMessage
