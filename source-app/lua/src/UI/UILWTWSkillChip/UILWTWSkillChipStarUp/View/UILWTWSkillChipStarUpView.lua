local UILWTWSkillStarUpView = BaseClass("UILWTWSkillStarUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SkillChipSimpleAttrLineItem = require("UI.UILWTWSkillChip.UILWTWSkillChipUpgrade.Component.SkillChipSimpleAttrLineItem")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local src_chip_item_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Chips/SrcChipItem"
local src_power_info_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Chips/SrcChipItem/SrcPowerInfo"
local src_power_number_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Chips/SrcChipItem/SrcPowerNumberText"
local arrow_icon_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Chips/ArrowIcon"
local dst_chip_item_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Chips/DstChipItem"
local dst_power_info_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Chips/DstChipItem/DstPowerInfo"
local dst_power_number_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/Chips/DstChipItem/DstPowerNumberText"
local skill_desc_text_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/SkillDetailDesc/skillDesc/viewport/content/skillDescText"
local seperate_line_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/SkillDetailDesc/seperateLine"
local unlock_skill_effect_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/SkillDetailDesc/unlockSkillEffect"
local star_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/SkillDetailDesc/unlockSkillEffect/viewport/effectContent/effectTxt/star"
local star_txt_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/SkillDetailDesc/unlockSkillEffect/viewport/effectContent/effectTxt/star/starTxt"
local effect_txt_path = "PopUpTitle/Common_bg_orange2/Content/BasicInfo/SkillDetailDesc/unlockSkillEffect/viewport/effectContent/effectTxt"
local use_common_upgrade_btn_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/LeftCost/UseCommonUpgradeBtn"
local upgrade_btn_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/RightCost/UpgradeBtn"
local right_cost_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/RightCost"
local right_same_cost_chip_item_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/RightCost/RightSameCostChipItem"
local right_cost_num_text_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/RightCost/RightSameCostChipItem/RightCostNumText"
local left_cost_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/LeftCost"
local left_common_chip_item_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/LeftCost/LeftCommonChipItem"
local left_same_cost_chip_item_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/LeftCost/LeftSameCostChipItem"
local left_common_cost_num_text_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/LeftCost/LeftCommonChipItem/LeftCommonCostNumText"
local left_same_cost_num_text_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons/LeftCost/LeftSameCostChipItem/LeftSameCostNumText"
local max_star_text_path = "PopUpTitle/Common_bg_orange2/Content/MaxStarText"
local funcitons_path = "PopUpTitle/Common_bg_orange2/Content/Funcitons"
local preview_btn_path = "PopUpTitle/Common_bg_orange2/Content/previewBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.chipInfo = self:GetUserData()
  if not self.chipInfo then
    return
  end
  self.canUseCommonItem = false
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SendChipStarUpMsg(self, commonFragCount)
  if not self.chipInfo then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.TWSkillChipStarUp, self.chipInfo.uuid, commonFragCount)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.src_chip_item = self:AddComponent(SkillChipItem, src_chip_item_path)
  self.src_power_number_text = self:AddComponent(UIText, src_power_number_text_path)
  self.arrow_icon = self:AddComponent(UIImage, arrow_icon_path)
  self.dst_chip_item = self:AddComponent(SkillChipItem, dst_chip_item_path)
  self.dst_power_info = self:AddComponent(UIImage, dst_power_info_path)
  self.dst_power_number_text = self:AddComponent(UIText, dst_power_number_text_path)
  self.skill_desc_text = self:AddComponent(UITextMeshProUGUIEx, skill_desc_text_path)
  self.skill_desc_text:OnPointerClick(function(eventData)
    self:OnDescClick(eventData)
  end)
  self.seperate_line = self:AddComponent(UIImage, seperate_line_path)
  self.unlock_skill_effect = self:AddComponent(UIText, unlock_skill_effect_path)
  self.star = self:AddComponent(UIImage, star_path)
  self.star_txt = self:AddComponent(UIText, star_txt_path)
  self.effect_txt = self:AddComponent(UIText, effect_txt_path)
  self.use_common_upgrade_btn = self:AddComponent(UIButton, use_common_upgrade_btn_path)
  self.use_common_upgrade_btn:SetOnClick(function()
    if self.haveFragCount + self.commonHeroFragCount >= self.costFragCount then
      local costCommonFragCount = self.costFragCount - self.haveFragCount
      if costCommonFragCount < 0 then
        costCommonFragCount = 0
      end
      SendChipStarUpMsg(self, costCommonFragCount)
    else
      TacticalWeaponUtils.ShowSkillChipLackWindow()
    end
  end)
  self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgrade_btn:SetOnClick(function()
    if self.haveFragCount >= self.costFragCount then
      SendChipStarUpMsg(self, 0)
    else
      local chipId, needCount
      if self.chipInfo then
        chipId = self.chipInfo:GetId()
        local haveCount = self.haveFragCount or 0
        local costCount = self.costFragCount or 0
        needCount = costCount
      end
      TacticalWeaponUtils.ShowSkillChipLackWindow(chipId, needCount)
    end
  end)
  self.right_cost = self:AddComponent(UIImage, right_cost_path)
  self.right_same_cost_chip_item = self:AddComponent(SkillChipItem, right_same_cost_chip_item_path)
  self.right_cost_num_text = self:AddComponent(UIText, right_cost_num_text_path)
  self.left_cost = self:AddComponent(UIImage, left_cost_path)
  self.left_common_chip_item = self:AddComponent(UICommonResItem, left_common_chip_item_path)
  self.left_same_cost_chip_item = self:AddComponent(SkillChipItem, left_same_cost_chip_item_path)
  self.left_common_cost_num_text = self:AddComponent(UIText, left_common_cost_num_text_path)
  self.left_same_cost_num_text = self:AddComponent(UIText, left_same_cost_num_text_path)
  self.max_star_text = self:AddComponent(UIText, max_star_text_path)
  self.funcitons = self:AddComponent(UIBaseContainer, funcitons_path)
  self.preview_btn = self:AddComponent(UIButton, preview_btn_path)
  self.preview_btn:SetOnClick(function()
    if self.chipInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipStarDetail, {anim = true}, self.chipInfo:GetId(), self.chipInfo:GetStar())
    end
  end)
  self.textLevel8 = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/Content/progress/level8")
  self.textLevel2 = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/Content/progress/level2")
  self.textLevel5 = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/Content/progress/level5")
  self.imgProgress = self:AddComponent(UIImage, "PopUpTitle/Common_bg_orange2/Content/progress")
  self.normalLvSelected = self:AddComponent(UIVfx, "PopUpTitle/Common_bg_orange2/Content/progress/normalLvSelected", VfxAssets.TacticalChipStarUpNormalLvSelect, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
  self.mainLvSelected = self:AddComponent(UIVfx, "PopUpTitle/Common_bg_orange2/Content/progress/mainLvSelected", VfxAssets.TacticalChipStarUpMainLvSelect, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
  self.normalUnlockable = self:AddComponent(UIVfx, "PopUpTitle/Common_bg_orange2/Content/progress/normalUnlockable", VfxAssets.TacticalChipStarUpLvUnlock, {
    lifeType = UIVfxLifeType.Stay
  })
  self.mainUnlockable = self:AddComponent(UIVfx, "PopUpTitle/Common_bg_orange2/Content/progress/mainUnlockable", VfxAssets.TacticalChipStarUpLvUnlock, {
    lifeType = UIVfxLifeType.Stay
  })
  self.bgHighLight = self:AddComponent(UIBaseContainer, "PopUpTitle/Common_bg_orange2/Content/bgHighLight111")
  self.compBgHighLight = self:AddComponent(UIVfx, "PopUpTitle/Common_bg_orange2/Content/bgHighLight", VfxAssets.TacticalChipStarUpMainLvBgEffect, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
  self.originLvHighLightPosX = -270
  self.lvHighLightPosDeltaX = 60
  self.mainLvDic = {
    [2] = self.textLevel2,
    [5] = self.textLevel5,
    [8] = self.textLevel8
  }
  self.textCostPropsTitle = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/Content/BasicInfo/SkillDetailDesc/costPropsTitle")
  self.textCostPropsTitle:SetLocalText("battlesystem_chip_info_desc4")
  self.compVfxDianLiu = self:AddComponent(UIVfx, "PopUpTitle/Common_bg_orange2/Content/vfxDianLiu")
  self.compLvArrow = self:AddComponent(UIBaseContainer, "PopUpTitle/Common_bg_orange2/Content/progress/lvArrow")
  self.progressValue = {
    [1] = 0.023,
    [2] = 0.15,
    [3] = 0.24,
    [4] = 0.35,
    [5] = 0.475,
    [6] = 0.566,
    [7] = 0.674,
    [8] = 0.8,
    [9] = 0.892,
    [10] = 1
  }
  self.compProgressReal = self:AddComponent(UIImage, "PopUpTitle/Common_bg_orange2/Content/progressReal")
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.textLevel8 = nil
  self.textLevel2 = nil
  self.textLevel5 = nil
  self.imgProgress = nil
  self.normalLvSelected = nil
  self.mainLvSelected = nil
  self.compBgHighLight = nil
  self.textCostPropsTitle = nil
  self.compLvArrow = nil
  self.compProgressReal = nil
  self:StopVXDianLiuSound()
end

local function DataDestroy(self)
  if self.delayUpTimer then
    self.delayUpTimer:Stop()
    self.delayUpTimer = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnChipStarUp(self, eventData)
  if eventData and eventData.changedChipUuid and eventData.changedChipUuid == self.chipInfo.uuid and eventData.srcStar then
    local targetFlag
    local newPosX = self.originLvHighLightPosX + eventData.srcStar * self.lvHighLightPosDeltaX
    if self.mainLvDic[eventData.srcStar + 1] then
      targetFlag = self.mainLvSelected
      self.compBgHighLight:Replay()
    else
      targetFlag = self.normalLvSelected
    end
    local originPos = targetFlag:GetLocalPosition()
    originPos.x = newPosX
    targetFlag:SetLocalPosition(originPos)
    targetFlag:Replay()
    self.compVfxDianLiu:PlayByOnce(VfxAssets.TacticalChipStarUpDianLiu)
    self:PlayVXDianLiuSound()
    self.delayUpTimer = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipChangeSuccess, {anim = true}, eventData.changedChipUuid, nil, eventData.srcStar)
      self:UpdateView()
    end, 1)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.UpdateView)
  self:AddUIListener(EventId.TWSkillUpdate, self.UpdateView)
  self:AddUIListener(EventId.TWSkillChipStarUp, self.OnChipStarUp)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateView)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.UpdateView)
  self:RemoveUIListener(EventId.TWSkillChipStarUp, self.OnChipStarUp)
end

local function OnOpen(self)
  self:UpdateView()
end

local function UpdateView(self)
  self.src_chip_item:SetData(self.chipInfo)
  local skillInfo = self.chipInfo:GetSkillInfo()
  self.skill_desc_text:SetText(skillInfo:GetDesc(false, "#5FEF87"))
  if self.chipInfo:IsMaxStar() then
    self.funcitons:SetActive(false)
    self.max_star_text:SetActive(true)
    self.arrow_icon:SetActive(false)
    self.dst_chip_item:SetActive(false)
    self.seperate_line:SetActive(false)
    self.unlock_skill_effect:SetActive(false)
    self.textCostPropsTitle:SetActive(false)
  else
    self.arrow_icon:SetActive(true)
    self.dst_chip_item:SetActive(true)
    self.funcitons:SetActive(true)
    self.max_star_text:SetActive(false)
    self.seperate_line:SetActive(false)
    self.unlock_skill_effect:SetActive(true)
    self.textCostPropsTitle:SetActive(true)
    local nextStar = self.chipInfo:GetStar() + 1
    self.star_txt:SetText(string.format("%d", nextStar))
    local effects = skillInfo:GetEffectsDescTWSkillChip()
    local nextEffect = effects[nextStar]
    if nextEffect then
      self.effect_txt:SetText(nextEffect.outDesc)
    else
      self.effect_txt:SetText("")
    end
    self.normalUnlockable:Stop()
    self.mainUnlockable:Stop()
    self.compProgressReal:SetFillAmount(self.progressValue[nextStar])
    local newPosX = self.originLvHighLightPosX + (nextStar - 1) * self.lvHighLightPosDeltaX
    local targetFlag
    if self.mainLvDic[nextStar] then
      targetFlag = self.mainUnlockable
      self.bgHighLight:SetActive(true)
    else
      targetFlag = self.normalUnlockable
      self.bgHighLight:SetActive(false)
    end
    local originPos = targetFlag:GetLocalPosition()
    originPos.x = newPosX
    targetFlag:SetLocalPosition(originPos)
    targetFlag:Replay()
    local arrowPos = self.compLvArrow:GetLocalPosition()
    arrowPos.x = newPosX
    self.compLvArrow:SetLocalPosition(arrowPos)
    for k, v in pairs(self.mainLvDic) do
      if nextStar < k then
        v:SetColorRGBA255(88, 144, 207, 255)
      else
        v:SetColorRGBA255(8, 8, 8, 255)
      end
    end
    if not self.targetChipInfo then
      self.targetChipInfo = TWSkillChipInfo.New()
    end
    self.targetChipInfo:CreateFromTemplate(self.chipInfo:GetId(), self.chipInfo:GetLevel(), nextStar)
    self.dst_chip_item:SetData(self.targetChipInfo)
    self.commonFragId, self.fragId, self.costFragCount = self.chipInfo:GetStarUpCost()
    if not self.fragId then
      return
    end
    self.haveFragCount = TacticalWeaponUtils.GetChipUseableCount(self.chipInfo)
    if not self.sameChipTempalte then
      self.sameChipTempalte = TWSkillChipInfo.New()
    end
    self.sameChipTempalte:CreateFromTemplate(self.chipInfo:GetId(), 1, 0)
    self.right_cost:SetActive(true)
    self.right_same_cost_chip_item:SetData(self.sameChipTempalte)
    self.commonHeroFragCount = 0
    self.src_power_number_text:SetText(self.chipInfo:GetPowerV2())
    self.dst_power_number_text:SetText(self.targetChipInfo:GetPowerV2())
    if self.haveFragCount >= self.costFragCount then
      self.left_cost:SetActive(false)
      self.right_cost_num_text:SetText(string.format("<color=#5FEF87>%d</color>/%d", self.haveFragCount, self.costFragCount))
    elseif self.commonFragId and self.canUseCommonItem == true then
      self.commonHeroFragCount = DataCenter.ItemData:GetItemCount(self.commonFragId)
      local count = self.costFragCount - self.haveFragCount
      local colour = count <= self.commonHeroFragCount and "<color=#5FEF87>%d</color>/%d" or "<color=#F97077>%d</color>/%d"
      self.left_same_cost_chip_item:SetActive(self.haveFragCount > 0)
      self.left_same_cost_chip_item:SetData(self.sameChipTempalte)
      self.left_common_chip_item:SetActive(true)
      if self.tempItemData == nil then
        self.tempItemData = {}
      end
      self.tempItemData.itemId = self.commonFragId
      self.tempItemData.rewardType = RewardType.GOODS
      self.left_common_chip_item:ReInit(self.tempItemData)
      self.left_common_cost_num_text:SetText(string.format(colour, self.commonHeroFragCount, count))
      self.left_same_cost_num_text:SetText(string.format("<color=#5FEF87>%d</color>/%d", self.haveFragCount, self.haveFragCount))
      self.right_cost_num_text:SetText(string.format("<color=#F97077>%d</color>/%d", self.haveFragCount, self.costFragCount))
      self.left_cost:SetActive(true)
    else
      self.left_cost:SetActive(false)
      self.right_cost_num_text:SetText(string.format("<color=#F97077>%d</color>/%d", self.haveFragCount, self.costFragCount))
    end
  end
end

function UILWTWSkillStarUpView:OnDescClick(eventData)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkId = self.skill_desc_text:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = UIUtil.GetString("", linkId)
  param.screenPos = clickPos
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function UILWTWSkillStarUpView:PlayVXDianLiuSound()
  self:StopVXDianLiuSound()
  self.playingVXDianLiuSoundId = DataCenter.LWSoundManager:PlaySound(62280, false)
end

function UILWTWSkillStarUpView:StopVXDianLiuSound()
  if self.playingVXDianLiuSoundId then
    DataCenter.LWSoundManager:StopSound(self.playingVXDianLiuSoundId)
    self.playingVXDianLiuSoundId = nil
  end
end

UILWTWSkillStarUpView.OnCreate = OnCreate
UILWTWSkillStarUpView.OnDestroy = OnDestroy
UILWTWSkillStarUpView.OnEnable = OnEnable
UILWTWSkillStarUpView.OnDisable = OnDisable
UILWTWSkillStarUpView.OnAddListener = OnAddListener
UILWTWSkillStarUpView.OnRemoveListener = OnRemoveListener
UILWTWSkillStarUpView.ComponentDefine = ComponentDefine
UILWTWSkillStarUpView.DataDefine = DataDefine
UILWTWSkillStarUpView.ComponentDestroy = ComponentDestroy
UILWTWSkillStarUpView.DataDestroy = DataDestroy
UILWTWSkillStarUpView.OnOpen = OnOpen
UILWTWSkillStarUpView.UpdateView = UpdateView
UILWTWSkillStarUpView.OnChipStarUp = OnChipStarUp
return UILWTWSkillStarUpView
