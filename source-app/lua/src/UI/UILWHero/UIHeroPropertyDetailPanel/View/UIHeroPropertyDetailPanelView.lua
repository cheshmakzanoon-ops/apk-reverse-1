local UIHeroPropertyDetailPanelView = BaseClass("UIHeroPropertyDetailPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroPropertyGroup = require("UI.UILWHero.UIHeroPropertyDetailPanel.Component.UIHeroPropertyGroup")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function ClearScroll(self)
  self.propertyGroupList:ClearCells()
  self.propertyGroupList:RemoveComponents(UIHeroPropertyGroup)
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnClickPropertyItem(self, itemObj, propertyDesc)
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = Localization:GetString(propertyDesc)
  param.alignObject = itemObj
  param.width = 400
  param.yPosFix = 11
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.propertyGroupList:AddComponent(UIHeroPropertyGroup, itemObj)
  cellItem:SetData(self.propertyLineTemplatePrefab, self.propertyGroupiesData[index], BindCallback(self, self.OnClickPropertyItem))
end

local function OnItemMoveOut(self, itemObj, index)
  self.propertyGroupList:RemoveComponent(itemObj.name, UIHeroPropertyGroup)
end

local function ComponentDefine(self)
  self.bgCloseBtn = self:AddComponent(UIButton, "Panel")
  self.bgCloseBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.titleText = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.propertyGroupList = self:AddComponent(UIScrollView, "Root/ImgBg/PropertyGroupScrollView")
  self.propertyGroupContent = self:AddComponent(UIBaseContainer, "Root/ImgBg/PropertyGroupScrollView/Viewport/Content")
  self.propertyGroupList:SetOnItemMoveIn(function(itemObj, index)
    OnItemMoveIn(self, itemObj, index)
  end)
  self.propertyGroupList:SetOnItemMoveOut(function(itemObj, index)
    OnItemMoveOut(self, itemObj, index)
  end)
  self.propertyLineTemplate = self:AddComponent(UIBaseContainer, "UIHeroPropLineItem")
  self.propertyLineTemplatePrefab = self.propertyLineTemplate.gameObject
  self.propertyLineTemplatePrefab:GameObjectCreatePool()
  self.infoBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_img_title/titleText/InfoBtn")
  self.infoBtn:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString(170001), nil, Localization:GetString("hero_overview_tips01"))
  end)
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.bgCloseBtn = nil
  self.titleText = nil
  self.propertyGroupList = nil
  self.propertyGroupContent = nil
  self.propertyLineTemplatePrefab:GameObjectRecycleAll()
  self.propertyLineTemplatePrefab = nil
  self.infoBtn = nil
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnOpen(self)
  self.heroData, self.propertyType = self:GetUserData()
  if self.propertyType == UIHeroPropertyDetailType.Hero then
    self.titleText:SetLocalText(151072)
  elseif self.propertyType == UIHeroPropertyDetailType.Equip then
    self.titleText:SetLocalText(151126)
  end
  self:UpdateView()
end

local function UpdateView(self)
  DataCenter.LWEffectOverviewManager:RefreshShowData()
  self.propertyGroupiesData = self.ctrl:GetHeroPropertyDetailGroupList(self.heroData, self.propertyType)
  local totalCount = 0
  if self.propertyGroupiesData ~= nil then
    totalCount = #self.propertyGroupiesData
  end
  if 0 < totalCount then
    self.propertyLineTemplatePrefab:GameObjectRecycleAll()
    self.propertyGroupList:SetTotalCount(totalCount)
    self.propertyGroupList:RefillCells()
  end
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UIHeroPropertyDetailPanelView.OnCreate = OnCreate
UIHeroPropertyDetailPanelView.OnDestroy = OnDestroy
UIHeroPropertyDetailPanelView.OnEnable = OnEnable
UIHeroPropertyDetailPanelView.OnDisable = OnDisable
UIHeroPropertyDetailPanelView.OnAddListener = OnAddListener
UIHeroPropertyDetailPanelView.OnRemoveListener = OnRemoveListener
UIHeroPropertyDetailPanelView.ComponentDefine = ComponentDefine
UIHeroPropertyDetailPanelView.DataDefine = DataDefine
UIHeroPropertyDetailPanelView.ComponentDestroy = ComponentDestroy
UIHeroPropertyDetailPanelView.DataDestroy = DataDestroy
UIHeroPropertyDetailPanelView.OnOpen = OnOpen
UIHeroPropertyDetailPanelView.OnBtnCloseClick = OnBtnCloseClick
UIHeroPropertyDetailPanelView.UpdateView = UpdateView
UIHeroPropertyDetailPanelView.OnClickPropertyItem = OnClickPropertyItem
return UIHeroPropertyDetailPanelView
