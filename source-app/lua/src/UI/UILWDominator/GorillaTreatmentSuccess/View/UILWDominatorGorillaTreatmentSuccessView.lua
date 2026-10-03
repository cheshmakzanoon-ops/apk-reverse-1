local UILWDominatorGorillaTreatmentSuccessView = BaseClass("UILWDominatorGorillaTreatmentSuccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DominatorGorillaInfo = require("DataCenter/Dominator/Main/DominatorGorillaInfo")

function UILWDominatorGorillaTreatmentSuccessView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorGorillaTreatmentSuccessView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorGorillaTreatmentSuccessView:ComponentDefine()
  self.textTitleTxt = self:AddComponent(UIText, "Content/bgContent1/titleBg/titleTxt")
  self.textTitleTxt:SetText(Localization:GetString("dominator_cure_title_1"))
  self.imgPreIcon = self:AddComponent(UIImage, "Content/bgContent1/PreIcon")
  self.imgNewIcon = self:AddComponent(UIImage, "Content/bgContent1/NewIcon")
  self.textDes = self:AddComponent(UIText, "Content/DesText")
  self.textDes:SetText(Localization:GetString("dominator_cure_desc_8"))
  self.textContinue = self:AddComponent(UIText, "Content/ContinueText")
  self.textContinue:SetText(Localization:GetString("dominator_cure_desc_9"))
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

function UILWDominatorGorillaTreatmentSuccessView:ComponentDestroy()
  self.textTitleTxt = nil
  self.imgPreIcon = nil
  self.imgNewIcon = nil
  self.textDes = nil
  self.textContinue = nil
  self.btnPanel = nil
end

function UILWDominatorGorillaTreatmentSuccessView:OnOpen()
  local param = self:GetUserData()
  self.closeCallback = param.closeCallback
  self.openCallback = param.openCallback
  self.evtData = param.evtData
  if self.evtData.preState == DominatorGorillaTreatmentStage.One then
    self.imgPreIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/zxl_zhuzai_jiuzhi_hong.png")
  elseif self.evtData.preState == DominatorGorillaTreatmentStage.Two then
    self.imgPreIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/zxl_zhuzai_jiuzhi_huang.png")
  end
  if self.evtData.curState == DominatorGorillaTreatmentStage.Two then
    self.imgNewIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/zxl_zhuzai_jiuzhi_huang.png")
  elseif self.evtData.curState == DominatorGorillaTreatmentStage.Three then
    self.imgNewIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/zxl_zhuzai_jiuzhi_lv.png")
  end
  if self.openCallback then
    self.openCallback()
  end
end

function UILWDominatorGorillaTreatmentSuccessView:DataDefine()
end

function UILWDominatorGorillaTreatmentSuccessView:DataDestroy()
end

function UILWDominatorGorillaTreatmentSuccessView:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorGorillaTreatmentSuccessView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorGorillaTreatmentSuccessView:OnBtnPanelClick()
  if self.closeCallback then
    self.closeCallback()
  end
  self.ctrl:CloseSelf()
end

return UILWDominatorGorillaTreatmentSuccessView
