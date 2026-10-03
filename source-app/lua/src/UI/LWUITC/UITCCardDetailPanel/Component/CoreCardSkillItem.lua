local CoreCardSkillItem = BaseClass("CoreCardSkillItem", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI.UILWScience.UILWScienceDetail.Component.UILWScienceDetailDesc")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, "head/name/content/name_txt")
  self.nextLv_txt = self:AddComponent(UITextMeshProUGUIEx, "head/name/content/ValueContainer/nextLv_txt")
  self.cdName_txt = self:AddComponent(UITextMeshProUGUIEx, "head/cd/content/cdName_txt")
  self.curCd_txt = self:AddComponent(UITextMeshProUGUIEx, "head/cd/content/ValueContainer/curCd_txt")
  self.cdArrow_icon = self:AddComponent(UIImage, "head/cd/content/ValueContainer/cdArrow_icon")
  self.nextCd_txt = self:AddComponent(UITextMeshProUGUIEx, "head/cd/content/ValueContainer/nextCd_txt")
  self.desc_txt = self:AddComponent(UILWScienceDetailDesc, "desc_txt")
  self.cd = self:AddComponent(UIBaseComponent, "head/cd")
  self.icon = self:AddComponent(UIImage, "head/icon")
  self.bg = self:AddComponent(UIImage, "bg")
  self.layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "")
end

local function ComponentDestroy(self)
  self.name_txt = nil
  self.nextLv_txt = nil
  self.cdName_txt = nil
  self.curCd_txt = nil
  self.cdArrow_icon = nil
  self.nextCd_txt = nil
  self.desc_txt = nil
  self.cd = nil
end

function CoreCardSkillItem:UpdateSkill(skillId, nextSkillId, showBg, cardData)
  self.skillId = skillId
  self.nextSkillId = nextSkillId
  if not self.skillId and self.nextSkillId then
    self.skillId = self.nextSkillId
    self.nextSkillId = nil
  end
  self.showBg = showBg
  self.cardData = cardData
  self:RefreshView()
end

function CoreCardSkillItem:UpdateData()
  if not self.skillId then
    return
  end
  local skillData = DataCenter.TacticalCardDataManager:GetSkillTemplateData(self.skillId)
  if not skillData then
    return
  end
  local icon = skillData:GetIcon()
  if icon then
    self.icon:LoadSpriteAuto(icon)
    self.icon:SetActive(true)
  else
    self.icon:SetActive(false)
  end
  self.skillData = skillData
  self.name_txt:SetLocalText(skillData.name)
  local cdDesc = skillData:GetCDDesc()
  if string.IsNullOrEmpty(cdDesc) then
    self.cdName_txt:SetLocalText("battle_card_cd_type3")
    self.curCd_txt:SetText("")
  else
    self.cdName_txt:SetText(cdDesc)
    local curCDPara = skillData:GetCDViewPara()
    self.curCd_txt:SetText(curCDPara)
  end
  local showNextCd = false
  local showNextLv = false
  if self.nextSkillId then
    if skillData:IsMaxLv() then
      self.nextCd_txt:SetActive(false)
      self.cdArrow_icon:SetActive(false)
    else
      local nextLvSkillData = DataCenter.TacticalCardDataManager:GetSkillTemplateData(self.nextSkillId)
      if nextLvSkillData then
        local nextCDPara = nextLvSkillData:GetCDViewPara()
        if not string.IsNullOrEmpty(nextCDPara) and nextCDPara ~= curCDPara then
          self.nextCd_txt:SetText(nextCDPara)
          showNextCd = true
        end
      end
    end
  end
  if self.cardData and self.cardData:IsUseNewSkillDesc() then
    if self.nextSkillId then
      local skillDesc = self.cardData:GetBaseSkillUpgradeDesc()
      if not string.IsNullOrEmpty(skillDesc) then
        self.desc_txt:SetText(skillDesc)
      end
    else
      local skillDesc = self.cardData:GetBaseSkillDesc()
      if not string.IsNullOrEmpty(skillDesc) then
        self.desc_txt:SetText(skillDesc)
      end
    end
  elseif self.nextSkillId then
    self.desc_txt:SetText(skillData:GetUpgradeDesc(self.nextSkillId))
  else
    self.desc_txt:SetText(skillData:GetDesc())
  end
  if showNextCd then
    self.nextCd_txt:SetActive(true)
    self.cdArrow_icon:SetActive(true)
  else
    self.nextCd_txt:SetActive(false)
    self.cdArrow_icon:SetActive(false)
  end
  if self.showBg then
    self.bg:SetActive(true)
    self.layout:SetPaddingLeft(15)
    self.layout:SetPaddingTop(12)
    self.desc_txt:SetSizeDeltaXY(670, 0)
  else
    self.bg:SetActive(false)
    self.layout:SetPaddingLeft(0)
    self.layout:SetPaddingTop(0)
    self.desc_txt:SetSizeDeltaXY(685, 0)
  end
end

CoreCardSkillItem.OnCreate = OnCreate
CoreCardSkillItem.OnDestroy = OnDestroy
CoreCardSkillItem.ComponentDefine = ComponentDefine
CoreCardSkillItem.ComponentDestroy = ComponentDestroy
return CoreCardSkillItem
