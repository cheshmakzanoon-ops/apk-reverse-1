local ActivityHeroExchangeMessage = BaseClass("ActivityHeroExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityHeroExchangeMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", param.aid)
  self.sfsObj:PutInt("startIndex", param.startIndex)
  self.sfsObj:PutInt("startStage", param.startStage)
  self.sfsObj:PutInt("endIndex", param.endIndex)
  self.sfsObj:PutInt("endStage", param.endStage)
end

function ActivityHeroExchangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityPersonalArmsDataManager:OnExchange(t)
  end
end

return ActivityHeroExchangeMessage
