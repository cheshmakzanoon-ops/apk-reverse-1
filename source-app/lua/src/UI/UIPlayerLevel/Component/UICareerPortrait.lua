local UICareerPortrait = BaseClass("UICareerPortrait", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UICareerEffect = require("UI.UIPlayerLevel.Component.UICareerEffect")
local UICareerTag = require("UI.UIPlayerLevel.Component.UICareerTag")
local btn_path = "Root/Btn"
local bg_path = "Root/Btn/Bg"
local head_path = "Root/Btn/HeadBg/Head"
local name_path = "Root/Btn/NameBg/Name"
local icon_path = "Root/Btn/NameBg/Icon"
local desc_bg_path = "Root/Btn/DescBg"
local desc_path = "Root/Btn/DescBg/Desc"
local story_path = "Root/Btn/Story"
local effect_list_path = "Root/Btn/EffectList"
local tag_list_path = "Root/Btn/TagList"
local selected_path = "Root/Btn/Selected"
local current_bg_path = "Root/Btn/CurrentBg"
local current_text_path = "Root/Btn/CurrentBg/Current"
local free_path = "Root/Btn/Free"
local free_text_path = "Root/Btn/Free/Bg/FreeText"
local MISSING_HEAD = "Assets/Main/Sprites/UI/UICareer/UICareer_heroIcon_33001"
local MISSING_ICON = "Assets/Main/Sprites/UI/UICareer/UICareer_icon_career"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.bg_image = self:AddComponent(UIImage, bg_path)
  self.head_image = self:AddComponent(UIImage, head_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.desc_bg_go = self:AddComponent(UIBaseContainer, desc_bg_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.story_text = self:AddComponent(UIText, story_path)
  self.effect_list_go = self:AddComponent(UIBaseContainer, effect_list_path)
  self.tag_list_go = self:AddComponent(UIBaseContainer, tag_list_path)
  self.selected_go = self:AddComponent(UIBaseContainer, selected_path)
  self.current_bg_go = self:AddComponent(UIBaseContainer, current_bg_path)
  self.current_text = self:AddComponent(UIText, current_text_path)
  self.current_text:SetLocalText(395014)
  self.free_go = self:AddComponent(UIBaseContainer, free_path)
  self.free_text = self:AddComponent(UIText, free_text_path)
  self.free_text:SetLocalText(130126)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.bg_image = nil
  self.head_image = nil
  self.name_text = nil
  self.icon_image = nil
  self.desc_bg_go = nil
  self.desc_text = nil
  self.story_text = nil
  self.effect_list_go = nil
  self.tag_list_go = nil
  self.selected_go = nil
  self.current_bg_go = nil
  self.current_text = nil
  self.free_go = nil
  self.free_text = nil
end

local function DataDefine(self)
  self.careerType = nil
  self.careerTemplate = nil
  self.careerEffectReqs = {}
  self.careerTagReqs = {}
  self.onClick = nil
  self.effectItemList = {}
  self.tagItemList = {}
end

local function DataDestroy(self)
  self.careerType = nil
  self.careerTemplate = nil
  self.careerEffectReqs = nil
  self.careerTagReqs = nil
  self.onClick = nil
  self.effectItemList = nil
  self.tagItemList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:ClearItems()
  base.OnDisable(self)
end

local function SetData(self, careerType)
  self.careerType = careerType
  self.careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(careerType, 1)
  if self.careerTemplate == nil then
    Logger.LogError("UICareerPortrait, SetData, careerTemplate = null")
    return
  end
  self.name_text:SetLocalText(self.careerTemplate.name)
  self.icon_image:LoadSprite(string.format(LoadPath.UIPlayerCareer, self.careerTemplate.icon), MISSING_ICON)
  self.desc_text:SetLocalText(self.careerTemplate.description)
  self.head_image:LoadSprite(string.format(LoadPath.UIPlayerCareer, self.careerTemplate.image), MISSING_HEAD)
  self.current_bg_go:SetActive(careerType == DataCenter.PlayerCareerManager:GetCareerType())
  self.effect_list_go:SetActive(false)
  self.free_go:SetActive(false)
  local initEffectList = {}
  for _, id in ipairs(self.careerTemplate.initEffectList) do
    local template = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(id)
    if template.show ~= 2 then
      table.insert(initEffectList, id)
    end
  end
  table.sort(initEffectList, function(id1, id2)
    local template1 = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(id1)
    local template2 = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(id2)
    if template1.type ~= template2.type then
      return template1.type < template2.type
    elseif template1.order ~= template2.order then
      return template1.order > template2.order
    else
      return id1 < id2
    end
  end)
  self.careerEffectReqs = {}
  for _, id in ipairs(initEffectList) do
    local req = Resource:InstantiateAsync(UIAssets.UICareerEffect)
    req:completed("+", function()
      if req.isError then
        return
      end
      if self.effect_list_go == nil then
        req:Destroy()
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(req)
      local go = req.gameObject
      go:SetActive(true)
      go.name = tostring(id)
      local tf = go.transform
      tf:SetParent(self.effect_list_go.transform)
      tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.effect_list_go:AddComponent(UICareerEffect, go)
      item:SetData(id)
      self.effectItemList[id] = item
      table.insert(self.careerEffectReqs, req)
    end)
  end
  self.careerTagReqs = {}
  for i, tagInfo in ipairs(self.careerTemplate.tagInfoList) do
    local req = Resource:InstantiateAsync(UIAssets.UICareerTag)
    req:completed("+", function()
      if req.isError then
        return
      end
      if self.tag_list_go == nil then
        req:Destroy()
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(req)
      local go = req.gameObject
      go:SetActive(true)
      go.name = tostring(i)
      local tf = go.transform
      tf:SetParent(self.tag_list_go.transform)
      tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.tag_list_go:AddComponent(UICareerTag, go)
      item:SetData(tagInfo)
      item:SetOnClick(BindCallback(self, self.OnClick))
      self.tagItemList[i] = item
      table.insert(self.careerTagReqs, req)
    end)
  end
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function ShowFree(self, show)
  self.free_go:SetActive(show)
end

local function ClearItems(self)
  if table.count(self.careerEffectReqs) > 0 then
    self.effect_list_go:RemoveComponents(UICareerEffect)
    for _, req in pairs(self.careerEffectReqs) do
      req:Destroy()
    end
    self.careerEffectReqs = {}
  end
  if 0 < table.count(self.careerTagReqs) then
    self.tag_list_go:RemoveComponents(UICareerTag)
    for _, req in pairs(self.careerTagReqs) do
      req:Destroy()
    end
    self.careerTagReqs = {}
  end
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

UICareerPortrait.OnCreate = OnCreate
UICareerPortrait.OnDestroy = OnDestroy
UICareerPortrait.ComponentDefine = ComponentDefine
UICareerPortrait.ComponentDestroy = ComponentDestroy
UICareerPortrait.DataDefine = DataDefine
UICareerPortrait.DataDestroy = DataDestroy
UICareerPortrait.OnAddListener = OnAddListener
UICareerPortrait.OnRemoveListener = OnRemoveListener
UICareerPortrait.OnEnable = OnEnable
UICareerPortrait.OnDisable = OnDisable
UICareerPortrait.ViewType = ViewType
UICareerPortrait.SetData = SetData
UICareerPortrait.SetOnClick = SetOnClick
UICareerPortrait.ShowFree = ShowFree
UICareerPortrait.ClearItems = ClearItems
UICareerPortrait.OnClick = OnClick
return UICareerPortrait
