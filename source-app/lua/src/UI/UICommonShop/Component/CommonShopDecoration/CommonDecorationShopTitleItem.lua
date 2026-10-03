local CommonDecorationShopTitleItem = BaseClass("CommonDecorationShopTitleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.img = self:AddComponent(UIImage, "Image")
  self.compButton = self:AddComponent(UIButton, "Button")
  self.compButton:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.typeNameText = self:AddComponent(UIText, "TypeNameText")
  self.showImage = self:AddComponent(UIImage, "Button/ShowImage")
  self.notShowImage = self:AddComponent(UIImage, "Button/NotShowImage")
end

local function ComponentDestroy(self)
  self.img = nil
  self.compButton = nil
  self.typeNameText = nil
  self.btnImage = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, rowInfo, showDetail, curShopType)
  local decorationShopInfo = DataCenter.CommonShopManager:GetDecorationShopInfo(curShopType)
  if not decorationShopInfo then
    Logger.LogError("decorationShopInfo is nil")
    return
  end
  self.subType = rowInfo.subType
  local nameKey = decorationShopInfo:GetItemSubTypeKey(self.subType)
  if not nameKey or string.IsNullOrEmpty(nameKey) then
    Logger.LogError("nameKey is nil,subType==" .. self.subType)
  else
    self.typeNameText:SetLocalText(nameKey)
  end
  self.showImage:SetActive(showDetail)
  self.notShowImage:SetActive(not showDetail)
end

local function OnClickBtn(self)
  EventManager:GetInstance():Broadcast(EventId.OnDecorationShopClickRowItem, self.subType)
end

CommonDecorationShopTitleItem.OnCreate = OnCreate
CommonDecorationShopTitleItem.OnDestroy = OnDestroy
CommonDecorationShopTitleItem.OnEnable = OnEnable
CommonDecorationShopTitleItem.OnDisable = OnDisable
CommonDecorationShopTitleItem.ComponentDefine = ComponentDefine
CommonDecorationShopTitleItem.ComponentDestroy = ComponentDestroy
CommonDecorationShopTitleItem.DataDefine = DataDefine
CommonDecorationShopTitleItem.DataDestroy = DataDestroy
CommonDecorationShopTitleItem.OnAddListener = OnAddListener
CommonDecorationShopTitleItem.OnRemoveListener = OnRemoveListener
CommonDecorationShopTitleItem.SetData = SetData
CommonDecorationShopTitleItem.OnClickBtn = OnClickBtn
return CommonDecorationShopTitleItem
