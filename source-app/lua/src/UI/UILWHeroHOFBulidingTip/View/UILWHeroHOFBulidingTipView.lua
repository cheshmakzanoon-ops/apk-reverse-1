local UILWHeroHOFBulidingTipView = BaseClass("UILWHeroHOFBulidingTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.buildingIcon = self:AddComponent(UIImage, "Root/BuildingIcon")
  self.tipText = self:AddComponent(UIText, "Root/TipText")
  self.gotoBtn = self:AddComponent(UIButton, "Root/GotoBtn")
  self.gotoBtn:SetOnClick(function()
    if not self.buildId then
      return
    end
    GoToUtil.GotoCityByBuildId(self.buildId, WorldTileBtnType.City_Upgrade)
  end)
  self.gotoBtnText = self:AddComponent(UIText, "Root/GotoBtn/BtnText")
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.closePanel = nil
  self.buildingIcon = nil
  self.tipText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshView(self)
  if not self.buildId then
    return
  end
  local needLevel = 1
  if self.needLevel then
    needLevel = self.needLevel
  end
  self.buildingIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.buildId, needLevel))
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
  self.tipText:SetLocalText(310128, needLevel, Localization:GetString(buildTemplate.name))
end

local function OnCreate(self)
  base.OnCreate(self)
  DataDefine(self)
  ComponentDefine(self)
  self.buildId, self.needLevel = self:GetUserData()
  RefreshView(self)
end

local function OnDestroy(self)
  DataDestroy(self)
  ComponentDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UILWHeroHOFBulidingTipView.OnCreate = OnCreate
UILWHeroHOFBulidingTipView.OnDestroy = OnDestroy
UILWHeroHOFBulidingTipView.OnEnable = OnEnable
UILWHeroHOFBulidingTipView.OnDisable = OnDisable
UILWHeroHOFBulidingTipView.ComponentDefine = ComponentDefine
UILWHeroHOFBulidingTipView.ComponentDestroy = ComponentDestroy
UILWHeroHOFBulidingTipView.DataDefine = DataDefine
UILWHeroHOFBulidingTipView.DataDestroy = DataDestroy
UILWHeroHOFBulidingTipView.OnAddListener = OnAddListener
UILWHeroHOFBulidingTipView.OnRemoveListener = OnRemoveListener
return UILWHeroHOFBulidingTipView
