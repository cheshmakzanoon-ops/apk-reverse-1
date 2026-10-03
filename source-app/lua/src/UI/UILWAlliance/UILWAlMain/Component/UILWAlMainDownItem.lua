local UILWAlMainDownItem = BaseClass("UILWAlMainDownItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local txt_path = "Text"
local click_btn_path = ""
local red_pot_path = "RedPot"

function UILWAlMainDownItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMainDownItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMainDownItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.text = self:AddComponent(UIText, txt_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.red_pot = self:AddComponent(UIBaseContainer, red_pot_path)
end

function UILWAlMainDownItem:ComponentDestroy()
  self.icon = nil
  self.text = nil
  self.clickBtn = nil
  self.red_pot = nil
end

function UILWAlMainDownItem:DataDefine()
  self.type = 0
end

function UILWAlMainDownItem:DataDestroy()
  self.type = nil
end

function UILWAlMainDownItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMainDownItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMainDownItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetNewAlJoinReq, self.UpdateRedPoint)
end

function UILWAlMainDownItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OnGetNewAlJoinReq, self.UpdateRedPoint)
  base.OnRemoveListener(self)
end

function UILWAlMainDownItem:SetData(params)
  self.type = params.type
  local infos = LWAlMainDownBtnParam[self.type]
  if infos then
    self.icon:LoadSprite(infos.Icon)
    self.text:SetLocalText(infos.Text)
  end
  self:UpdateRedPoint()
end

function UILWAlMainDownItem:UpdateRedPoint()
  if self.type == LWAlMainDownBtnType.Al_Apply then
    local redP = DataCenter.AllianceMemberDataManager:GetAllianceApplyRedCount()
    self.red_pot:SetActive(0 < redP)
  else
    self.red_pot:SetActive(false)
  end
end

function UILWAlMainDownItem:OnClick()
  self.view.ctrl:OnDownBtnClick(self.type)
end

return UILWAlMainDownItem
