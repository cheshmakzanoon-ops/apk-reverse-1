local base = UIBaseContainer
local LWUIMeteoriteConditionNoticeIR = BaseClass("LWUIMeteoriteConditionNoticeIR", base)
local tmpCondition_path = "ImgLabelBg/tmpCondition"
local imgPic_path = "ImgPic"
local imgTag_path = "ImgLabelBg/ImgTag"
local listItem_path = ""
local imgBg_path = "ImgLabelBg"

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
  self.tmpCondition = self:AddComponent(UIText, tmpCondition_path)
  self.imgPic = self:AddComponent(UIRawImage, imgPic_path)
  self.imgTag = self:AddComponent(UIImage, imgTag_path)
  self.imgBg = self:AddComponent(UIImage, imgBg_path)
end

local function ComponentDestroy(self)
  self.tmpCondition = nil
  self.imgPic = nil
  self.imgTag = nil
  self.listItem = nil
  self.imgBg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local PATH_OK_TAG = "Assets/Main/Sprites/UI/LWActMeteorite/lrb_xuanzhanjiemian_fuhetiaojian.png"
local PATH_NOT_OK_TAG = "Assets/Main/Sprites/UI/LWActMeteorite/lrb_xuanzhanjiemian_bufuhetiaojian.png"

function LWUIMeteoriteConditionNoticeIR:ReInit(index, data)
  self.tmpCondition:SetText(data.label)
  if string.IsNullOrEmpty(data.pic) then
    self.imgPic:SetActive(false)
  else
    self.imgPic:SetActive(true)
    self.imgPic:LoadSpriteAuto(data.pic, function()
      if self.imgPic then
        self.imgPic:SetPreserveAspectSize(690)
      end
    end)
  end
  local tagPath = data.ok and PATH_OK_TAG or PATH_NOT_OK_TAG
  self.imgTag:LoadSpriteAuto(tagPath)
  if data.ok then
    self.imgBg:SetColorRGBA(0.69, 0.91, 0.73, 1)
  else
    self.imgBg:SetColorRGBA(1, 0.7, 0.66, 1)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

LWUIMeteoriteConditionNoticeIR.OnCreate = OnCreate
LWUIMeteoriteConditionNoticeIR.OnDestroy = OnDestroy
LWUIMeteoriteConditionNoticeIR.OnEnable = OnEnable
LWUIMeteoriteConditionNoticeIR.OnDisable = OnDisable
LWUIMeteoriteConditionNoticeIR.ComponentDefine = ComponentDefine
LWUIMeteoriteConditionNoticeIR.ComponentDestroy = ComponentDestroy
LWUIMeteoriteConditionNoticeIR.DataDefine = DataDefine
LWUIMeteoriteConditionNoticeIR.DataDestroy = DataDestroy
return LWUIMeteoriteConditionNoticeIR
