local UINoEarthOrderCtrl = BaseClass("UINoEarthOrderCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINoEarthOrder)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetPanelData(self)
  local info = DataCenter.EarthOrderDataManager:GetOneEarthOrder()
  local result = {}
  local orderIds = {}
  local numPerLine = 3
  if info ~= nil then
    local needResourceItems = info:GetNeedItem()
    for k, v in ipairs(needResourceItems) do
      if math.fmod(k, numPerLine) == 1 then
        table.insert(orderIds, v.needId)
      end
    end
  end
  table.walk(orderIds, function(_, v)
    local param = {}
    param.rewardType = RewardType.RESOURCE_ITEM
    param.icon = DataCenter.RewardManager:GetPicByType(param.rewardType, v)
    param.itemId = v
    param.count = 1
    table.insert(result, param)
  end)
  return result
end

UINoEarthOrderCtrl.CloseSelf = CloseSelf
UINoEarthOrderCtrl.Close = Close
UINoEarthOrderCtrl.GetPanelData = GetPanelData
return UINoEarthOrderCtrl
