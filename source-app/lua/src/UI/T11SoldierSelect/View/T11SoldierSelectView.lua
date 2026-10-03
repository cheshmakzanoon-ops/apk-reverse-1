local T11SoldierSelectView = BaseClass("T11SoldierSelectView", UIBaseView)
local base = UIBaseView
local M = T11SoldierSelectView
local T11SoldierSelectSkillComponent = require("UI.T11SoldierSelect.Component.T11SoldierSelectSkillComponent")
local UISoldierInfoTip = require("UI.UILWMilitaryCampPanel.Component.UISoldierInfoTip")
local Const = require("DataCenter.T11DataManager.T11Constant")
local Localization = CS.GameEntry.Localization

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textUnlockInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.rawImgSoldierAImage = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.rawImgSoldierBImage = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.btnTeamASelect = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnTeamASelect:SetOnClick(function()
    self:OnBtnTeamASelectClick()
  end)
  self.btnTeamBSelect = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnTeamBSelect:SetOnClick(function()
    self:OnBtnTeamBSelectClick()
  end)
  self.compSoldierInfo = self.viewSkin:AddComponent(self, UISoldierInfoTip, 7)
  self.btnSelect = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.textSelectBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compSkill = self.viewSkin:AddComponent(self, T11SoldierSelectSkillComponent, 10)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textSelect = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.simpleAnimationT11SoldierSelect = self.viewSkin:AddComponent(self, UISimpleAnimation, 13)
  self.simpleAnimationTeam = self.viewSkin:AddComponent(self, UISimpleAnimation, 14)
end

function M:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textUnlockInfo = nil
  self.rawImgSoldierAImage = nil
  self.rawImgSoldierBImage = nil
  self.btnTeamASelect = nil
  self.btnTeamBSelect = nil
  self.compSoldierInfo = nil
  self.btnSelect = nil
  self.textSelectBtn = nil
  self.compSkill = nil
  self.btnClose = nil
  self.textSelect = nil
  self.simpleAnimationT11SoldierSelect = nil
  self.simpleAnimationTeam = nil
end

function M:DataDefine()
  self.initSelect = nil
  self.curSelect = nil
  self.curStage = nil
  self.soldierATypeData = nil
  self.soldierBTypeData = nil
  self.soldierASkillInfos = nil
  self.soldierBSkillInfos = nil
  self.showCountDown = false
end

function M:DataDestroy()
  self.initSelect = nil
  self.curSelect = nil
  self.curStage = nil
  self.soldierATypeData = nil
  self.soldierBTypeData = nil
  self.soldierASkillInfos = nil
  self.soldierBSkillInfos = nil
  self.showCountDown = nil
  if self.openViewAniTimer then
    self.openViewAniTimer:Stop()
    self.openViewAniTimer = nil
  end
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnBtnTeamASelectClick()
  self:OnSelect(T11SoldierType.T11SoldierTypeA)
end

function M:OnBtnTeamBSelectClick()
  self:OnSelect(T11SoldierType.T11SoldierTypeB)
end

function M:OnBtnSelectClick()
  local isCanChangeModel = T11Util.CheckIsCanChangeSoldierMode()
  if not isCanChangeModel then
    UIUtil.ShowTipsId("soldier_eleven_cant_change_01")
    return
  end
  if self.curSelect and self.initSelect and self.curSelect ~= self.initSelect then
    local cdMinute = LuaEntry.DataConfig:TryGetNum("soldier_eleven_param", "k3")
    local cdHours = math.floor(cdMinute / 60 + 0.5)
    UIUtil.ShowMessage(Localization:GetString("soldier_eleven_change_confirm", cdHours), 2, "soldier_eleven_change_confirm_btn_01", "soldier_eleven_change_confirm_btn_02", function()
      SFSNetwork.SendMessage(MsgDefines.SoldierElevenChange, self.curSelect)
      self.ctrl:CloseSelf()
    end)
  end
end

function M:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function M:InitView()
  self.textTitle:SetLocalText("soldier_eleven_choose_title")
  self.textUnlockInfo:SetLocalText("soldier_eleven_choose")
  self.textSelectBtn:SetLocalText("soldier_eleven_choose_btn_01")
  self.initSelect = T11Util.GetCurT11SoldierType()
  self.curSelect = self.initSelect
  self.curStage = T11Util.GetCurStage()
  if not self.initSelect then
    Logger.LogError("t11 has not unlocked yet")
    return
  end
  if not self.curStage then
    Logger.LogError("curStage is nil")
    return
  end
  if self.openViewAniTimer then
    self.openViewAniTimer:Stop()
    self.openViewAniTimer = nil
  end
  self:InitSelect()
  self.compSkill:Init(self.ctrl)
  self.compSkill:RefreshSkillList(self.curSelect)
  self:RefreshSoldierTip()
end

function M:InitSelect()
  local soldierAData = T11Util.GetT11SoldierDataByStageAndType(self.curStage, T11SoldierType.T11SoldierTypeA)
  local soldierBData = T11Util.GetT11SoldierDataByStageAndType(self.curStage, T11SoldierType.T11SoldierTypeB)
  if soldierAData then
    self.soldierATypeData = soldierAData
    self.rawImgSoldierAImage:LoadSprite(soldierAData.soldierImage)
  end
  if soldierBData then
    self.soldierBTypeData = soldierBData
    self.rawImgSoldierBImage:LoadSprite(soldierBData.soldierImage)
  end
  self:RefreshSelectNode()
end

function M:RefreshSoldierTip()
  self.compSoldierInfo:SetActive(true)
  local soldierId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(Const.SoldierLevel)
  self.compSoldierInfo:Refresh(DataCenter.SoldierDataManager:GetTemplate(soldierId))
end

function M:OnSelect(selectType)
  self.curSelect = selectType
  self:RefreshSelectNode()
  self.compSkill:RefreshSkillList(self.curSelect)
end

function M:RefreshSelectNode()
  local aniName = self.curSelect == T11SoldierType.T11SoldierTypeA and "selectA" or "selectB"
  self.simpleAnimationTeam:Play(aniName)
  if self.curSelect == self.initSelect then
    self.showCountDown = false
    self.textSelect:SetActive(true)
    self.btnSelect:SetActive(false)
    self.textSelect:SetLocalText("soldier_eleven_choose_btn_02")
  else
    local nextSwitchTime = DataCenter.T11DataManager:GetNextSwitchTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local canSwitch = nextSwitchTime <= curTime
    if not canSwitch then
      self.showCountDown = true
      self.btnSelect:SetActive(false)
      self:Update1000MS()
    else
      self.showCountDown = false
      self.btnSelect:SetActive(true)
      self.textSelect:SetActive(false)
    end
  end
end

function M:Update1000MS()
  if self.showCountDown then
    local nextSwitchTime = DataCenter.T11DataManager:GetNextSwitchTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if nextSwitchTime > curTime then
      local timeLeft = nextSwitchTime - curTime
      self.textSelect:SetLocalText("soldier_eleven_choose_btn_03", UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft))
    else
      self.showCountDown = false
      self:RefreshSelectNode()
    end
  end
end

function M:IsPlayingOpenViewAni()
  return self.openViewAniTimer
end

return T11SoldierSelectView
