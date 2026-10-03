local UIServerBattleLastKingServerInfo2 = BaseClass("UIServerBattleLastKingServerInfo2", UIBaseContainer)
local base = UIBaseContainer
local vs1_path = "vs1"
local vs2_path = "vs2"
local house1_path = "House1"
local home_icon1_path = "House1/homeIcon1"
local server_bg1_path = "House1/ServerBg1"
local server_txt1_path = "House1/ServerBg1/ServerTxt1"
local house2_path = "House2"
local home_icon2_path = "House2/homeIcon2"
local server_bg2_path = "House2/ServerBg2"
local server_txt2_path = "House2/ServerBg2/ServerTxt2"
local score1_path = "score1"
local status1_path = "score1/status1"
local score1txt_path = "score1/score1txt"
local win1_path = "score1/Win1"
local lose1_path = "score1/Lose1"
local score2_path = "score2"
local score2txt_path = "score2/score2txt"
local status2_path = "score2/status2"
local win2_path = "score2/Win2"
local lose2_path = "score2/Lose2"

function UIServerBattleLastKingServerInfo2:OnCreate()
  base.OnCreate(self)
  self.vs1 = self:AddComponent(UIImage, vs1_path)
  self.vs2 = self:AddComponent(UIImage, vs2_path)
  self.house1 = self:AddComponent(UIImage, house1_path)
  self.home_icon1 = self:AddComponent(UIImage, home_icon1_path)
  self.server_bg1 = self:AddComponent(UIButton, server_bg1_path)
  self.server_txt1 = self:AddComponent(UIText, server_txt1_path)
  self.KingBtn1 = self:AddComponent(UIButton, home_icon1_path)
  self.house2 = self:AddComponent(UIImage, house2_path)
  self.home_icon2 = self:AddComponent(UIImage, home_icon2_path)
  self.server_bg2 = self:AddComponent(UIButton, server_bg2_path)
  self.server_txt2 = self:AddComponent(UIText, server_txt2_path)
  self.KingBtn2 = self:AddComponent(UIButton, home_icon2_path)
  self.score1 = self:AddComponent(UIImage, score1_path)
  self.status1 = self:AddComponent(UIText, status1_path)
  self.score1txt = self:AddComponent(UIText, score1txt_path)
  self.win1 = self:AddComponent(UIImage, win1_path)
  self.lose1 = self:AddComponent(UIImage, lose1_path)
  self.score2 = self:AddComponent(UIImage, score2_path)
  self.score2txt = self:AddComponent(UIText, score2txt_path)
  self.status2 = self:AddComponent(UIText, status2_path)
  self.win2 = self:AddComponent(UIImage, win2_path)
  self.lose2 = self:AddComponent(UIImage, lose2_path)
  self.KingBtn1:SetOnClick(function()
    if self.leftInfo and self.leftInfo.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.leftInfo.serverId)
    end
  end)
  self.KingBtn2:SetOnClick(function()
    if self.rightInfo and self.rightInfo.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.rightInfo.serverId)
    end
  end)
  self.server_bg1:SetOnClick(function()
    if self.leftInfo and self.leftInfo.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.leftInfo.serverId)
    end
  end)
  self.server_bg2:SetOnClick(function()
    if self.rightInfo and self.rightInfo.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.rightInfo.serverId)
    end
  end)
end

function UIServerBattleLastKingServerInfo2:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleLastKingServerInfo2:OnEnable()
  base.OnEnable(self)
end

function UIServerBattleLastKingServerInfo2:OnDisable()
  base.OnDisable(self)
end

function UIServerBattleLastKingServerInfo2:ReInit(configSchedule, fightInfo, config, serverBattleType)
  self.config = config
  self.serverBattleType = serverBattleType
  self.configSchedule = configSchedule
  self.fightInfo = fightInfo
  local mySeverId, leftInfo, rightInfo = DataCenter.ZoneWarManager:ParseVsRound(fightInfo.curVsRound, true)
  local serverInfo1 = fightInfo.serverInfo[tostring(leftInfo.serverId)] or {cfgId = 511001}
  local serverInfo2 = fightInfo.serverInfo[tostring(rightInfo.serverId)] or {cfgId = 511001}
  self:ReInitWeek(leftInfo, rightInfo, serverInfo1, serverInfo2, mySeverId)
  self.win1:SetActive(leftInfo.win == 1)
  self.lose1:SetActive(leftInfo.win == -1)
  self.win2:SetActive(rightInfo.win == 1)
  self.lose2:SetActive(rightInfo.win == -1)
end

function UIServerBattleLastKingServerInfo2:ReInitWeek(leftInfo, rightInfo, serverInfo1, serverInfo2, mySeverId)
  self.leftInfo = leftInfo
  self.rightInfo = rightInfo
  self.serverInfo1 = serverInfo1
  self.serverInfo2 = serverInfo2
  if leftInfo.score > rightInfo.score or leftInfo.score == rightInfo.score and leftInfo.serverId > rightInfo.serverId then
    self.vs1:SetLocalScaleXYZ(1, 1, 1)
    self.vs2:SetLocalScaleXYZ(1, 1, 1)
    self.score1:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_icon_gongji.png")
    self.score2:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_icon_fangyv.png")
    self.status1:SetLocalText(801461)
    self.status2:SetLocalText(801462)
  else
    self.vs1:SetLocalScaleXYZ(-1, 1, 1)
    self.vs2:SetLocalScaleXYZ(-1, 1, 1)
    self.score1:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_icon_fangyv.png")
    self.score2:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_icon_gongji.png")
    self.status1:SetLocalText(801462)
    self.status2:SetLocalText(801461)
  end
  if serverInfo1.cfgId then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(serverInfo1.cfgId)
    if itemCfg ~= nil then
      self.home_icon1:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
  if serverInfo2.cfgId then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(serverInfo2.cfgId)
    if itemCfg ~= nil then
      self.home_icon2:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
  self.score1txt:SetText("+" .. string.GetFormattedSeparatorNum(leftInfo.score) .. "pt")
  self.win1:SetActive(false)
  self.lose1:SetActive(false)
  self.score2txt:SetText("+" .. string.GetFormattedSeparatorNum(rightInfo.score) .. "pt")
  self.win2:SetActive(false)
  self.lose2:SetActive(false)
  local rightStatus = DataCenter.ZoneWarManager:IsAlly(rightInfo.serverId, mySeverId) and 2 or 1
  local leftStatus = rightStatus == 1 and 2 or 1
  DataCenter.ZoneWarManager:SetServerInfo(self.server_bg1, self.server_txt1, leftInfo.serverId, leftStatus)
  DataCenter.ZoneWarManager:SetServerInfo(self.server_bg2, self.server_txt2, rightInfo.serverId, rightStatus)
end

return UIServerBattleLastKingServerInfo2
