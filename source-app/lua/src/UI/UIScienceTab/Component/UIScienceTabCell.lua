local UIScienceTabCell = BaseClass("UIScienceTabCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  template,
  isResearching,
  isResearchingScienceId
}
local this_path = "bgBtn"
local tab_name_path = "bgBtn/TabName"
local no_unlock_text_path = "bgBtn/NoUnlockText"
local pro_text_path = "bgBtn/ProText"
local maxLevelTxt_path = "bgBtn/MaxText"
local researchingTxt_path = "bgBtn/ResearchingTxt"
local researching_anim_path = "bgBtn/UIResearchingAnim"
local lockImg_path = "bgBtn/Image"
local BgType = {
  Max = "UI_shiyanshi_jindu02",
  Other = "UI_shiyanshi_jindu01"
}
local isResearchingTextPosition = Vector3.New(-18.8, 58.7, 0)
local LockTextPosition = Vector3.New(5, 58.7, 0)
local LockColor = Color.New(0.7137255, 0.5372549, 0.4392157, 1)
local isResearchingColor = Color.New(1, 1, 1, 1)

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
  if self.param then
    self:ReInit(self.param)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn_img = self:AddComponent(UIImage, this_path)
  self.tab_name = self:AddComponent(UIText, tab_name_path)
  self.no_unlock_text = self:AddComponent(UIText, no_unlock_text_path)
  self.pro_text = self:AddComponent(UIText, pro_text_path)
  self.researchingTxtN = self:AddComponent(UIText, researchingTxt_path)
  self.researchingTxtN:SetLocalText(GameDialogDefine.SCIENCE_RESEARCHING)
  self.maxLvTxtN = self:AddComponent(UIText, maxLevelTxt_path)
  self.maxLvTxtN:SetLocalText(GameDialogDefine.MAX)
  self.lockImgN = self:AddComponent(UIBaseContainer, lockImg_path)
  self.researching_anim = self:AddComponent(UIBaseContainer, researching_anim_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.tab_name = nil
  self.no_unlock_text = nil
  self.pro_text = nil
  self.btn_img = nil
  self.researching_anim = nil
end

local function DataDefine(self)
  self.param = nil
  self.state = nil
end

local function DataDestroy(self)
  self.param = nil
  self.state = nil
end

local function ReInit(self, param)
  self.param = param
  if self.param.template.id == 1 then
    self.tab_name:SetAnchoredPositionXY(0, self.tab_name:GetAnchoredPositionY())
  elseif self.param.template.id == 2 then
    self.tab_name:SetAnchoredPositionXY(0, self.tab_name:GetAnchoredPositionY())
  elseif self.param.template.id == 3 then
    self.tab_name:SetAnchoredPositionXY(0, self.tab_name:GetAnchoredPositionY())
  elseif self.param.template.id == 4 then
    self.tab_name:SetAnchoredPositionXY(0, self.tab_name:GetAnchoredPositionY())
  end
  self.tab_name:SetLocalText(param.template.name)
  local lockedTip = ""
  self.state, lockedTip = DataCenter.ScienceTemplateManager:GetTabState(param.template.id)
  if self.state == ScienceTabState.UnLock then
    if param.isResearching then
      self.researching_anim:SetActive(true)
      self.pro_text:SetActive(false)
      self.no_unlock_text:SetActive(false)
      self.maxLvTxtN:SetActive(false)
      self.researchingTxtN:SetActive(true)
    else
      self.researching_anim:SetActive(false)
      self.no_unlock_text:SetActive(false)
      self.researchingTxtN:SetActive(false)
      local pro = DataCenter.ScienceTemplateManager:GetScienceTabPro(param.template.id)
      if 1 <= pro then
        self.pro_text:SetActive(false)
        self.maxLvTxtN:SetActive(true)
      else
        self.pro_text:SetActive(true)
        self.maxLvTxtN:SetActive(false)
        if 0 < pro and pro < 0.01 then
          self.pro_text:SetText(math.ceil(pro * 100) .. "%")
        else
          self.pro_text:SetText(math.floor(pro * 100) .. "%")
        end
      end
    end
    self.lockImgN:SetActive(false)
    self.tab_name:SetColor(ScienceNameUnlockColor)
    self.btn_img:LoadSprite(string.format(LoadPath.UIScience, param.template.icon))
  elseif self.state == ScienceTabState.Lock then
    self.btn_img:LoadSprite(string.format(LoadPath.UIScience, param.template.icon .. "_gray"))
    self.pro_text:SetActive(false)
    self.no_unlock_text:SetActive(true)
    self.no_unlock_text:SetText(lockedTip)
    self.no_unlock_text:SetColor(LockColor)
    self.researching_anim:SetActive(false)
    self.lockImgN:SetActive(true)
  elseif self.state == ScienceTabState.LockShow then
    self.btn_img:LoadSprite(string.format(LoadPath.UIScience, param.template.icon .. "_gray"))
    self.pro_text:SetActive(false)
    self.maxLvTxtN:SetActive(false)
    self.researchingTxtN:SetActive(false)
    self.no_unlock_text:SetActive(true)
    self.no_unlock_text:SetText(lockedTip)
    self.researching_anim:SetActive(false)
    self.tab_name:SetColor(ScienceNameLockColor)
    self.lockImgN:SetActive(true)
  elseif self.state == ScienceTabState.CanUnlock then
    self.btn_img:LoadSprite(string.format(LoadPath.UIScience, param.template.icon .. "_gray"))
    self.pro_text:SetActive(false)
    self.no_unlock_text:SetActive(true)
    self.no_unlock_text:SetLocalText(GameDialogDefine.UNLOCK)
    self.no_unlock_text:SetColor(LockColor)
    self.researching_anim:SetActive(false)
  end
  self.btn_img:SetNativeSize()
end

local function OnBtnClick(self)
  if self.state == ScienceTabState.UnLock then
    if self.param.isResearching ~= nil and self.param.isResearching == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience, {anim = true, hideTop = true}, self.param.template.id, self.param.isResearchingScienceId, true, self.view.bUuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience, {anim = true, hideTop = true}, self.param.template.id, nil, true, self.view.bUuid)
    end
  elseif self.state == ScienceTabState.CanUnlock then
    if self.param.isResearching ~= nil and self.param.isResearching == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience, {anim = true, hideTop = true}, self.param.template.id, self.param.isResearchingScienceId, false, self.view.bUuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience, {anim = true, hideTop = true}, self.param.template.id, nil, true, self.view.bUuid)
    end
    DataCenter.ScienceTemplateManager:SetScienceTabSetting(self.param.template.id)
    self:ReInit(self.param)
  elseif self.state == ScienceTabState.Lock then
  end
end

UIScienceTabCell.OnCreate = OnCreate
UIScienceTabCell.OnDestroy = OnDestroy
UIScienceTabCell.Param = Param
UIScienceTabCell.OnEnable = OnEnable
UIScienceTabCell.OnDisable = OnDisable
UIScienceTabCell.ComponentDefine = ComponentDefine
UIScienceTabCell.ComponentDestroy = ComponentDestroy
UIScienceTabCell.DataDefine = DataDefine
UIScienceTabCell.DataDestroy = DataDestroy
UIScienceTabCell.ReInit = ReInit
UIScienceTabCell.OnBtnClick = OnBtnClick
return UIScienceTabCell
