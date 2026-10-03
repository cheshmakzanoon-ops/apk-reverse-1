local base = UIBaseView
local MailScoutFormationDetailView = BaseClass("MailScoutFormationDetailView", base)
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local title_txt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local groupTitle_txt_path = "Root/scroll/viewport/content/group/groupTitle/groupTitle_txt"
local power_txt_path = "Root/scroll/viewport/content/group/groupTitle/power_info/RealPower"
local power_info_path = "Root/scroll/viewport/content/group/groupTitle/power_info"
local group_path = "Root/scroll/viewport/content/group"
local panelClose_btn_path = "UICommonPopUpTitle/panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.formation, self.displayType, self.isDisturbed = self:GetUserData()
  if not self.formation then
    self.ctrl:CloseSelf()
    return
  end
  self:OnOpen()
end

local function OnDestroy(self)
  self:HideLines()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.groupTitle_txt = self:AddComponent(UIText, groupTitle_txt_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.power_info = self:AddComponent(UIBaseContainer, power_info_path)
  self.group = self:AddComponent(UIBaseContainer, group_path)
  self.panelClose_btn = self:AddComponent(UIButton, panelClose_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelClose_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.title_txt = nil
  self.groupTitle_txt = nil
  self.power_txt = nil
  self.power_info = nil
  self.group = nil
  self.panelClose_btn = nil
end

local function DataDefine(self)
  self.requests = {}
end

local function DataDestroy(self)
end

local function GetFormationEquipPower(self)
  if not self.formation then
    return 0
  end
  local totalPower = 0
  for i = 1, #self.formation.hero do
    local heroData = self.formation.hero[i]
    totalPower = totalPower + (heroData.equipPower or 0)
  end
  return totalPower
end

local function GetFormationSkillPower(self)
  if not self.formation then
    return 0
  end
  local totalPower = 0
  for i = 1, #self.formation.hero do
    local heroData = self.formation.hero[i]
    totalPower = totalPower + (heroData.skillPower or 0)
  end
  return totalPower
end

local function GetUniqueWepaonPower(self)
  if not self.formation then
    return 0
  end
  local totalPower = 0
  for i = 1, #self.formation.hero do
    local heroData = self.formation.hero[i]
    totalPower = totalPower + (heroData.weaponPower or 0)
  end
  return totalPower
end

local LINE1_PATH = "Assets/Main/Prefabs/UI/LWMail/MailScout/ScoutFormationDetailLine1.prefab"
local LINE1_CLS = require("UI.MailScoutFormationDetail.Component.GroupDetailLine1")
local LINE2_PATH = "Assets/Main/Prefabs/UI/LWMail/MailScout/ScoutFormationDetailLine2.prefab"
local LINE2_CLS = require("UI.MailScoutFormationDetail.Component.GroupDetailLine2")
local DISPLAY_TYPES = {
  [1] = {
    name = "scout_report_panel_name_4",
    prefabPath = LINE1_PATH,
    cls = LINE1_CLS,
    getPowerFunc = GetFormationEquipPower
  },
  [2] = {
    name = "scout_report_panel_name_5",
    prefabPath = LINE1_PATH,
    cls = LINE1_CLS,
    getPowerFunc = GetFormationSkillPower
  },
  [3] = {
    name = "scout_report_panel_name_6",
    prefabPath = LINE2_PATH,
    cls = LINE2_CLS,
    getPowerFunc = GetUniqueWepaonPower
  }
}

local function CreateShowData(self)
  local datas = {}
  local heroes = self.formation.hero
  if self.displayType == 1 then
    for i = 1, #heroes do
      local heroData = heroes[i]
      local equipMap = {}
      if not self.isDisturbed then
        local heroEquips = heroData.equipInfos
        local hasEquip = false
        for j = 1, #heroEquips do
          local equip = heroEquips[j]
          local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(equip.equipId)
          if equipTemplate then
            equipMap[equipTemplate.slot] = equip
            hasEquip = true
          end
        end
        if hasEquip then
          datas[#datas + 1] = {
            type = self.displayType,
            heroData = heroData,
            lineDatas = equipMap
          }
        end
      else
        datas[#datas + 1] = {
          type = self.displayType,
          heroData = heroData,
          lineDatas = equipMap,
          isHide = true
        }
      end
    end
  elseif self.displayType == 2 then
    for i = 1, #heroes do
      local heroData = heroes[i]
      local heroInfo = heroData.heroInfo
      if heroInfo then
        local heroSkills = heroInfo.skillList
        datas[#datas + 1] = {
          type = self.displayType,
          heroData = heroData,
          lineDatas = heroSkills,
          isHide = self.isDisturbed
        }
      end
    end
  elseif self.displayType == 3 then
    datas[1] = {}
    for i = 1, #heroes do
      local heroData = heroes[i]
      local heroInfo = heroData.heroInfo
      if heroInfo then
        local lv = heroInfo:GetUniqueWeaponLv()
        if 0 < lv then
          datas[1][#datas[1] + 1] = heroData
        end
      end
    end
  end
  return datas
end

local function OnOpen(self)
  local config = DISPLAY_TYPES[self.displayType]
  local name = ""
  if config then
    name = config.name
  end
  self.groupTitle_txt:SetLocalText(name)
  local power = 0
  if config then
    power = config.getPowerFunc(self)
  end
  self.power_txt:SetText(string.GetFormattedStr(math.floor(power)))
  self.showDatas = CreateShowData(self)
  self:ShowLines()
end

local function ShowLines(self)
  local config = DISPLAY_TYPES[self.displayType]
  if not config then
    return
  end
  local prefabPath = config.prefabPath
  local cls = config.cls
  for i = 1, #self.showDatas do
    local data = self.showDatas[i]
    local request = self:GameObjectInstantiateAsync(prefabPath, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local transform = obj.transform
      transform:SetParent(self.group.transform)
      transform:Set_localPosition(0, 0, 0)
      transform:Set_localScale(1, 1, 1)
      local nameStr = "Line" .. i
      obj.name = nameStr
      local comp = self:AddComponent(cls, group_path .. "/" .. nameStr)
      comp:SetData(data)
      comp:SetActive(true)
      comp:SetBottomLineActive(i ~= #self.showDatas)
    end)
    self.requests[i] = request
  end
end

local function HideLines(self)
  self:RemoveComponents(LINE1_CLS)
  self:RemoveComponents(LINE2_CLS)
  for i = 1, #self.requests do
    self:GameObjectDestroy(self.requests[i])
  end
  self.requests = {}
end

MailScoutFormationDetailView.OnCreate = OnCreate
MailScoutFormationDetailView.OnDestroy = OnDestroy
MailScoutFormationDetailView.OnEnable = OnEnable
MailScoutFormationDetailView.OnDisable = OnDisable
MailScoutFormationDetailView.ComponentDefine = ComponentDefine
MailScoutFormationDetailView.ComponentDestroy = ComponentDestroy
MailScoutFormationDetailView.DataDefine = DataDefine
MailScoutFormationDetailView.DataDestroy = DataDestroy
MailScoutFormationDetailView.OnOpen = OnOpen
MailScoutFormationDetailView.ShowLines = ShowLines
MailScoutFormationDetailView.HideLines = HideLines
return MailScoutFormationDetailView
