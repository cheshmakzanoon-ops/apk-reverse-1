local GoldPrice = BaseClass("GoldPrice", Singleton)

function GoldPrices:__init()
end

function GoldPrices:__reset()
  self.id = ""
  self.exchange_id = ""
  self.product_id = ""
  self.vk = ""
  self.qq = ""
  self.mycard = ""
  self.gash = ""
  self.mol = ""
end

function GoldPrices:Parse(data)
  if data == nil then
    return
  end
  self.id = data.id or ""
  self.exchange_id = data.exchange_id or ""
  self.product_id = data.product_id or ""
  self.vk = data.VK or ""
  self.qq = data.QQ or ""
  self.mycard = data.mycard or ""
  self.gash = data.gash or ""
  self.mol = data.mol or ""
end

return GoldPrice
