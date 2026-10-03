local LWVipPayData = BaseClass("LWVipPayData")

function LWVipPayData:__init()
  self.id = 0
  self.day = 0
  self.arPay = 0
  self.arVip = ""
  self.otherPay = 0
  self.otherVip = ""
end

function LWVipPayData:__delete()
  self.id = nil
  self.day = nil
  self.arPay = nil
  self.arVip = nil
  self.otherPay = nil
  self.otherVip = nil
end

function LWVipPayData:Init(row)
  self.id = row:getValue("id") or 0
  self.day = row:getValue("day") or 0
  self.arPay = row:getValue("arPay") or 0
  self.arVip = row:getValue("arVip") or ""
  self.otherPay = row:getValue("otherPay") or 0
  self.otherVip = row:getValue("otherVip") or ""
end

return LWVipPayData
