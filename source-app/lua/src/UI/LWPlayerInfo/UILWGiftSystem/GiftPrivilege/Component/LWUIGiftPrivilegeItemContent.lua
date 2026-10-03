local base = UIBaseContainer
local LWUIGiftPrivilegeItemContent = BaseClass("LWUIGiftPrivilegeItemContent", base)
local levelTxt_path = "Level"
local content_path = "Content"
local descTxt_path = "Content/Desc"
local iconImg_path = "Content/Icon"
local claimBtn_path = "Content/ClaimBtn"
local claimBtnGray_path = "Content/ClaimBtn/Gray"
local iconBtn_path = "Content/Icon"
local iconTipRoot_path = "Content/Icon/iconTipRoot"
local btn_txt_path = "Content/ClaimBtn/BtnTxt"
local privilegeType = {reward = "1", unlock = "2"}

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
  self.levelTxt = self:AddComponent(UIText, levelTxt_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.iconImg = self:AddComponent(UIImage, iconImg_path)
  self.claimBtn = self:AddComponent(UIButton, claimBtn_path)
  self.claimBtnGray = self:AddComponent(UIBaseContainer, claimBtnGray_path)
  self.iconBtn = self:AddComponent(UIButton, iconBtn_path)
  self.iconTipRoot = self:AddComponent(UIBaseContainer, iconTipRoot_path)
  self.claimBtn:SetOnClick(function()
    self:OnClaimClick()
  end)
  self.iconBtn:SetOnClick(function()
    self:OnIconClick()
  end)
  self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
end

local function ComponentDestroy(self)
  self.levelTxt = nil
  self.content = nil
  self.descTxt = nil
  self.iconImg = nil
  self.claimBtn = nil
  self.claimBtnGray = nil
  self.iconBtn = nil
  self.iconTipRoot = nil
  self.btn_txt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIGiftPrivilegeItemContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GiftSystemReceivingPrivilege, self.RefreshClaimBtn)
end

function LWUIGiftPrivilegeItemContent:OnRemoveListener()
  self:RemoveUIListener(EventId.GiftSystemReceivingPrivilege, self.RefreshClaimBtn)
  base.OnRemoveListener(self)
end

function LWUIGiftPrivilegeItemContent:RefreshClaimBtn()
  self.claimBtnGray:SetActive(not self.data.Unlock or DataCenter.GiftSystemManager:HasPrivilegeClaimed(self.data.template.id))
  if DataCenter.GiftSystemManager:HasPrivilegeClaimed(self.data.template.id) then
    if self.data.template.type == privilegeType.unlock then
      self.btn_txt:SetLocalText("gift_unlock_button2")
    else
      self.btn_txt:SetLocalText("170003")
    end
  elseif self.data.template.type == privilegeType.unlock then
    self.btn_txt:SetLocalText("gift_unlock_button")
  else
    self.btn_txt:SetLocalText("bingo_task_button1")
  end
end

function LWUIGiftPrivilegeItemContent:UpdateItem(data, index)
  local height = 0
  self.data = data
  if data.showLevel then
    self.levelTxt:SetActive(true)
    self.levelTxt:SetLocalText(140002, data.template.level)
    height = 140
  else
    self.levelTxt:SetActive(false)
    height = 80
  end
  self.descTxt:SetLocalText(data.template.des)
  if string.IsNullOrEmpty(data.template.icon) then
    self.iconImg:SetActive(false)
  else
    self.iconImg:SetActive(true)
    self.iconImg:LoadSprite(data.template.icon)
  end
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, height)
  if self.view and self.view.scrollView then
    self.view.scrollView.unity_looplistview2:OnItemSizeChanged(index)
  end
  self:RefreshClaimBtn()
end

function LWUIGiftPrivilegeItemContent:OnClaimClick()
  if not self.data then
    return
  end
  if not self.data.template then
    return
  end
  if not self.data.Unlock or DataCenter.GiftSystemManager:HasPrivilegeClaimed(self.data.template.id) then
    return
  end
  DataCenter.GiftSystemManager:RequestGetPrivilegeReward(self.data.template.id)
end

function LWUIGiftPrivilegeItemContent:OnIconClick()
  if not self.data then
    return
  end
  if not self.data.template then
    return
  end
  local param = {}
  param.alignObject = self.iconTipRoot
  param.yPosFix = 20
  param.showArrow = true
  param.preferTop = false
  param.itemId = self.data.template.show_goods_id
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStickerTipsViewView, {anim = true}, param)
end

LWUIGiftPrivilegeItemContent.OnCreate = OnCreate
LWUIGiftPrivilegeItemContent.OnDestroy = OnDestroy
LWUIGiftPrivilegeItemContent.OnEnable = OnEnable
LWUIGiftPrivilegeItemContent.OnDisable = OnDisable
LWUIGiftPrivilegeItemContent.ComponentDefine = ComponentDefine
LWUIGiftPrivilegeItemContent.ComponentDestroy = ComponentDestroy
LWUIGiftPrivilegeItemContent.DataDefine = DataDefine
LWUIGiftPrivilegeItemContent.DataDestroy = DataDestroy
return LWUIGiftPrivilegeItemContent
