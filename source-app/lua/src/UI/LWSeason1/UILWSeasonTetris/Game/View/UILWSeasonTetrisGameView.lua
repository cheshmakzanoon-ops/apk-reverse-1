local UILWSeasonTetrisGameView = BaseClass("UILWSeasonTetrisGameView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWSeasonTetrisMapComp = require("UI.LWSeason1.UILWSeasonTetris.Game.Component.UILWSeasonTetrisGridMapComp")
local bg_path = "mask/ContentRoot/UIBackground"
local bg_pos1_path = "mask/ContentRoot/ContentMid/GridMap/PiecePosContent/piece_bg1"
local bg_pos2_path = "mask/ContentRoot/ContentMid/GridMap/PiecePosContent/piece_bg2"
local bg_pos3_path = "mask/ContentRoot/ContentMid/GridMap/PiecePosContent/piece_bg3"
local text_put_time_path = "mask/ContentRoot/ContentBottom/content_put_time/TextPutTime"
local content_put_time_path = "mask/ContentRoot/ContentBottom/content_put_time"
local content_time_path = "mask/ContentRoot/ContentBottom/content_time"
local p_loading_path = "mask/ContentRoot/ContentMid/p_loading"

function UILWSeasonTetrisGameView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textLevelTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compGridMap = self.viewSkin:AddComponent(self, UILWSeasonTetrisMapComp, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnRestart = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnRestart:SetOnClick(function()
    self:OnBtnRestartClick()
  end)
  self.textBtnRestart = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.animReset = self.viewSkin:AddComponent(self, UIAnimator, 8)
  self.compAnim = self:AddComponent(UIAnimator, "")
  self.imgMainBg = self:AddComponent(UIRawImage, bg_path)
  self.imgPiece1Bg = self:AddComponent(UIImage, bg_pos1_path)
  self.imgPiece2Bg = self:AddComponent(UIImage, bg_pos2_path)
  self.imgPiece3Bg = self:AddComponent(UIImage, bg_pos3_path)
  self.text_put_time = self:AddComponent(UITextMeshProUGUIEx, text_put_time_path)
  self.content_put_time = self:AddComponent(UIBaseContainer, content_put_time_path)
  self.content_time = self:AddComponent(UIBaseContainer, content_time_path)
  self.p_loading = self:AddComponent(UIBaseContainer, p_loading_path)
end

function UILWSeasonTetrisGameView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textLevelTitle = nil
  self.compGridMap = nil
  self.textTime = nil
  self.btnRestart = nil
  self.textBtnRestart = nil
  self.btnBack = nil
  self.animReset = nil
  self.compAnim = nil
  self.imgMainBg = nil
  self.imgPiece1Bg = nil
  self.imgPiece2Bg = nil
  self.imgPiece3Bg = nil
  self.text_put_time = nil
  self.content_put_time = nil
  self.content_time = nil
  self.p_loading = nil
end

function UILWSeasonTetrisGameView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local dataSource = DataCenter.SeasonTetrisManager.DataSource
  self.ShowTime = dataSource:ShowTextTime()
  self.ShowPutTime = dataSource:ShowPutTime()
  self:InitUi()
  self:ReInit()
  self.animReset:SetActive(false)
  DataCenter.LWSoundManager:PlaySound(1000021, false)
  DataCenter.SeasonTetrisManager:StopAMBSound()
end

function UILWSeasonTetrisGameView:OnDestroy()
  local dataSource = DataCenter.SeasonTetrisManager.DataSource
  if dataSource ~= nil then
    dataSource:OnGameViewDestroy()
  end
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.SeasonTetrisManager:ResumeAMBSound()
  base.OnDestroy(self)
end

function UILWSeasonTetrisGameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTetrisResetUpdate, self.OnResetCallback)
  self:AddUIListener(EventId.SeasonTetrisCloseGame, self.OnCloseEvt)
  self:AddUIListener(EventId.SeasonTetrisOnPutCallback, self.OnPutCallback)
  self:AddUIListener(EventId.SeasonSelectLocationGameEsc, self.OnEscClicked)
  self:AddUIListener(EventId.SeasonTetrisResetWithError, self.OnResetWithError)
  self:AddUIListener(EventId.SeasonTetrisGetInfoPayload, self.OnGetInfoUpdate)
end

function UILWSeasonTetrisGameView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisResetUpdate, self.OnResetCallback)
  self:RemoveUIListener(EventId.SeasonTetrisCloseGame, self.OnCloseEvt)
  self:RemoveUIListener(EventId.SeasonTetrisOnPutCallback, self.OnPutCallback)
  self:RemoveUIListener(EventId.SeasonSelectLocationGameEsc, self.OnEscClicked)
  self:RemoveUIListener(EventId.SeasonTetrisResetWithError, self.OnResetWithError)
  self:RemoveUIListener(EventId.SeasonTetrisGetInfoPayload, self.OnGetInfoUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonTetrisGameView:OnResetCallback(evt)
  self.animReset:SetActive(true)
  self.animReset:Play("Eff_ani_ActivityTetrisGame_zhuanchang_1")
  DataCenter.LWSoundManager:PlaySound(1000021, false)
  self.Timer = TimerManager:GetInstance():DelayInvoke(function()
    self:ReInit()
  end, 0.2)
  self:ResetTimeText()
  self:Update1000MS()
end

function UILWSeasonTetrisGameView:DataDefine()
  self.GameData = DataCenter.SeasonTetrisManager.GameData
end

function UILWSeasonTetrisGameView:DataDestroy()
  self.GameData = nil
  if self.Timer ~= nil then
    self.Timer:Stop()
    self.Timer = nil
  end
  if self.ResetTimer ~= nil then
    self.ResetTimer:Stop()
    self.ResetTimer = nil
  end
end

function UILWSeasonTetrisGameView:ReInit()
  if self.compGridMap ~= nil then
    self.compGridMap:ReInit()
  end
end

function UILWSeasonTetrisGameView:InitUi()
  local actData = DataCenter.SeasonTetrisManager:GetActData()
  if actData ~= nil then
    self.textTitle:SetLocalText(actData.name)
  end
  self.textBtnRestart:SetLocalText("season_s1_activity1200030_desc04")
  local dataSource = DataCenter.SeasonTetrisManager.DataSource
  if dataSource ~= nil then
    self.imgMainBg:LoadSpriteAsync(dataSource:GetMainBg())
    self.imgPiece1Bg:LoadSpriteAsync(dataSource:GetPieceBg())
    self.imgPiece2Bg:LoadSpriteAsync(dataSource:GetPieceBg())
    self.imgPiece3Bg:LoadSpriteAsync(dataSource:GetPieceBg())
    self.btnRestart:SetActive(dataSource:CanReset())
    if self.compAnim ~= nil then
      self.compAnim:Play(dataSource:GetGameViewAnim())
    end
  end
  self:UpdatePutTime()
  self.textTime:SetText("00:00:00")
  self:ResetTimeText()
  self:Update1000MS()
  self.p_loading:SetActive(false)
end

function UILWSeasonTetrisGameView:ResetTimeText()
  self.content_time:SetActive(self.ShowTime)
  self.content_put_time:SetActive(self.ShowPutTime)
end

function UILWSeasonTetrisGameView:HideTime()
  self.content_time:SetActive(false)
end

function UILWSeasonTetrisGameView:UpdatePutTime()
  self.text_put_time:SetLocalText("zone_selection_location_UI_42", toInt(self.GameData.PutTimes))
end

function UILWSeasonTetrisGameView:Update1000MS()
  if self.ShowTime and self.GameData ~= nil then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    local past = math.max(0, now - checknumber(self.GameData.StartTime))
    if 0 < past then
      self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(past))
    end
  end
end

function UILWSeasonTetrisGameView:CanPlace(piece)
  return self.compGridMap:CanPlace(piece)
end

function UILWSeasonTetrisGameView:ShowShadows(piece)
  self.compGridMap:ShowShadows(piece)
end

function UILWSeasonTetrisGameView:ClearShadows()
  self.compGridMap:ClearShadows()
end

function UILWSeasonTetrisGameView:PlacePiece(piece)
  self.compGridMap:PlacePiece(piece)
end

function UILWSeasonTetrisGameView:HasWinOrFail()
  return self.compGridMap.HasWinOrFail
end

function UILWSeasonTetrisGameView:OnBtnRestartClick()
  if self.compGridMap ~= nil and not self.compGridMap:CheckGameState(false) then
    DataCenter.SeasonTetrisManager:SendReset(true)
  end
end

function UILWSeasonTetrisGameView:OnBtnBackClick()
  local dataSource = DataCenter.SeasonTetrisManager.DataSource
  if dataSource ~= nil and dataSource:TwiceConfirmExit() then
    if self.compGridMap ~= nil then
      self.compGridMap:SetCanGuide(false)
    end
    local tips = Localization:GetString("zone_selection_location_UI_53")
    
    local function rightCallback()
      if self.compGridMap ~= nil then
        self.compGridMap:SetCanGuide(true)
      end
    end
    
    local function leftCallback()
      local gameData = DataCenter.SeasonTetrisManager.GameData
      if gameData ~= nil then
        CommonUtil.PlayerPrefsSetLong("TETRIS_GAME_MANUAL_QUIT", checknumber(gameData.StartTime))
      end
      self.ctrl:CloseSelf()
    end
    
    UIUtil.ShowMessage(tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, leftCallback, rightCallback)
    return
  end
  self.ctrl:CloseSelf()
end

function UILWSeasonTetrisGameView:OnCloseEvt()
  self.ctrl:CloseSelf()
end

function UILWSeasonTetrisGameView:OnPutCallback()
  self:UpdatePutTime()
end

function UILWSeasonTetrisGameView:OnEscClicked()
  self:OnBtnBackClick()
end

function UILWSeasonTetrisGameView:OnResetWithError()
  self.p_loading:SetActive(true)
  self.ResetTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ReInit()
    self.p_loading:SetActive(false)
  end, 1)
  self:ResetTimeText()
  self:Update1000MS()
end

function UILWSeasonTetrisGameView:OnGetInfoUpdate()
  self:OnResetWithError()
end

return UILWSeasonTetrisGameView
