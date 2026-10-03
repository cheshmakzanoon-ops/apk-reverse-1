local UIDecorationMainCtrl = BaseClass("UIDecorationMainCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDecorateUnlock)
end

local function GetPanelData(self, decorationId)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  local orderIndex = 0
  local result = {}
  local list = {}
  result.list = list
  if template then
    local methods = template.gainMethod
    for _, v in pairs(methods) do
      local para = {}
      para.id = v.id
      para.time = v.time
      para.index = v.index
      para.skinId = v.skinId
      
      function para.getBtnClickAction()
        LWResourceLackUtil:GotoGoodsItemLack(v.id, 1)
      end
      
      local itemCount = DataCenter.ItemData:GetItemCount(para.id)
      if 0 < itemCount then
        orderIndex = orderIndex + 1
        para.order = orderIndex
      else
        para.order = 999
      end
      table.insert(list, para)
    end
  end
  if LuaEntry.DataConfig:CheckSwitch("decorationshop") then
    if template.type == DecorationType.DecorationType_Main_City then
      local resLackInfoList = DataCenter.LWResourceLackManager:GetSpecialResWay(ResLackContextType.MainCitySkin)
      if resLackInfoList then
        for k, v in pairs(resLackInfoList) do
          if v.tips and v.tips == LWResourceLackGetWay.DecoSelfSelectItem then
            local itemId = 611006
            local itemInfo = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
            local ifCurBoxContainDecoration = false
            if itemInfo and itemInfo.type == GOODS_TYPE.GOODS_TYPE_138 and itemInfo.para1 then
              do
                local paraList = string.split(itemInfo.para1, "|")
                for m, n in pairs(paraList) do
                  local paraPair = string.split(n, ",")
                  if #paraPair == 2 or #paraPair == 3 then
                    local boxContainItemId = 0
                    if #paraPair == 2 then
                      boxContainItemId = paraPair[1]
                    else
                      boxContainItemId = paraPair[2]
                    end
                    local boxItemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(boxContainItemId)
                    if boxItemTemplate and boxItemTemplate.para1 and tonumber(boxItemTemplate.para1) == decorationId then
                      ifCurBoxContainDecoration = true
                      break
                    end
                  end
                end
                if ifCurBoxContainDecoration then
                  local itemCount = DataCenter.ItemData:GetItemCount(itemId)
                  if 0 < itemCount then
                    local para = {}
                    para.id = itemId
                    
                    function para.getBtnClickAction()
                      LWResourceLackUtil:GotoGoodsItemLack(itemId, 1)
                    end
                    
                    orderIndex = orderIndex + 1
                    para.order = orderIndex
                    para.index = 0
                    table.insert(list, para)
                  end
                end
              end
            end
          end
          if v.tips and v.tips == LWResourceLackGetWay.ActivityAndCheckOpen then
            local havePermanentItem = self:IsHavePermanentItem(decorationId)
            if not havePermanentItem then
              local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(v.para1))
              if actInfo then
                local para = {}
                para.pic = v.pic
                para.tips = v.tips
                para.btnName = Localization:GetString(v.name)
                
                function para.getBtnClickAction(id)
                  GoToUtil.GoActWindow({
                    tonumber(v.para1)
                  }, true)
                end
                
                orderIndex = orderIndex + 1
                para.order = orderIndex
                para.index = 0
                table.insert(list, para)
              end
            end
          end
          if v.tips and v.tips == LWResourceLackGetWay.GoToDecorationShop then
            local havePermanentItem = self:IsHavePermanentItem(decorationId)
            if not havePermanentItem then
              local isSaleInShop = DataCenter.CommonShopManager:IsSaleInDecorationShop(decorationId, CommonShopType.DecorationShop)
              if isSaleInShop then
                local para = {}
                para.pic = v.pic
                para.tips = v.tips
                para.btnName = Localization:GetString(v.name)
                
                function para.getBtnClickAction()
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.DecorationShop)
                end
                
                orderIndex = orderIndex + 1
                para.order = orderIndex
                para.index = 0
                table.insert(list, para)
              end
            end
          end
        end
      end
    end
    table.sort(list, function(a, b)
      if a.order == b.order then
        return a.index < b.index
      end
      return a.order < b.order
    end)
  end
  local data = DataCenter.DecorationDataManager:GetSkinDataById(decorationId)
  local name = template.name
  local time = data and data.expireTime or -1
  result.name = name
  result.time = time
  result.img = template.img
  return result
end

local function GetColourData(self, colourId)
  local decorationId = GetTableData(TableName.DecorationDazzle, tonumber(colourId), "decoration_id")
  local template = DataCenter.DecorationDazzleManager:GetDazzleSkinTemplateById(decorationId, colourId)
  local orderIndex = 0
  local result = {}
  local list = {}
  result.list = list
  if template then
    local methods = template.gainMethod
    for _, v in pairs(methods) do
      local para = {}
      para.id = v.id
      para.time = v.time
      para.index = v.index
      para.skinId = v.skinId
      para.type = 2
      
      function para.getBtnClickAction()
        LWResourceLackUtil:GotoGoodsItemLack(v.id, 1)
      end
      
      local itemCount = DataCenter.ItemData:GetItemCount(para.id)
      if 0 < itemCount then
        orderIndex = orderIndex + 1
        para.order = orderIndex
      else
        para.order = 999
      end
      table.insert(list, para)
    end
  end
  local data = DataCenter.ItemSkinDataManager:GetItemSkinDataById(colourId)
  local name = template.name
  local time = data and data.endTime or -1
  result.name = name
  result.time = time
  return result
end

local function IsHavePermanentItem(self, skinId)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  local gain = template.gainMethod
  local isHave = false
  for k, v in pairs(gain) do
    local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(v.id)
    if itemData and tonumber(itemData.para2) == 0 and 0 < DataCenter.ItemData:GetItemCount(v.id) then
      isHave = true
      break
    end
  end
  return isHave
end

UIDecorationMainCtrl.CloseSelf = CloseSelf
UIDecorationMainCtrl.GetPanelData = GetPanelData
UIDecorationMainCtrl.GetColourData = GetColourData
UIDecorationMainCtrl.IsHavePermanentItem = IsHavePermanentItem
return UIDecorationMainCtrl
