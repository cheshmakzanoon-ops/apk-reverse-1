local UILWTWSkillChipDetailView = BaseClass("UILWTWSkillChipDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SkillChipSimpleAttrLineItem = require("UI.UILWTWSkillChip.UILWTWSkillChipManage.Component.SkillChipSimpleAttrLineItem")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local panel_path = "bgBtn"
local chip_item_path = "Root/BasicInfo/ChipItem"
local name_text_path = "Root/BasicInfo/NameText"
local type_icon_path = "Root/BasicInfo/ChipType/TypeIcon"
local type_text_path = "Root/BasicInfo/ChipType/TypeText"
local power_number_text_path = "Root/BasicInfo/PowerInfo/PowerNumberText"
local functions_path = "Root/Functions"
local star_btn_path = "Root/Functions/StarBtn"
local update_btn_path = "Root/Functions/UpdateBtn"
local replace_btn_path = "Root/TopFunctions/ReplaceBtn"
local star_btn_image_path = "Root/Functions/StarBtn/Btn"
local update_btn_image_path = "Root/Functions/UpdateBtn/Btn2"
local star_btn_red_point_path = "Root/Functions/StarBtn/Btn/StarBtnRedPoint"
local update_btn_red_point_path = "Root/Functions/UpdateBtn/Btn2/UpdateBtnRedPoint"
local replace_btn_red_point_path = "Root/TopFunctions/ReplaceBtn/Btn/ReplaceBtnRedPoint"
local remove_btn_path = "Root/TopFunctions/removeBtn"
local skill_desc_txt_path = "Root/BasicInfo/textScroll/viewport/content/skillDescTxt"
local info_btn_path = "Root/BasicInfo/infoBtn"
local close_btn_path = "Root/CloseBtn"
local preview_state_text_path = "Root/previewStateText"
local quality_top_bg_path = "Root/qualityTopBg"
local quality_bar_bg_path = "Root/qualityBarBg"
local pos_icon_path = "Root/posIcon"
local QUALITY_TOP_BG_STR = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_XQbg_0%s"
local QUALITY_BAR_BG_STR = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_XQ_0%s"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.skillChipInfo, self.showFunctions, self.showManageFunctions, self.customTierSystemEffectValue = self:GetUserData()
  if not self.showFunctions then
    self.showFunctions = false
  end
  self.infoBtn:SetActive(self.skillChipInfo.maxStar > 0)
  self.previewBtn:SetActive(not self.customTierSystemEffectValue)
  self:OnOpen()
  if self.root then
    local trTransform = self.root.transform
    DOTween.Kill(trTransform)
    trTransform:Set_localScale(0, 0, 0)
    trTransform:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
      trTransform:DOScale(Vector3.one, 0.1)
    end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end
end

local function OnDestroy(self)
  if self.root then
    local trTransform = self.root.transform
    DOTween.Kill(trTransform)
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIButton, panel_path)
  self.root:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.chip_item = self:AddComponent(SkillChipItem, chip_item_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.type_icon = self:AddComponent(UIImage, type_icon_path)
  self.type_text = self:AddComponent(UIText, type_text_path)
  self.power_number_text = self:AddComponent(UIText, power_number_text_path)
  self.functions = self:AddComponent(UIBaseContainer, functions_path)
  self.star_btn = self:AddComponent(UIButton, star_btn_path)
  self.star_btn:SetOnClick(function()
    if self.skillChipInfo:IsMaxStar() then
      UIUtil.ShowTipsId("drone_skillChip_tips_4")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipStarUp, {anim = true}, self.skillChipInfo)
    self.ctrl:CloseSelf()
  end)
  self.replace_btn = self:AddComponent(UIButton, replace_btn_path)
  self.replace_btn:SetOnClick(function()
    if not self.skillChipInfo then
      return
    end
    local setId = self.skillChipInfo:GetMasterSet()
    if setId <= 0 then
      return
    end
    local hasChips = DataCenter.TacticalChipManager:HasChipByPosType(self.skillChipInfo:GetType())
    if not hasChips then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipManageEmpty, {anim = true}, self.skillChipInfo:GetType())
    else
      local heroType
      local hasReplaceChip, chipInfo = TacticalWeaponUtils.SkillChipCanReplace(self.skillChipInfo)
      if hasReplaceChip then
        heroType = chipInfo:GetHeroType()
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipManage, {anim = true}, self.skillChipInfo:GetType(), setId, heroType)
    end
    self.ctrl:CloseSelf()
  end)
  self.star_btn_image = self:AddComponent(UIImage, star_btn_image_path)
  self.update_btn_image = self:AddComponent(UIImage, update_btn_image_path)
  self.star_btn_red_point = self:AddComponent(UIImage, star_btn_red_point_path)
  self.update_btn_red_point = self:AddComponent(UIImage, update_btn_red_point_path)
  self.replace_btn_red_point = self:AddComponent(UIImage, replace_btn_red_point_path)
  self.removeBtn = self:AddComponent(UIButton, remove_btn_path)
  self.removeBtn:SetOnClick(function()
    if not self.skillChipInfo then
      return
    end
    local setId = self.skillChipInfo:GetMasterSet()
    if setId <= 0 then
      return
    end
    SFSNetwork.SendMessage(MsgDefines.TWSkillChipPutOff, setId, self.skillChipInfo.uuid)
    self.ctrl:CloseSelf()
  end)
  self.skillDescTxt = self:AddComponent(UITextMeshProUGUIEx, skill_desc_txt_path)
  self.skillDescTxt:OnPointerClick(function(eventData)
    if self.customTierSystemEffectValue then
      return
    end
    self:OnDescClick(eventData)
  end)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    if not self.skillChipInfo then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipStarDetail, {anim = true}, self.skillChipInfo:GetId(), self.skillChipInfo:GetStar())
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.previewStateText = self:AddComponent(UIText, preview_state_text_path)
  self.quality_top_bg = self:AddComponent(UIImage, quality_top_bg_path)
  self.quality_bar_bg = self:AddComponent(UIImage, quality_bar_bg_path)
  self.pos_icon = self:AddComponent(UIImage, pos_icon_path)
  if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == -1 then
    self.pos_icon:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.pos_icon:SetLocalScaleXYZ(1, 1, 1)
  end
  self.previewBtn = self:AddComponent(UIButton, "Root/previewBtn")
  self.previewBtn:SetOnClick(function()
    if self.chipInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipStarDetail, {anim = true}, self.chipInfo:GetId(), self.chipInfo:GetStar())
    end
  end)
  self.textSkillTips = self:AddComponent(UIText, "Root/BasicInfo/skillTipsText")
  self.upgradeNeedCostDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/upgradeNeedCostDesc")
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.textSkillTips = nil
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnOpen(self)
  self:UpdateView()
end

local function RefreshChipInfo(self, chipInfo)
  self.chipInfo = chipInfo
  self.chip_item:SetData(chipInfo)
  self.name_text:SetText(chipInfo:GetName())
  self.type_icon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(chipInfo:GetType()))
  self.type_text:SetText(TacticalWeaponUtils.GetSkillChipTypeText(chipInfo:GetType()))
  self.pos_icon:LoadSprite(DataCenter.TacticalChipManager:GetChipPosIcon(chipInfo:GetType()))
  self.power_number_text:SetText(chipInfo:GetPowerV2())
  local quality = chipInfo:GetQuality()
  self.quality_top_bg:LoadSprite(string.format(QUALITY_TOP_BG_STR, quality))
  self.quality_bar_bg:LoadSprite(string.format(QUALITY_BAR_BG_STR, quality))
  if 5 <= quality then
    self.textSkillTips:SetLocalText("battlesystem_chip_info_desc1")
  elseif chipInfo:GetStar() > 0 then
    self.textSkillTips:SetLocalText("battlesystem_chip_info_desc2", chipInfo:GetExpOnFeed())
  else
    self.textSkillTips:SetLocalText("battlesystem_chip_info_desc3", chipInfo:GetExpOnFeed())
  end
  local skillInfo = chipInfo:GetSkillInfo()
  if skillInfo then
    self.skillDescTxt:SetText(skillInfo:GetDesc(false, "#5FEF87", self.customTierSystemEffectValue))
  else
    self.skillDescTxt:SetText("")
  end
end

local function RefreshBtns(self)
  if self.showFunctions then
    self.functions:SetActive(true)
    self.previewStateText:SetActive(false)
    self.upgradeNeedCostDesc:SetActive(true)
    local showStarUpBtn = self.skillChipInfo.maxStar > 0
    if showStarUpBtn then
      self.star_btn:SetActive(true)
      local starUpRedPoint = TacticalWeaponUtils.SkillChipCanStarUp(self.skillChipInfo)
      self.star_btn_red_point:SetActive(starUpRedPoint)
      if starUpRedPoint then
        self.star_btn_image:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
      else
        self.star_btn_image:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
      end
      local isMaxStar = self.skillChipInfo:IsMaxStar()
      if isMaxStar == false then
        local haveCount = TacticalWeaponUtils.GetChipUseableCount(self.skillChipInfo)
        local commonFragId, fragId, costNum = self.skillChipInfo:GetStarUpCost()
        if costNum and haveCount then
          local haveCountFormat
          if haveCount >= costNum then
            haveCountFormat = string.format("<color=#099b4a>%s</color>", haveCount)
          else
            haveCountFormat = string.format("<color=#f53c3d>%s</color>", haveCount)
          end
          self.upgradeNeedCostDesc:SetLocalText("drone_skillchip_show_4_limit_8", haveCountFormat, costNum)
        else
          self.upgradeNeedCostDesc:SetActive(false)
        end
      else
        self.upgradeNeedCostDesc:SetActive(false)
      end
      UIGray.SetGray(self.star_btn.transform, self.skillChipInfo:IsMaxStar(), true)
    else
      self.star_btn:SetActive(false)
      self.upgradeNeedCostDesc:SetActive(false)
    end
    local lvUpRedPoint = TacticalWeaponUtils.SkillChipCanLvUp(self.skillChipInfo)
    self.update_btn_red_point:SetActive(lvUpRedPoint)
    if lvUpRedPoint then
      self.update_btn_image:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
    else
      self.update_btn_image:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
    end
    if (self.showManageFunctions == nil or self.showManageFunctions == true) and not self.skillChipInfo:IsFree() then
      self.replace_btn:SetActive(true)
      self.removeBtn:SetActive(true)
      local replaceRedPoint = TacticalWeaponUtils.SkillChipCanReplace(self.skillChipInfo)
      self.replace_btn_red_point:SetActive(replaceRedPoint)
    else
      self.replace_btn:SetActive(false)
      self.removeBtn:SetActive(false)
    end
  else
    self.functions:SetActive(false)
    self.upgradeNeedCostDesc:SetActive(false)
    self.previewStateText:SetActive(true)
    self.replace_btn:SetActive(false)
    self.removeBtn:SetActive(false)
  end
end

local function UpdateView(self)
  self:RefreshChipInfo(self.skillChipInfo)
  RefreshBtns(self)
end

function UILWTWSkillChipDetailView:OnDescClick(eventData)
  if not eventData then
    return
  end
  if self.chipInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipStarDetail, {anim = true}, self.chipInfo:GetId(), self.chipInfo:GetStar(), 2, self.customTierSystemEffectValue)
  end
end

UILWTWSkillChipDetailView.OnCreate = OnCreate
UILWTWSkillChipDetailView.OnDestroy = OnDestroy
UILWTWSkillChipDetailView.OnEnable = OnEnable
UILWTWSkillChipDetailView.OnDisable = OnDisable
UILWTWSkillChipDetailView.OnAddListener = OnAddListener
UILWTWSkillChipDetailView.OnRemoveListener = OnRemoveListener
UILWTWSkillChipDetailView.ComponentDefine = ComponentDefine
UILWTWSkillChipDetailView.DataDefine = DataDefine
UILWTWSkillChipDetailView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipDetailView.DataDestroy = DataDestroy
UILWTWSkillChipDetailView.OnOpen = OnOpen
UILWTWSkillChipDetailView.UpdateView = UpdateView
UILWTWSkillChipDetailView.RefreshChipInfo = RefreshChipInfo
return UILWTWSkillChipDetailView
