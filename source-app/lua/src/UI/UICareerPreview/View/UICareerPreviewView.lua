local UICareerPreview = BaseClass("UICareerPreview", UIBaseView)
local base = UIBaseView
local CareerContent = require("UI.UIPlayerLevel.Component.CareerContent")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_path = "UICommonPopUpTitle/CloseBtn"
local return_path = "UICommonPopUpTitle/panel"
local content_path = "CareerContent"

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

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(395000)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(CareerContent, content_path)
  self.content:SetDraggingDisableBtn({
    self.close_btn,
    self.return_btn
  })
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.close_btn = nil
  self.return_btn = nil
  self.content = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerCareerSelect, self.OnCareerSelect)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerCareerSelect, self.OnCareerSelect)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local careerType = self:GetUserData()
  self.content:ReInit(careerType, nil, false, false, true)
end

local function OnCareerSelect(self)
  self.ctrl:CloseSelf()
end

UICareerPreview.OnCreate = OnCreate
UICareerPreview.OnDestroy = OnDestroy
UICareerPreview.ComponentDefine = ComponentDefine
UICareerPreview.ComponentDestroy = ComponentDestroy
UICareerPreview.DataDefine = DataDefine
UICareerPreview.DataDestroy = DataDestroy
UICareerPreview.OnEnable = OnEnable
UICareerPreview.OnDisable = OnDisable
UICareerPreview.OnAddListener = OnAddListener
UICareerPreview.OnRemoveListener = OnRemoveListener
UICareerPreview.ReInit = ReInit
UICareerPreview.OnCareerSelect = OnCareerSelect
return UICareerPreview
