local UIDecorationChoiceBoxCtrl = BaseClass("UIDecorationChoiceBoxCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDecorationChoiceBox)
end

local function GetShowData(self, itemId)
  local showDataList = {}
  local itemTemp = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if itemTemp and itemTemp.type == GOODS_TYPE.GOODS_TYPE_138 then
    local dataList = string.string2array_i(itemTemp.para1, ",", "|")
    for index, showData in pairs(dataList) do
      local showId = showData[1]
      local showNum = showData[2]
      local showItemTemp = DataCenter.ItemTemplateManager:GetItemTemplate(showId)
      local isCanUse = true
      local decoTemp, decoData
      local eternalType = GoodsType113DecorationEternalType.None
      if showItemTemp.type == GOODS_TYPE.GOODS_TYPE_113 then
        local decoId = showItemTemp.para1
        decoId = tonumber(decoId)
        decoTemp = DataCenter.DecorationTemplateManager:GetTemplate(decoId)
        decoData = DataCenter.DecorationDataManager:GetSkinDataById(decoId)
        local isEternal = false
        isEternal, eternalType = DataCenter.ItemTemplateManager:CheckDecorationEternalByGoodsType113ID(showId)
        isCanUse = not isEternal
      elseif showItemTemp.type == GOODS_TYPE.GOODS_TYPE_149 then
        local isEternal = DataCenter.ItemTemplateManager:CheckDecorationEternalByGoodsType149ID(showId)
        isCanUse = not isEternal
      end
      local showData = {
        index = index,
        itemId = showId,
        itemNum = showNum,
        itemTemp = showItemTemp,
        decoTemp = decoTemp,
        decoData = decoData,
        isCanUse = isCanUse,
        eternalType = eternalType
      }
      table.insert(showDataList, showData)
    end
  end
  table.sort(showDataList, function(a, b)
    if a.isCanUse ~= b.isCanUse then
      if a.isCanUse then
        return true
      else
        return false
      end
    end
    local aIsDeco = a.itemTemp.type == GOODS_TYPE.GOODS_TYPE_113
    local bIsDeco = b.itemTemp.type == GOODS_TYPE.GOODS_TYPE_113
    if aIsDeco ~= bIsDeco then
      if aIsDeco then
        return true
      else
        return false
      end
    end
    return a.itemId < b.itemId
  end)
  return showDataList
end

UIDecorationChoiceBoxCtrl.CloseSelf = CloseSelf
UIDecorationChoiceBoxCtrl.GetShowData = GetShowData
return UIDecorationChoiceBoxCtrl
