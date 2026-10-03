local UIResidentOrderCell = BaseClass("UIResidentOrderCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  itemId,
  count,
  isRed
}
local need_text_path = "Bg/needTxt"
local need_icon_path = "Bg/needIcon"
local bg_path = "Bg"
OwnColor = Color.New(0.4078431, 0.4196078, 0.4784314, 1)

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
  self.need_text = self:AddComponent(UIText, need_text_path)
  self.need_icon = self:AddComponent(UIImage, need_icon_path)
  self.anim = self:AddComponent(UIAnimator, bg_path)
end

local function ComponentDestroy(self)
  self.need_text = nil
  self.need_icon = nil
  self.anim = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  if param ~= nil then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(param.itemId)
    if template ~= nil then
      self.need_icon:LoadSprite(template:GetIconPath())
      self.need_text:SetText(Localization:GetString(template.name) .. "  x" .. param.count)
      self:RefreshIsRed(param.isRed)
    end
  end
end

local function RefreshIsRed(self, isRed)
  if isRed then
    self.need_text:SetColor(RedColor)
  else
    self.need_text:SetColor(OwnColor)
  end
end

local function PlayExitAnim(self)
  self.anim:Play("ResidentOrderBgExit", 0, 0)
end

UIResidentOrderCell.OnCreate = OnCreate
UIResidentOrderCell.OnDestroy = OnDestroy
UIResidentOrderCell.Param = Param
UIResidentOrderCell.OnEnable = OnEnable
UIResidentOrderCell.OnDisable = OnDisable
UIResidentOrderCell.ComponentDefine = ComponentDefine
UIResidentOrderCell.ComponentDestroy = ComponentDestroy
UIResidentOrderCell.DataDefine = DataDefine
UIResidentOrderCell.DataDestroy = DataDestroy
UIResidentOrderCell.ReInit = ReInit
UIResidentOrderCell.RefreshIsRed = RefreshIsRed
UIResidentOrderCell.PlayExitAnim = PlayExitAnim
return UIResidentOrderCell
