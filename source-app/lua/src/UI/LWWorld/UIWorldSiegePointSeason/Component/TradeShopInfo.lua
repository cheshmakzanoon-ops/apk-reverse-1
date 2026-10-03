local base = UIAsyncContainer
local TradeShopInfo = BaseClass("TradeShopInfo", base)
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local scroll_view_path = "bg/ScrollView"
local scroll_content_path = "bg/ScrollView/Viewport/Content"
local tip_info_path = "tipInfo"
local desc_txt_path = "tipInfo/descTxt"
local taxes_info_path = "taxesInfo"
local taxes_root_path = "taxesInfo/taxes_root"
local taxes_desc_path = "taxesInfo/taxes_root/taxes_desc"
local taxes_icon_path = "taxesInfo/taxes_root/icon/taxes_icon"
local taxes_count_path = "taxesInfo/taxes_root/taxes_count"
local info_btn_path = "title/titleGroup/InfoBtn"
local info_img_path = "title/titleGroup/InfoBtn/InfoImg"
local taxes_info_btn_path = "taxesInfo/taxesInfoBtn"

function TradeShopInfo:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
  self.tip_info = self:AddComponent(UIBaseComponent, tip_info_path)
  self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, desc_txt_path)
  self.taxes_info = self:AddComponent(UIBaseComponent, taxes_info_path)
  self.taxes_root = self:AddComponent(UIBaseComponent, taxes_root_path)
  self.taxes_desc = self:AddComponent(UITextMeshProUGUIEx, taxes_desc_path)
  self.taxes_icon = self:AddComponent(UIImage, taxes_icon_path)
  self.taxes_count = self:AddComponent(UITextMeshProUGUIEx, taxes_count_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local strTip = Localization:GetString("season_s3_trade_city011")
    UIUtil.ShowBubbleTips(strTip, self.info_img.transform.position, 0, -30, 0, nil, nil)
  end)
  self.taxes_info_btn = self:AddComponent(UIButton, taxes_info_btn_path)
  self.taxes_info_btn:SetOnClick(function()
    local strTip = Localization:GetString("season_s3_trade_city050")
    UIUtil.ShowBubbleTips(strTip, self.taxes_info_btn.transform.position, 20, -30, 0, nil, nil)
  end)
  self.info_img = self:AddComponent(UIImage, info_img_path)
end

function TradeShopInfo:OnDestroy()
  self.shopId = nil
  self:ClearItems()
  self.bg = nil
  self.scroll_view = nil
  self.tip_info = nil
  self.desc_txt = nil
  self.taxes_info = nil
  self.taxes_root = nil
  self.taxes_desc = nil
  self.taxes_icon = nil
  self.taxes_count = nil
  self.info_btn = nil
  self.info_img = nil
  self.taxes_info_btn = nil
  base.OnDestroy(self)
end

function TradeShopInfo:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.GetTradeDetail, self.Refresh)
  self:AddUIListener(EventId.GetTradeShopGoodsInfo, self.Refresh)
end

function TradeShopInfo:OnDisable()
  self:RemoveUIListener(EventId.GetTradeDetail, self.Refresh)
  self:RemoveUIListener(EventId.GetTradeShopGoodsInfo, self.Refresh)
  base.OnDisable(self)
end

function TradeShopInfo:UpdateData()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  self:Refresh()
end

function TradeShopInfo:SetData(data)
  self.data = data
  self:UpdateData()
end

function TradeShopInfo:Refresh()
  local data = self.data
  self.cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(data.cityId, LuaEntry.Player:GetCurServerId())
  local shopId = self.cityTemplate ~= nil and self.cityTemplate:GetShopId()
  self.shopId = shopId
  local tradeInfo = DataCenter.SeasonTradeShopDataManager.curTrade
  if tradeInfo and tradeInfo.tradeId ~= data.cityId then
    self.bg:SetActive(false)
    self.taxes_info:SetActive(false)
    return
  end
  local state = tradeInfo ~= nil and tradeInfo:GetShopState()
  self.shopState = state
  local tradeStation = self.data.tradeData:GetTimeState()
  self.tip_info:SetActive(state ~= 1 and self.data.tradeData:HasLord() and tradeStation ~= AllianceCityShowTimeState.TradeBattle)
  self.taxes_info:SetActive(state == 1)
  if state == 0 then
    self.desc_txt:SetLocalText("season_s3_trade_city012")
  elseif state == 1 then
    self.taxes_count:SetText("\195\151" .. (tradeInfo ~= nil and tradeInfo:GetTaxes() or 0))
  else
    self.desc_txt:SetLocalText("season_s3_trade_city014")
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.taxes_root.transform)
  self.list = DataCenter.SeasonTradeShopDataManager:GetItemsByShopId(shopId)
  local cnt = #self.list
  local height = 6 < cnt and 180 or 100
  self.bg:SetSizeDeltaY(height)
  self.bg:SetActive(true)
  self:RefreshList()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  local item = self.list[1]
  if item ~= nil then
    self.resId = item.currency_id
    self.taxes_icon:LoadSprite(CommonUtil.GetResOrItemIcon(self.resId))
  end
end

function TradeShopInfo:ClearItems()
  self.scroll_content:RemoveComponents(UIBaseContainer)
  if self.items then
    for k, v in pairs(self.items) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function TradeShopInfo:RefreshList()
  self:ClearItems()
  self.items = {}
  local index = 0
  local parent = self.scroll_content.transform
  for i, data in ipairs(self.list) do
    self.items[i] = self:GameObjectInstantiateAsync("Assets/Main/SeasonRes/Shared/Prefabs/UI/LWUIWorld/TradeShopItem.prefab", function(request)
      index = index + 1
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(parent)
      go.transform:Set_localScale(1, 1, 1)
      go.name = tostring(index)
      local cellItem = self.scroll_content:AddComponent(UIBaseContainer, go.name)
      local item = cellItem:AddComponent(UICommonResItem, "UICommonResItem")
      cellItem.resItem = item
      cellItem.mask = cellItem.transform:Find("Mask").gameObject
      cellItem.itemParam = UICommonResItem.Param.New()
      local template = self.list[index]
      local itemParam = cellItem.itemParam
      itemParam = UICommonResItem.Param.New()
      itemParam.rewardType = template.rewardType
      itemParam.itemId = template.itemId
      itemParam.count = template.cycle_times * template.goods_num
      itemParam.enableClick = true
      item:ReInit(itemParam)
      cellItem.mask:SetActive(self.shopState ~= 1)
    end)
  end
end

return TradeShopInfo
