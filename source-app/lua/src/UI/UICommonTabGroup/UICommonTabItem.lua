local base = UIBaseContainer
local UICommonTabItem = BaseClass("UICommonTabItem", base)
local btn_path = "TypeButton"
local selectPanel_path = "Select"
local unSelectPanel_path = "UnSelect"
local selectTitleText_path = "Select/SelectTitleText"
local unSelectTitleText_path = "UnSelect/UnSelectTitleText"
local newDot_path = "NewDot"
local redPoint_path = "RedPoint"
local redNum_path = "RedPoint/RedNum"
local selectIcon_path = "Select/SelectIcon"
local select_path = "Select"
local arrow_path = "Select/Arrow"
local unSelect_path = "TypeButton"
local unSelectIcon_path = "UnSelect/UnSelectIcon"

local function OnCreate(self, data, index)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData(data, index)
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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.selectPanel = self:AddComponent(UIBaseContainer, selectPanel_path)
  self.unSelectPanel = self:AddComponent(UIBaseContainer, unSelectPanel_path)
  self.selectTitleText = self:AddComponent(UIText, selectTitleText_path)
  self.unSelectTitleText = self:AddComponent(UIText, unSelectTitleText_path)
  self.newDot = self:AddComponent(UIBaseContainer, newDot_path)
  self.redPoint = self:AddComponent(UIBaseContainer, redPoint_path)
  self.redNum = self:AddComponent(UIText, redNum_path)
  self.selectIcon = self:AddComponent(UIImage, selectIcon_path)
  self.select = self:AddComponent(UIImage, select_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.btn:SetOnClick(BindCallback(self, self.SelectTab))
  self.layout = self:TryAddComponent(UILayoutElement, "")
  self.unSelect = self:TryAddComponent(UIImage, unSelect_path)
  self.unSelectIcon = self:TryAddComponent(UIImage, unSelectIcon_path)
  self.unSelect = self:TryAddComponent(UIImage, unSelectPanel_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.selectPanel = nil
  self.unSelectPanel = nil
  self.selectTitleText = nil
  self.unSelectTitleText = nil
  self.newDot = nil
  self.redPoint = nil
  self.redNum = nil
  self.selectIcon = nil
  self.select = nil
  self.arrow = nil
  self.layout = nil
  self.unSelectIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
  self.index = nil
  self.eventId = nil
  self.tabSelectAction = nil
  self.clickAction = nil
  self.refreshRedAction = nil
end

local function SetData(self, data, index)
  self.data = data
  self.index = index
  self.eventId = self.data.eventId
  self.selectTitleText:SetText(data.title)
  self.unSelectTitleText:SetText(data.title)
  if not string.IsNullOrEmpty(self.data.iconPath) then
    self.selectIcon:SetActive(true)
    self.selectIcon:LoadSprite(self.data.iconPath)
  else
    self.selectIcon:SetActive(false)
  end
  if self.unSelect and self.data.unSelectBgPath then
    if not string.IsNullOrEmpty(self.data.unSelectBgPath) then
      self.unSelect:LoadSprite(self.data.unSelectBgPath)
    else
      self.unSelect:LoadSprite(string.format(LoadPath.LWCommonPath, "cfm_tongyong_yeqian_yiji_2.png"))
    end
  end
  if self.unSelectIcon then
    if not string.IsNullOrEmpty(self.data.unSelectIconPath) then
      self.unSelectIcon:SetActive(true)
      self.unSelectIcon:LoadSprite(self.data.unSelectIconPath)
    else
      self.unSelectIcon:SetActive(false)
    end
  end
  if not string.IsNullOrEmpty(self.data.selectBgPath) then
    self.select:LoadSpriteAsync(self.data.selectBgPath)
  else
    self.select:LoadSprite(string.format(LoadPath.UIActivity, "cfm_huodong_yeqian_!.png"))
  end
  if not string.IsNullOrEmpty(self.data.unSelectBgPath) and self.unSelect then
    self.unSelect:LoadSpriteAsync(self.data.unSelectBgPath)
  end
  if self.data.arrowPath == false then
    self.arrow:SetActive(false)
  else
    if not string.IsNullOrEmpty(self.data.arrowPath) then
      self.arrow:LoadSprite(self.data.arrowPath)
    else
      self.arrow:LoadSprite(string.format(LoadPath.UIActivity, "cfm_huodong_yeqian_2.png"))
    end
    self.arrow:SetActive(true)
  end
  if self.layout then
    if self.data.minWidth then
      self.layout:SetMinWidth(self.data.minWidth)
    end
    if self.data.minHeight then
      self.layout:SetMinHeight(self.data.minHeight)
    end
  end
  self.selectPanel:SetActive(false)
  self.unSelectPanel:SetActive(false)
  self.newDot:SetActive(false)
  self.redPoint:SetActive(false)
end

local function SetCallback(self, tabSelectAction, clickAction, refreshRedAction)
  self.tabSelectAction = tabSelectAction
  self.clickAction = clickAction
  self.refreshRedAction = refreshRedAction
end

local function SelectTab(self)
  if self.tabSelectAction then
    self.tabSelectAction(self.index)
  end
end

local function SetUnSelect(self)
  self.selectPanel:SetActive(false)
  self.unSelectPanel:SetActive(true)
end

local function SetSelect(self)
  self.selectPanel:SetActive(true)
  self.unSelectPanel:SetActive(false)
end

local function OnClick(self)
  if self.clickAction then
    self.clickAction(self.index)
  end
end

local function RefreshRedPoint(self)
  if not self.refreshRedAction then
    return
  end
  local isRed, redNum = self.refreshRedAction(self.index)
  self.redPoint:SetActive(isRed)
  if redNum and 0 < redNum then
    self.redNum:SetActive(true)
    self.redNum:SetText(redNum)
  else
    self.redNum:SetActive(false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  if not string.IsNullOrEmpty(self.eventId) then
    self:AddUIListener(self.eventId, self.RefreshRedPoint)
  end
end

local function OnRemoveListener(self)
  if not string.IsNullOrEmpty(self.eventId) then
    self:RemoveUIListener(self.eventId, self.RefreshRedPoint)
  end
  base.OnRemoveListener(self)
end

UICommonTabItem.OnCreate = OnCreate
UICommonTabItem.OnDestroy = OnDestroy
UICommonTabItem.OnEnable = OnEnable
UICommonTabItem.OnDisable = OnDisable
UICommonTabItem.ComponentDefine = ComponentDefine
UICommonTabItem.ComponentDestroy = ComponentDestroy
UICommonTabItem.DataDefine = DataDefine
UICommonTabItem.DataDestroy = DataDestroy
UICommonTabItem.SetData = SetData
UICommonTabItem.SetCallback = SetCallback
UICommonTabItem.SelectTab = SelectTab
UICommonTabItem.SetUnSelect = SetUnSelect
UICommonTabItem.SetSelect = SetSelect
UICommonTabItem.OnClick = OnClick
UICommonTabItem.RefreshRedPoint = RefreshRedPoint
UICommonTabItem.OnAddListener = OnAddListener
UICommonTabItem.OnRemoveListener = OnRemoveListener
return UICommonTabItem
