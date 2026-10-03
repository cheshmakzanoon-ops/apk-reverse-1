local UIRefundView = BaseClass("UIRefundView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LineItem = require("UI.UIRefundTip.Component.LineItem")
local panel_path = "panel"
local closeBtn_path = "Common_bg_orange/CloseBtn"
local line_template_path = "Common_bg_orange/Line"
local line_container_path = "Common_bg_orange/Common_bg_orange2/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_panel = self:AddComponent(UIButton, panel_path)
  self.close_panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.lineTemplate = self:AddComponent(UIBaseContainer, line_template_path)
  self.lineTemplate:SetActive(false)
  self.lineTemplateObj = self.lineTemplate.gameObject
  self.lineTemplateObj:GameObjectCreatePool()
  self.lineContainer = self:AddComponent(UIBaseContainer, line_container_path)
  self:RefreshView()
end

local function OnDestroy(self)
  self.lineContainer:RemoveComponents(LineItem)
  self.lineTemplateObj:GameObjectRecycleAll()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshView(self)
  local giftPacks = GiftPackageData:getPacksByType(GiftPackType.CreditPackage)
  if not table.IsNullOrEmpty(giftPacks) then
    table.sort(giftPacks, function(a, b)
      return tonumber(a:getID()) < tonumber(b:getID())
    end)
    for i, v in ipairs(giftPacks) do
      local tempLine = self.lineTemplateObj:GameObjectSpawn(self.lineContainer.transform)
      tempLine:SetActive(true)
      local strI = tostring(i)
      tempLine.name = strI
      local tempLineItem = self.lineContainer:AddComponent(LineItem, strI)
      local viewData = {}
      viewData.price = string.format("%s:", v:getPriceText())
      viewData.creditValue = v:getCredit()
      tempLineItem:OnRefresh(viewData)
    end
  end
end

UIRefundView.OnCreate = OnCreate
UIRefundView.OnDestroy = OnDestroy
UIRefundView.OnEnable = OnEnable
UIRefundView.OnDisable = OnDisable
UIRefundView.RefreshView = RefreshView
return UIRefundView
