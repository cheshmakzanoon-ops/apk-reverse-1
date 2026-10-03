local UIMainAccountBindTipBtn = BaseClass("UIMainAccountBindTipBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local name_text_path = "NameText"

function UIMainAccountBindTipBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainAccountBindTipBtn:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainAccountBindTipBtn:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.name_text:SetLocalText("208181")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIMainAccountBindTipBtn:ComponentDestroy()
  self.btn = nil
  self.name_text = nil
end

function UIMainAccountBindTipBtn:ReInit()
end

function UIMainAccountBindTipBtn:Refresh()
  self:SetActive(DataCenter.LWAccountBindTipManager:CheckTipShow())
end

function UIMainAccountBindTipBtn:OnBtnClick()
  DataCenter.LWAccountBindTipManager:GuideToAccountBind()
end

return UIMainAccountBindTipBtn
