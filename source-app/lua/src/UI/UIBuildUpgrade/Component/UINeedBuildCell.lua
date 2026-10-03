local UINeedBuildCell = BaseClass("UINeedBuildCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  buildId,
  buildLv
}
local icon_path = "Icon"
local go_btn_path = "Common_btn_green_small"
local go_btn_name_path = "Common_btn_green_small/Go"
local build_text_path = "NeedText"
local monopolyImgPath = "Assets/Main/Sprites/HeroIconsSmall/zombie_icon01.png"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.go_btn_name = self:AddComponent(UIText, go_btn_name_path)
  self.build_text = self:AddComponent(UIText, build_text_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.go_btn_name = nil
  self.build_text = nil
  self.go_btn = nil
end

local function DataDefine(self)
  self.param = {}
  self.goBtnText = nil
  self.buildText = nil
end

local function DataDestroy(self)
  self.param = nil
  self.goBtnText = nil
  self.buildText = nil
end

local function ReInit(self, param)
  self.param = param
  self:SetGoBtnText(Localization:GetString("110003"))
  if self.param.type == BuildPreConditionType.monopoly then
    self:SetIconImage(monopolyImgPath)
    local mono_condition = DataCenter.MonopolyManager:GetPlacealityQuestOrder(tonumber(self.param.mono_condition))
    self:SetBuildText(Localization:GetString("monopoly_lock_1", mono_condition))
  else
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(param.buildId)
    if template ~= nil then
      self:SetIconImage(DataCenter.BuildManager:GetBuildIconPath(param.buildId, param.buildLv))
      self:SetBuildText(Localization:GetString("science_condition", param.buildLv, Localization:GetString(template.name)))
    end
  end
end

local function OnBtnClick(self)
  if self.param and self.param.type == BuildPreConditionType.monopoly then
    UIUtil.StageJump()
    GoToUtil.CloseAllWindows()
  elseif self.param then
    GoToUtil.GotoCityByBuildId(self.param.buildId, WorldTileBtnType.City_Upgrade)
  end
end

local function SetIconImage(self, imageName)
  self.icon:LoadSpriteAuto(imageName)
end

local function SetGoBtnText(self, value)
  if self.goBtnText ~= value then
    self.goBtnText = value
    self.go_btn_name:SetText(value)
  end
end

local function SetBuildText(self, value)
  if self.buildText ~= value then
    self.buildText = value
    self.build_text:SetText(value)
  end
end

UINeedBuildCell.OnCreate = OnCreate
UINeedBuildCell.OnDestroy = OnDestroy
UINeedBuildCell.Param = Param
UINeedBuildCell.OnBtnClick = OnBtnClick
UINeedBuildCell.OnEnable = OnEnable
UINeedBuildCell.OnDisable = OnDisable
UINeedBuildCell.ComponentDefine = ComponentDefine
UINeedBuildCell.ComponentDestroy = ComponentDestroy
UINeedBuildCell.DataDefine = DataDefine
UINeedBuildCell.DataDestroy = DataDestroy
UINeedBuildCell.ReInit = ReInit
UINeedBuildCell.SetIconImage = SetIconImage
UINeedBuildCell.SetGoBtnText = SetGoBtnText
UINeedBuildCell.SetBuildText = SetBuildText
return UINeedBuildCell
