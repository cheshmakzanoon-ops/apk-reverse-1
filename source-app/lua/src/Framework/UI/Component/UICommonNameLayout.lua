local UICommonNameLayout = BaseClass("UICommonNameLayout", UIBaseContainer)
local base = UIBaseContainer
local _cp_namelable = "Line/NameText"
local _cp_nameTransform = "Line"
local _cp_careerLabel = "Line/UICareerLabel"
local _cp_allianceOfficialPos = "Line/UIAlOfficialPos"
local _cp_allianceOfficialPosName = "Line/UIAlOfficialPos/Root/Name"
local _cp_gender = "Line/Gender"
local _cp_gender_Man = "Line/Gender/Man"
local _cp_gender_Woman = "Line/Gender/Woman"
local _cp_sender_lv_path = "Line/SenderLv"
local _cp_lv_path = "Line/SenderLv/lv"
local government_path = "Line/Government"
local government_icon_path = "Line/Government/icon"

function UICommonNameLayout:ComponentDefine()
  self._nameLable = self:AddComponent(UIText, _cp_namelable)
  self._nameTransform = self:AddComponent(UIBaseContainer, _cp_nameTransform)
  self._careerLabel = self:AddComponent(UICareerLabel, _cp_careerLabel)
  self._alOfficialPos = self:AddComponent(UIBaseContainer, _cp_allianceOfficialPos)
  self._alOfficialPosNameText = self:AddComponent(UIText, _cp_allianceOfficialPosName)
  self._gender = self.transform:Find(_cp_gender)
  if self._gender then
    self._gender = self._gender.gameObject
    self._gender_Man = self.transform:Find(_cp_gender_Man).gameObject
    self._gender_Woman = self.transform:Find(_cp_gender_Woman).gameObject
  end
  self.sender_lv_root = self:AddComponent(UIBaseContainer, _cp_sender_lv_path)
  self.sender_lv = self:AddComponent(UIText, _cp_lv_path)
  self.government_root = self:AddComponent(UIBaseContainer, government_path)
  self.government_icon = self:AddComponent(UIImage, government_icon_path)
end

function UICommonNameLayout:ComponentDestroy()
  self._nameLable = nil
  self._nameTransform = nil
  self._careerLabel = nil
  self._alOfficialPos = nil
  self._gender = nil
  self._gender_Man = nil
  self._gender_Woman = nil
  self.sender_lv_root = nil
  self.sender_lv = nil
  self.government_root = nil
  self.government_icon = nil
end

function UICommonNameLayout:DataDefine()
end

function UICommonNameLayout:DataDestroy()
end

function UICommonNameLayout:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICommonNameLayout:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UICommonNameLayout:OnEnable()
  base.OnEnable(self)
end

function UICommonNameLayout:OnDisable()
  base.OnDisable(self)
end

function UICommonNameLayout:OnAddListener()
end

function UICommonNameLayout:OnRemoveListener()
end

function UICommonNameLayout:SetData(name, allianceBr, gender, officialPositionId, playerLevel, officialPos, serverId)
  local nameStr = ""
  if not string.IsNullOrEmpty(allianceBr) then
    nameStr = string.format("[%s]%s", allianceBr, name)
  else
    nameStr = name
  end
  if not string.IsNullOrEmpty(serverId) then
    nameStr = string.format("#%s %s", serverId, nameStr)
  end
  self._nameLable:SetText(nameStr)
  if gender then
    self._gender:SetActive(true)
    local isMan = gender == 1
    self._gender_Man:SetActive(isMan)
    self._gender_Woman:SetActive(not isMan)
  else
    self._gender:SetActive(false)
  end
  if officialPositionId ~= nil then
    local configData = DataCenter.GovernmentTemplateManager:GetTemplate(officialPositionId)
    if configData == nil then
      self.government_root:SetActive(false)
    else
      self.government_root:SetActive(true)
      self.government_icon:LoadSprite(configData.icon)
    end
  else
    self.government_root:SetActive(false)
  end
  if officialPos then
    self._alOfficialPos:SetActive(true)
    self._alOfficialPosNameText:SetLocalText(AllianceOfficialPosConf[officialPos].name)
  else
    self._alOfficialPos:SetActive(false)
  end
  if playerLevel ~= nil then
    self.sender_lv_root:SetActive(true)
    self.sender_lv:SetText("Lv." .. playerLevel)
  else
    self.sender_lv_root:SetActive(false)
  end
end

return UICommonNameLayout
