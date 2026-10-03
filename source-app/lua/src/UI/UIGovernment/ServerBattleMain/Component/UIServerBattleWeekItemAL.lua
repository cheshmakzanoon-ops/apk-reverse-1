local UIServerBattleWeekItemAL = BaseClass("UIServerBattleWeekItemAL", UIBaseContainer)
local base = UIBaseContainer
local info_img_path = "InfoImg"
local title_path = "title"
local score_path = "score"
local flag_icon1_path = "flagIcon1"
local name1_path = "flagIcon1/Name1"
local win1_path = "flagIcon1/Win1"
local lose1_path = "flagIcon1/Lose1"
local flag_icon2_path = "flagIcon2"
local name2_path = "flagIcon2/Name2"
local win2_path = "flagIcon2/Win2"
local lose2_path = "flagIcon2/Lose2"

function UIServerBattleWeekItemAL:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.infoImg = self:AddComponent(UIImage, info_img_path)
  self.title = self:AddComponent(UIText, title_path)
  self.score = self:AddComponent(UIText, score_path)
  self.flag_icon1 = self:AddComponent(UIImage, flag_icon1_path)
  self.name1 = self:AddComponent(UIText, name1_path)
  self.win1 = self:AddComponent(UIImage, win1_path)
  self.lose1 = self:AddComponent(UIImage, lose1_path)
  self.flag_icon2 = self:AddComponent(UIImage, flag_icon2_path)
  self.name2 = self:AddComponent(UIText, name2_path)
  self.win2 = self:AddComponent(UIImage, win2_path)
  self.lose2 = self:AddComponent(UIImage, lose2_path)
end

function UIServerBattleWeekItemAL:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleWeekItemAL:ReInit(configScore, config, serverBattleType, isWinner, scoreData)
  local allianceInfo = scoreData.extra
  local winAlliance = allianceInfo.winAlliance
  local lostAlliance = allianceInfo.lostAlliance
  local myInfo, targetInfo
  if isWinner then
    myInfo = winAlliance
    targetInfo = lostAlliance
  else
    myInfo = lostAlliance
    targetInfo = winAlliance
  end
  self.configScore = configScore
  self.config = config
  self.serverBattleType = serverBattleType
  if isWinner then
    self.title:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    self.score:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_wofangjilubg.png")
  else
    self.title:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    self.score:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difangjilubg.png")
  end
  self.title:SetLocalText(configScore.name)
  self.score:SetText("+" .. string.GetFormattedSeparatorNum(scoreData.score or configScore.score or 0) .. "pt")
  self.win1:SetActive(isWinner)
  self.lose2:SetActive(isWinner)
  self.lose1:SetActive(not isWinner)
  self.win2:SetActive(not isWinner)
  if string.IsNullOrEmpty(myInfo.abbr) then
    self.name1:SetText("#" .. (myInfo.server or myInfo.serverId or "???") .. " " .. myInfo.alliancename)
  else
    self.name1:SetText("#" .. (myInfo.server or myInfo.serverId or "???") .. " [" .. myInfo.abbr .. "]" .. myInfo.alliancename)
  end
  if string.IsNullOrEmpty(targetInfo.abbr) then
    self.name2:SetText("#" .. (targetInfo.server or targetInfo.serverId or "???") .. " " .. targetInfo.alliancename)
  else
    self.name2:SetText("#" .. (targetInfo.server or targetInfo.serverId or "???") .. " [" .. targetInfo.abbr .. "]" .. targetInfo.alliancename)
  end
  self.flag_icon1:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(myInfo.icon)))
  self.flag_icon2:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(targetInfo.icon)))
  self.infoImg:LoadSprite(configScore.icon)
  self.infoImg:SetNativeSize()
end

return UIServerBattleWeekItemAL
