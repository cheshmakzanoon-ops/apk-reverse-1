local base = UIBaseContainer
local TradeStationHonorItemLine = BaseClass("TradeStationHonorItemLine", base)
local TradeStationHonorItem = require("UI.LWSeason.LWSeasonTradeStation.TradeStationHonor.Component.TradeStationHonorItem")
local Localization = CS.GameEntry.Localization

function TradeStationHonorItemLine:OnCreate()
  base.OnCreate(self)
  self.itemList = {}
  for i = 1, 3 do
    self.itemList[i] = self:AddComponent(TradeStationHonorItem, "TradeStationHonorItem" .. i)
  end
end

function TradeStationHonorItemLine:OnDestroy()
  base.OnDestroy(self)
end

function TradeStationHonorItemLine:OnEnable()
  base.OnEnable(self)
end

function TradeStationHonorItemLine:OnDisable()
  base.OnDisable(self)
end

function TradeStationHonorItemLine:ReInit(list)
  for i = 1, 3 do
    if list[i] then
      self.itemList[i]:ReInit(list[i])
      self.itemList[i]:SetActive(true)
    else
      self.itemList[i]:SetActive(false)
    end
  end
end

return TradeStationHonorItemLine
