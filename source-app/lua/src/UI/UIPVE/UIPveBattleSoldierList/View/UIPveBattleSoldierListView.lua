local UIPveBattleSoldierListView = BaseClass("UIPveBattleSoldierListView", UIBaseView)
local UIPveBattleSoldierTab = require("UI.UIPVE.UIPveBattleSoldierList.Component.UIPveBattleSoldierTab")
local base = UIBaseView

local function OnCreate(self)
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.left = self:AddComponent(UIPveBattleSoldierTab, "SafeArea/leftRoot")
  self.right = self:AddComponent(UIPveBattleSoldierTab, "SafeArea/rightRoot")
  if self.param.isShowLeft == true then
    self.right:SetActive(false)
    self.left:SetData(self.param.soldierData, self.param.isShowLeft, self.param.maxNum)
    self.left:SetActive(true)
  else
    self.left:SetActive(false)
    self.right:SetData(self.param.soldierData, self.param.isShowLeft)
    self.right:SetActive(true)
  end
end

local function ComponentDestroy(self)
  if self.left ~= nil then
    self.left:ClearContent()
  end
  if self.right ~= nil then
    self.right:ClearContent()
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

UIPveBattleSoldierListView.OnCreate = OnCreate
UIPveBattleSoldierListView.OnDestroy = OnDestroy
UIPveBattleSoldierListView.ComponentDefine = ComponentDefine
UIPveBattleSoldierListView.ComponentDestroy = ComponentDestroy
UIPveBattleSoldierListView.OnEnable = OnEnable
UIPveBattleSoldierListView.OnDisable = OnDisable
return UIPveBattleSoldierListView
