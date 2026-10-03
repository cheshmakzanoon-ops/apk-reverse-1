local base = UIBaseContainer
local SkillUseHistoryItem = BaseClass("SkillUseHistoryItem", base)
local Localization = CS.GameEntry.Localization
local playerHead_path = "UIPlayerHead"
local descTxt_path = "Txt_Des"
local timeTxt_path = "Txt_Time"
local titleTxt_path = "Txt_Title"
local skill_icon2_path = "showType2/mask/skillIcon2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.playerHeadComponent = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHeadComponent:SetEnableClickShowInfo(true, true)
  self.skill_icon2 = self:AddComponent(UIImage, skill_icon2_path)
end

local function ComponentDestroy(self)
  self.playerHead = nil
  self.descTxt = nil
  self.timeTxt = nil
  self.titleTxt = nil
  self.playerHeadComponent = nil
  self.skill_icon2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SkillUseHistoryItem:RefreshView(index, data)
  if data == nil then
    return
  end
  self.data = data
  local userInfo = data
  local name = ""
  local isAnonymous = data.anonymous == 1
  if not isAnonymous then
    name = UIUtil.FormatServerAllianceName(userInfo.serverId, userInfo.abbr, userInfo.name)
  else
    name = Localization:GetString("390810")
  end
  userInfo.isActiveAnonymity = isAnonymous
  local isBlock = ChatManager2:GetInstance().Restrict:isInRestrictList(userInfo.uid, RestrictType.BLOCK)
  if isBlock then
    name = Localization:GetString("390810")
    userInfo.isActiveAnonymity = true
  end
  self.playerHeadComponent:SetEnableClickShowInfo(data.anonymous ~= 1)
  self.playerHeadComponent:ParseHeadInfo(userInfo)
  self.titleTxt:SetText(name)
  self.timeTxt:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time, false))
  local skillId = self.data.skillId
  local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(skillId)
  if skillTemp then
    self.descTxt:SetLocalText(skillTemp.name)
    self.skill_icon2:SetActive(true)
    self.skill_icon2:LoadSprite(skillTemp:GetIconFullPath())
  else
    self.descTxt:SetText("")
    self.skill_icon2:SetActive(false)
  end
end

SkillUseHistoryItem.OnCreate = OnCreate
SkillUseHistoryItem.OnDestroy = OnDestroy
SkillUseHistoryItem.OnEnable = OnEnable
SkillUseHistoryItem.OnDisable = OnDisable
SkillUseHistoryItem.ComponentDefine = ComponentDefine
SkillUseHistoryItem.ComponentDestroy = ComponentDestroy
SkillUseHistoryItem.DataDefine = DataDefine
SkillUseHistoryItem.DataDestroy = DataDestroy
return SkillUseHistoryItem
