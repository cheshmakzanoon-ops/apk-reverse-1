local TacticalChipStarDetailItem = BaseClass("TacticalChipStarDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BG_COLOR_UNLOCK_NORMAL = Color.New(0.0784313725490196, 0.11372549019607843, 0.23137254901960785, 1)
local BG_COLOR_UNLOCK_MAIN = Color.New(0.5411764705882353, 0.3803921568627451, 0.1843137254901961, 1)
local BG_COLOR_LOCK_NORMAL = Color.New(0.0784313725490196, 0.11372549019607843, 0.23137254901960785, 0.35294117647058826)
local BG_COLOR_LOCK_MAIN = Color.New(0.5411764705882353, 0.3803921568627451, 0.1843137254901961, 0.35294117647058826)
local DESC_COLOR_UNLOCK_NORMAL = Color.New(0.8235294117647058, 0.8901960784313725, 1, 1)
local DESC_COLOR_UNLOCK_MAIN = Color.New(1, 0.8980392156862745, 0.4196078431372549, 1)
local DESC_COLOR_LOCK_NORMAL = Color.New(0.5098039215686274, 0.5529411764705883, 0.7490196078431373, 0.35294117647058826)
local DESC_COLOR_LOCK_MAIN = Color.New(1, 0.8980392156862745, 0.4196078431372549, 0.35294117647058826)

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
  self.imgBg = self:AddComponent(UIImage, "bg")
  self.imgStar = self:AddComponent(UIImage, "star")
  self.textStarNum = self:AddComponent(UIText, "star/starNum")
  self.textTitle = self:AddComponent(UIText, "title")
  self.textDesc = self:AddComponent(UIText, "desc")
end

local function ComponentDestroy(self)
  self.imgBg = nil
  self.imgStar = nil
  self.textStarNum = nil
  self.textTitle = nil
  self.textDesc = nil
end

function TacticalChipStarDetailItem:SetData(effectText, index, bgType)
  if index <= 5 then
    self.imgStar:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_wurenjixinpian_zhujiemian_star02.png")
  else
    self.imgStar:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_wurenjixinpian_zhujiemian_star01.png")
  end
  self.textStarNum:SetText(index)
  self.textDesc:SetText(effectText)
  if bgType == 1 then
    self.imgBg:SetColor(BG_COLOR_UNLOCK_NORMAL)
    self.textDesc:SetColor(DESC_COLOR_UNLOCK_NORMAL)
    CS.UIGray.SetGray(self.imgStar.transform, false, false)
  elseif bgType == 2 then
    self.imgBg:SetColor(BG_COLOR_UNLOCK_MAIN)
    self.textDesc:SetColor(DESC_COLOR_UNLOCK_MAIN)
    CS.UIGray.SetGray(self.imgStar.transform, false, false)
  elseif bgType == 3 then
    self.imgBg:SetColor(BG_COLOR_LOCK_NORMAL)
    self.textDesc:SetColor(DESC_COLOR_LOCK_NORMAL)
    CS.UIGray.SetGray(self.imgStar.transform, true, false)
  elseif bgType == 4 then
    self.imgBg:SetColor(BG_COLOR_LOCK_MAIN)
    self.textDesc:SetColor(DESC_COLOR_LOCK_MAIN)
    CS.UIGray.SetGray(self.imgStar.transform, true, false)
  end
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

TacticalChipStarDetailItem.OnCreate = OnCreate
TacticalChipStarDetailItem.OnDestroy = OnDestroy
TacticalChipStarDetailItem.OnEnable = OnEnable
TacticalChipStarDetailItem.OnDisable = OnDisable
TacticalChipStarDetailItem.ComponentDefine = ComponentDefine
TacticalChipStarDetailItem.ComponentDestroy = ComponentDestroy
TacticalChipStarDetailItem.DataDefine = DataDefine
TacticalChipStarDetailItem.DataDestroy = DataDestroy
TacticalChipStarDetailItem.OnAddListener = OnAddListener
TacticalChipStarDetailItem.OnRemoveListener = OnRemoveListener
return TacticalChipStarDetailItem
