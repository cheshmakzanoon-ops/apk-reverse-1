local EncourageHistoryItem = BaseClass("EncourageHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local effect_desc_path = "desc/EffectDesc"
local time_path = "desc/Time"

function EncourageHistoryItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc = self:AddComponent(UIText, effect_desc_path)
  self.time = self:AddComponent(UIText, time_path)
end

function EncourageHistoryItem:OnDestroy()
  base.OnDestroy(self)
end

function EncourageHistoryItem:OnEnable()
  base.OnEnable(self)
end

function EncourageHistoryItem:OnDisable()
  base.OnDisable(self)
end

function EncourageHistoryItem:ReInit(index, data, kingName)
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
  self.desc:SetLocalText(457071, kingName, data:GetPlayerName(data.toUid), Localization:GetString(configData.name))
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.sendTime))
end

return EncourageHistoryItem
