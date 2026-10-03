local SeasonOfficialLeaderHistoryItem = BaseClass("SeasonOfficialLeaderHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local num_txt_path = "numTxt"
local name_txt_path = "nameTxt"
local time_tip_text_path = "timeTipText"
local time_text_path = "timeText"
local player_path = "player"
local DESC_KEY = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_17",
  [GovOfficialType.Center] = "supreme_president_ui_20"
}

function SeasonOfficialLeaderHistoryItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "bg")
  self.round_text = self:AddComponent(UIText, num_txt_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.time_txt = self:AddComponent(UIText, time_text_path)
  self.time_tip_txt = self:AddComponent(UIText, time_tip_text_path)
  self.player_head_icon = self:AddComponent(UICommonHead, player_path)
  self.player_head_icon:SetEnableClickShowInfo(true, true)
  if self.transform:Find("ItemDrop") ~= nil then
    self.ItemDrop = self:AddComponent(SeasonOfficialLeaderHistoryItem, "ItemDrop")
    self.ItemDrop:SetActive(false)
  elseif self.transform:Find("drop") ~= nil then
    self.dropText = self:AddComponent(UIText, "drop")
  end
end

function SeasonOfficialLeaderHistoryItem:OnDestroy()
  base.OnDestroy(self)
end

function SeasonOfficialLeaderHistoryItem:ReInit(index, param)
  self.index = index
  self.param = param
  if self.ItemDrop then
    self.ItemDrop:SetActive(false)
  end
  self.bg:SetActive(true)
  self.round_text:SetActive(true)
  self.name_txt:SetActive(true)
  self.time_txt:SetActive(true)
  self.time_tip_txt:SetActive(true)
  local config = DataCenter.GovernmentTemplateManager:GetTemplate(self.param.positionId)
  self.round_text:SetLocalText(DESC_KEY[config.type] or "", index)
  if self.param.uid ~= nil and self.param.uid ~= "" then
    self.player_head_icon:SetActive(true)
    self.name_txt:SetText(UIUtil.FormatServerAllianceName(self.param.serverId, self.param.abbr, self.param.name, self.param.uid))
    self.player_head_icon:SetHead(self.param.uid, self.param.pic, self.param.picVer, nil, self.param:GetHeadBgImg())
    self.time_txt:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.param.appointTime))
    self.time_tip_txt:SetLocalText(457035, "")
  else
    self.player_head_icon:SetActive(false)
    self.name_txt:SetText("???")
    self.time_txt:SetText("???")
    self.time_tip_txt:SetText("???")
  end
end

return SeasonOfficialLeaderHistoryItem
