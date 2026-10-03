local UILWSeason4MilitaryCenterWork = BaseClass("UILWSeason4MilitaryCenterWork", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local WorkItem = require("UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.Component.UILWSeason4MilitaryCenterWorkItem")
local build_icon_path = "TargetItem/buildIcon"
local buff_btn_path = "TargetItem/buffBtn"
local title_path = "TargetItem/title"
local speed_now_path = "TargetItem/speedNow"
local speed_now_value_path = "TargetItem/speedNow/speedNowValue"
local speed_all_path = "TargetItem/speedAll"
local speed_all_value_path = "TargetItem/speedAll/speedAllValue"
local cell_path = "Cell"
local power_count_txt_path = "TargetItem/powerCountTxt"
local player_count_txt_path = "TargetItem/playerCountTxt"
local desc_path = "TargetItem/desc"
local icon_power_path = "TargetItem/powerCountTxt/iconPower"
local power_speed_path = "TargetItem/power_speed"
local power_excel_path = "TargetItem/Power_excel"
local input_pointer_path = "TargetItem/Power_excel/InputPointer"
local btn_player_count_path = "TargetItem/btnPlayerCount"
local btn_speed_path = "TargetItem/btnSpeed"
local icon_alliance_path = "TargetItem/iconAlliance"

function UILWSeason4MilitaryCenterWork:OnCreate()
  base.OnCreate(self)
  self.icon_alliance = self:AddComponent(UIImage, icon_alliance_path)
  self.build_icon = self:AddComponent(UIButton, build_icon_path)
  self.buff_btn = self:AddComponent(UIButton, buff_btn_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.power_count_txt = self:AddComponent(UITextMeshProUGUIEx, power_count_txt_path)
  self.player_count_txt = self:AddComponent(UITextMeshProUGUIEx, player_count_txt_path)
  self.icon_power = self:AddComponent(UIButton, icon_power_path)
  self.speed_now = self:AddComponent(UITextMeshProUGUIEx, speed_now_path)
  self.speed_now_value = self:AddComponent(UITextMeshProUGUIEx, speed_now_value_path)
  self.speed_all = self:AddComponent(UITextMeshProUGUIEx, speed_all_path)
  self.speed_all_value = self:AddComponent(UITextMeshProUGUIEx, speed_all_value_path)
  self.buff_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityBuff, {anim = true})
  end)
  self.power_excel = self:AddComponent(UIButton, power_excel_path)
  self.power_speed = self:AddComponent(UITextMeshProUGUIEx, power_speed_path)
  self.input_pointer = self:AddComponent(UIImage, input_pointer_path)
  self.build_icon:SetOnClick(function()
    if self.meta then
      UIUtil.ShowButtonTips(self.build_icon, self.meta.name, self.meta.desc, false)
    end
  end)
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.btn_player_count = self:AddComponent(UIButton, btn_player_count_path)
  self.btn_speed = self:AddComponent(UIButton, btn_speed_path)
  self.btn_speed:SetOnClick(function()
    if self.meta then
      UIUtil.ShowButtonTips(self.btn_speed, nil, "season_s4_alliance_center_tips01", false)
    end
  end)
  self.btn_player_count:SetOnClick(function()
    if self.meta then
      UIUtil.ShowButtonTips(self.btn_player_count, nil, "season_s4_alliance_center_tips02", false)
    end
  end)
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if alData ~= nil and alData.icon then
    self.icon_alliance:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, alData.icon))
  end
end

function UILWSeason4MilitaryCenterWork:OnDestroy()
  self:RemoveComponents(WorkItem)
  self.theItem:GameObjectRecycleAll()
  self.power_speed = nil
  self.icon_alliance = nil
  self.input_pointer = nil
  self.build_icon = nil
  self.buff_btn = nil
  self.title = nil
  self.power_excel = nil
  self.speed_now = nil
  self.speed_now_value = nil
  self.speed_all = nil
  self.speed_all_value = nil
  self.desc = nil
  self.power_count_txt = nil
  self.player_count_txt = nil
  self.icon_power = nil
  self.btn_player_count = nil
  self.btn_speed = nil
  base.OnDestroy(self)
end

function UILWSeason4MilitaryCenterWork:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeason4MilitaryCenterWork:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeason4MilitaryCenterWork:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  self:RemoveComponents(WorkItem)
  self.theItem:GameObjectRecycleAll()
  local build = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  if build then
    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(build.level + build.buildId)
    if template ~= nil then
      self.meta = template
      self.build_icon:LoadSprite(template:GetIconPath())
      self.title:SetLocalText(template.name)
      self.desc:SetLocalText(template.name)
      local theBuildInfos = DataCenter.AllianceMineManager.militaryCenterBuildInfos or {}
      if build.status ~= AllianceMineStatus.Normal or build:Injuried() then
        self.power_speed:SetText("+" .. UIUtil.GetMinuteSpeedStr(0))
      else
        self.power_speed:SetText(UIUtil.GetMinuteSpeedStr(template.electricity * 60))
      end
      if theBuildInfos.darknessSeason then
        self.affectedNum = toInt(theBuildInfos.darknessSeason.affectedNum)
      else
        self.affectedNum = 0
      end
      local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if baseData and baseData.curMember then
        self.player_count_txt:SetText(self.affectedNum .. "/" .. toInt(baseData.curMember))
      else
        self.player_count_txt:SetText(self.affectedNum .. "/100")
      end
      self.buff_btn:SetActive(false)
      local max_level = template.max_level
      local max_electricity = template.electricity
      for level = build.level, max_level do
        local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(level + build.buildId)
        if meta ~= nil then
          max_electricity = math.max(max_electricity, meta.electricity)
        end
      end
      self.input_pointer:SetEulerAnglesXYZ(0, 0, 90 - template.electricity / max_electricity * 180)
    end
  end
  local theAttachmentList = DataCenter.AllianceMineManager:GetAllianceCenterAttachmentList()
  if theAttachmentList ~= nil then
    local buildList = {}
    for _, theBuild in pairs(theAttachmentList) do
      buildList[theBuild.buildId] = theBuild
    end
    local BuildIds = {
      BuildingTypes.SEASON_POWER_CENTER_PLUGIN1,
      BuildingTypes.SEASON_POWER_CENTER_PLUGIN2,
      BuildingTypes.SEASON_POWER_CENTER_PLUGIN3
    }
    local goItem, theItem
    for _, buildId in ipairs(BuildIds) do
      goItem = self.theItem:GameObjectSpawn(self.transform)
      goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
      goItem:SetActive(true)
      theItem = self:AddComponent(WorkItem, goItem.name)
      theItem:ReInit(1, buildId, buildList[buildId])
    end
  end
end

return UILWSeason4MilitaryCenterWork
