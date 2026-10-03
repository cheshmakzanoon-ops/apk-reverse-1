local ServerBattleActivityPopupView = BaseClass("ServerBattleActivityPopupView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local btn_back_path = "BtnBack"
local arrow_path = "ImageKing/arrow"
local btn_go_path = "ImageKing/BtnGo"
local home_icon1_path = "ImageKing/House1/homeIcon1"
local server_txt1_path = "ImageKing/House1/ServerBg1/ServerTxt1"
local server_bg1_path = "ImageKing/House1/ServerBg1"
local flag1_path = "ImageKing/House1/GameObject/flag1"
local attack1_path = "ImageKing/House1/GameObject/attack1"
local home_icon2_path = "ImageKing/House2/homeIcon2"
local server_txt2_path = "ImageKing/House2/ServerBg2/ServerTxt2"
local server_bg2_path = "ImageKing/House2/ServerBg2"
local flag2_path = "ImageKing/House2/GameObject/flag2"
local defence2_path = "ImageKing/House2/GameObject/defence2"
local house1_path = "ImageKing/House1"
local house2_path = "ImageKing/House2"

function ServerBattleActivityPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ServerBattleActivityPopupView:OnDestroy()
  UIUtil.GetWeekActiveCount("CrossKingBattlePopup", true)
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.CrossKingActivity, false)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ServerBattleActivityPopupView:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
end

function ServerBattleActivityPopupView:OnDisable()
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
  base.OnDisable(self)
end

function ServerBattleActivityPopupView:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_go:SetOnClick(function()
    self:GotoCity()
  end)
  self.house1 = self:AddComponent(UIImage, house1_path)
  self.house2 = self:AddComponent(UIImage, house2_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.house1:SetActive(false)
  self.house2:SetActive(false)
  self.arrow:SetActive(false)
  self.home_icon1 = self:AddComponent(UIImage, home_icon1_path)
  self.server_txt1 = self:AddComponent(UIText, server_txt1_path)
  self.server_bg1 = self:AddComponent(UIImage, server_bg1_path)
  self.flag1 = self:AddComponent(UIButton, flag1_path)
  self.attack1 = self:AddComponent(UIText, attack1_path)
  self.home_icon2 = self:AddComponent(UIImage, home_icon2_path)
  self.server_txt2 = self:AddComponent(UIText, server_txt2_path)
  self.server_bg2 = self:AddComponent(UIImage, server_bg2_path)
  self.flag2 = self:AddComponent(UIButton, flag2_path)
  self.defence2 = self:AddComponent(UIText, defence2_path)
  self:UpdateData()
end

function ServerBattleActivityPopupView:ComponentDestroy()
  self.btn_back = nil
  self.arrow = nil
  self.btn_go = nil
  self.home_icon1 = nil
  self.server_txt1 = nil
  self.flag1 = nil
  self.attack1 = nil
  self.home_icon2 = nil
  self.server_txt2 = nil
  self.flag2 = nil
  self.defence2 = nil
end

function ServerBattleActivityPopupView:UpdateData()
  local fightInfo = DataCenter.ZoneWarManager:GetCrossKingFightInfo(true)
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule == nil or fightInfo == nil then
    return
  end
  self.house1:SetActive(true)
  self.house2:SetActive(true)
  self.arrow:SetActive(true)
  self.fightInfo = fightInfo
  self.configSchedule = configSchedule
  self:RefreshUI(configSchedule, fightInfo)
end

function ServerBattleActivityPopupView:RefreshUI(configSchedule, fightInfo)
  local leftInfo = fightInfo.curVsRound[1] or {
    serverId = 0,
    score = 0,
    campId = 0
  }
  local rightInfo = fightInfo.curVsRound[2] or {
    serverId = 0,
    score = 0,
    campId = 0
  }
  if 0 < leftInfo.campId and 0 < rightInfo.campId and leftInfo.campId < rightInfo.campId then
    local temp = leftInfo
    leftInfo = rightInfo
    rightInfo = temp
  end
  local serverInfo1 = fightInfo.serverInfo[tostring(leftInfo.serverId)] or {cfgId = 511001}
  local serverInfo2 = fightInfo.serverInfo[tostring(rightInfo.serverId)] or {cfgId = 511001}
  if leftInfo.score > rightInfo.score or leftInfo.score == rightInfo.score and leftInfo.serverId > rightInfo.serverId then
    self.arrow:SetLocalScaleXYZ(1, 1, 1)
    self.flag1:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_icon_gongji.png")
    self.flag2:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_icon_fangyv.png")
    self.attack1:SetLocalText(801461)
    self.defence2:SetLocalText(801462)
    self.battleServerId = rightInfo.serverId
  else
    self.arrow:SetLocalScaleXYZ(-1, 1, 1)
    self.flag1:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_icon_fangyv.png")
    self.flag2:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_icon_gongji.png")
    self.attack1:SetLocalText(801462)
    self.defence2:SetLocalText(801461)
    self.battleServerId = leftInfo.serverId
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
  local rightStatus = SeasonUtil.IsAlly(rightInfo.serverId, LuaEntry.Player:GetSourceServerId(), rightInfo.allianceId) and 2 or 1
  local leftStatus = rightStatus == 1 and 2 or 1
  DataCenter.ZoneWarManager:SetServerInfo(self.server_bg1, self.server_txt1, leftInfo.serverId, leftStatus)
  DataCenter.ZoneWarManager:SetServerInfo(self.server_bg2, self.server_txt2, rightInfo.serverId, rightStatus)
  self.leftInfo = leftInfo
  self.rightInfo = rightInfo
  self.serverInfo1 = serverInfo1
  self.serverInfo2 = serverInfo2
end

function ServerBattleActivityPopupView:GotoCity()
  if DataCenter.LWZombieRushManager:IsChallenging() then
    UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      CrossServerUtil.JumpToKingdomAround(self.battleServerId, MoveCrossServerType.CrossServerKingBattle)
    end, function()
    end)
  else
    CrossServerUtil.JumpToKingdomAround(self.battleServerId, MoveCrossServerType.CrossServerKingBattle)
  end
end

return ServerBattleActivityPopupView
