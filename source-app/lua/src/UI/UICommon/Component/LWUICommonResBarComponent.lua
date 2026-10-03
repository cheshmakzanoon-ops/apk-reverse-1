local base = UIBaseContainer
local LWUICommonResBarComponent = BaseClass("LWUICommonResBarComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICommonResBarComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICommonResBarComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICommonResBarComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgResourceIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textResourceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnAdd = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.compAddRedPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function LWUICommonResBarComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgResourceIcon = nil
  self.textResourceNum = nil
  self.btnAdd = nil
  self.compAddRedPoint = nil
end

function LWUICommonResBarComponent:DataDefine()
  self.itemId = nil
  self.resourceType = nil
  self.addBtnCallBack = nil
end

function LWUICommonResBarComponent:DataDestroy()
  self.itemId = nil
  self.resourceType = nil
  self.addBtnCallBack = nil
end

function LWUICommonResBarComponent:SetData(itemId, resourceType, addBtnCallBack)
  self.itemId = itemId
  self.resourceType = resourceType
  self.addBtnCallBack = addBtnCallBack
  local iconPath = self:GetIconName()
  self.imgResourceIcon:LoadSprite(iconPath)
  local resNum = self:GetCurNum()
  self.textResourceNum:SetText(string.GetFormattedSeperatorNum(resNum))
end

function LWUICommonResBarComponent:RefreshData()
  local resNum = self:GetCurNum()
  if self.textResourceNum then
    self.textResourceNum:SetText(string.GetFormattedSeperatorNum(resNum))
  end
end

function LWUICommonResBarComponent:SetRedPointActive(isActive)
  self.compAddRedPoint:SetActive(isActive)
end

function LWUICommonResBarComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUICommonResBarComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

local showNeedCount = 100000

function LWUICommonResBarComponent:OnBtnAddClick()
  if self.addBtnCallBack then
    self.addBtnCallBack()
    return
  end
  if self.itemId then
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, showNeedCount)
  elseif self.resourceType == ResourceType.Gold then
    local data = {}
    table.insert(data, {
      resType = self.resourceType,
      need = showNeedCount
    })
    LWResourceLackUtil:GotoResLack(data)
  end
end

function LWUICommonResBarComponent:GetIconName()
  if self.itemId ~= nil then
    return DataCenter.ItemTemplateManager:GetIconPath(self.itemId)
  elseif self.resourceType ~= nil then
    return DataCenter.ResourceManager:GetResourceIconByType(self.resourceType)
  end
  return ""
end

function LWUICommonResBarComponent:GetCurNum()
  if self.itemId ~= nil then
    return DataCenter.ItemData:GetItemCount(self.itemId)
  elseif self.resourceType ~= nil then
    return LuaEntry.Resource:GetCntByResType(self.resourceType)
  end
  return 0
end

return LWUICommonResBarComponent
