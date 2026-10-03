local SeasonDeclareCityDetailView = BaseClass("SeasonDeclareCityDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local DetailItem = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityDetail.Component.SeasonDeclareCityDetailItem")
local item_path = "PopUpTitle/ScrollView/Viewport/Content/item"
local items_path = "PopUpTitle/ScrollView/Viewport/Content/items"
local close_btn_path = "PopUpTitle/CloseBtn"

function SeasonDeclareCityDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonDeclareCityDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonDeclareCityDetailView:ComponentDefine()
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

function SeasonDeclareCityDetailView:ComponentDestroy()
  self.content:RemoveComponents(DetailItem)
  self.theItem:GameObjectRecycleAll()
end

function SeasonDeclareCityDetailView:UpdateData()
  local goItem
  local theItem = self.titleBar
  self.content:RemoveComponents(DetailItem)
  self.theItem:GameObjectRecycleAll()
  theItem:ReInit(0, true)
  for i = 1, 6 do
    local theName = "item_" .. i
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = theName
    goItem:SetActive(true)
    theItem = self.content:AddComponent(DetailItem, theName)
    theItem:ReInit(i, false)
  end
end

return SeasonDeclareCityDetailView
