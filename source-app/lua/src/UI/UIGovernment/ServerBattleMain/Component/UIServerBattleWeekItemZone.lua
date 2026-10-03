local UIServerBattleWeekItemZone = BaseClass("UIServerBattleWeekItemZone", UIBaseContainer)
local base = UIBaseContainer
local info_img_path = "InfoImg"
local title_path = "title"
local score_path = "score"
local flag_icon1_path = "flagIcon1"
local name1_path = "flagIcon1/Name1"
local win1_path = "flagIcon1/Win1"
local lose1_path = "flagIcon1/Lose1"
local score1_path = "flagIcon1/score1"
local flag_icon2_path = "flagIcon2"
local name2_path = "flagIcon2/Name2"
local win2_path = "flagIcon2/Win2"
local lose2_path = "flagIcon2/Lose2"
local score2_path = "flagIcon2/score2"

function UIServerBattleWeekItemZone:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.infoImg = self:AddComponent(UIImage, info_img_path)
  self.title = self:AddComponent(UIText, title_path)
  self.score = self:AddComponent(UIText, score_path)
  self.flag_icon1 = self:AddComponent(UIImage, flag_icon1_path)
  self.name1 = self:AddComponent(UIText, name1_path)
  self.win1 = self:AddComponent(UIImage, win1_path)
  self.lose1 = self:AddComponent(UIImage, lose1_path)
  self.score1 = self:AddComponent(UIText, score1_path)
  self.flag_icon2 = self:AddComponent(UIImage, flag_icon2_path)
  self.name2 = self:AddComponent(UIText, name2_path)
  self.win2 = self:AddComponent(UIImage, win2_path)
  self.lose2 = self:AddComponent(UIImage, lose2_path)
  self.score2 = self:AddComponent(UIText, score2_path)
end

function UIServerBattleWeekItemZone:OnDestroy()
  base.OnDestroy(self)
  self.score1 = nil
  self.score2 = nil
end

function UIServerBattleWeekItemZone:ReInit(configScore, config, serverBattleType, isWinner, scoreData, myInfo, targetInfo)
  local zoneInfo = scoreData.extra
  local winnerId = scoreData.serverId
  local loseId = winnerId == zoneInfo.serverId and zoneInfo.vsServerId or zoneInfo.serverId or 0
  local mySeverId = isWinner and winnerId or loseId
  local enemyServerId = isWinner and loseId or winnerId
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
  if zoneInfo.vsServerScore == nil then
    self.score:SetText("+" .. string.GetFormattedSeparatorNum(scoreData.score or configScore.score or 0) .. "pt")
    self.win1:SetActive(isWinner)
    self.lose2:SetActive(isWinner)
    self.lose1:SetActive(not isWinner)
    self.win2:SetActive(not isWinner)
  else
    self.win1:SetActive(false)
    self.lose2:SetActive(false)
    self.lose1:SetActive(false)
    self.win2:SetActive(false)
    self.score:SetText("")
    if mySeverId == zoneInfo.serverId then
      self.score1:SetText("+" .. string.GetFormattedSeparatorNum(scoreData.score or configScore.score or 0) .. "pt")
      self.score2:SetText("+" .. string.GetFormattedSeparatorNum(zoneInfo.vsServerScore or 0) .. "pt")
    else
      self.score1:SetText("+" .. string.GetFormattedSeparatorNum(zoneInfo.vsServerScore or 0) .. "pt")
      self.score2:SetText("+" .. string.GetFormattedSeparatorNum(scoreData.score or configScore.score or 0) .. "pt")
    end
  end
  self.name1:SetText("#" .. mySeverId)
  self.name2:SetText("#" .. enemyServerId)
  local template = myInfo.cfgId and DataCenter.ItemTemplateManager:GetItemTemplate(tostring(myInfo.cfgId))
  if template then
    self.flag_icon1:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
  end
  template = targetInfo.cfgId and DataCenter.ItemTemplateManager:GetItemTemplate(tostring(targetInfo.cfgId))
  if template then
    self.flag_icon2:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
  end
  self.infoImg:LoadSprite(configScore.icon)
  self.infoImg:SetNativeSize()
end

return UIServerBattleWeekItemZone
