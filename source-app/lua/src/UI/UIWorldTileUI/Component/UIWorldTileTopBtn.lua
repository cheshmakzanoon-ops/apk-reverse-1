local UIWorldTileTopBtn = BaseClass("UIWorldTileTopBtn", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  topBtnType,
  index,
  name,
  buildId
}
local this_path = ""

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
  self.btnImage = self:AddComponent(UIImage, this_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.btnImage = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  local iconPath = UIWorldTileTopBtnImage[param.topBtnType]
  if param.topBtnType == UIWorldTileTopBtnType.Book and DataCenter.AllianceBaseDataManager:IsR4orR5() then
    iconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_mark"
  end
  self.btnImage:LoadSprite(iconPath)
end

local function OnBtnClick(self)
  local oname = self.param.name
  local serverId = self.param.server
  if self.param.topBtnType == UIWorldTileTopBtnType.Share then
    local share_param = {}
    share_param.sid = serverId
    share_param.pos = self.param.index
    share_param.oname = oname
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  elseif self.param.topBtnType == UIWorldTileTopBtnType.Book then
    local share_param = {}
    share_param.sid = serverId
    share_param.pos = self.param.index * 10 + buildTemplate.tileX
    share_param.oname = oname
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
  end
  self.view.ctrl:CloseSelf()
end

UIWorldTileTopBtn.OnCreate = OnCreate
UIWorldTileTopBtn.OnDestroy = OnDestroy
UIWorldTileTopBtn.Param = Param
UIWorldTileTopBtn.OnEnable = OnEnable
UIWorldTileTopBtn.OnDisable = OnDisable
UIWorldTileTopBtn.ComponentDefine = ComponentDefine
UIWorldTileTopBtn.ComponentDestroy = ComponentDestroy
UIWorldTileTopBtn.DataDefine = DataDefine
UIWorldTileTopBtn.DataDestroy = DataDestroy
UIWorldTileTopBtn.ReInit = ReInit
UIWorldTileTopBtn.OnBtnClick = OnBtnClick
return UIWorldTileTopBtn
