local base = UIBaseView
local UILWBiuBiuPvpResultView = BaseClass("UILWBiuBiuPvpResultView", base)
local Localization = CS.GameEntry.Localization
local btn_bg_path = "btn_bg"
local title_win_path = "Top/title_win"
local title_lose_path = "Top/title_lose"
local title_tie_path = "Top/title_tie"
local bet_panel_path = "Center/bet_panel"
local txt_bet_win_path = "Center/bet_panel/txt_bet_win"
local txt_bet_title_path = "Center/bet_panel/txt_bet_title"
local u_i_common_res_item_path = "Center/bet_panel/UICommonResItem"
local not_betpanel_path = "Center/not_betpanel"
local txt_not_bet_win_path = "Center/not_betpanel/txt_not_bet_win"
local txt_win_player_name_path = "Center/player_win/txt_winPlayerName"
local txt_win_shoot_count_path = "Center/player_win/txt_winShoot_count"
local img_win_path = "Center/player_win/img_win"
local txt_lose_player_name_path = "Center/player_lose/txt_losePlayerName"
local txt_lose_shoot_count_path = "Center/player_lose/txt_loseShoot_count"
local img_lose_path = "Center/player_lose/img_lose"
local player_win_path = "Center/player_win/player_win/player_win"
local player_lose_path = "Center/player_lose/player_lose/player_lose"
local img_headshot_path = "Center/player_lose/img_headshot"
local txt_battle_time_path = "Center/txt_battleTime"
local btn_again_path = "Buttom/BtnAgain"
local btn_back_path = "Buttom/BtnBack"
local btn_share_path = "Buttom/BtnShare"

function UILWBiuBiuPvpResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.battleResult = self:GetUserData()
  self:Refresh()
  local result = self.battleResult:GetResult()
  if result == 1 then
    DataCenter.LWSoundManager:PlaySound(5100013, false)
  elseif result == 2 then
    DataCenter.LWSoundManager:PlaySound(5100015, false)
  else
    DataCenter.LWSoundManager:PlaySound(5100015, false)
  end
  self.configWaitTime = toInt(GetTableData(TableName.DataConfig, "season_shoot_game_pvp", "k2"))
  self.opTime = -1
end

function UILWBiuBiuPvpResultView:OnDestroy()
  if self.battleResult ~= nil then
    if self.battleResult:GetType() == 0 then
      self.battleResult:GetBoot():Exit()
    end
    self.battleResult = nil
  end
  self.opTime = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuPvpResultView:ComponentDefine()
  self.btn_bg = self:AddComponent(UIButton, btn_bg_path)
  self.img_btn_bg = self.btn_bg.gameObject:GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.title_win = self:AddComponent(UIBaseContainer, title_win_path)
  self.title_lose = self:AddComponent(UIBaseContainer, title_lose_path)
  self.title_tie = self:AddComponent(UIBaseContainer, title_tie_path)
  self.bet_panel = self:AddComponent(UIBaseContainer, bet_panel_path)
  self.txt_bet_win = self:AddComponent(UITextMeshProUGUIEx, txt_bet_win_path)
  self.txt_bet_title = self:AddComponent(UITextMeshProUGUIEx, txt_bet_title_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.not_betpanel = self:AddComponent(UIBaseContainer, not_betpanel_path)
  self.txt_not_bet_win = self:AddComponent(UITextMeshProUGUIEx, txt_not_bet_win_path)
  self.txt_win_player_name = self:AddComponent(UITextMeshProUGUIEx, txt_win_player_name_path)
  self.txt_win_shoot_count = self:AddComponent(UITextMeshProUGUIEx, txt_win_shoot_count_path)
  self.img_win = self:AddComponent(UIImage, img_win_path)
  self.txt_lose_player_name = self:AddComponent(UITextMeshProUGUIEx, txt_lose_player_name_path)
  self.txt_lose_shoot_count = self:AddComponent(UITextMeshProUGUIEx, txt_lose_shoot_count_path)
  self.img_lose = self:AddComponent(UIImage, img_lose_path)
  self.txt_battle_time = self:AddComponent(UITextMeshProUGUIEx, txt_battle_time_path)
  self.btn_again = self:AddComponent(UIButton, btn_again_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_share = self:AddComponent(UIButton, btn_share_path)
  self.player_win = self:AddComponent(UICommonHead, player_win_path)
  self.player_lose = self:AddComponent(UICommonHead, player_lose_path)
  self.img_headshot = self:AddComponent(UIImage, img_headshot_path)
  self.player_win:SetEnableClickShowInfo(true, true)
  self.player_lose:SetEnableClickShowInfo(true, true)
  self.btn_bg:SetOnClick(BindCallback(self, self.OnBackClick))
  self.btn_again:SetOnClick(BindCallback(self, self.OnAgainClick))
  self.btn_back:SetOnClick(BindCallback(self, self.OnBackClick))
  self.btn_share:SetOnClick(BindCallback(self, self.OnShareClick))
end

function UILWBiuBiuPvpResultView:ComponentDestroy()
  self.btn_bg = nil
  self.title_win = nil
  self.title_lose = nil
  self.title_tie = nil
  self.bet_panel = nil
  self.txt_bet_win = nil
  self.txt_bet_title = nil
  self.u_i_common_res_item = nil
  self.not_betpanel = nil
  self.txt_not_bet_win = nil
  self.txt_win_player_name = nil
  self.txt_win_shoot_count = nil
  self.img_win = nil
  self.txt_lose_player_name = nil
  self.txt_lose_shoot_count = nil
  self.img_lose = nil
  self.txt_battle_time = nil
  self.btn_again = nil
  self.btn_back = nil
  self.btn_share = nil
  self.player_win = nil
  self.player_lose = nil
  self.img_headshot = nil
end

function UILWBiuBiuPvpResultView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBiuBiuChatShared, self.SeasonBiuBiuChatSharedHandle)
end

function UILWBiuBiuPvpResultView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBiuBiuChatShared, self.SeasonBiuBiuChatSharedRoomHandle)
  base.OnRemoveListener(self)
end

function UILWBiuBiuPvpResultView:SeasonBiuBiuChatSharedHandle()
  self.opTime = self.configWaitTime or 10
end

function UILWBiuBiuPvpResultView:OnBackClick()
  self.ctrl:CloseSelf()
end

function UILWBiuBiuPvpResultView:OnShareClick()
  if self.opTime > 0 then
    UIUtil.ShowTips(Localization:GetString("season_s5_activity_1200045_desc86", tostring(math.ceil(self.opTime))))
    return
  end
  local share_param = {}
  share_param.postType = PostType.Season_BiuBiuResult
  share_param.param = {
    serverResult = self.battleResult.data.serverResult,
    gameLiftResult = self.battleResult.data.gameLiftResult
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function UILWBiuBiuPvpResultView:OnAgainClick()
  self.battleResult:GetBoot():Again()
  self.ctrl:CloseSelf()
end

function UILWBiuBiuPvpResultView:Refresh()
  local result = self.battleResult:GetResult()
  local serverResult = self.battleResult:GetServerResult()
  local betData = DataCenter.LWBiuBiuDataManager:GetBetData()
  local betid = string.IsNullOrEmpty(serverResult.createitemid) and betData.id or serverResult.createitemid
  local betnum = string.IsNullOrEmpty(serverResult.createitemid) and serverResult.betnum or 1
  self.title_win:SetActive(result == 1)
  self.title_lose:SetActive(result == 2)
  self.title_tie:SetActive(result == 3)
  local hasBet = 0 < betnum
  self.bet_panel:SetActive(hasBet)
  self.not_betpanel:SetActive(not hasBet)
  if hasBet then
    local itemData = {
      itemId = betid,
      rewardType = RewardType.GOODS,
      count = betnum
    }
    self.u_i_common_res_item:ReInit(itemData)
  end
  local txt_result = hasBet and self.txt_bet_win or self.txt_not_bet_win
  if not hasBet then
    txt_result:SetLocalText("season_s5_activity_1200045_desc90")
  elseif result == 3 then
    txt_result:SetLocalText("season_s5_activity_1200045_desc83")
    self.txt_bet_title:SetLocalText("season_s5_activity_1200045_desc89")
  elseif result == 1 then
    txt_result:SetLocalText("season_s5_activity_1200045_desc81")
    self.txt_bet_title:SetLocalText("season_s5_activity_1200045_desc87")
  else
    txt_result:SetLocalText("season_s5_activity_1200045_desc82")
    self.txt_bet_title:SetLocalText("season_s5_activity_1200045_desc88")
  end
  local winHead, loseHead = self.battleResult:GetWinLoseUsers()
  local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(winHead.headSkinId, winHead.headSkinET, false)
  self.player_win:SetHead(winHead.uid, winHead.pic, winHead.picVer, nil, headFrame)
  headFrame = DataCenter.DecorationDataManager:GetHeadFrame(loseHead.headSkinId, loseHead.headSkinET, false)
  self.player_lose:SetHead(loseHead.uid, loseHead.pic, loseHead.picVer, nil, headFrame)
  self.img_headshot:SetActive(self.battleResult:GetHeadShot())
  local winServerName, loseServerName
  if string.IsNullOrEmpty(winHead.abbr) then
    winServerName = "#" .. tostring(winHead.serverId)
  else
    winServerName = Localization:GetString("season_s5_activity_1200045_desc38", winHead.serverId, winHead.abbr)
  end
  if string.IsNullOrEmpty(loseHead.abbr) then
    loseServerName = "#" .. tostring(loseHead.serverId)
  else
    loseServerName = Localization:GetString("season_s5_activity_1200045_desc38", loseHead.serverId, loseHead.abbr)
  end
  self.txt_win_player_name:SetText(winServerName .. winHead.name)
  self.txt_lose_player_name:SetText(loseServerName .. loseHead.name)
  self.img_win:SetActive(result ~= 3)
  self.img_lose:SetActive(result ~= 3)
  local selfFireCount, otherFireCount = self.battleResult:GetFireCount()
  if result == 3 then
    self.txt_win_shoot_count:SetText(tostring(selfFireCount))
    self.txt_lose_shoot_count:SetText(tostring(otherFireCount))
  else
    local winFireCount = result == 1 and selfFireCount or otherFireCount
    local loseFireCount = result == 1 and otherFireCount or selfFireCount
    self.txt_win_shoot_count:SetText(tostring(winFireCount))
    self.txt_lose_shoot_count:SetText(tostring(loseFireCount))
  end
  local inBattle = self.battleResult:GetType() ~= 1
  self.txt_battle_time:SetLocalText("season_s5_activity_1200045_desc30", tostring(self.battleResult:GetBattleTime()))
  self.btn_share:SetActive(inBattle)
  local r, g, b, a = self.img_btn_bg:Get_color()
  self.img_btn_bg:Set_color(r or 1, g or 1, b or 1, inBattle and 0.9607843137254902 or 0.984313725490196)
end

function UILWBiuBiuPvpResultView:Update1000MS()
  if self.opTime > 0 then
    self.opTime = self.opTime - 1
  end
end

return UILWBiuBiuPvpResultView
