local img_icon_path = "GoReinforcement/img_kuang/img_icon"
local txt_name_path = "GoReinforcement/txt_Name"
local pro_blue_path = "GoReinforcement/pro_bg/pro_blue"
local pro_gray_path = "GoReinforcement/pro_bg/pro_gray"
local pro_blue_info_path = "GoCityInfo/pro_bg/pro_blueInfo"
local progress_text_path = "GoCityInfo/pro_bg/pro_blueInfo/ProgressText"
local prefab_path = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/AllianceSkillReinforcementHud.prefab"
local ResourceManager = CS.GameEntry.Resource
local base = UIBaseContainer
local AllianceSkillReinforcementHud = BaseClass("AllianceSkillReinforcementHud", UIBaseContainer)

function AllianceSkillReinforcementHud:ComponentDefine()
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.pro_blue = self:AddComponent(UISlider, pro_blue_path)
  self.pro_gray = self:AddComponent(UISlider, pro_gray_path)
  self.pro_blue_info = self:AddComponent(UISlider, pro_blue_info_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
end

function AllianceSkillReinforcementHud:ComponentDestroy()
  self.img_icon = nil
  self.txt_name = nil
  self.pro_blue = nil
  self.pro_gray = nil
  self.pro_blue_info = nil
  self.progress_text = nil
end

function AllianceSkillReinforcementHud:DataDefine()
end

function AllianceSkillReinforcementHud:DataDestroy()
end

function AllianceSkillReinforcementHud:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceSkillReinforcementHud:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceSkillReinforcementHud:OnAddListener()
  base.OnAddListener(self)
end

function AllianceSkillReinforcementHud:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceSkillReinforcementHud:__init(transform, serverId)
  local request = ResourceManager:InstantiateAsync(prefab_path)
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or transform == nil or theWorld == nil or IsNull(transform) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(transform)
    local hasHpCode = transform:Find("HpLod/HpNode")
    if not IsNull(hasHpCode) and hasHpCode.gameObject.activeSelf then
      go.transform:Set_localPosition(0, 1.5, 0)
    else
      go.transform:Set_localPosition(0, 0.7, 0)
    end
    go.transform:Set_localRotation(0, 0, 0, 1)
    go.transform:Set_localScale(0.006, 0.006, 0.006)
    base.Reinit(self, go, "")
    self.initActiveSelf = true
    self:OnCreate()
    self:OnEnable()
    self:SetLod(theWorld:GetLodLevel())
    self:UpdateUi()
  end)
  self.lodCache = 0
  self.request = request
end

function AllianceSkillReinforcementHud:__delete()
  if self.gameObject ~= nil then
    self:OnDisable()
    self:OnDestroy()
  else
    self.holder = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
end

function AllianceSkillReinforcementHud:ReInit(data, extraInfo)
  self.Data = data
  self.CityId = checknumber(data.id)
  self.CityType = checknumber(self.Data.type)
  self.ExtraInfo = extraInfo
  self.ShieldInfo = extraInfo.shieldInfo
end

function AllianceSkillReinforcementHud:UpdateUi()
  if IsNull(self.img_icon) or not self.ShieldInfo then
    return
  end
  local allianceCity = self.ShieldInfo.allianceCity
  if allianceCity.skillId then
    local skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(allianceCity.skillId)
    if skillConfig then
      self.img_icon:LoadSprite(skillConfig.skill_icon)
    end
  end
  local reinforcementStr = CS.GameEntry.Localization:GetString("season_s6_government_skill_desc81", self.ShieldInfo.shieldValue, self.ShieldInfo.shieldMaxValue)
  self.txt_name:SetText(reinforcementStr)
  local shieldValue = self.ShieldInfo.shieldValue / self.ShieldInfo.shieldMaxValue
  self.pro_blue:SetValue(shieldValue)
  local contributionValue = self.ShieldInfo.totalContribution / self.ShieldInfo.shieldMaxValue
  self.pro_gray:SetValue(contributionValue)
  local durability = self.ExtraInfo.durability
  self.pro_blue_info:SetValue(durability / self.ShieldInfo.shieldMaxValue)
  self.progress_text:SetText(durability .. "/" .. self.ShieldInfo.shieldMaxValue)
end

function AllianceSkillReinforcementHud:SetLod(lod)
  self.lodCache = checknumber(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

return AllianceSkillReinforcementHud
