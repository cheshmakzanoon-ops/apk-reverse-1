local DecorationViewEffectDesc = BaseClass("DecorationViewEffectDesc", UIBaseContainer)
local base = UIBaseContainer
local name_path = "NameText"
local use_title_path = "UseTitle"
local use_effect_path = "UseEffect"
local own_title_path = "OwnTitle"
local own_effect_path = "OwnEffect"
local vipSkinName_path = "vipSkinName"
local vipSkinName_text_path = "vipSkinName/vipSkinName_txt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.name = self:AddComponent(UIText, name_path)
  self.use_title = self:AddComponent(UIText, use_title_path)
  self.use_title:SetLocalText(2000471)
  self.use_effect = self:AddComponent(UIText, use_effect_path)
  self.own_title = self:AddComponent(UIText, own_title_path)
  self.own_effect = self:AddComponent(UIText, own_effect_path)
  self.own_title:SetLocalText(2000472)
  self.vipSkinName = self:TryAddComponent(UIBaseContainer, vipSkinName_path)
  self.vipSkinName_text = self:TryAddComponent(UITextMeshProUGUIEx, vipSkinName_text_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, data)
  self.data = data
  self:RefreshView()
end

local function HideEffectNode(self)
  self.data = nil
  self.use_title:SetActive(false)
  self.use_effect:SetActive(false)
  self.own_title:SetActive(false)
  self.own_effect:SetActive(false)
end

local function RefreshView(self)
  local _name = self.data.name
  if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) and self.data.decorationId then
    _name = string.format("%s[%s]", _name, self.data.decorationId)
  end
  local isVipCitySkin = self.data.isVipCitySkin
  if self.vipSkinName ~= nil and isVipCitySkin then
    self.vipSkinName:SetActive(true)
    self.name:SetActive(false)
    self.vipSkinName_text:SetText(_name)
  else
    self.name:SetActive(true)
    if self.vipSkinName ~= nil then
      self.vipSkinName:SetActive(false)
    end
    self.name:SetText(_name)
    self.name:SetColor(self.data.color)
  end
  if string.IsNullOrEmpty(self.data.useEffect) then
    self.use_title:SetActive(false)
    self.use_effect:SetActive(false)
  else
    self.use_title:SetActive(true)
    self.use_effect:SetActive(true)
    self.use_effect:SetText(self.data.useEffect)
  end
  if string.IsNullOrEmpty(self.data.ownEffect) then
    self.own_title:SetActive(false)
    self.own_effect:SetActive(false)
  else
    self.own_title:SetActive(true)
    self.own_effect:SetActive(true)
    self.own_effect:SetText(self.data.ownEffect)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

DecorationViewEffectDesc.OnCreate = OnCreate
DecorationViewEffectDesc.OnDestroy = OnDestroy
DecorationViewEffectDesc.OnEnable = OnEnable
DecorationViewEffectDesc.OnDisable = OnDisable
DecorationViewEffectDesc.ComponentDefine = ComponentDefine
DecorationViewEffectDesc.ComponentDestroy = ComponentDestroy
DecorationViewEffectDesc.DataDefine = DataDefine
DecorationViewEffectDesc.DataDestroy = DataDestroy
DecorationViewEffectDesc.ReInit = ReInit
DecorationViewEffectDesc.RefreshView = RefreshView
DecorationViewEffectDesc.HideEffectNode = HideEffectNode
return DecorationViewEffectDesc
