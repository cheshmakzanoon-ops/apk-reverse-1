local SeasonMilitaryShopNewPopupRowCell = require("UI.LWSeason6.UILWSeasonMilitaryShop.NewPopup.Comp.SeasonMilitaryShopNewPopupRowCell")
local base = UIBaseView
local SeasonMilitaryShopNewPopupView = BaseClass("SeasonMilitaryShopNewPopupView", UIBaseView)

function SeasonMilitaryShopNewPopupView:ComponentDefine()
  local p_btn_panel_path = "p_btn_panel"
  local p_scroll_view_path = "ContentRoot/content_list/p_scroll_view"
  self.p_btn_panel = self:AddComponent(UIButton, p_btn_panel_path)
  self.p_btn_panel:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_scroll_view = self:AddComponent(UILoopListViewSimple, p_scroll_view_path)
end

function SeasonMilitaryShopNewPopupView:ComponentDestroy()
  self.Data = nil
  self.p_btn_panel = nil
  self.p_text_title = nil
  self.p_scroll_view = nil
end

function SeasonMilitaryShopNewPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit(self:GetUserData())
end

function SeasonMilitaryShopNewPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonMilitaryShopNewPopupView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonMilitaryShopNewPopupView:InitData(data)
  if data ~= nil then
    self.Data = data
    DataCenter.SeasonBountyShopManager:SaveCurValidShopList()
    return true
  end
  return false
end

function SeasonMilitaryShopNewPopupView:InitUi()
  self.p_scroll_view:Clear()
  if not table.IsNullOrEmpty(self.Data.ShopIdList) then
    self.p_scroll_view:Init(SeasonMilitaryShopNewPopupRowCell)
    local rowData = {}
    for _, shopId in pairs(self.Data.ShopIdList) do
      local shopData = DataCenter.SeasonBountyShopManager:GetShopData(shopId)
      if shopData ~= nil and shopData:IsValid() then
        table.insert(rowData, shopData)
      end
      if table.count(rowData) == 3 then
        self.p_scroll_view:AddData(DeepCopy(rowData))
        table.clear(rowData)
      end
    end
    if table.count(rowData) > 0 then
      self.p_scroll_view:AddData(rowData)
    end
    self.p_scroll_view:Show()
  end
end

function SeasonMilitaryShopNewPopupView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

return SeasonMilitaryShopNewPopupView
