local LWRefundGoldBrickTemplate = BaseClass("LWRefundGoldBrickTemplate")

function LWRefundGoldBrickTemplate:__init()
  self.id = 0
  self.brickNum = ""
  self.goodsId = ""
end

function LWRefundGoldBrickTemplate:__delete()
  self.id = nil
  self.brickNum = nil
  self.goodsId = nil
end

function LWRefundGoldBrickTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.brickNum = row:getValue("pay_brick_num") or ""
  self.goodsId = row:getValue("goods_id") or ""
end

return LWRefundGoldBrickTemplate
