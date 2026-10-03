local UIKillZombieBoxResItem = BaseClass("UIKillZombieBoxResItem", UIBaseContainer)
local base = UIBaseContainer

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
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "NumText")
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textNum = nil
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

local function Init(self, itemId)
  if itemId ~= nil and itemId ~= "" then
    local newAlData = DataCenter.ActivityKillZombieManager.newAlData
    local remainNum = newAlData and newAlData.keyNum or 0
    local iconPath = DataCenter.ItemTemplateManager:GetIconPath(itemId)
    if iconPath then
      self.imgIcon:LoadSprite(iconPath)
    end
    self.textNum:SetText(remainNum)
    return remainNum
  end
end

local function RefreshNum(self, remainNum)
  if remainNum then
    self.textNum:SetText(remainNum)
    if remainNum == 0 then
      self:SetActive(false)
    end
  end
end

UIKillZombieBoxResItem.OnCreate = OnCreate
UIKillZombieBoxResItem.OnDestroy = OnDestroy
UIKillZombieBoxResItem.OnEnable = OnEnable
UIKillZombieBoxResItem.OnDisable = OnDisable
UIKillZombieBoxResItem.ComponentDefine = ComponentDefine
UIKillZombieBoxResItem.ComponentDestroy = ComponentDestroy
UIKillZombieBoxResItem.DataDefine = DataDefine
UIKillZombieBoxResItem.DataDestroy = DataDestroy
UIKillZombieBoxResItem.OnAddListener = OnAddListener
UIKillZombieBoxResItem.OnRemoveListener = OnRemoveListener
UIKillZombieBoxResItem.Init = Init
UIKillZombieBoxResItem.RefreshNum = RefreshNum
return UIKillZombieBoxResItem
