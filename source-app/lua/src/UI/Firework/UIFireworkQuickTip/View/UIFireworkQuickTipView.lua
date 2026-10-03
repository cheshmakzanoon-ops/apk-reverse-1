local base = UIBaseView
local UIFireworkQuickTipView = BaseClass("UIFireworkQuickTipView", base)
local nameTxt_path = "bg/nameTxt"
local exitBtn_path = "bg/exitBtn"
local btnTxt_path = "bg/exitBtn/BtnTxt"
local countTxt_path = "bg/FireworkBg/FireworkIcon/Count"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  DataCenter.LWFireworkManager:SetInQuickMode(false)
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
  self.nameTxt = self:AddComponent(UIText, nameTxt_path)
  self.exitBtn = self:AddComponent(UIButton, exitBtn_path)
  self.btnTxt = self:AddComponent(UIText, btnTxt_path)
  self.countTxt = self:AddComponent(UIText, countTxt_path)
  self.exitBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.nameTxt = nil
  self.exitBtn = nil
  self.btnTxt = nil
  self.countTxt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIFireworkQuickTipView:OnChangeCameraLod(lod)
  if 3 <= lod then
    self:SetActive(false)
  else
    self:SetActive(true)
  end
end

function UIFireworkQuickTipView:RefreshView()
  self.nameTxt:SetLocalText("firework_interface_1003")
  self.btnTxt:SetLocalText("110043")
  self.countTxt:SetText(DataCenter.ItemData:GetItemCount(DataCenter.LWFireworkManager:GetDefaultFireworkItemId()))
end

function UIFireworkQuickTipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
  self:AddUIListener(EventId.ChangeCameraLod, self.OnChangeCameraLod)
end

function UIFireworkQuickTipView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.OnChangeCameraLod)
end

UIFireworkQuickTipView.OnCreate = OnCreate
UIFireworkQuickTipView.OnDestroy = OnDestroy
UIFireworkQuickTipView.OnEnable = OnEnable
UIFireworkQuickTipView.OnDisable = OnDisable
UIFireworkQuickTipView.ComponentDefine = ComponentDefine
UIFireworkQuickTipView.ComponentDestroy = ComponentDestroy
UIFireworkQuickTipView.DataDefine = DataDefine
UIFireworkQuickTipView.DataDestroy = DataDestroy
return UIFireworkQuickTipView
