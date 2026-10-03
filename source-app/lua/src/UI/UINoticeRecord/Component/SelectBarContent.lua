local base = UIBaseContainer
local SelectBarContent = BaseClass("SelectBarContent", base)
local Localization = CS.GameEntry.Localization
local HideMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1"
local ShowMenuImage = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2"
local type_menu_icon_path = "MenuBtn/typeMenuIcon"
local type_txt_path = "typeTxtContent/typeTxt"

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
  self.type_menu_icon = self:AddComponent(UIImage, type_menu_icon_path)
  self.type_txt = self:AddComponent(UITextMeshProUGUIEx, type_txt_path)
  self.type_select_bar = self:AddComponent(UIButton, "")
  self.type_select_bar:SetOnClick(function()
    self:OnSelectBarClick()
  end)
end

local function ComponentDestroy(self)
  self.type_menu_icon = nil
  self.type_txt = nil
  self.type_select_bar = nil
end

local function DataDefine(self)
  self.menuShow = false
  self.filterType = nil
end

local function DataDestroy(self)
  self.menuShow = nil
  self.filterType = nil
end

function SelectBarContent:SetData(filterType)
  self.menuShow = false
  self.filterType = filterType
  self:RefreshView()
end

function SelectBarContent:RefreshView()
  self:RefreshMenuShowBtn()
  local filterTypeCfg = self.view.ctrl:GetFilterTypeConfig(self.filterType)
  if filterTypeCfg then
    local txtKey = filterTypeCfg.txtKey
    self.type_txt:SetLocalText(txtKey)
  end
end

function SelectBarContent:RefreshMenuShowBtn()
  if self.menuShow then
    self.type_menu_icon:LoadSprite(ShowMenuImage)
  else
    self.type_menu_icon:LoadSprite(HideMenuImage)
  end
end

function SelectBarContent:OnSelectBarClick()
  if self.filterType == nil then
    return
  end
  if self.menuShow then
    return
  end
  self.menuShow = true
  self:RefreshMenuShowBtn()
  local typeList = self.view.ctrl:GetFilterTypeShowList()
  local show_list = {}
  for i, v in ipairs(typeList) do
    local curType = self.filterType
    table.insert(show_list, {
      id = i,
      type = v,
      isSelect = v == curType
    })
  end
  self.view:OnSetMenuShow(self.type_select_bar, show_list)
end

SelectBarContent.OnCreate = OnCreate
SelectBarContent.OnDestroy = OnDestroy
SelectBarContent.OnEnable = OnEnable
SelectBarContent.OnDisable = OnDisable
SelectBarContent.ComponentDefine = ComponentDefine
SelectBarContent.ComponentDestroy = ComponentDestroy
SelectBarContent.DataDefine = DataDefine
SelectBarContent.DataDestroy = DataDestroy
return SelectBarContent
