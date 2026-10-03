local UIHeroSkillTipView = BaseClass("UIHeroSkillTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local MinWidth = 689
local MinHeight = 80
local MarginX = 30
local MarginY = 20
local Direction = {
  ABOVE = 1,
  BELOW = 2,
  LEFT = 3,
  RIGHT = 4
}
local ParamData = {
  skillId = "",
  skillLevel = 1,
  skillIndex = -1,
  skillUnlockQuality = 1,
  heroRarity = -1,
  heroUuid = -1,
  dir = Direction.ABOVE,
  pivot = 0.5,
  position = Vector2.zero
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  local param = self:GetUserData()
  self.param = param
  self.isSend = false
  self:RefreshView()
  self:PlayShowAnimation()
end

local function RefreshView(self)
  local param = self.param
  local dir = param.dir
  local pivot = param.pivot
  local defWidth = param.defWidth
  local skillIndex = param.skillIndex
  local notShowUnlock = param.notShowUnlock
  local rootRt = self.root.rectTransform
  local arrowRt = self.imgArrow.rectTransform
  if dir == Direction.ABOVE then
    rootRt.pivot = Vector2.New(pivot, 0)
    arrowRt.localRotation = Quaternion.Euler(0, 0, 90)
    arrowRt.anchorMin = Vector2.New(pivot, 0)
    arrowRt.anchorMax = Vector2.New(pivot, 0)
    arrowRt.anchoredPosition = Vector2.New(0, 8)
  elseif dir == Direction.BELOW then
    rootRt.pivot = Vector2.New(pivot, 1)
    arrowRt.localRotation = Quaternion.Euler(0, 0, -90)
    arrowRt.anchorMin = Vector2.New(pivot, 1)
    arrowRt.anchorMax = Vector2.New(pivot, 1)
    arrowRt.anchoredPosition = Vector2.New(0, -8)
  elseif dir == Direction.RIGHT then
    rootRt.pivot = Vector2.New(0, pivot)
    arrowRt.localRotation = Quaternion.Euler(0, 0, 0)
    arrowRt.anchorMin = Vector2.New(0, pivot)
    arrowRt.anchorMax = Vector2.New(0, pivot)
    arrowRt.anchoredPosition = Vector2.New(9, 0)
  elseif dir == Direction.LEFT then
    rootRt.pivot = Vector2.New(1, pivot)
    arrowRt.localRotation = Quaternion.Euler(0, 0, 180)
    arrowRt.anchorMin = Vector2.New(1, pivot)
    arrowRt.anchorMax = Vector2.New(1, pivot)
    arrowRt.anchoredPosition = Vector2.New(-9, 0)
  end
  local skillId, skillLevel = param.skillId, param.skillLevel
  local skillName = Localization:GetString(GetTableData(TableName.SkillTab, skillId, "name"))
  local skillType = Localization:GetString(GetTableData(TableName.SkillTab, skillId, "type_des"))
  local skillDesc, effectDesc = HeroUtils.GetSkillDescStr(skillId, skillLevel)
  self.textSkillName:SetText(skillName)
  self.textSkillType:SetText(skillType)
  local skillType2 = tonumber(GetTableData(TableName.SkillTab, skillId, "type2"))
  if skillType2 ~= 11 then
    self.textSubTitle2:SetLocalText(150166)
    self.textEffect:SetText(effectDesc)
    local preHeight = self.textEffect:GetHeight()
    self.textEffect.rectTransform:Set_sizeDelta(self.textEffect.rectTransform.sizeDelta.x, preHeight)
  end
  self.textSubTitle2:SetActive(skillType2 ~= 11)
  self.textEffect:SetActive(skillType2 ~= 11)
  local showTextUnlock = false
  self.upgrade:SetActive(false)
  if notShowUnlock ~= nil and notShowUnlock == true then
  else
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(param.heroUuid)
    if heroData ~= nil then
      local skillUpgradeFlag = heroData:IsSkillUnlock(skillId)
      self.upgrade:SetActive(skillUpgradeFlag)
      if skillUpgradeFlag then
        self:RefreshUpgradeBtn()
      end
    end
    if skillType2 ~= 11 then
      if not param.isUnlock then
        local heroLevel = self:GetSKillNextLevelHeroLv(skillIndex)
        if heroLevel ~= nil then
          showTextUnlock = true
          self.textUnlock:SetLocalText(129216, heroLevel)
        end
      end
    elseif param.heroUuid ~= nil then
      local maxRankId = heroData.config.max_rank_level
      local curRankId = heroData:GetRank()
      showTextUnlock = maxRankId > curRankId
      self.textUnlock:SetLocalText(129220)
    end
  end
  self.textUnlock:SetActive(showTextUnlock)
  self.textUnlock.rectTransform:Set_sizeDelta(rootRt.sizeDelta.x - 56, self.textUnlock:GetHeight())
  local preferredWidth = self.textEffect.rectTransform.rect.width
  rootRt:Set_sizeDelta(math.max(MinWidth, preferredWidth + 56), rootRt.sizeDelta.y)
  self.textSkillDesc.rectTransform:Set_sizeDelta(rootRt.sizeDelta.x - 56, 0)
  self.textSkillDesc:SetText(skillDesc)
  local descHeight = self.textSkillDesc:GetHeight()
  self.textSkillDesc.rectTransform:Set_sizeDelta(rootRt.sizeDelta.x - 56, descHeight)
  rootRt.position = param.position
  if self.sizeFitter then
    self.sizeFitter.enabled = false
    self.sizeFitter.enabled = true
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rootRt)
  local rootPreHeight = self.layoutGroup.preferredHeight
  rootRt:Set_sizeDelta(math.max(MinWidth, preferredWidth + 56), rootPreHeight)
end

local function OnSkillDataChange(self)
  self.isSend = false
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.heroUuid)
  if heroData then
    local skillLevel = heroData:GetSkillLevel(self.param.skillId)
    self.param.skillLevel = skillLevel
  end
  self:RefreshView()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillAdvanceSuccess, self.param.heroUuid, self.param.skillId)
end

local function RefreshUpgradeBtn(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.heroUuid)
  self.upgradeBtn:SetActive(false)
  self.skillLevelText:SetActive(false)
  self.getMoreBtn:SetActive(false)
  self.medal:SetActive(false)
  self.skillMax:SetActive(false)
  if heroData ~= nil then
    if heroData:IsSkillCanUpgrade(self.param.skillId) then
      self.medal:SetActive(true)
      self.skillLevelText:SetActive(true)
      self.skillLevelText:SetLocalText(129252)
      self.skillLevelCurrentText:SetText(self.param.skillLevel)
      self.skillLevelNextText:SetText(self.param.skillLevel + 1)
      local costMedalId, costItemNum = HeroUtils.GetSkillUpgradeItemAndNum(heroData.heroId, self.param.skillLevel)
      local num = DataCenter.ItemData:GetItemCount(costMedalId)
      self.medalNumText:SetText(costItemNum)
      self.medalIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(costMedalId))
      local itemEnough = costItemNum <= num
      if itemEnough then
        self.upgradeBtn:SetActive(true)
        self.medalNumText:SetColor(WhiteColor)
      else
        self.getMoreBtn:SetActive(true)
        self.medalNumText:SetColor(RedColor)
      end
    else
      local max = heroData:IsSkillMax(self.param.skillId)
      if max then
        self.skillMax:SetActive(true)
      end
    end
  end
end

local function OnDestroy(self)
  self.isSend = false
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.sizeFitter = self.root.rectTransform:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
  self.layoutGroup = self.root.rectTransform:GetComponent(typeof(CS.UnityEngine.UI.VerticalLayoutGroup))
  self.imgArrow = self:AddComponent(UIImage, "Root/ImgArrow")
  self.textSkillName = self:AddComponent(UIText, "Root/TextSkillName")
  self.textSkillType = self:AddComponent(UIText, "Root/TextSkillType")
  self.textSkillDesc = self:AddComponent(UIText, "Root/TextSkillDesc")
  self.textSubTitle2 = self:AddComponent(UIText, "Root/TextSubTitle2")
  self.textEffect = self:AddComponent(UIText, "Root/TextEffect")
  self.textUnlock = self:AddComponent(UIText, "Root/TextUnlock")
  self.upgrade = self:AddComponent(UIBaseContainer, "Root/Upgrade")
  self.upgradeBtn = self:AddComponent(UIButton, "Root/Upgrade/UpgradeBtn")
  self.upgradeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUpgradeClick()
  end)
  self.upgradeTxt = self:AddComponent(UIText, "Root/Upgrade/UpgradeBtn/UpgradeBtnText")
  self.upgradeTxt:SetLocalText(100091)
  self.skillLevelText = self:AddComponent(UIText, "Root/Upgrade/SkillLevelText")
  self.skillLevelCurrentText = self:AddComponent(UIText, "Root/Upgrade/SkillLevelText/CurLevelText")
  self.skillLevelNextText = self:AddComponent(UIText, "Root/Upgrade/SkillLevelText/CurLevelText/Common_btn_arrow/NextLevelText")
  self.getMoreBtn = self:AddComponent(UIButton, "Root/Upgrade/GetMoreBtn")
  self.getMoreBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnGetMoreClick()
  end)
  self.getMoreTxt = self:AddComponent(UIText, "Root/Upgrade/GetMoreBtn/GetMoreBtnText")
  self.getMoreTxt:SetLocalText(129253)
  self.medal = self:AddComponent(UIBaseContainer, "Root/Upgrade/SkillMedal")
  self.medalIcon = self:AddComponent(UIImage, "Root/Upgrade/SkillMedal/SkillMedalIcon")
  self.medalNumText = self:AddComponent(UIText, "Root/Upgrade/SkillMedal/SkillMedalNumText")
  self.skillMax = self:AddComponent(UIText, "Root/Upgrade/SkillMaxText")
  self.skillMax:SetLocalText(129254)
end

local function ComponentDestroy(self)
  self.root = nil
  self.imgArrow = nil
  self.textSkillName = nil
  self.textSkillType = nil
  self.textSkillDesc = nil
  self.textSubTitle2 = nil
  self.textEffect = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.sizeFitter.enabled = false
end

local function PlayShowAnimation(self)
  local rootRt = self.root.rectTransform
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(0, 0, 0)
  local sequence = DOTween.Sequence()
  sequence:AppendInterval(0.1)
  sequence:AppendCallback(function()
  end)
  sequence:Append(rootRt:DOScale(Vector3.New(1.02, 1.02, 0), 0.05))
  sequence:Append(rootRt:DOScale(Vector3.one, 0.05))
  sequence:SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkillUpgradeEnd, self.OnSkillDataChange)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SkillUpgradeEnd, self.OnSkillDataChange)
end

local function GetSkillTypeStr(self, skillType)
  local type = tonumber(skillType)
  local key = "150163"
  if type == 1 then
    key = "150163"
  elseif type == 2 then
    key = "150164"
  elseif type == 10 or type == 11 then
    key = "150165"
  elseif type == 12 then
    key = "161015"
  elseif type == 13 then
    key = "161016"
  end
  return Localization:GetString(key)
end

local function GetSKillNextLevelHeroLv(self, skillIndex)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.heroUuid)
  if heroData ~= nil then
    local heroConfig = heroData:GetConfig()
    if heroConfig ~= nil then
      local skillArray = heroConfig.skill
      if type(skillArray) ~= "table" then
        skillArray = string.split(skillArray, "|")
      end
      if skillIndex <= table.count(skillArray) then
        local skillData = heroData:GetSkillData(skillArray[skillIndex])
        return skillData.unlockHeroLv
      end
    end
  end
  return nil
end

local function OnUpgradeClick(self)
  if self.isSend == true then
    return
  end
  self.isSend = true
  SFSNetwork.SendMessage(MsgDefines.HeroSkillUpgrade, self.param.heroUuid, self.param.skillId)
end

local function OnGetMoreClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBag)
  self.ctrl:CloseSelf()
end

UIHeroSkillTipView.Param = Param
UIHeroSkillTipView.Direction = Direction
UIHeroSkillTipView.OnCreate = OnCreate
UIHeroSkillTipView.OnDestroy = OnDestroy
UIHeroSkillTipView.OnEnable = OnEnable
UIHeroSkillTipView.ComponentDefine = ComponentDefine
UIHeroSkillTipView.ComponentDestroy = ComponentDestroy
UIHeroSkillTipView.PlayShowAnimation = PlayShowAnimation
UIHeroSkillTipView.GetSkillTypeStr = GetSkillTypeStr
UIHeroSkillTipView.OnUpgradeClick = OnUpgradeClick
UIHeroSkillTipView.GetSKillNextLevelHeroLv = GetSKillNextLevelHeroLv
UIHeroSkillTipView.RefreshUpgradeBtn = RefreshUpgradeBtn
UIHeroSkillTipView.OnGetMoreClick = OnGetMoreClick
UIHeroSkillTipView.OnSkillDataChange = OnSkillDataChange
UIHeroSkillTipView.RefreshView = RefreshView
UIHeroSkillTipView.OnAddListener = OnAddListener
UIHeroSkillTipView.OnRemoveListener = OnRemoveListener
return UIHeroSkillTipView
