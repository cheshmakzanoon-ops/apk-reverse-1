local UILWAlMemberOfficialTipPanel = BaseClass("UILWAlMemberOfficialTipPanel", UIBaseContainer)
local base = UIBaseContainer

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
  self.viewBtn = self:AddComponent(UIButton, "TipBg/ViewBtn")
  self.viewBtnText = self:AddComponent(UIText, "TipBg/ViewBtn/ViewBtnText")
  self.appointBtn = self:AddComponent(UIButton, "TipBg/AppointBtn")
  self.appointBtnText = self:AddComponent(UIText, "TipBg/AppointBtn/AppointBtnText")
  self.removeBtn = self:AddComponent(UIButton, "TipBg/RemoveBtn")
  self.removeBtnText = self:AddComponent(UIText, "TipBg/RemoveBtn/RemoveBtnText")
  self.tipBg = self:AddComponent(UIBaseComponent, "TipBg")
  self.viewBtn:SetOnClick(function()
    if self.type then
      local playerInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(self.type)
      if playerInfo then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, playerInfo.uid)
      end
    end
    self.view:CloseTipPanel()
  end)
  self.appointBtn:SetOnClick(function()
    if self.type then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMemberOfficial, {anim = true}, self.type)
    end
    self.view:CloseTipPanel()
  end)
  self.removeBtn:SetOnClick(function()
    if self.type then
      local playerInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(self.type)
      if playerInfo then
        DataCenter.AllianceMemberDataManager:SendAllianceSetRank(playerInfo.uid, 4, 0)
      end
    end
    self.view:CloseTipPanel()
  end)
  self.viewBtnText:SetLocalText("alliance_officer_btn_profile")
  self.appointBtnText:SetLocalText("alliance_officer_btn_change")
end

local function ComponentDestroy(self)
  self.viewBtn = nil
  self.viewBtnText = nil
  self.appointBtn = nil
  self.appointBtnText = nil
  self.removeBtn = nil
  self.removeBtnText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

function UILWAlMemberOfficialTipPanel:SetData(type, onlyShowRemove, pos)
  self.type = type
  self.viewBtn:SetActive(not onlyShowRemove)
  self.appointBtn:SetActive(not onlyShowRemove)
  self.removeBtn:SetActive(true)
  self.tipBg:SetPosition(pos)
  local anchorPos = self.tipBg:GetAnchoredPosition()
  self.tipBg:SetAnchoredPositionXY(anchorPos.x, anchorPos.y - 45)
  if onlyShowRemove then
    self.removeBtnText:SetLocalText("alliance_officer_btn_retire")
  else
    self.removeBtnText:SetLocalText("alliance_officer_btn_resign")
  end
end

UILWAlMemberOfficialTipPanel.OnCreate = OnCreate
UILWAlMemberOfficialTipPanel.OnDestroy = OnDestroy
UILWAlMemberOfficialTipPanel.OnEnable = OnEnable
UILWAlMemberOfficialTipPanel.OnDisable = OnDisable
UILWAlMemberOfficialTipPanel.ComponentDefine = ComponentDefine
UILWAlMemberOfficialTipPanel.ComponentDestroy = ComponentDestroy
UILWAlMemberOfficialTipPanel.DataDefine = DataDefine
UILWAlMemberOfficialTipPanel.DataDestroy = DataDestroy
UILWAlMemberOfficialTipPanel.OnAddListener = OnAddListener
UILWAlMemberOfficialTipPanel.OnRemoveListener = OnRemoveListener
return UILWAlMemberOfficialTipPanel
