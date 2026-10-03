local T11SoldierNewGetView = BaseClass("T11SoldierNewGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local selectColor = "17386F"
local unSelectColor = "7CB5EF"

function T11SoldierNewGetView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function T11SoldierNewGetView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SoldierNewGetView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textUnlockInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.rawImgSoldierAImage = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.compT11SoldierSkillItemA = self.viewSkin:AddComponent(self, T11SoldierSkillItemComponent, 5)
  self.textTeamAName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.rawImgSoldierBImage = self.viewSkin:AddComponent(self, UIRawImage, 7)
  self.compT11SoldierSkillItemB = self.viewSkin:AddComponent(self, T11SoldierSkillItemComponent, 8)
  self.textTeamBName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textCloseBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnTeamASelect = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnTeamASelect:SetOnClick(function()
    self:OnBtnTeamASelectClick()
  end)
  self.btnTeamBSelect = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnTeamBSelect:SetOnClick(function()
    self:OnBtnTeamBSelectClick()
  end)
  self.textSelect = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.simpleAnimationT11SoldierNewGet = self.viewSkin:AddComponent(self, UISimpleAnimation, 15)
end

function T11SoldierNewGetView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnPanel = nil
  self.textUnlockInfo = nil
  self.rawImgSoldierAImage = nil
  self.compT11SoldierSkillItemA = nil
  self.textTeamAName = nil
  self.rawImgSoldierBImage = nil
  self.compT11SoldierSkillItemB = nil
  self.textTeamBName = nil
  self.btnClose = nil
  self.textCloseBtn = nil
  self.btnTeamASelect = nil
  self.btnTeamBSelect = nil
  self.textSelect = nil
  self.simpleAnimationT11SoldierNewGet = nil
end

function T11SoldierNewGetView:DataDefine()
  self.initSelect = nil
  self.curSelect = nil
  self.soldierATypeData = {}
  self.soldierBTypeData = {}
end

function T11SoldierNewGetView:DataDestroy()
  self.initSelect = nil
  self.curSelect = nil
  self.soldierATypeData = nil
  self.soldierBTypeData = nil
end

function T11SoldierNewGetView:OnAddListener()
  base.OnAddListener(self)
end

function T11SoldierNewGetView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SoldierNewGetView:OnBtnPanelClick()
end

function T11SoldierNewGetView:OnBtnCloseClick()
  if self.curSelect and self.initSelect then
    local isFirstSelect = true
    SFSNetwork.SendMessage(MsgDefines.SoldierElevenChange, self.curSelect, isFirstSelect)
  end
  self.ctrl:CloseSelf()
end

function T11SoldierNewGetView:InitView()
  self.textTitle:SetLocalText("soldier_eleven_army_unlock_title")
  self.textUnlockInfo:SetLocalText("soldier_eleven_army_unlock")
  self.textCloseBtn:SetLocalText("soldier_eleven_choose_confirm")
  self:InitTeam()
end

function T11SoldierNewGetView:InitTeam()
  local stage = T11Util.GetCurStage()
  local soldierAData = T11Util.GetT11SoldierDataByStageAndType(stage, T11SoldierType.T11SoldierTypeA)
  local soldierBData = T11Util.GetT11SoldierDataByStageAndType(stage, T11SoldierType.T11SoldierTypeB)
  if soldierAData then
    self.soldierATypeData = soldierAData
    self.rawImgSoldierAImage:LoadSprite(soldierAData.soldierImage)
    self.textTeamAName:SetLocalText(soldierAData.name)
    local skillData = T11Util.GetSkillInfoByStage(stage, T11SoldierType.T11SoldierTypeA)
    self.compT11SoldierSkillItemA:Init(skillData)
  end
  if soldierBData then
    self.soldierBTypeData = soldierBData
    self.rawImgSoldierBImage:LoadSprite(soldierBData.soldierImage)
    self.textTeamBName:SetLocalText(soldierBData.name)
    local skillData = T11Util.GetSkillInfoByStage(stage, T11SoldierType.T11SoldierTypeB)
    self.compT11SoldierSkillItemB:Init(skillData)
  end
  local soldierType = T11Util.GetCurT11SoldierType()
  if soldierType == T11SoldierType.T11NotUnLock then
    Logger.LogError("t11 has not unlocked yet")
    return
  end
  self.initSelect = soldierType
  self:SetSelect(soldierType)
end

function T11SoldierNewGetView:SetSelect(soldierType)
  local aniName = soldierType == T11SoldierType.T11SoldierTypeA and "SelectA" or "SelectB"
  self.simpleAnimationT11SoldierNewGet:Play(aniName)
  self.textTeamAName:SetColorHex(soldierType == T11SoldierType.T11SoldierTypeA and selectColor or unSelectColor)
  self.textTeamBName:SetColorHex(soldierType == T11SoldierType.T11SoldierTypeB and selectColor or unSelectColor)
  if self.soldierATypeData and self.soldierBTypeData then
    local name = soldierType == T11SoldierType.T11SoldierTypeA and self.soldierATypeData.name or self.soldierBTypeData.name
    local selectText = Localization:GetString("soldier_eleven_choose_tips", Localization:GetString(name))
    self.textSelect:SetText(selectText)
  end
  self.curSelect = soldierType
end

function T11SoldierNewGetView:OnBtnTeamASelectClick()
  self:SetSelect(T11SoldierType.T11SoldierTypeA)
end

function T11SoldierNewGetView:OnBtnTeamBSelectClick()
  self:SetSelect(T11SoldierType.T11SoldierTypeB)
end

return T11SoldierNewGetView
