local UIRedEquipLimitTipView = BaseClass("UIRedEquipLimitTipView", UIBaseView)
local base = UIBaseView
local BagItem = require("UI.UIEquipRedOpen.Component.UIRedEquipLimitTipBagItem")
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local info_btn_path = "Root/InfoBtn"
local open_condition_title_path = "Root/topRoot/openConditionTitle"
local open_condition_limit_path = "Root/topRoot/openConditionLimit"
local equip_desc_path = "Root/bottomRoot/equipDesc"
local item_holder_path = "Root/bottomRoot/ItemHolder"
local item_content_path = "Root/bottomRoot/ItemHolder/ItemContent"

function UIRedEquipLimitTipView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.open_condition_title = self:AddComponent(UITextMeshProUGUIEx, open_condition_title_path)
  self.open_condition_limit = self:AddComponent(UITextMeshProUGUIEx, open_condition_limit_path)
  self.equip_desc = self:AddComponent(UITextMeshProUGUIEx, equip_desc_path)
  self.itemContent = self:AddComponent(UIScrollRect, item_holder_path)
  self.itemContentScroll = self:AddComponent(GridInfinityScrollView, item_content_path)
  self:ReInit()
end

function UIRedEquipLimitTipView:OnDestroy()
  self:ClearItemCell()
  base.OnDestroy(self)
end

function UIRedEquipLimitTipView:DataDefine()
  self.itemList = {}
  self.listGO = {}
end

function UIRedEquipLimitTipView:ReInit()
  self.title_text:SetLocalText("red_equip_open_title")
  self.open_condition_title:SetLocalText("red_equip_open_tip1")
  local totalLv = DataCenter.EquipDataManager:GetTotalLevelByQuality(HeroEquipQuality.Orange)
  local limitLevel = LuaEntry.DataConfig:TryGetNum("red_equip_open", "k1")
  self.open_condition_limit:SetLocalText("red_equip_open_tip2", totalLv, limitLevel)
  self.equip_desc:SetLocalText("red_equip_open_tip3")
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  self.itemContentScroll:Init(bindFunc1, bindFunc2)
  self:RefreshList()
end

function UIRedEquipLimitTipView:OnInitScroll(go, index)
  local item = self.itemContent:AddComponent(BagItem, go)
  self.listGO[go] = item
end

function UIRedEquipLimitTipView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  go.name = "bag_item_" .. index
  local param = {
    data = self.itemList[index + 1],
    type = BagItemType.HeroEquip,
    index = index + 1,
    showRedPoint = false
  }
  cellItem:SetData(param)
  cellItem:SetActive(true)
end

function UIRedEquipLimitTipView:RefreshList()
  self.itemList = self.ctrl:GetAllEquipList()
  local itemCount = #self.itemList
  if 0 < itemCount then
    self.itemContentScroll:SetItemCount(itemCount)
  end
end

function UIRedEquipLimitTipView:ClearItemCell()
  self.itemContent:RemoveComponents(BagItem)
  self.itemContentScroll:DestroyChildNode()
end

return UIRedEquipLimitTipView
