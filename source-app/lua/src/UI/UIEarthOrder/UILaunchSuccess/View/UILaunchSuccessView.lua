local UILaunchSuccessView = BaseClass("UILaunchSuccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceItem = require("UI.UICapacityTable.Component.ResourceItem")
local reward_title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local bg_btn_path = "UICommonRewardPopUp/Panel"
local money_cell_path = "Root/Table/CellList/Viewport/Content/UIMoney"
local money_cell_txt_path = "Root/Table/CellList/Viewport/Content/UIMoney/item_num"
local scroll_content_path = "Root/Table/CellList/Viewport/Content"
local ResourceItem_path = "Root/Cell/ResourceItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, reward_title_path)
  self.textTitle:SetLocalText(128027)
  local btnClose = self:AddComponent(UIButton, bg_btn_path)
  btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textMoney = self:AddComponent(UIText, money_cell_txt_path)
  self.MoneyCell = self:AddComponent(UIBaseContainer, money_cell_path)
  self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
  self.item_prefab = self.transform:Find(ResourceItem_path).gameObject
  self.item_prefab:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textMoney = nil
  self.MoneyCell = nil
  self.scroll_content = nil
  self.item_prefab.gameObject:GameObjectRecycleAll()
  self.item_prefab = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  local param = self:GetUserData()
  self.itemList = param.itemList
  self.money = param.money
  self:InitData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitData(self)
  if self.money > 0 then
    self.textMoney:SetText(self.money)
    self.MoneyCell.gameObject:SetActive(true)
  else
    self.MoneyCell.gameObject:SetActive(false)
  end
  self.item_prefab.gameObject:GameObjectRecycleAll()
  local list = self.itemList
  if list ~= nil then
    for i = 1, table.length(list) do
      local item = self.item_prefab:GameObjectSpawn(self.scroll_content.transform)
      item.name = tostring(i)
      local cell = self.scroll_content:AddComponent(ResourceItem, item.name, list[i])
      cell:RefreshData(list[i])
    end
  end
end

UILaunchSuccessView.OnCreate = OnCreate
UILaunchSuccessView.OnDestroy = OnDestroy
UILaunchSuccessView.OnEnable = OnEnable
UILaunchSuccessView.OnDisable = OnDisable
UILaunchSuccessView.ComponentDefine = ComponentDefine
UILaunchSuccessView.ComponentDestroy = ComponentDestroy
UILaunchSuccessView.InitData = InitData
return UILaunchSuccessView
