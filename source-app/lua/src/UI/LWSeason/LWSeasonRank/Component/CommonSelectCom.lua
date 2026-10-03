local base = UIBaseContainer
local CommonSelectCom = BaseClass("CommonSelectCom", base)
local CommonSelectItem = require("UI.LWSeason.LWSeasonRank.Component.CommonSelectItem")
local selectText_path = "sortTypeTxt"
local selectBtn_path = ""
local selectIcon_path = "foldStateIcon"
local areaBg_path = "menuBg"
local itemParent_path = "menuBg/tContent"
local selectPrefab_path = "selectItem"

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
  self.selectText = self:AddComponent(UIText, selectText_path)
  self.selectBtn = self:AddComponent(UIButton, selectBtn_path)
  self.selectIcon = self:AddComponent(UIImage, selectIcon_path)
  self.areaBg = self:AddComponent(UIBaseContainer, areaBg_path)
  self.itemParent = self:AddComponent(UIBaseContainer, itemParent_path)
  self.selectPrefab = self:AddComponent(UIBaseContainer, selectPrefab_path)
  self.selectBtn:SetOnClick(function()
    self:OpenMenu()
  end)
end

local function ComponentDestroy(self)
  self.selectText = nil
  self.selectBtn = nil
  self.selectIcon = nil
  self.areaBg = nil
  self.itemParent = nil
  self.selectPrefab = nil
end

local function DataDefine(self)
  self.isOpen = false
  self.openFrame = -1
  self.selectPrefabPool = self.selectPrefab.gameObject
  self.selectPrefabPool:GameObjectCreatePool()
end

local function DataDestroy(self)
  self:ClearItem()
  self.selectPrefabPool = nil
  self.itemList = nil
  self.curIndex = nil
  self.callback = nil
  self.data = nil
  self.needFitBg = nil
  self.checkCount = nil
end

function CommonSelectCom:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SCREEN_TOUCH_CLICK_IGNORE_UI, self.OnScreenTouch)
end

function CommonSelectCom:OnRemoveListener()
  self:RemoveUIListener(EventId.SCREEN_TOUCH_CLICK_IGNORE_UI, self.OnScreenTouch)
  base.OnRemoveListener(self)
end

function CommonSelectCom:ClearItem()
  self.itemParent:RemoveComponents(CommonSelectItem)
  self.selectPrefabPool:GameObjectRecycleAll()
end

function CommonSelectCom:Init(data, callback)
  self.callback = callback
  self:ClearItem()
  self.data = data
  local count = #data.itemList
  self.itemList = {}
  self.curIndex = data.defaultIndex
  self.isTop = data.isTop == nil and true or data.isTop
  if data.isTop then
    self.isTop = data.isTop
  end
  if self.isTop then
    self.areaBg:SetPivotXY(0.5, 0)
    self.areaBg:SetAnchorMinXY(0.5, 1)
    self.areaBg:SetAnchorMaxXY(0.5, 1)
    self.areaBg:SetAnchoredPositionXY(0, 0)
  else
    self.areaBg:SetPivotXY(0.5, 1)
    self.areaBg:SetAnchorMinXY(0.5, 0)
    self.areaBg:SetAnchorMaxXY(0.5, 0)
    self.areaBg:SetAnchoredPositionXY(0, 0)
  end
  for index = 1, count do
    local itemData = data.itemList[index]
    local goItem = self.selectPrefabPool:GameObjectSpawn(self.itemParent.transform)
    local itemIndex = #self.itemList + 1
    goItem.name = "tab_" .. itemIndex
    goItem:SetActive(true)
    local itemCom = self.itemParent:AddComponent(CommonSelectItem, goItem.name)
    itemCom:ReInit(index, itemData, data.defaultIndex == index, function(i)
      self:SetIndex(i, true)
    end)
    table.insert(self.itemList, itemCom)
  end
  self:SetActive(true)
  self:HideMenu()
end

function CommonSelectCom:SetIndex(index, fireCall)
  if self.curIndex ~= index then
    local result = true
    if fireCall and self.callback then
      result = self.callback(self.data.itemList[index], index)
    end
    if result then
      if self.curIndex then
        self.itemList[self.curIndex]:SetSelectFlag(false)
      end
      self.itemList[index]:SetSelectFlag(true)
      self.curIndex = index
      if self.isOpen then
        self:HideMenu()
      end
      self.selectText:SetText(self.data.itemList[self.curIndex].des)
    end
  end
end

function CommonSelectCom:OpenMenu()
  if not self.isOpen then
    self.needFitBg = true
    self.checkCount = 0
    self.isOpen = true
    self.openFrame = Time.frameCount
    self.areaBg:SetActive(self.isOpen)
    if self.isTop then
      self.selectIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
    else
      self.selectIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png")
    end
  end
end

function CommonSelectCom:HideMenu()
  self.isOpen = false
  self.openFrame = -1
  self.areaBg:SetActive(self.isOpen)
  if self.isTop then
    self.selectIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png")
  else
    self.selectIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
  end
end

function CommonSelectCom:OnScreenTouch(info)
  if self.areaBg:GetActive() then
    if self.openFrame == Time.frameCount then
      return
    end
    if self:CheckRect(info) then
      return
    end
    self:HideMenu()
  end
end

function CommonSelectCom:CheckRect(touchInfo)
  local touchPos = touchInfo.pointerPos
  local result = CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(self.areaBg.transform, touchPos, CS.GameEntry.UICamera)
  return result
end

function CommonSelectCom:UpdateItemDescByIndex(index, des)
  local comp = self.itemList[index or 1]
  if comp then
    comp:SetDes(des)
  end
  if index == self.curIndex then
    self.selectText:SetText(des)
  end
end

function CommonSelectCom:Update100MS()
  if self.needFitBg then
    local y = self.itemParent.transform.sizeDelta.y
    local bgY = self.areaBg.transform.sizeDelta.y
    if y + 20 == bgY then
      self.checkCount = self.checkCount + 1
    else
      self.checkCount = 0
      self.areaBg:SetSizeDeltaXY(self.areaBg.transform.sizeDelta.x, y + 20)
    end
    if self.checkCount == 4 then
      self.needFitBg = false
    end
  end
end

CommonSelectCom.OnCreate = OnCreate
CommonSelectCom.OnDestroy = OnDestroy
CommonSelectCom.OnEnable = OnEnable
CommonSelectCom.OnDisable = OnDisable
CommonSelectCom.ComponentDefine = ComponentDefine
CommonSelectCom.ComponentDestroy = ComponentDestroy
CommonSelectCom.DataDefine = DataDefine
CommonSelectCom.DataDestroy = DataDestroy
return CommonSelectCom
