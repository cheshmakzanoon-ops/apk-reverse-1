local ItemSkinData = BaseClass("ItemSkinData")

function ItemSkinData:__init()
  self.uuid = nil
  self.uid = nil
  self.colourId = nil
  self.expireTime = nil
end

function ItemSkinData:__delete()
  self.uuid = nil
  self.uid = nil
  self.colourId = nil
  self.expireTime = nil
end

function ItemSkinData:ParseData(data)
  self.uuid = data.uuid
  self.uid = data.uid
  self.colourId = data.colourId
  self.expireTime = data.endTime
end

function ItemSkinData:IsInExpireTime()
  if self.expireTime <= 0 then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now < self.expireTime
end

return ItemSkinData
