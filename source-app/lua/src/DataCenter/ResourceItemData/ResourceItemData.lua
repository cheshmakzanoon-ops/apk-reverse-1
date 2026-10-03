local ResourceItemData = BaseClass("ResourceItemData")

function ResourceItemData:__init()
  self.uuid = 0
  self.uid = ""
  self.itemId = 0
  self.number = 0
  self.itemType = ResourceItemType.Farming
  self.name = ""
  self.desc = ""
  self.pic = ""
  self.order = 0
  self.template = nil
end

function ResourceItemData:__delete()
  self.uuid = nil
  self.uid = nil
  self.itemId = nil
  self.number = nil
  self.itemType = nil
  self.name = nil
  self.desc = nil
  self.pic = nil
  self.order = nil
  self.template = nil
end

function ResourceItemData:InitData(message)
  if message ~= nil then
    self:ParseData(message)
  end
end

function ResourceItemData:RefreshData(message)
  if message ~= nil then
    local oldNumber = self.number
    self:ParseData(message)
    local deltaNumber = self.number - oldNumber
    if deltaNumber ~= 0 then
      EventManager:GetInstance():Broadcast(EventId.ResourceItemCountChanged, {data = self, delta = deltaNumber})
    end
  end
end

function ResourceItemData:ParseData(message)
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.itemId ~= nil then
    self.itemId = message.itemId
    self.template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.itemId)
  end
  assert(message.number == nil or message.count == nil, "ResourceItemData:RefreshData \229\136\183\230\150\176\233\129\147\229\133\183\230\182\136\230\129\175\228\184\141\232\131\189\229\144\140\230\151\182\229\173\152\229\156\168number\229\146\140count\229\173\151\230\174\181!")
  if message.number ~= nil then
    self.number = message.number
  end
  if message.count ~= nil then
    self.number = message.count
  end
end

return ResourceItemData
