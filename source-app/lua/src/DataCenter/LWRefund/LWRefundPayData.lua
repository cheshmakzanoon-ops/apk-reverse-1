local LWRefundPayData = BaseClass("LWRefundPayData")

function LWRefundPayData:__init()
  self.orderId = ""
  self.pf = ""
  self.productId = ""
  self.spend = 0
  self.time = 0
  self.rewards = {}
  self.cannotReasonType = 0
  self.refundTime = 0
  self.countType = 0
  self.exchangeName = ""
  self.rewardEnough = true
end

function LWRefundPayData:__delete()
  self.orderId = nil
  self.pf = nil
  self.productId = nil
  self.spend = nil
  self.time = nil
  self.rewards = nil
  self.cannotReasonType = nil
  self.refundTime = nil
  self.countType = nil
  self.exchangeName = nil
  self.rewardEnough = nil
end

function LWRefundPayData:ParsePayData(data)
  self.orderId = data.orderid
  self.pf = data.pf
  self.productId = data.productid
  self.spend = data.spend
  self.time = data.time
  self.rewards = data.rewards
  self.cannotReasonType = data.cant_refund_type or 0
  self.refundTime = data.refundTime or 0
  self.countType = data.countType
  self.exchangeName = data.exchangeName
  self.rewardEnough = data.rewardEnough
end

return LWRefundPayData
