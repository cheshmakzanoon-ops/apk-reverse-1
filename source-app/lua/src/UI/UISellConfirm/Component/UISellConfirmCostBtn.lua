local base = UIButton
local UISellConfirmCostBtn = BaseClass("UISellConfirmCostBtn", base)
local btnText_path = "BtnText"
local btnCostPanel_path = "BtnCostPanel"
local btnCostIcon_path = "BtnCostPanel/BtnCostIcon"
local btnCostText_path = "BtnCostPanel/BtnCostText"

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
  self.btnText = self:AddComponent(UIText, btnText_path)
  self.btnCostPanel = self:AddComponent(UIBaseContainer, btnCostPanel_path)
  self.btnCostIcon = self:AddComponent(UIImage, btnCostIcon_path)
  self.btnCostText = self:AddComponent(UIText, btnCostText_path)
end

local function ComponentDestroy(self)
  self.btnText = nil
  self.btnCostPanel = nil
  self.btnCostIcon = nil
  self.btnCostText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, text, btnNoUseDialog, param)
  if string.IsNullOrEmpty(text) then
    self.btnText:SetActive(false)
  else
    self.btnText:SetActive(true)
    if btnNoUseDialog then
      self.btnText:SetText(text)
    else
      self.btnText:SetLocalText(text)
    end
  end
  if param == nil then
    self.btnCostPanel:SetActive(false)
  else
    self.btnCostPanel:SetActive(true)
    if string.IsNullOrEmpty(param.iconPath) then
      self.btnCostIcon:SetActive(false)
    else
      self.btnCostIcon:SetActive(true)
      self.btnCostIcon:LoadSprite(param.iconPath)
    end
    if string.IsNullOrEmpty(param.text) then
      self.btnCostText:SetActive(false)
    else
      self.btnCostText:SetActive(true)
      if btnNoUseDialog then
        self.btnCostText:SetText(param.text)
      else
        self.btnCostText:SetLocalText(param.text)
      end
    end
  end
end

UISellConfirmCostBtn.OnCreate = OnCreate
UISellConfirmCostBtn.OnDestroy = OnDestroy
UISellConfirmCostBtn.OnEnable = OnEnable
UISellConfirmCostBtn.OnDisable = OnDisable
UISellConfirmCostBtn.ComponentDefine = ComponentDefine
UISellConfirmCostBtn.ComponentDestroy = ComponentDestroy
UISellConfirmCostBtn.DataDefine = DataDefine
UISellConfirmCostBtn.DataDestroy = DataDestroy
UISellConfirmCostBtn.SetData = SetData
return UISellConfirmCostBtn
