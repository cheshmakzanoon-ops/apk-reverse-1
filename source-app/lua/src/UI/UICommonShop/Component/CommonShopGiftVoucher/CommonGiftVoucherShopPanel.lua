local base = UIBaseView
local CommonGiftVoucherShopPanel = BaseClass("CommonGiftVoucherShopPanel", base)
local Localization = CS.GameEntry.Localization
local CommonGiftVoucherShopItem = require("UI.UICommonShop.Component.CommonShopGiftVoucher.CommonGiftVoucherShopItem")
local svGoods_path = "ScrollView"
local content_path = "ScrollView/Content"
local select_comp_btn_path = "selectCompBtn"
local select_tip_path = "selectCompBtn/selectTip"
local select_content_path = "selectCompBtn/selectContent"
local btn_img_path = "selectCompBtn/selectContent/btnImg"
local progress_path = "selectCompBtn/selectContent/progress"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnDisable(self)
  DataCenter.CommonShopManager:UpdateDecorationShopItemNew(self.curShowType)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.svGoodsN = self:AddComponent(UIBaseContainer, svGoods_path)
  self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
  self.select_comp_btn = self:AddComponent(UIButton, select_comp_btn_path)
  self.select_tip = self:AddComponent(UITextMeshProUGUIEx, select_tip_path)
  self.select_content = self:AddComponent(UIBaseContainer, select_content_path)
  self.btn_img = self:AddComponent(UIImage, btn_img_path)
  self.select_comp_btn:SetOnClick(BindCallback(self, self.OnSelectCompBtnClick))
  self.progress = self:AddComponent(UIImage, progress_path)
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self.svGoodsN = nil
  self.contentN = nil
  self.select_comp_btn = nil
  self.select_tip = nil
  self.select_content = nil
  self.btn_img = nil
  self.progress = nil
end

local function DataDefine(self)
  self.curShowType = nil
  self.goodsList = {}
  self.goodsItemsList = {}
  self.listGO = {}
end

local function DataDestroy(self)
  self.curShowType = nil
  self.goodsList = nil
  self.goodsItemsList = nil
  self.listGO = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
  self:AddUIListener(EventId.GiftVoucherNumChange, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
  self:RemoveUIListener(EventId.GiftVoucherNumChange, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, shopType)
  self.curShowType = shopType
  self:RefreshAll()
end

local function RefreshAll(self, shopType)
  if shopType and shopType ~= self.curShowType then
    return
  end
  self:SetGoodsInfo()
  local line, hide
  for i = #self.goodsList, 1, -1 do
    line = LocalController:instance():getLine(TableName.LW_Shop, self.goodsList[i].id)
    if line then
      if string.IsNullOrEmpty(line:getValue("is_hide")) then
        hide = 0
      else
        hide = tonumber(line:getValue("is_hide"))
      end
      if hide ~= 0 then
        table.remove(self.goodsList, i)
      end
    end
  end
  self.contentN:SetItemCount(#self.goodsList)
  if self.spe_res_num then
    self.spe_res_num:SetText(DataCenter.CommonShopManager:GetGiftVoucherShopItemNum())
  end
  self:RefreshSelectComp()
end

local function RefreshSelectComp(self)
  local curSelect = DataCenter.GiftVoucherShopBuildBubbleDataManager:GetBubbleShowSet()
  self.select_tip:SetLocalText("gift_coupon_tips1")
  self.progress:SetActive(curSelect)
  self.btn_img:SetAnchoredPositionXY(curSelect and 20 or -20, 0)
end

local function OnSelectCompBtnClick(self)
  local curSelect = DataCenter.GiftVoucherShopBuildBubbleDataManager:GetBubbleShowSet()
  DataCenter.GiftVoucherShopBuildBubbleDataManager:SetBubbleShowSet(not curSelect)
  self:RefreshSelectComp()
end

local function OnInitScroll(self, go, index)
  local item = self.svGoodsN:AddComponent(CommonGiftVoucherShopItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local conf = self.goodsList[index + 1]
  if conf == nil then
    return
  end
  go.name = conf.id
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetItem(self.goodsList[index + 1], self.curShowType)
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearItemCell(self)
  self.svGoodsN:RemoveComponents(CommonGiftVoucherShopItem)
  self.contentN:DestroyChildNode()
end

local function SetNodeList(self, refresh_time_root, refresh_time_title, refresh_time_txt, spe_res_num)
  self.spe_res_num = spe_res_num
end

local function SetGoodsInfo(self)
  local shopInfo = DataCenter.CommonShopManager:GetGoodsListByShopType(self.curShowType)
  local sortList = {}
  for _, item in ipairs(shopInfo) do
    item.state = self:GetGoodsState(item)
    table.insert(sortList, item)
  end
  table.sort(sortList, function(a, b)
    if a.state == b.state then
      return a.order > b.order
    end
    return a.state < b.state
  end)
  self.goodsList = sortList
end

local function GetGoodsState(self, goodsConf)
  local state = ShoGoodsState.None
  if self:IsGoodsItemSoldOut(goodsConf) then
    state = ShoGoodsState.SoldOut
  elseif self:IsGoodsItemUnlock(goodsConf) then
    state = ShoGoodsState.isUnlock
  elseif self:IsGoodsItemHaveItem(goodsConf) then
    state = ShoGoodsState.isHave
  else
    state = ShoGoodsState.Sale
  end
  return state
end

local function IsGoodsItemSoldOut(self, goodsConf)
  local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.curShowType, goodsConf.id)
  local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
  return boughtTimes >= goodsConf.maxTimes
end

local function IsGoodsItemUnlock(self, goodsConf)
  local itemId = goodsConf.itemId
  local items = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local skinId = tonumber(items.para1)
  local skinData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
  return skinData and skinData.expireTime == 0
end

local function IsGoodsItemHaveItem(self, goodsConf)
  local isHave = false
  local itemId = goodsConf.itemId
  local items = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if items == nil then
    return isHave
  end
  if items.type ~= GOODS_TYPE.GOODS_TYPE_113 then
    return isHave
  end
  local skinId = tonumber(items.para1)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  local gain = template.gainMethod
  for k, v in pairs(gain) do
    local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(v.id)
    if itemData and tonumber(itemData.para2) == 0 and 0 < DataCenter.ItemData:GetItemCount(v.id) then
      isHave = true
      break
    end
  end
  return isHave
end

CommonGiftVoucherShopPanel.OnCreate = OnCreate
CommonGiftVoucherShopPanel.OnDestroy = OnDestroy
CommonGiftVoucherShopPanel.OnDisable = OnDisable
CommonGiftVoucherShopPanel.OnAddListener = OnAddListener
CommonGiftVoucherShopPanel.OnRemoveListener = OnRemoveListener
CommonGiftVoucherShopPanel.ComponentDefine = ComponentDefine
CommonGiftVoucherShopPanel.ComponentDestroy = ComponentDestroy
CommonGiftVoucherShopPanel.DataDefine = DataDefine
CommonGiftVoucherShopPanel.DataDestroy = DataDestroy
CommonGiftVoucherShopPanel.ShowPanel = ShowPanel
CommonGiftVoucherShopPanel.RefreshAll = RefreshAll
CommonGiftVoucherShopPanel.OnInitScroll = OnInitScroll
CommonGiftVoucherShopPanel.OnUpdateScroll = OnUpdateScroll
CommonGiftVoucherShopPanel.OnDestroyScrollItem = OnDestroyScrollItem
CommonGiftVoucherShopPanel.ClearItemCell = ClearItemCell
CommonGiftVoucherShopPanel.SetNodeList = SetNodeList
CommonGiftVoucherShopPanel.RefreshSelectComp = RefreshSelectComp
CommonGiftVoucherShopPanel.OnSelectCompBtnClick = OnSelectCompBtnClick
CommonGiftVoucherShopPanel.SetGoodsInfo = SetGoodsInfo
CommonGiftVoucherShopPanel.GetGoodsState = GetGoodsState
CommonGiftVoucherShopPanel.IsGoodsItemSoldOut = IsGoodsItemSoldOut
CommonGiftVoucherShopPanel.IsGoodsItemUnlock = IsGoodsItemUnlock
CommonGiftVoucherShopPanel.IsGoodsItemHaveItem = IsGoodsItemHaveItem
return CommonGiftVoucherShopPanel
