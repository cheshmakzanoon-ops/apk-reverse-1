local UILWDominatorPropertyDetailView = BaseClass("UILWDominatorPropertyDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroPropertyGroup = require("UI/UILWDominator/PropertyDetail/Component/UILWDominatorPropertyDetailGroup")

function UILWDominatorPropertyDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorPropertyDetailView:ClearScroll()
  self.propertyGroupList:ClearCells()
  self.propertyGroupList:RemoveComponents(UIHeroPropertyGroup)
end

function UILWDominatorPropertyDetailView:OnDestroy()
  self:ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWDominatorPropertyDetailView:OnClickPropertyItem(itemObj, propertyDesc)
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = Localization:GetString(propertyDesc)
  param.alignObject = itemObj
  param.width = 400
  param.yPosFix = 11
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function UILWDominatorPropertyDetailView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.propertyGroupList:AddComponent(UIHeroPropertyGroup, itemObj)
  cellItem:SetData(self.propertyLineTemplatePrefab, self.propertyGroupiesData[index], BindCallback(self, self.OnClickPropertyItem))
end

function UILWDominatorPropertyDetailView:OnItemMoveOut(itemObj, index)
  self.propertyGroupList:RemoveComponent(itemObj.name, UIHeroPropertyGroup)
end

function UILWDominatorPropertyDetailView:ComponentDefine()
  self.bgCloseBtn = self:AddComponent(UIButton, "Panel")
  self.bgCloseBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.titleText = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.propertyGroupList = self:AddComponent(UIScrollView, "Root/ImgBg/PropertyGroupScrollView")
  self.propertyGroupContent = self:AddComponent(UIBaseContainer, "Root/ImgBg/PropertyGroupScrollView/Viewport/Content")
  self.propertyGroupList:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.propertyGroupList:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.propertyLineTemplate = self:AddComponent(UIBaseContainer, "UIHeroPropLineItem")
  self.propertyLineTemplatePrefab = self.propertyLineTemplate.gameObject
  self.propertyLineTemplatePrefab:GameObjectCreatePool()
end

function UILWDominatorPropertyDetailView:DataDefine()
end

function UILWDominatorPropertyDetailView:ComponentDestroy()
  self.bgCloseBtn = nil
  self.titleText = nil
  self.propertyGroupList = nil
  self.propertyGroupContent = nil
  self.propertyLineTemplatePrefab:GameObjectRecycleAll()
  self.propertyLineTemplatePrefab = nil
end

function UILWDominatorPropertyDetailView:DataDestroy()
end

function UILWDominatorPropertyDetailView:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function UILWDominatorPropertyDetailView:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function UILWDominatorPropertyDetailView:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorPropertyDetailView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorPropertyDetailView:OnOpen()
  self.dominatorInfo, self.propertyType = self:GetUserData()
  self.titleText:SetLocalText("dominator_attr_title_1")
  self:UpdateView()
end

function UILWDominatorPropertyDetailView:UpdateView()
  DataCenter.LWEffectOverviewManager:RefreshShowData()
  self.propertyGroupiesData = self.ctrl:GetHeroPropertyDetailGroupList(self.dominatorInfo, self.propertyType)
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

function UILWDominatorPropertyDetailView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UILWDominatorPropertyDetailView
