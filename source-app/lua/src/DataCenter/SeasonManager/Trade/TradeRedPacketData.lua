local TradeRedPacketData = BaseClass("TradeRedPacketData")

function TradeRedPacketData:__init()
  self.uuid = 0
  self.configId = 0
  self.gold = 0
  self.createTime = 0
  self.serverId = 0
  self.pointId = 0
  self.tradeLevel = 1
  self.goodsTemplate = nil
  self.newCount = 0
end

function TradeRedPacketData:__delete()
  self.uuid = 0
  self.configId = 0
  self.gold = 0
  self.createTime = 0
  self.serverId = 0
  self.pointId = 0
  self.tradeLevel = 1
  self.goodsTemplate = nil
  self.newCount = 0
end

function TradeRedPacketData:ParseData(t)
  if t == nil then
    return
  end
  if t.uuid ~= nil then
    self.uuid = t.uuid
    local newCnt = CommonUtil.PlayerPrefsGetInt(self.uuid, 1)
    self:SetNewCount(newCnt)
  end
  if t.configId ~= nil then
    self.configId = t.configId
  end
  if t.gold ~= nil then
    self.gold = t.gold
  end
  if t.createTime ~= nil then
    self.createTime = t.createTime
  end
  local extra = t.extra
  if extra ~= nil then
    if extra.serverId ~= nil then
      self.serverId = extra.serverId
    end
    if extra.pointId ~= nil then
      self.pointId = extra.pointId
    end
    if extra.tradeLevel ~= nil then
      self.tradeLevel = extra.tradeLevel
    end
  end
end

function TradeRedPacketData:SetNewCount(num)
  CommonUtil.PlayerPrefsSetInt(self.uuid, num)
  self.newCount = num
  EventManager:GetInstance():Broadcast(EventId.RefreshBagRedDot)
end

function TradeRedPacketData.getters:goods()
  if self.goodsTemplate == nil then
    local template = DataCenter.RedPacketTemplateManager:GetTemplate(self.configId)
    if template == nil then
      Logger.LogError("\233\133\141\231\189\174\233\151\174\233\162\152 \230\163\128\230\159\165\233\133\141\231\189\174 \230\178\161\230\156\137\231\186\162\229\140\133  id : " .. self.configId)
      return
    end
    self.goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(template.goodsId)
  end
  return self.goodsTemplate
end

return TradeRedPacketData
