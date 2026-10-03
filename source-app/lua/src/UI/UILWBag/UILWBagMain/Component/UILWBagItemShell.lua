local base = UIBaseContainer
local UILWBagItemShell = BaseClass("UILWBagItemShell", UIBaseContainer)
local BagItem = require("UI.UILWBag.UILWBagMain.Component.UILWBagItem")
local BagItemPath = "Assets/Main/Prefabs/UI/LWBag/UILWBagItem.prefab"

function UILWBagItemShell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWBagItemShell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBagItemShell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
end

function UILWBagItemShell:ComponentDestroy()
  self.viewSkin = nil
  self.compRoot = nil
end

function UILWBagItemShell:DataDefine()
  self.itemGo = nil
  self.itemScript = nil
  self.propertyData = nil
  self.isSelected = false
end

function UILWBagItemShell:DataDestroy()
  self.compRoot:RemoveComponents(BagItem)
  if self.itemGo ~= nil then
    self:GameObjectDestroy(self.itemGo)
    self.itemGo = nil
  end
  self.itemScript = nil
  self.propertyData = nil
  self.isSelected = false
end

function UILWBagItemShell:OnAddListener()
  base.OnAddListener(self)
end

function UILWBagItemShell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWBagItemShell:SetData(propertyData)
  self.propertyData = propertyData
  if self.itemScript then
    self:SetBagItemState(self.itemScript)
    self.itemScript:SetData(propertyData)
    self.itemScript:SetActive(true)
  else
    if self.itemGo then
      self:GameObjectDestroy(self.itemGo)
    end
    self.itemGo = self:GameObjectInstantiateAsync(BagItemPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      NameCount = NameCount + 1
      go.name = "BagItem" .. NameCount
      go.transform:SetParent(self.compRoot.transform)
      self.itemScript = self.compRoot:AddComponent(BagItem, go.name)
      self:SetBagItemState(self.itemScript)
      self.itemScript:SetData(propertyData)
      if self.isSelected then
        self.view:CellsCallBack_RefreshSelectFrame(self.itemScript.transform, self.propertyData.index)
      end
    end)
  end
end

function UILWBagItemShell:SetBagItemState(itemScript)
  itemScript:SetPivotXY(0, 1)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    itemScript:SetAnchoredPositionXY(162, 0)
  else
    itemScript:SetAnchoredPositionXY(0, 0)
  end
  itemScript:SetLocalScaleXYZ(1, 1, 1)
  itemScript:SetSizeDeltaXY(162, 170)
  itemScript:SetActive(true)
end

function UILWBagItemShell:SetSelectState(isSelected)
  self.isSelected = isSelected
  if self.itemScript and self.isSelected then
    self.view:CellsCallBack_RefreshSelectFrame(self.itemScript.transform, self.propertyData.index)
  end
end

function UILWBagItemShell:ResetRecycleState()
  self.isSelected = false
  if self.itemScript == nil and self.itemGo then
    self:GameObjectDestroy(self.itemGo)
  end
end

function UILWBagItemShell:OnBtnClick()
  if self.itemScript then
    self.itemScript:OnBtnClick()
  end
end

return UILWBagItemShell
