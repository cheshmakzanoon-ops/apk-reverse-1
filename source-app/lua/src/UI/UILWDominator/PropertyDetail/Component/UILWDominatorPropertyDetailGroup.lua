local UILWDominatorPropertyDetailGroup = BaseClass("UILWDominatorPropertyDetailGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroPropertyItem = require("UI/UILWDominator/PropertyDetail/Component/UILWDominatorPropertyDetailItem")
local UICommonPropertyCanFoldItem = require("UI.UICommonPropertyCanFold.Component.UICommonPropertyCanFoldItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self.groupNameText = self:AddComponent(UIText, "PropertyGroupName")
  self.properties = self:AddComponent(UIBaseContainer, "Properties")
  self.bgImg = self:AddComponent(UIImage, "Img")
  self.cellReqs = {}
  self.cells = {}
end

local function ComponentDestroy(self)
  self:ClearList()
  self.groupNameText = nil
  self.properties = nil
  self.propertyLineTemplate = nil
  self.bgImg = nil
end

local function SetData(self, propertyLineTemplatePrefab, groupData, clickCallBack)
  if groupData == nil then
    return
  end
  self.groupNameText:SetLocalText(groupData.title)
  if groupData.showTitleType == HeroPropertyDetailShowTitle.Base then
    self.bgImg:SetColorRGBA(0.847, 0.811, 0.792, 1)
  else
    self.bgImg:SetColorRGBA(0.772, 0.776, 0.85, 1)
  end
  for i, v in ipairs(groupData.itemList) do
    self.cellReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonPropertyCanFoldItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.properties.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "showType_" .. i
      go.name = nameStr
      self.cells[i] = self.properties:AddComponent(UICommonPropertyCanFoldItem, nameStr)
      self.cells[i]:Refresh(v)
    end)
  end
end

local function ClearList(self)
  if self.cellReqs then
    self.properties:RemoveComponents(UICommonPropertyCanFoldItem)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

UILWDominatorPropertyDetailGroup.OnCreate = OnCreate
UILWDominatorPropertyDetailGroup.OnDestroy = OnDestroy
UILWDominatorPropertyDetailGroup.OnEnable = OnEnable
UILWDominatorPropertyDetailGroup.OnDisable = OnDisable
UILWDominatorPropertyDetailGroup.ComponentDefine = ComponentDefine
UILWDominatorPropertyDetailGroup.ComponentDestroy = ComponentDestroy
UILWDominatorPropertyDetailGroup.SetData = SetData
UILWDominatorPropertyDetailGroup.ClearList = ClearList
return UILWDominatorPropertyDetailGroup
