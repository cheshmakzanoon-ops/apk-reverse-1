local TorchRelayStageRandomTemplate = BaseClass("TorchRelayBattleStageConfigTemplate")

function TorchRelayStageRandomTemplate:__init()
  self.id = 0
  self.item_distance = ""
  self.buff_num_weight = 0
  self.buff_weight = ""
  self.buff_fall = 0
  self:InitCustom()
end

function TorchRelayStageRandomTemplate:__delete()
  self.id = nil
  self.item_distance = nil
  self.buff_num_weight = nil
  self.buff_weight = ""
  self.buff_fall = nil
  self:DeleteCustom()
end

function TorchRelayStageRandomTemplate:InitCustom()
  self.buff_weight_percent = 0
  self.minBornDistance = 0
  self.maxBornDistance = 0
  self.totalWeight = 0
  self.propsList = {}
end

function TorchRelayStageRandomTemplate:DeleteCustom()
  self.buff_weight_percent = nil
  self.minBornDistance = nil
  self.maxBornDistance = nil
  self.totalWeight = nil
  self.propsList = nil
end

function TorchRelayStageRandomTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.item_distance = row:getValue("item_distance")
  self.buff_num_weight = tonumber(row:getValue("buff_num_weight")) or 0
  self.buff_weight = row:getValue("buff_weight")
  self.buff_fall = tonumber(row:getValue("buff_fall")) or 0
  if self.item_distance then
    local distanceStr = string.split(self.item_distance, ";")
    self.minBornDistance = tonumber(distanceStr[1]) or 0
    self.maxBornDistance = tonumber(distanceStr[2]) or 0
  end
  if self.buff_weight then
    local weightStr = string.split(self.buff_weight, "|")
    if weightStr then
      for i = 1, #weightStr do
        local idWeightStr = string.split(weightStr[i], ";")
        if 2 <= #idWeightStr then
          local item = {}
          item.id = tonumber(idWeightStr[1])
          item.weight = tonumber(idWeightStr[2])
          self.totalWeight = self.totalWeight + item.weight
          table.insert(self.propsList, item)
        end
      end
    end
  end
end

return TorchRelayStageRandomTemplate
