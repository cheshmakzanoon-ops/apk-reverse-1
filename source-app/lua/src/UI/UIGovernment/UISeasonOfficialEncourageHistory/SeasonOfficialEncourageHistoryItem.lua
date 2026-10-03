local SeasonOfficialEncourageHistoryItem = BaseClass("SeasonOfficialEncourageHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local effect_desc_path = "desc/EffectDesc"
local time_path = "desc/Time"
local LANG_KEY = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_26",
  [GovOfficialType.Center] = "supreme_president_ui_23",
  [GovOfficialType.Destroyer] = "season_s6_zone_government_1"
}

function SeasonOfficialEncourageHistoryItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc = self:AddComponent(UIText, effect_desc_path)
  self.time = self:AddComponent(UIText, time_path)
end

function SeasonOfficialEncourageHistoryItem:OnDestroy()
  base.OnDestroy(self)
end

function SeasonOfficialEncourageHistoryItem:OnEnable()
  base.OnEnable(self)
end

function SeasonOfficialEncourageHistoryItem:OnDisable()
  base.OnDisable(self)
end

function SeasonOfficialEncourageHistoryItem:ReInit(index, data, kingName, govOfficialType)
  local configData = DataCenter.WonderGiftTemplateManager:GetTemplate(data.presentId)
  local iconList = {
    "huang",
    "zi",
    "lan",
    "lv"
  }
  local iconPath = string.format("Assets/Main/Sprites/UI/UIGovernment/Sprites/zyf_wangzhuozhan_guohuijiangli_%ssebaoxiang.png", iconList[configData.type])
  self.icon:LoadSprite(iconPath)
  self.icon:SetNativeSize()
  self.desc:SetLocalText(LANG_KEY[govOfficialType], kingName, data:GetPlayerName(data.toUid), Localization:GetString(configData.name))
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.sendTime))
end

return SeasonOfficialEncourageHistoryItem
