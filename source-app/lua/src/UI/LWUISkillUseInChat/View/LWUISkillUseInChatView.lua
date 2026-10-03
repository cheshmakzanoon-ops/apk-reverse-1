local LWUISkillUseInWorldView = BaseClass("LWUISkillUseInWorldView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIMasterySkillUseInChatContent = require("UI.LWUISkillUseInChat.Component.LWUIMasterySkillUseInChatContent")
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local mastery_skill_content_path = "Root/MasterySkillContent"
local title_text_path = "UICommonMiniPopUpTitle/titleText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.mastery_skill_content = self:AddComponent(LWUIMasterySkillUseInChatContent, mastery_skill_content_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
end

local function ComponentDestroy(self)
  self.return_btn = nil
  self.close_btn = nil
  self.toggle1 = nil
  self.selectToggle1 = nil
  self.toggle2 = nil
  self.selectToggle2 = nil
  self.mastery_skill_content = nil
  self.city_skin_skill_content = nil
  self.title_text = nil
end

local function DataDefine(self)
  self.playerUuid = self:GetUserData()
end

local function DataDestroy(self)
  self.playerUuid = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self:InitData()
  self:InitView()
  self:Refresh()
end

local function InitData(self)
end

local function InitView(self)
end

local function Refresh(self)
  self.mastery_skill_content:SetData(self.playerUuid)
end

LWUISkillUseInWorldView.OnCreate = OnCreate
LWUISkillUseInWorldView.OnDestroy = OnDestroy
LWUISkillUseInWorldView.ComponentDefine = ComponentDefine
LWUISkillUseInWorldView.ComponentDestroy = ComponentDestroy
LWUISkillUseInWorldView.DataDefine = DataDefine
LWUISkillUseInWorldView.DataDestroy = DataDestroy
LWUISkillUseInWorldView.OnAddListener = OnAddListener
LWUISkillUseInWorldView.OnRemoveListener = OnRemoveListener
LWUISkillUseInWorldView.ReInit = ReInit
LWUISkillUseInWorldView.InitView = InitView
LWUISkillUseInWorldView.InitData = InitData
LWUISkillUseInWorldView.Refresh = Refresh
return LWUISkillUseInWorldView
