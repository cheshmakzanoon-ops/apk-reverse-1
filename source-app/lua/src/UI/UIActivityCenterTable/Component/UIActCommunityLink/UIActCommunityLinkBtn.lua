local UIActCommunityLinkBtn = BaseClass("UIActCommunityLinkBtn", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIRawImage, "RawImage")
  self.btn = self:AddComponent(UIButton, "")
  self.newImg = self:AddComponent(UIBaseComponent, "NewImg")
end

local function DataDefine(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnDisable(self)
  self.data:SaveNeedShowNew()
  base.OnDisable(self)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.newImg = nil
end

local function DataDestroy(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self, data, clickAction)
  self.data = data
  self.icon:LoadSprite(data.iconPath)
  self.btn:SetOnClick(function()
    self:OnClick()
    if clickAction then
      clickAction()
    end
  end)
  self.newImg:SetActive(data.needShowNew)
  self.data:SaveNeedShowNew()
end

local function OnClick(self)
  self.data:SaveNeedShowNew()
  self.newImg:SetActive(self.data.needShowNew)
end

UIActCommunityLinkBtn.OnCreate = OnCreate
UIActCommunityLinkBtn.OnEnable = OnEnable
UIActCommunityLinkBtn.OnAddListener = OnAddListener
UIActCommunityLinkBtn.OnRemoveListener = OnRemoveListener
UIActCommunityLinkBtn.OnDisable = OnDisable
UIActCommunityLinkBtn.ComponentDefine = ComponentDefine
UIActCommunityLinkBtn.ComponentDestroy = ComponentDestroy
UIActCommunityLinkBtn.ComponentDestroy = ComponentDestroy
UIActCommunityLinkBtn.DataDefine = DataDefine
UIActCommunityLinkBtn.DataDestroy = DataDestroy
UIActCommunityLinkBtn.OnDestroy = OnDestroy
UIActCommunityLinkBtn.SetData = SetData
UIActCommunityLinkBtn.OnClick = OnClick
return UIActCommunityLinkBtn
