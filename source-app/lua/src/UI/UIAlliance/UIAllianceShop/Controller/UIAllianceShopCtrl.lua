local UIAllianceShopCtrl = BaseClass("UIAllianceShopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceShop)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
  self.currentItemId = ""
  self.selectTab = 1
  self.tempTab = 0
  SFSNetwork.SendMessage(MsgDefines.AlShopShow)
end

local function GetTab(self)
  return self.selectTab
end

local function SetTab(self, tab)
  self.selectTab = tab
end

local function SetCurrentItemId(self, id)
  self.currentItemId = id
end

local function GetAllianceShopData(self)
  local isChangeTab = true
  if self.selectTab == self.tempTab then
    isChangeTab = false
  end
  self.tempTab = self.selectTab
  local isEnd = false
  local selectIdx = 1
  if self.data ~= nil and self.data.list ~= nil then
    local idx = 1
    table.walk(self.data.list, function(k, v)
      if self.currentItemId ~= nil and self.currentItemId == v then
        selectIdx = idx
      end
      idx = idx + 1
    end)
  end
  self.data = {}
  self.data.accPoint = string.GetFormattedSeperatorNum(DataCenter.AllianceShopDataManager:GetAccPoint())
  self.data.list = DataCenter.AllianceShopDataManager:GetAllianceShopIdList()
  if self.data.list ~= nil then
    local idx = 1
    local hasId = false
    table.walk(self.data.list, function(k, v)
      if not isChangeTab then
        if self.currentItemId == "" then
          self:SelectOneItem(v)
        end
        if self.currentItemId == v then
          hasId = true
        end
        if idx == table.count(self.data.list) and not hasId then
          if selectIdx > table.count(self.data.list) then
            self:SelectOneItem(v)
          else
            self:SelectOneItem(self.data.list[selectIdx])
          end
        end
      elseif self.currentItemId == "" then
        self:SelectOneItem(v)
      end
      idx = idx + 1
    end)
  end
  return self.data
end

local function GetAllianceBagData(self)
  self.tempTab = self.selectTab
  local data = {}
  data.alliancePoint = string.GetFormattedSeperatorNum(DataCenter.AllianceShopDataManager:GetAlliancePoint())
  data.list = DataCenter.AllianceShopDataManager:GetAllianceBagIdList()
  if data.list ~= nil then
    table.walk(data.list, function(k, v)
      if self.currentItemId == "" then
        self:SelectOneItem(v)
      end
    end)
  end
  return data
end

local function GetItemData(self, itemId)
  local item = {}
  local tab = self:GetTab()
  if tab == 1 then
    local itemData = DataCenter.AllianceShopDataManager:GetAllianceShopOneData(itemId)
    if itemData == nil then
      return item
    end
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if goods ~= nil then
      if tonumber(itemData.count) <= 0 then
        return item
      end
      item.itemId = itemId
      item.iconName = DataCenter.ItemTemplateManager:GetIconPath(itemId)
      item.count = string.GetFormattedSeperatorNum(itemData.count)
      item.itemName = DataCenter.ItemTemplateManager:GetName(itemId)
      item.des = DataCenter.ItemTemplateManager:GetDes(itemId)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
      local itemType = goods.type
      if itemType == 2 then
        if goods.para1 ~= nil and goods.para1 ~= "" then
          local para1 = goods.para1
          local temp = string.split(para1, ";")
          if temp ~= nil and 1 < #temp then
            item.itemFlag = temp[1] .. temp[2]
          end
        end
      elseif itemType == 3 then
        local type2 = goods.type2
        if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
          local res_num = tonumber(goods.para)
          item.itemFlag = string.GetFormattedStr(res_num)
        end
      else
        item.itemFlag = ""
      end
      local selfItem = DataCenter.ItemData:GetItemById(itemId)
      if selfItem ~= nil and selfItem.count > 0 then
        item.ownNum = selfItem.count
      else
        item.ownNum = 0
      end
    end
  elseif tab == 2 then
    local goods = DataCenter.AllianceShopDataManager:GetAllianceBagOneData(itemId)
    if goods ~= nil then
      item.itemId = itemId
      item.iconName = DataCenter.ItemTemplateManager:GetIconPath(itemId)
      item.count = ""
      item.itemName = DataCenter.ItemTemplateManager:GetName(itemId)
      item.des = DataCenter.ItemTemplateManager:GetDes(itemId)
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
      local itemType = goods.type
      if itemType == 2 then
        if goods.para1 ~= nil and goods.para1 ~= "" then
          local para1 = goods.para1
          local temp = string.split(para1, ";")
          if temp ~= nil and 1 < #temp then
            item.itemFlag = temp[1] .. temp[2]
          end
        end
      elseif itemType == 3 then
        local type2 = goods.type2
        if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
          local res_num = tonumber(goods.para)
          item.itemFlag = string.GetFormattedStr(res_num)
        end
      else
        item.itemFlag = ""
      end
      local itemData = DataCenter.AllianceShopDataManager:GetAllianceShopOneData(itemId)
      if itemData ~= nil and itemData.count > 0 then
        item.ownNum = itemData.count
      else
        item.ownNum = 0
      end
    end
  end
  return item
end

local function GetCurButtonState(self, num)
  local state = {}
  state.canDec = false
  state.canAdd = false
  state.needCount = ""
  state.canUse = false
  local tab = self:GetTab()
  local currentItemId = self:GetCurrentItemId()
  if tab == 1 then
    local itemData = DataCenter.AllianceShopDataManager:GetAllianceShopOneData(currentItemId)
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(currentItemId)
    if itemData ~= nil and goods ~= nil then
      local itemCount = itemData.count
      local price = goods.price_all
      local accPoint = DataCenter.AllianceShopDataManager:GetAccPoint()
      local needAlAcc = price * num
      state.canDec = 1 < num
      state.canUse = accPoint >= needAlAcc
      state.canAdd = num < itemCount and accPoint > needAlAcc
      state.price = string.GetFormattedSeperatorNum(price)
      state.needAlAcc = string.GetFormattedSeperatorNum(needAlAcc)
    end
  elseif tab == 2 then
    local goods = DataCenter.AllianceShopDataManager:GetAllianceBagOneData(currentItemId)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(currentItemId)
    local itemData = DataCenter.AllianceShopDataManager:GetAllianceShopOneData(currentItemId)
    if goods ~= nil and itemTemplate ~= nil then
      local price = goods.price_all
      local alliancePoint = DataCenter.AllianceShopDataManager:GetAlliancePoint()
      local needAlPoint = price * num
      local addNeedAlPoint = price * (num + 1)
      state.canDec = 1 < num
      state.canUse = alliancePoint >= needAlPoint
      local allianceNum = itemTemplate.allianceNum
      if 0 < allianceNum and itemData ~= nil then
        allianceNum = allianceNum - tonumber(itemData.buyCount)
        if allianceNum < 0 then
          allianceNum = 0
        end
      end
      state.allianceNum = allianceNum
      state.canAdd = alliancePoint >= addNeedAlPoint and (0 < allianceNum or allianceNum == -1)
      state.price = string.GetFormattedSeperatorNum(price)
      state.needAlPoint = string.GetFormattedSeperatorNum(needAlPoint)
      state.nextWeekTime = DataCenter.AllianceShopDataManager:GetNextWeekTime()
    end
  end
  return state
end

local function OnChangeSelectNumCheck(self, count)
  local num = 1
  local changeNum = math.floor(count)
  if 1 < changeNum then
    local tab = self:GetTab()
    local currentItemId = self:GetCurrentItemId()
    if tab == 1 then
      local itemData = DataCenter.AllianceShopDataManager:GetAllianceShopOneData(currentItemId)
      if itemData ~= nil then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(currentItemId)
        local itemCount = itemData.count
        local price = goods.price_all
        local accPoint = DataCenter.AllianceShopDataManager:GetAccPoint()
        local maxCount = math.min(itemCount, math.floor(accPoint / price))
        num = math.min(maxCount, changeNum)
      end
    elseif tab == 2 then
      local goods = DataCenter.AllianceShopDataManager:GetAllianceBagOneData(currentItemId)
      if goods ~= nil then
        local price = goods.price_all
        local alliancePoint = DataCenter.AllianceShopDataManager:GetAlliancePoint()
        local maxCount = math.floor(alliancePoint / price)
        num = math.min(maxCount, changeNum)
      end
    end
  end
  if num < 1 then
    num = 1
  end
  return num
end

local function OnUseClick(self, num, canUse)
  local currentItemId = self:GetCurrentItemId()
  if currentItemId ~= nil and currentItemId ~= "" then
    if canUse then
      SFSNetwork.SendMessage(MsgDefines.AlShopBuyUsr, currentItemId, num)
    else
      UIUtil.ShowTipsId(390270)
    end
  else
    UIUtil.ShowTipsId(100290)
  end
end

local function OnBuyClick(self, num, canUse)
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    local currentItemId = self:GetCurrentItemId()
    if currentItemId ~= nil and currentItemId ~= "" then
      if canUse then
        SFSNetwork.SendMessage(MsgDefines.AlShopBuyAl, currentItemId, num)
      else
        UIUtil.ShowTipsId(390271)
      end
    else
      UIUtil.ShowTipsId(100290)
    end
  else
    UIUtil.ShowTipsId(390272)
  end
end

local function SelectOneItem(self, itemId)
  local oldSelectId = self.currentItemId
  self.currentItemId = itemId
  if oldSelectId ~= nil and oldSelectId ~= "" then
    EventManager:GetInstance():Broadcast(EventId.CLICK_ALLIANCE_SHOP_ITEM, oldSelectId)
  end
end

local function GetCurrentItemId(self)
  return self.currentItemId
end

UIAllianceShopCtrl.CloseSelf = CloseSelf
UIAllianceShopCtrl.Close = Close
UIAllianceShopCtrl.InitData = InitData
UIAllianceShopCtrl.GetTab = GetTab
UIAllianceShopCtrl.SetTab = SetTab
UIAllianceShopCtrl.SetCurrentItemId = SetCurrentItemId
UIAllianceShopCtrl.GetCurrentItemId = GetCurrentItemId
UIAllianceShopCtrl.GetAllianceShopData = GetAllianceShopData
UIAllianceShopCtrl.GetAllianceBagData = GetAllianceBagData
UIAllianceShopCtrl.GetItemData = GetItemData
UIAllianceShopCtrl.GetCurButtonState = GetCurButtonState
UIAllianceShopCtrl.OnChangeSelectNumCheck = OnChangeSelectNumCheck
UIAllianceShopCtrl.OnUseClick = OnUseClick
UIAllianceShopCtrl.OnBuyClick = OnBuyClick
UIAllianceShopCtrl.SelectOneItem = SelectOneItem
return UIAllianceShopCtrl
