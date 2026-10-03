local WorldSimpleMonsterDes = BaseClass("WorldSimpleMonsterDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local name_path = "BuildDetails/NameText"
local des_txt_path = "BuildDetails/desTxt"
local icon_path = "BuildDetails/Monster_Icon"
local bg1_path = "BuildDetails/Monster_Icon_BG1"
local bg2_path = "BuildDetails/Monster_Icon_BG2"
local tip_path = "BuildDetails/Content/simple_tip"
local tip_1_path = "BuildDetails/Content/simple_tip_1"
local ele_icon_path = "BuildDetails/Content/ele_icon"
local default_icon_path = "Assets/Main/Sprites/UI/LWCommon/Sprite/singlemap_monster_head.png"

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
  self.name = self:AddComponent(UIText, name_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.bg2 = self:AddComponent(UIImage, bg2_path)
  self.tip = self:AddComponent(UIText, tip_path)
  self.tip_1 = self:AddComponent(UIText, tip_1_path)
  self.ele_icon = self:AddComponent(UIBaseComponent, ele_icon_path)
end

local function ComponentDestroy(self)
  self.name = nil
  self.des_txt = nil
  self.tip = nil
  self.ele_icon = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

local function RefreshData(self, param)
  self.data = param
  if param.isRawName == true then
    self.name:SetText(self.data.name)
  else
    self.name:SetLocalText(self.data.name)
  end
  if param.icon ~= nil then
    self.icon:LoadSprite(param.icon)
  else
    self.icon:LoadSprite(default_icon_path)
  end
  if param.tip ~= nil then
    self.tip:SetText(param.tip)
    self.tip_1:SetText(param.tip_1)
    self.tip:SetActive(true)
    self.tip_1:SetActive(true)
    self.ele_icon:SetActive(true)
  else
    self.tip:SetActive(false)
    self.tip_1:SetActive(false)
    self.ele_icon:SetActive(false)
  end
  if param.onlyIcon then
    self.bg1:SetActive(false)
    self.bg2:SetActive(false)
  else
    self.bg1:SetActive(true)
    self.bg2:SetActive(true)
  end
  self.icon:SetNativeSize()
  self.des_txt:SetLocalText(self.data.des)
end

WorldSimpleMonsterDes.OnCreate = OnCreate
WorldSimpleMonsterDes.OnDestroy = OnDestroy
WorldSimpleMonsterDes.OnEnable = OnEnable
WorldSimpleMonsterDes.OnDisable = OnDisable
WorldSimpleMonsterDes.ComponentDefine = ComponentDefine
WorldSimpleMonsterDes.ComponentDestroy = ComponentDestroy
WorldSimpleMonsterDes.DataDefine = DataDefine
WorldSimpleMonsterDes.DataDestroy = DataDestroy
WorldSimpleMonsterDes.RefreshData = RefreshData
return WorldSimpleMonsterDes
