local UIGuideTalkSelectBtn = BaseClass("UIGuideTalkSelectBtn", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  des,
  nextId
}
local this_path = ""
local btn_name_path = "BtnNameText"

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
  self.desText = self:AddComponent(UIText, btn_name_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.desText = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.desText:SetText(param.des)
end

local function OnBtnClick(self)
  DataCenter.GuideManager:SetCurGuideId(self.param.nextId)
  DataCenter.GuideManager:DoGuide()
end

UIGuideTalkSelectBtn.OnCreate = OnCreate
UIGuideTalkSelectBtn.OnDestroy = OnDestroy
UIGuideTalkSelectBtn.Param = Param
UIGuideTalkSelectBtn.OnBtnClick = OnBtnClick
UIGuideTalkSelectBtn.OnEnable = OnEnable
UIGuideTalkSelectBtn.OnDisable = OnDisable
UIGuideTalkSelectBtn.ComponentDefine = ComponentDefine
UIGuideTalkSelectBtn.ComponentDestroy = ComponentDestroy
UIGuideTalkSelectBtn.DataDefine = DataDefine
UIGuideTalkSelectBtn.DataDestroy = DataDestroy
UIGuideTalkSelectBtn.ReInit = ReInit
return UIGuideTalkSelectBtn
