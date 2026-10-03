local T11SoldierPreviewView = BaseClass("T11SoldierPreviewView", UIBaseView)
local Const = require("DataCenter.T11DataManager.T11Constant")
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function T11SoldierPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function T11SoldierPreviewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SoldierPreviewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compT11SoldierSkillItemB = self.viewSkin:AddComponent(self, T11SoldierSkillItemComponent, 1)
  self.compT11SoldierSkillItemA = self.viewSkin:AddComponent(self, T11SoldierSkillItemComponent, 2)
  self.rawImgSoldierBBg = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.rawImgSoldierABg = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textSoldierAName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textSoldierBName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.simpleAnimationT11SoldierPreview = self.viewSkin:AddComponent(self, UISimpleAnimation, 8)
end

function T11SoldierPreviewView:ComponentDestroy()
  self.viewSkin = nil
  self.compT11SoldierSkillItemB = nil
  self.compT11SoldierSkillItemA = nil
  self.rawImgSoldierBBg = nil
  self.rawImgSoldierABg = nil
  self.btnPanel = nil
  self.textSoldierAName = nil
  self.textSoldierBName = nil
  self.simpleAnimationT11SoldierPreview = nil
end

function T11SoldierPreviewView:DataDefine()
end

function T11SoldierPreviewView:DataDestroy()
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

function T11SoldierPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function T11SoldierPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SoldierPreviewView:OnBtnPanelClick()
  if self.closeTimer then
    return
  end
  local ret, duration = self.simpleAnimationT11SoldierPreview:PlayAnimationReturnTime("Hide")
  if ret then
    self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.closeTimer = nil
      self.ctrl:CloseSelf()
    end, duration)
  else
    self.ctrl:CloseSelf()
  end
end

function T11SoldierPreviewView:OnBtnSoldierASkillClick()
end

function T11SoldierPreviewView:OnBtnSoldierBSkillClick()
end

function T11SoldierPreviewView:InitView()
  local nextStage = T11Util.GetT11InitialStage()
  local soldierAData = T11Util.GetT11SoldierDataByStageAndType(nextStage, T11SoldierType.T11SoldierTypeA)
  local soldierBData = T11Util.GetT11SoldierDataByStageAndType(nextStage, T11SoldierType.T11SoldierTypeB)
  self:InitSoldierA(soldierAData, nextStage)
  self:InitSoldierB(soldierBData, nextStage)
end

function T11SoldierPreviewView:InitSoldierA(soldierData, stage)
  if not soldierData then
    Logger.LogError("T11SoldierPreviewView:InitSoldierA: soldierData is nil")
    return
  end
  self.textSoldierAName:SetText(Localization:GetString(soldierData.name))
  self.rawImgSoldierABg:LoadSprite(soldierData.soldierImage)
  self.rawImgSoldierABg:SetNativeSize()
  local skillData = T11Util.GetSkillInfoByStage(stage, T11SoldierType.T11SoldierTypeA)
  self.compT11SoldierSkillItemA:Init(skillData, false)
end

function T11SoldierPreviewView:InitSoldierB(soldierData, stage)
  if not soldierData then
    Logger.LogError("T11SoldierPreviewView:InitSoldierB: soldierData is nil")
    return
  end
  self.textSoldierBName:SetText(Localization:GetString(soldierData.name))
  self.rawImgSoldierBBg:LoadSprite(soldierData.soldierImage)
  self.rawImgSoldierBBg:SetNativeSize()
  local skillData = T11Util.GetSkillInfoByStage(stage, T11SoldierType.T11SoldierTypeB)
  self.compT11SoldierSkillItemB:Init(skillData, false)
end

return T11SoldierPreviewView
