local WeekCardSpecialChooseMessage = BaseClass("WeekCardSpecialChooseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function WeekCardSpecialChooseMessage:OnCreate(aid, cardId, indexArr)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", aid)
  self.sfsObj:PutInt("cardId", cardId)
  local rewardArr = SFSArray.New()
  table.walk(indexArr, function(k, v)
    rewardArr:AddInt(v)
  end)
  self.sfsObj:PutSFSArray("indexArr", rewardArr)
end

function WeekCardSpecialChooseMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWOptionalWeekCardManager:UpdateWeekCardDataByChoose(message)
  end
end

return WeekCardSpecialChooseMessage
