local UIGarbageRewardShowView = BaseClass("UIGarbageRewardShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local icon_path = "ContentGo/Icon"
local des_text_path = "ContentGo/DesText"
local btn_go_path = "ContentGo/BtnGo"
local green_btn_path = "ContentGo/BtnGo/Common_btn_greenm"
local green_btn_text_path = "ContentGo/BtnGo/Common_btn_greenm/btnTxt_green_big_new"
local people_bg_path = "ContentGo/PeopleBg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.return_btn = self:AddComponent(UIButton, panel_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.btn_go = self:AddComponent(UIBaseContainer, btn_go_path)
  self.green_btn = self:AddComponent(UIButton, green_btn_path)
  self.green_btn_text = self:AddComponent(UIText, green_btn_text_path)
  self.people_bg = self:AddComponent(UIBaseContainer, people_bg_path)
  self.return_btn:SetOnClick(function()
    self:ReturnBtnClick()
  end)
  self.green_btn:SetOnClick(function()
    self:GoBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.return_btn = nil
  self.icon = nil
  self.des_text = nil
  self.btn_go = nil
  self.green_btn = nil
  self.green_btn_text = nil
  self.people_bg = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local showType, itemId = self:GetUserData()
  if showType == CityGarbageResultShowType.People then
    self.people_bg:SetActive(true)
    self.btn_go:SetActive(false)
    self.des_text:SetLocalText(GameDialogDefine.CITY_GARBAGE_GET_PEOPLE)
    self.icon:LoadSprite(string.format(LoadPath.Guide, "UIGuide_astronaut"))
  elseif showType == CityGarbageResultShowType.UseItem then
    self.people_bg:SetActive(false)
    self.btn_go:SetActive(true)
    self.green_btn_text:SetLocalText(GameDialogDefine.USE)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if itemTemplate ~= nil then
      self.des_text:SetLocalText(itemTemplate.description)
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
    end
    self:CheckDoGuide()
  elseif showType == CityGarbageResultShowType.NoUseItem then
    self.people_bg:SetActive(false)
    self.btn_go:SetActive(false)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if itemTemplate ~= nil then
      self.des_text:SetLocalText(itemTemplate.description)
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
    end
  end
end

local function CheckDoGuide(self)
  if DataCenter.GuideManager:InGuide() then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and template.type == GuideType.CityGarbageResultShow then
      DataCenter.GuideManager:DoNext()
    end
  end
end

local function ReturnBtnClick(self)
  self.ctrl:CloseSelf()
  self:CheckDoGuide()
end

local function GoBtnClick(self)
  self.ctrl:CloseSelf()
end

UIGarbageRewardShowView.OnCreate = OnCreate
UIGarbageRewardShowView.OnDestroy = OnDestroy
UIGarbageRewardShowView.OnEnable = OnEnable
UIGarbageRewardShowView.OnDisable = OnDisable
UIGarbageRewardShowView.ComponentDefine = ComponentDefine
UIGarbageRewardShowView.ComponentDestroy = ComponentDestroy
UIGarbageRewardShowView.DataDefine = DataDefine
UIGarbageRewardShowView.DataDestroy = DataDestroy
UIGarbageRewardShowView.OnAddListener = OnAddListener
UIGarbageRewardShowView.OnRemoveListener = OnRemoveListener
UIGarbageRewardShowView.ReInit = ReInit
UIGarbageRewardShowView.CheckDoGuide = CheckDoGuide
UIGarbageRewardShowView.ReturnBtnClick = ReturnBtnClick
UIGarbageRewardShowView.GoBtnClick = GoBtnClick
return UIGarbageRewardShowView
