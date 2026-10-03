local Season5DeclareCityDetailView = BaseClass("Season5DeclareCityDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local DetailItem = require("UI.LWSeason5.DeclareCity.Season5DeclareCityDetail.Component.Season5DeclareCityDetailItem")
local item_path = "PopUpTitle/ScrollView/Viewport/Content/item"
local items_path = "PopUpTitle/ScrollView/Viewport/Content/items"
local close_btn_path = "PopUpTitle/CloseBtn"

function Season5DeclareCityDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function Season5DeclareCityDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareCityDetailView:ComponentDefine()
  self.titleBar = self:AddComponent(DetailItem, item_path)
  self.content = self:AddComponent(UIBaseContainer, items_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel = self:AddComponent(UIButton, "panel")
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.theItem = self.titleBar.gameObject
  self.theItem:GameObjectCreatePool()
  self:UpdateData()
end

function Season5DeclareCityDetailView:ComponentDestroy()
  self.content:RemoveComponents(DetailItem)
  self.theItem:GameObjectRecycleAll()
end

function Season5DeclareCityDetailView:UpdateData()
  local goItem
  local theItem = self.titleBar
  self.content:RemoveComponents(DetailItem)
  self.theItem:GameObjectRecycleAll()
  theItem:ReInit(0, true)
  for i = 1, 11 do
    local cityInfo = DataCenter.AllianceCityTemplateManager:GetCityByLevel(i, nil, 1)
    if cityInfo ~= nil then
      local theName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(DetailItem, theName)
      theItem:ReInit(i, false)
    end
  end
end

return Season5DeclareCityDetailView
