local Vip18CityListPanel = BaseClass("Vip18CityListPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local VipExtendCitySkinProduceItem = require("UI.UIVipExtend.Component.Vip18.VipExtendCitySkinProduceItem")
local title_path = "canvasGroup/title"
local item_holder_path = "ItemHolder"
local item_content_path = "ItemHolder/ItemContent"
local silde_to_next_page_desc_path = "canvasGroup/bottom/sildeToNextPageDesc"
local next_page_btn_path = "canvasGroup/bottom/nextPageBtn"
local HIDE_PANEL_ANI_TIME = 0.15
local AnimationNames = {
  Show = "Eff_VipExtendVip18PanelCityIn",
  Show2 = "Eff_VipExtendVip18PanelCityIn2",
  Hide = "Eff_VipExtendVip18PanelCityOut"
}

function Vip18CityListPanel:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("vip_base_skin_desc8")
  self.itemContent = self:AddComponent(UIScrollRect, item_holder_path)
  self.itemContent:AddValueChangeListener(function(vec)
    self:OnScrollValueChanged(vec)
  end)
  self.itemContentScroll = self:AddComponent(GridInfinityScrollView, item_content_path)
  self.nextPage_desc = self:AddComponent(UITextMeshProUGUIEx, silde_to_next_page_desc_path)
  self.nextPage_desc:SetLocalText("vip_base_skin_desc12")
  self.nextPage_btn = self:AddComponent(UIButton, next_page_btn_path)
  self.nextPage_btn:SetOnClick(function()
    self:OnNextPageBtnClick()
  end)
  self.dataList = {}
  self.listGO = {}
  self.animator = self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
end

function Vip18CityListPanel:OnDestroy()
  self:ClearItemCell()
  self.animator = nil
  self.title = nil
  self.itemContent = nil
  self.itemContentScroll = nil
  base.OnDestroy(self)
end

function Vip18CityListPanel:OnEnable()
  base.OnEnable(self)
end

function Vip18CityListPanel:OnDisable()
  base.OnDisable(self)
end

function Vip18CityListPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.VipExtendCitySkinListUpdate, self.OnRefreshList)
end

function Vip18CityListPanel:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.VipExtendCitySkinListUpdate, self.OnRefreshList)
end

function Vip18CityListPanel:InitPanel(param)
  self.onNextPageClickHandler = param.onNextPageClickHandler
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  self.itemContentScroll:Init(bindFunc1, bindFunc2)
  self:RefreshList()
end

function Vip18CityListPanel:OnNextPageBtnClick()
  self.itemContentScroll:MoveItemByIndex(0, 0)
  if self.onNextPageClickHandler then
    self.onNextPageClickHandler(self.holder)
  end
end

function Vip18CityListPanel:OnRefreshList()
  self:RefreshList()
end

function Vip18CityListPanel:RefreshList()
  self.dataList = DataCenter.VipExtendManager.historyRecords
  local itemCount = #self.dataList
  if 0 < itemCount then
    self.itemContentScroll:SetItemCount(itemCount)
  end
end

function Vip18CityListPanel:OnInitScroll(go, index)
  local item = self.itemContent:AddComponent(VipExtendCitySkinProduceItem, go)
  self.listGO[go] = item
end

function Vip18CityListPanel:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  go.name = "citySkinItem_" .. index
  local param = {
    data = self.dataList[index + 1],
    index = index + 1
  }
  cellItem:ReInit(param)
  cellItem:SetActive(true)
end

function Vip18CityListPanel:ClearItemCell()
  self.itemContent:RemoveComponents(VipExtendCitySkinProduceItem)
  self.itemContentScroll:DestroyChildNode()
end

function Vip18CityListPanel:OnScrollValueChanged(value)
  if value.y < 0.1 then
    DataCenter.VipExtendManager:LoadMoreHistory()
  end
end

return Vip18CityListPanel
