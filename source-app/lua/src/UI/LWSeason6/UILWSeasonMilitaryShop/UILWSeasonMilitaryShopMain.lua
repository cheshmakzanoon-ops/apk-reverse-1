local ItemTitleCell = require("UI.LWSeason6.UILWSeasonMilitaryShop.Comp.UILWSeasonMilitaryShopTitleCell")
local ItemRowCell = require("UI.LWSeason6.UILWSeasonMilitaryShop.Comp.UILWSeasonMilitaryShopRowCell")
local UILWSeasonMilitaryLevelComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryLevelComp")
local p_btn_bank_path = "Root/Top/p_btn_bank"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWSeasonMilitaryShopMain = BaseClass("UILWSeasonMilitaryShopMain", UIBaseContainer)

function UILWSeasonMilitaryShopMain:ComponentDefine()
  self.textActTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/p_text_act_title")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/TimeContent/p_text_time")
  self.btnInfo = self:AddComponent(UIButton, "Root/Top/p_btn_info")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnTalk = self:AddComponent(UIButton, "bg/Image (1)/p_btn_talk")
  self.btnTalk:SetOnClick(function()
    self:OnBtnTalkClick()
  end)
  self.textTalk = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/talkTip/p_text_talk")
  self.compLoopListView = self:AddComponent(UILoopListView2, "Root/Mid/p_scroll_view")
  self.transCellRoot = self:AddComponent(UIBaseContainer, "Root/Mid/p_scroll_view/Viewport/p_scroll_content")
  self.btnCurrency = self:AddComponent(UIButton, "Root/Top/p_btn_currency_get_more")
  self.btnCurrency:SetOnClick(function()
    self:OnBtnCurrencyClick()
  end)
  self.textCurrency = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/p_btn_currency_get_more/root/p_text_currency_num")
  self.imgCurrency = self:AddComponent(UIImage, "Root/Top/p_btn_currency_get_more/root/p_text_currency_icon")
  self.compLoopListView:InitListView(0, function(listView, index)
    return self:TryGetCell(listView, index)
  end)
  self.p_content_military = self:AddComponent(UIBaseContainer, "Root/Top/p_content_military")
  self.p_comp_military = self:AddComponent(UILWSeasonMilitaryLevelComp, "Root/Top/p_content_military/p_comp_military")
  self.p_text_military_name = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/p_content_military/p_text_military_name")
  self.p_btn_goto_military = self:AddComponent(UIButton, "Root/Bottom/p_btn_goto_military")
  self.p_btn_goto_military:SetOnClick(BindCallback(self, self.OnGotoMilitaryClicked))
end

function UILWSeasonMilitaryShopMain:ComponentDestroy()
  self.items = {}
  self.transCellRoot:RemoveComponents(ItemRowCell)
  self.transCellRoot:RemoveComponents(ItemTitleCell)
  self.compLoopListView:ClearAllItems()
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
  self.p_content_military = nil
  self.p_comp_military = nil
  self.p_text_military_name = nil
  self.p_btn_goto_military = nil
end

function UILWSeasonMilitaryShopMain:DataDefine()
  self.CellIndex = 0
  self.items = {}
  self.NextRefreshTime = LongMaxValue
  self.CurrencyId = DataCenter.SeasonMilitaryManager:GetMilitaryItemId()
  self.Init = false
end

function UILWSeasonMilitaryShopMain:DataDestroy()
  self.Init = false
end

function UILWSeasonMilitaryShopMain:OnEnable()
  base.OnEnable(self)
  self:UpdateMilitary()
  if self:UpdateData() then
    self:UpdateUi()
    self:TryShowNewListPopup()
  end
end

function UILWSeasonMilitaryShopMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWSeasonMilitaryShopMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryShopMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBountyShopGetListUpdate, self.OnGetListUpdate)
  self:AddUIListener(EventId.SeasonBountyShopExchangeUpdate, self.OnExchangeUpdate)
  self:AddUIListener(EventId.SeasonBountyShopForceRefresh, self.OnForceRefresh)
  self:AddUIListener(EventId.SeasonMilitaryInfoUpdate, self.OnMilitaryGetInfoUpdate)
end

function UILWSeasonMilitaryShopMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBountyShopGetListUpdate, self.OnGetListUpdate)
  self:RemoveUIListener(EventId.SeasonBountyShopExchangeUpdate, self.OnExchangeUpdate)
  self:RemoveUIListener(EventId.SeasonBountyShopForceRefresh, self.OnForceRefresh)
  self:RemoveUIListener(EventId.SeasonMilitaryInfoUpdate, self.OnMilitaryGetInfoUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryShopMain:SetData(actId, actData)
  local data = {}
  data.actId = actId
  data.actData = actData
end

function UILWSeasonMilitaryShopMain:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryShopMain:InitData(data)
  self.ActData = DataCenter.SeasonBountyShopManager:GetActData()
  if self.ActData ~= nil then
    self.TalkClick = string.split(self.ActData.para_1, "|")
    self.TalkBuy = string.split(self.ActData.para_2, "|")
    self.LastTalkKey = ""
    return true
  end
  return false
end

function UILWSeasonMilitaryShopMain:InitUi()
  DataCenter.SeasonBountyShopManager:SendGetList()
  self.textActTitle:SetLocalText(self.ActData.name)
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.CurrencyId)
  self.imgCurrency:LoadSprite(iconPath)
  self:Talk(false)
  self:Update1000MS()
  DataCenter.SeasonBountyShopManager:SetDailyRed()
  self.p_content_military:SetActive(false)
  self:UpdateMilitary()
end

function UILWSeasonMilitaryShopMain:UpdateData()
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

function UILWSeasonMilitaryShopMain:UpdateUi()
  if self.DataList == nil or #self.DataList <= 0 then
    self.transCellRoot:RemoveComponents(ItemRowCell)
    self.transCellRoot:RemoveComponents(ItemTitleCell)
    self.compLoopListView:ClearAllItems()
  else
    self.BaseTime = UITimeManager:GetInstance():GetServerSeconds()
    self.compLoopListView:SetListItemCount(#self.DataList, false, false)
    self.compLoopListView:RefreshAllShownItem()
  end
  self:UpdateCurrency()
end

function UILWSeasonMilitaryShopMain:UpdateMilitary()
  local infoData = DataCenter.SeasonMilitaryManager.InfoData
  if infoData ~= nil then
    self.p_content_military:SetActive(true)
    self.p_comp_military:ReInit(infoData:GetLevel())
    if infoData.Cell ~= nil then
      self.p_text_military_name:SetLocalText(infoData.Cell:GetName())
    end
  end
end

function UILWSeasonMilitaryShopMain:UpdateCurrency()
  local currencyNum = DataCenter.ItemData:GetItemCount(self.CurrencyId)
  self.textCurrency:SetText(string.GetFormattedSeperatorNum(currencyNum))
end

function UILWSeasonMilitaryShopMain:TryGetCell(listView, index)
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
    data.BaseTime = self.BaseTime
    self.items[csItem]:ReInit(data)
  end
  return csItem
end

function UILWSeasonMilitaryShopMain:GenerateDataList()
  local dataList = {}
  self:GenerateListInternal(dataList, self.ShopDataDict.OpenedList, true)
  self:GenerateListInternal(dataList, self.ShopDataDict.UnopenedList, false)
  return dataList
end

function UILWSeasonMilitaryShopMain:GenerateListInternal(ret, list, isOpen)
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

function UILWSeasonMilitaryShopMain:Talk(buy)
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

function UILWSeasonMilitaryShopMain:TryShowNewListPopup()
  if not self.Init then
    return
  end
  local newList = DataCenter.SeasonBountyShopManager:GetNewShopDataList()
  if not table.IsNullOrEmpty(newList) then
    local param = {}
    param.ShopIdList = newList
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonMilitaryShopNewPopup, {anim = true}, param)
  end
end

function UILWSeasonMilitaryShopMain:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.ActData ~= nil then
    local timeLeft = math.max(0, self.ActData.endTime - now)
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft))
  end
  if now > self.NextRefreshTime and self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonMilitaryShopMain:OnGetListUpdate(evt)
  self.Init = true
  if self:UpdateData() then
    self:UpdateUi()
    self:TryShowNewListPopup()
  end
end

function UILWSeasonMilitaryShopMain:OnExchangeUpdate(evt)
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

function UILWSeasonMilitaryShopMain:OnForceRefresh(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonMilitaryShopMain:OnMilitaryGetInfoUpdate(evt)
  self:UpdateMilitary()
end

function UILWSeasonMilitaryShopMain:OnBtnInfoClick()
  if self.ActData == nil or string.IsNullOrEmpty(self.ActData.story) then
    DataCenter.SeasonBountyShopManager:Log("story is nil")
    return
  end
  local param = {}
  param.activityRulesStr = Localization:GetString(self.ActData.story)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWSeasonMilitaryShopMain:OnBtnTalkClick()
  self:Talk(false)
end

function UILWSeasonMilitaryShopMain:OnBtnCurrencyClick()
  LWResourceLackUtil:GotoGoodsItemLack(self.CurrencyId, 1)
end

function UILWSeasonMilitaryShopMain:OnGotoMilitaryClicked()
  SeasonUtil.OpenSeasonActivityByType(EnumActivity.SeasonMilitary.Type)
end

return UILWSeasonMilitaryShopMain
