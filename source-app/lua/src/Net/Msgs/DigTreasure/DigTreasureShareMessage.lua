local DigTreasureShareMessage = BaseClass("DigTreasureShareMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DigTreasureShareMessage:OnCreate(param)
  base.OnCreate(self)
end

function DigTreasureShareMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(120061)
    DataCenter.DigTreasureManager:UpdateLastShareTime()
  end
end

return DigTreasureShareMessage
