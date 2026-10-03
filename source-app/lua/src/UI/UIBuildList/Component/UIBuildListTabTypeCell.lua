local UIBuildListTabTypeCell = BaseClass("UIBuildListTabTypeCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  tabType
}
local this_path = ""
local red_dot_path = "RedPointNum"
local red_num_path = "RedPointNum/Text"
local select_bg_path = "SelectImg"
local select_icon_path = "SelectImg/SelectIcon"
local select_text_path = "SelectImg/SelectText"
local unSelect_icon_path = "unSelectImg/UnSelectIcon"
local unSelect_bg_path = "unSelectImg"

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, this_path)
  self.red_dot = self:AddComponent(UIBaseContainer, red_dot_path)
  self.red_num_text = self:AddComponent(UIText, red_num_path)
  self.select_bg = self:AddComponent(UIImage, select_bg_path)
  self.unSelect_bg = self:AddComponent(UIImage, unSelect_bg_path)
  self.select_icon = self:AddComponent(UIImage, select_icon_path)
  self.unSelect_icon = self:AddComponent(UIImage, unSelect_icon_path)
  self.select_text = self:AddComponent(UITextMeshProUGUIEx, select_text_path)
  self.text_shadow = self:AddComponent(UIShadow, select_text_path)
  self.btn:SetOnClick(function()
    self:OnSelectBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.red_dot = nil
  self.red_num_text = nil
  self.unSelect_bg = nil
  self.unSelect_icon = nil
  self.select_bg = nil
  self.select_icon = nil
  self.select_text = nil
  self.text_shadow = nil
end

local function DataDefine(self)
  self.tabType = nil
  self.isSelect = nil
end

local function DataDestroy(self)
  self.tabType = nil
  self.isSelect = nil
end

local function ReInit(self, param)
  local text = ""
  self.tabType = param
  if self.tabType == UIBuildListTabType.Decorate then
    text = Localization:GetString("100071")
  elseif self.tabType == UIBuildListTabType.Economy then
    text = Localization:GetString("100068")
  elseif self.tabType == UIBuildListTabType.Military then
    text = Localization:GetString("100069")
  elseif self.tabType == UIBuildListTabType.SeasonBuild then
    text = Localization:GetString("100069")
  elseif self.tabType == UIBuildListTabType.SeasonCityBuild then
    text = Localization:GetString("100356")
  end
  self.select_text:SetText(text)
end

local function RefreshRedDot(self, num)
  if 0 < num then
    self.red_dot:SetActive(true)
    self.red_num_text:SetText(num)
  else
    self.red_dot:SetActive(false)
  end
end

local function SetSelect(self, isSelect)
  if self.isSelect ~= isSelect then
    self.isSelect = isSelect
    if self.tabType == UIBuildListTabType.Decorate then
      self.select_icon:LoadSprite(string.format(LoadPath.UILWBuild, "lrb_zhuangshiwu_icon1"))
      self.unSelect_icon:LoadSprite(string.format(LoadPath.UILWBuild, "lrb_zhuangshiwu_icon1"))
    elseif self.tabType == UIBuildListTabType.Economy then
      self.select_icon:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_jingji_lzh_icon1"))
      self.unSelect_icon:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_jingji_lzh_icon1"))
    elseif self.tabType == UIBuildListTabType.Military then
      self.select_icon:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_junshi_lzh_icon1"))
      self.unSelect_icon:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_junshi_lzh_icon1"))
    elseif self.tabType == UIBuildListTabType.SeasonBuild then
      self.select_icon:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_icon_select_outcity"))
      self.unSelect_icon:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_icon_select_outcity"))
    elseif self.tabType == UIBuildListTabType.SeasonCityBuild then
      self.select_icon:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_icon_select_outcity"))
      self.unSelect_icon:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_icon_select_outcity"))
    end
    self.select_icon:SetNativeSize()
    self.unSelect_icon:SetNativeSize()
    self.select_bg.gameObject:SetActive(isSelect)
    self.unSelect_bg.gameObject:SetActive(not isSelect)
  end
end

local function OnSelectBtnClick(self)
  if not self.isSelect then
    self.view:OnTabTypeSelect(self.tabType)
  end
end

UIBuildListTabTypeCell.OnCreate = OnCreate
UIBuildListTabTypeCell.OnDestroy = OnDestroy
UIBuildListTabTypeCell.Param = Param
UIBuildListTabTypeCell.OnEnable = OnEnable
UIBuildListTabTypeCell.OnDisable = OnDisable
UIBuildListTabTypeCell.ComponentDefine = ComponentDefine
UIBuildListTabTypeCell.ComponentDestroy = ComponentDestroy
UIBuildListTabTypeCell.DataDefine = DataDefine
UIBuildListTabTypeCell.DataDestroy = DataDestroy
UIBuildListTabTypeCell.ReInit = ReInit
UIBuildListTabTypeCell.RefreshRedDot = RefreshRedDot
UIBuildListTabTypeCell.SetSelect = SetSelect
UIBuildListTabTypeCell.OnSelectBtnClick = OnSelectBtnClick
return UIBuildListTabTypeCell
