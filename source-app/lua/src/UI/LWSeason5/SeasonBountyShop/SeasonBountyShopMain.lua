local ItemTitleCell = require("UI/LWSeason5/SeasonBountyShop/Comp/SeasonBountyShopTitleCell")
local ItemRowCell = require("UI/LWSeason5/SeasonBountyShop/Comp/SeasonBountyShopRowCell")
local p_btn_bank_path = "Root/Top/p_btn_bank"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SeasonBountyShopMain = BaseClass("SeasonBountyShopMain", UIBaseContainer)

function SeasonBountyShopMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textActTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnTalk = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnTalk:SetOnClick(function()
    self:OnBtnTalkClick()
  end)
  self.textTalk = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compLoopListView = self.viewSkin:AddComponent(self, UILoopListView2, 6)
  self.transCellRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.btnCurrency = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnCurrency:SetOnClick(function()
    self:OnBtnCurrencyClick()
  end)
  self.textCurrency = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.imgCurrency = self.viewSkin:AddComponent(self, UIImage, 10)
  self.compLoopListView:InitListView(0, function(listView, index)
    return self:TryGetCell(listView, index)
  end)
  self.p_btn_bank = self:AddComponent(UIButton, p_btn_bank_path)
  self.p_btn_bank:SetOnClick(BindCallback(self, self.OnBankClicked))
end

function SeasonBountyShopMain:ComponentDestroy()
  self.items = {}
  self.transCellRoot:RemoveComponents(ItemRowCell)
  self.transCellRoot:RemoveComponents(ItemTitleCell)
  self.compLoopListView:ClearAllItems()
  self.viewSkin = nil
  self.textActTitle = nil
  self.textTime = nil
  self.btnInfo = nil
  self.btnTalk = nil
  self.textTalk = nil
  self.compLoopListView = nil
  self.transCellRoot = nil
  self.btnCurrency = nil
  self.textCurrency = nil
  self.imgCurrency = nil
  self.p_btn_bank = nil
end

function SeasonBountyShopMain:DataDefine()
  self.CellIndex = 0
  self.items = {}
  self.NextRefreshTime = LongMaxValue
  self.LastListStr = ""
  self.CurrencyId = 650053
end

function SeasonBountyShopMain:DataDestroy()
end

function SeasonBountyShopMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function SeasonBountyShopMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonBountyShopMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBountyShopGetListUpdate, self.OnGetListUpdate)
  self:AddUIListener(EventId.SeasonBountyShopExchangeUpdate, self.OnExchangeUpdate)
  self:AddUIListener(EventId.SeasonBountyShopForceRefresh, self.OnForceRefresh)
end

function SeasonBountyShopMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBountyShopGetListUpdate, self.OnGetListUpdate)
  self:RemoveUIListener(EventId.SeasonBountyShopExchangeUpdate, self.OnExchangeUpdate)
  self:RemoveUIListener(EventId.SeasonBountyShopForceRefresh, self.OnForceRefresh)
  base.OnRemoveListener(self)
end

function SeasonBountyShopMain:SetData(actId, actData)
  local data = {}
  data.actId = actId
  data.actData = actData
end

function SeasonBountyShopMain:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonBountyShopMain:InitData(data)
  self.ActData = DataCenter.SeasonBountyShopManager:GetActData()
  if self.ActData ~= nil then
    self.TalkClick = string.split(self.ActData.para_1, "|")
    self.TalkBuy = string.split(self.ActData.para_2, "|")
    self.LastTalkKey = ""
    return true
  end
  return false
end

function SeasonBountyShopMain:InitUi()
  DataCenter.SeasonBountyShopManager:SendGetList()
  self.textActTitle:SetLocalText(self.ActData.name)
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.CurrencyId)
  self.imgCurrency:LoadSprite(iconPath)
  self:Talk(false)
  self:Update1000MS()
  DataCenter.SeasonBountyShopManager:SetDailyRed()
end

function SeasonBountyShopMain:UpdateData()
  self.ShopDataDict = DataCenter.SeasonBountyShopManager.ShopDataDict
  if self.ShopDataDict ~= nil then
    self.NextRefreshTime = LongMaxValue
    if self.ShopDataDict.OpenedList ~= nil then
      for _, shopGroupData in pairs(self.ShopDataDict.OpenedList) do
        self.NextRefreshTime = math.min(self.NextRefreshTime, shopGroupData.ShopData:GetNextRefreshTime())
      end
    end
    if self.ShopDataDict.UnopenedList ~= nil then
      for _, shopGroupData in pairs(self.ShopDataDict.UnopenedList) do
        self.NextRefreshTime = math.min(self.NextRefreshTime, shopGroupData.ShopData:GetNextRefreshTime())
      end
    end
  end
  if self.ShopDataDict ~= nil then
    self.DataList = self:GenerateDataList()
    return true
  end
  return false
end

function SeasonBountyShopMain:UpdateUi()
  if self.DataList == nil or #self.DataList <= 0 then
    self.transCellRoot:RemoveComponents(ItemRowCell)
    self.transCellRoot:RemoveComponents(ItemTitleCell)
    self.compLoopListView:ClearAllItems()
  elseif self.LastListStr == "" then
    self.compLoopListView:SetListItemCount(#self.DataList, false, false)
    self.compLoopListView:RefreshAllShownItem()
  else
    self.compLoopListView:SetListItemCount_Mod(#self.DataList, false, false, true)
  end
  self:UpdateCurrency()
end

function SeasonBountyShopMain:UpdateCurrency()
  local currencyNum = DataCenter.ItemData:GetItemCount(self.CurrencyId)
  self.textCurrency:SetText(string.GetFormattedSeperatorNum(currencyNum))
end

function SeasonBountyShopMain:TryGetCell(listView, index)
  local dataList = self.DataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem, script
  local data = dataList[index]
  if data.Type == 0 then
    csItem = listView:NewListViewItem("p_title_slot")
    script = ItemTitleCell
  else
    csItem = listView:NewListViewItem("p_row_slot")
    script = ItemRowCell
  end
  if self.items[csItem] == nil then
    self.CellIndex = self.CellIndex + 1
    local name = "Cell" .. self.CellIndex
    csItem.gameObject.name = name
    self.items[csItem] = self.transCellRoot:AddComponent(script, name)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(data.Data)
  end
  return csItem
end

function SeasonBountyShopMain:GenerateDataList()
  local dataList = {}
  self:GenerateListInternal(dataList, self.ShopDataDict.OpenedList, true)
  self:GenerateListInternal(dataList, self.ShopDataDict.UnopenedList, false)
  return dataList
end

function SeasonBountyShopMain:GenerateListInternal(ret, list, isOpen)
  local lastTime = 0
  local rowDataList = {}
  if not table.IsNullOrEmpty(list) then
    for _, shopDataGroup in pairs(list) do
      if not shopDataGroup.ShopData:CanShow() then
        DataCenter.SeasonBountyShopManager:Log("\229\149\134\229\147\129\231\154\132\229\137\141\231\189\174\230\157\161\228\187\182\228\184\141\230\187\161\232\182\179\239\188\140id = %s", shopDataGroup.ShopData.ShopCell.id)
      elseif shopDataGroup.Time ~= lastTime then
        if not table.IsNullOrEmpty(rowDataList) then
          table.insert(ret, {Type = 1, Data = rowDataList})
        end
        lastTime = shopDataGroup.Time
        table.insert(ret, {
          Type = 0,
          Data = {
            IsOpen = isOpen,
            Time = shopDataGroup.Time,
            Data = shopDataGroup.ShopData
          }
        })
        rowDataList = {}
        table.insert(rowDataList, shopDataGroup.ShopData)
      else
        table.insert(rowDataList, shopDataGroup.ShopData)
        if 3 <= #rowDataList then
          table.insert(ret, {Type = 1, Data = rowDataList})
          rowDataList = {}
        end
      end
    end
  end
  if not table.IsNullOrEmpty(rowDataList) then
    table.insert(ret, {Type = 1, Data = rowDataList})
  end
end

function SeasonBountyShopMain:Talk(buy)
  local pool = self.TalkClick
  if buy then
    pool = self.TalkBuy
  end
  if 0 < #pool then
    local randomTime = 10
    local key = self.LastTalkKey
    while 0 < randomTime and key == self.LastTalkKey do
      key = pool[math.random(1, #pool)]
      randomTime = randomTime - 1
    end
    if not string.IsNullOrEmpty(key) then
      self.LastTalkKey = key
      self.textTalk:SetLocalText(key)
    end
  end
end

function SeasonBountyShopMain:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.ActData ~= nil then
    local timeLeft = math.max(0, self.ActData.endTime - now)
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft))
  end
  if now > self.NextRefreshTime and self:UpdateData() then
    self:UpdateUi()
  end
end

function SeasonBountyShopMain:OnGetListUpdate(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function SeasonBountyShopMain:OnExchangeUpdate(evt)
  self:Talk(true)
  self:UpdateCurrency()
  local msg = {
    reward = {}
  }
  if evt ~= nil and evt.productInfo ~= nil then
    local productType = checknumber(evt.productInfo.productType)
    if productType == DataCenter.SeasonBountyShopManager.ProductType.GOODS then
      local info = evt.productInfo
      local _reward = {
        type = RewardType.GOODS,
        value = {
          id = info.itemId,
          uuid = info.itemUuid,
          num = info.itemAddNum
        }
      }
      table.insert(msg.reward, _reward)
    elseif productType == DataCenter.SeasonBountyShopManager.ProductType.RES then
      local info = evt.productInfo
      if info ~= nil and table.count(info.resource_items) > 0 then
        local res = info.resource_items[1]
        if res ~= nil then
          local _reward = {
            type = RewardType.RESOURCE_ITEM,
            value = {
              id = res.itemId,
              uuid = res.itemUuid,
              num = res.addNum
            }
          }
          table.insert(msg.reward, _reward)
        end
      end
    elseif productType == DataCenter.SeasonBountyShopManager.ProductType.TITLE then
    end
    if not table.IsNullOrEmpty(msg.reward) then
      DataCenter.RewardManager:ShowCommonReward(msg)
    end
  end
end

function SeasonBountyShopMain:OnForceRefresh(evt)
  self.LastListStr = ""
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function SeasonBountyShopMain:GetDataListStr(list)
  local str = ""
  if list == nil then
    return str
  end
  str = "OpenedList:"
  for _, groupData in pairs(list.OpenedList) do
    str = str .. "_" .. groupData.ShopData:GetKey()
  end
  str = str .. "_UnopenedList:"
  for _, groupData in pairs(list.UnopenedList) do
    str = str .. "_" .. groupData.ShopData:GetKey()
  end
  return str
end

function SeasonBountyShopMain:OnBtnInfoClick()
  if self.ActData == nil or string.IsNullOrEmpty(self.ActData.story) then
    DataCenter.SeasonBountyShopManager:Log("story is nil")
    return
  end
  local param = {}
  param.activityRulesStr = Localization:GetString(self.ActData.story)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function SeasonBountyShopMain:OnBtnTalkClick()
  self:Talk(false)
end

function SeasonBountyShopMain:OnBtnCurrencyClick()
  LWResourceLackUtil:GotoGoodsItemLack(self.CurrencyId, 1)
end

function SeasonBountyShopMain:OnBankClicked()
  UIManager:GetInstance():OpenWindow(UIWindowNames.BankCity, {anim = true})
end

return SeasonBountyShopMain
