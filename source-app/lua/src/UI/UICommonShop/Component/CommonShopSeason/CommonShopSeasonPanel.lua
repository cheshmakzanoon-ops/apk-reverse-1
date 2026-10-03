local base = UIBaseView
local CommonShopSeasonPanel = BaseClass("CommonShopSeasonPanel", base)
local Localization = CS.GameEntry.Localization
local CommonShopSeasonItem = require("UI.UICommonShop.Component.CommonShopSeason.CommonShopSeasonItem")
local svGoods_path = "ScrollView"
local content_path = "ScrollView/Content"

function CommonShopSeasonPanel:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function CommonShopSeasonPanel:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CommonShopSeasonPanel:ComponentDefine()
  self.svGoodsN = self:AddComponent(UIBaseContainer, svGoods_path)
  self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
end

function CommonShopSeasonPanel:ComponentDestroy()
  self:ClearItemCell()
  self.svGoodsN = nil
  self.contentN = nil
end

function CommonShopSeasonPanel:DataDefine()
  self.curShowType = nil
  self.goodsList = {}
  self.goodsItemsList = {}
  self.listGO = {}
end

function CommonShopSeasonPanel:DataDestroy()
  self.curShowType = nil
  self.goodsList = nil
  self.goodsItemsList = nil
  self.listGO = nil
end

function CommonShopSeasonPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
end

function CommonShopSeasonPanel:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  base.OnRemoveListener(self)
end

function CommonShopSeasonPanel:ShowPanel(shopType)
  self.curShowType = CommonShopType.SeasonShop
  self.refresh_time_root:SetActive(false)
  self:RefreshAll(self.curShowType)
end

function CommonShopSeasonPanel:RefreshAll(shopType)
  if shopType and shopType == CommonShopType.SeasonShop then
    self.goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.SeasonShop)
    self.contentN:SetItemCount(#self.goodsList)
  end
  self.spe_res_num:SetText(string.GetFormattedGoldNum(SeasonUtil.GetSeasonShopResCount()))
end

function CommonShopSeasonPanel:OnInitScroll(go, index)
  local item = self.svGoodsN:AddComponent(CommonShopSeasonItem, go)
  self.listGO[go] = item
end

function CommonShopSeasonPanel:OnUpdateScroll(go, index)
  local conf = self.goodsList[index + 1]
  if conf == nil then
    return
  end
  go.name = conf.id
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetItem(self.goodsList[index + 1])
end

function CommonShopSeasonPanel:OnDestroyScrollItem(go, index)
end

function CommonShopSeasonPanel:ClearItemCell()
  self.svGoodsN:RemoveComponents(CommonShopSeasonItem)
  self.contentN:DestroyChildNode()
end

function CommonShopSeasonPanel:SetNodeList(refresh_time_root, refresh_time_title, refresh_time_txt, spe_res_num)
  self.refresh_time_root = refresh_time_root
  self.refresh_time_title = refresh_time_title
  self.refresh_time_txt = refresh_time_txt
  self.spe_res_num = spe_res_num
end

return CommonShopSeasonPanel
