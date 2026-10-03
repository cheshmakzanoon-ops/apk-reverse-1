local PresidentHistoryItem = BaseClass("PresidentHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local num_txt_path = "numTxt"
local name_txt_path = "nameTxt"
local time_tip_text_path = "timeTipText"
local time_text_path = "timeText"
local player_path = "player"

function PresidentHistoryItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "bg")
  self.round_text = self:AddComponent(UIText, num_txt_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.time_txt = self:AddComponent(UIText, time_text_path)
  self.time_tip_txt = self:AddComponent(UIText, time_tip_text_path)
  self.player_head_icon = self:AddComponent(UICommonHead, player_path)
  self.player_head_icon:SetEnableClickShowInfo(true, true)
  if self.transform:Find("ItemDrop") ~= nil then
    self.ItemDrop = self:AddComponent(PresidentHistoryItem, "ItemDrop")
    self.ItemDrop:SetActive(false)
  elseif self.transform:Find("drop") ~= nil then
    self.dropText = self:AddComponent(UIText, "drop")
  end
end

function PresidentHistoryItem:OnDestroy()
  base.OnDestroy(self)
end

function PresidentHistoryItem:ReInit(index, param, attacker)
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
  if self.dropText and attacker then
    local enemyName = "#" .. attacker.occupyServerId
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(param.uid, param.name)
    if string.IsNullOrEmpty(param.allianceAbbr) then
      enemyName = enemyName .. " " .. showName
    else
      enemyName = enemyName .. " [" .. param.allianceAbbr .. "]" .. showName
    end
    self.time_txt:SetActive(false)
    self.time_tip_txt:SetActive(false)
    self.dropText:SetLocalText("801464", enemyName)
  end
  self.round_text:SetLocalText(457034, self.param.round)
  if self.param.uid ~= nil and self.param.uid ~= "" then
    local presidentName = ""
    if param.occupyServerId ~= nil and param.occupyServerId ~= 0 then
      presidentName = "#" .. param.occupyServerId .. " "
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail/lyp_lianmeng_anniu_3.png")
    else
      self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_sanji_1.png")
    end
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.param.uid, self.param.name)
    if string.IsNullOrEmpty(self.param.allianceAbbr) then
      presidentName = presidentName .. showName
    else
      presidentName = presidentName .. "[" .. self.param.allianceAbbr .. "] " .. showName
    end
    self.player_head_icon:SetActive(true)
    self.name_txt:SetText(presidentName)
    self.player_head_icon:SetHead(self.param.uid, self.param.pic, self.param.picVer, nil, self.param:GetHeadBgImg())
    if param.occupyServerId ~= nil and param.occupyServerId ~= 0 then
      self.round_text:SetText(Localization:GetString(457034, self.param.round) .. " (" .. Localization:GetString("801609") .. ")")
      self.time_txt:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.param.beKingTime))
      self.time_tip_txt:SetLocalText(801464, "")
    else
      self.time_txt:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.param.beKingTime))
      self.time_tip_txt:SetLocalText(457035, "")
    end
  else
    self.player_head_icon:SetActive(false)
    self.name_txt:SetText("???")
    self.time_txt:SetText("???")
    self.time_tip_txt:SetText("???")
  end
end

return PresidentHistoryItem
