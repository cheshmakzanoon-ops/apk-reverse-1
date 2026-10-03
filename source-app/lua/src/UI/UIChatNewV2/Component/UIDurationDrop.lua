local base = UIBaseContainer
local UIDurationDrop = BaseClass("UIDurationDrop", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIDurationDropItem = require("UI.UIChatNewV2.Component.UIDurationDropItem")

function UIDurationDrop:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDurationDrop:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDurationDrop:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compDrop = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.contentCom = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compItem = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.compDropView = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.btnDrop = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnDrop:SetOnClick(function()
    self:OnBtnDropClick()
  end)
  self.itemObj = self.compItem.gameObject
  self.itemObj:GameObjectCreatePool()
end

function UIDurationDrop:OnBtnDropClick()
  self:ChangeType(true)
end

function UIDurationDrop:ChangeType(isOn)
  self.isShowDrop = isOn
  self.compDropView:SetActive(isOn)
  self.btnMask:SetActive(isOn)
end

function UIDurationDrop:ComponentDestroy()
  self.contentCom:RemoveComponents(UIDurationDropItem)
  self.itemObj:GameObjectRecycleAll()
  self.itemObj = nil
  self.viewSkin = nil
  self.compDrop = nil
  self.text = nil
  self.contentCom = nil
  self.compItem = nil
  self.btnMask = nil
  self.compDropView = nil
  self.btnDrop = nil
end

function UIDurationDrop:ReInit(dataList, param)
  if not dataList then
    return
  end
  local data
  self.cellDic = {}
  self.dataList = dataList
  self.param = param
  self.contentCom:RemoveComponents(UIDurationDropItem)
  self.itemObj:GameObjectRecycleAll()
  for i = 1, #dataList do
    data = {
      generalColor = param.generalColor,
      selectColor = param.selectColor,
      text = dataList[i],
      callBack = function(index)
        self:OnItemSelect(index)
      end
    }
    local go = self.itemObj:GameObjectSpawn(self.contentCom.transform)
    go:SetActive(true)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "item" .. tostring(i)
    local cell = self.contentCom:AddComponent(UIDurationDropItem, go.name)
    cell:ReInit(data, i)
    self.cellDic[i] = cell
  end
  self:ChangeType(false)
end

function UIDurationDrop:SetOnValueChanged(valueChangeCallBack)
  self.valueChangeCallBack = valueChangeCallBack
end

function UIDurationDrop:OnItemSelect(index)
  self:SetValue(index)
  self:ChangeType(false)
end

function UIDurationDrop:SetValue(index, notNotify)
  for i, item in pairs(self.cellDic) do
    item:ChangeItem(index)
  end
  self.text:SetText(self.dataList[index])
  if self.valueChangeCallBack and not notNotify then
    self.valueChangeCallBack(index)
  end
end

function UIDurationDrop:DataDefine()
  self.cellDic = {}
end

function UIDurationDrop:DataDestroy()
  self.cellDic = nil
  self.dataList = nil
  self.param = nil
end

function UIDurationDrop:OnAddListener()
  base.OnAddListener(self)
end

function UIDurationDrop:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDurationDrop:OnBtnMaskClick()
  self:ChangeType(false)
end

return UIDurationDrop
