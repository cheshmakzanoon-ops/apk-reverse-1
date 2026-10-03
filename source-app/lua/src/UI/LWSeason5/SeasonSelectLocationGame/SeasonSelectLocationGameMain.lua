local p_btn_resume_path = "Root/bottom/p_btn_resume"
local p_text_resume_path = "Root/bottom/p_btn_resume/LW_Btn_Common_New_Base/p_text_resume"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rank_item_script = require("UI/LWSeason5/SeasonSelectLocationGame/Common/SeasonSelectLocationGameRankItem")
local SeasonSelectLocationGameMain = BaseClass("SeasonSelectLocationGameMain", UIBaseContainer)

function SeasonSelectLocationGameMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textActName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnHelp = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnHelp:SetOnClick(function()
    self:OnBtnHelpClick()
  end)
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.transRankRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.goRankTemplate = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.textRankDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnStart = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnStart:SetOnClick(function()
    self:OnBtnStartClick()
  end)
  self.textTimes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textBtnReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.p_btn_resume = self:AddComponent(UIButton, p_btn_resume_path)
  self.p_btn_resume:SetOnClick(BindCallback(self, self.OnResumeClicked))
  self.p_text_resume = self:AddComponent(UITextMeshProUGUIEx, p_text_resume_path)
  self.goTemplate = self.goRankTemplate.gameObject
  self.goTemplate.gameObject:GameObjectCreatePool()
  self.goTemplate:SetActive(false)
end

function SeasonSelectLocationGameMain:ComponentDestroy()
  self.transRankRoot:RemoveComponents(rank_item_script)
  self.goTemplate:GameObjectRecycleAll()
  self.viewSkin = nil
  self.textActName = nil
  self.textTime = nil
  self.btnHelp = nil
  self.btnSwitch = nil
  self.transRankRoot = nil
  self.goRankTemplate = nil
  self.textRankDesc = nil
  self.btnStart = nil
  self.textTimes = nil
  self.btnReward = nil
  self.textBtnReward = nil
  self.p_btn_resume = nil
  self.p_text_resume = nil
end

function SeasonSelectLocationGameMain:DataDefine()
  self.CreateIndex = 0
end

function SeasonSelectLocationGameMain:DataDestroy()
  self.ActData = nil
end

function SeasonSelectLocationGameMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonSelectLocationGameMain:OnDestroy()
  DataCenter.SeasonSelectLocationGameManager:ClearCacheRankData()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameMain:SetData(actId, actData)
  self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  self:ReInit()
end

function SeasonSelectLocationGameMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTetrisGetInfoPayloadUpdate, self.OnGetInfoUpdate)
  self:AddUIListener(EventId.SeasonTetrisStartGame, self.OnStartUpdate)
  self:AddUIListener(EventId.SeasonSelectLocationGameRankUpdate, self.OnRankUpdate)
  self:AddUIListener(EventId.SeasonSelectLocationGameClose, self.OnGameViewClosed)
end

function SeasonSelectLocationGameMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisGetInfoPayloadUpdate, self.OnGetInfoUpdate)
  self:RemoveUIListener(EventId.SeasonTetrisStartGame, self.OnStartUpdate)
  self:RemoveUIListener(EventId.SeasonSelectLocationGameRankUpdate, self.OnRankUpdate)
  self:RemoveUIListener(EventId.SeasonSelectLocationGameClose, self.OnGameViewClosed)
  base.OnRemoveListener(self)
end

function SeasonSelectLocationGameMain:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function SeasonSelectLocationGameMain:InitData(data)
  self.LastClick = 0
  self.Cd = 10000
  return true
end

function SeasonSelectLocationGameMain:InitUi()
  self.textActName:SetLocalText(self.ActData.bannerTittle)
  self.textRankDesc:SetLocalText("zone_selection_location_game_name_UI_4", checknumber(self.ActData.para_3))
  self:ResetBottomInfo()
  DataCenter.SeasonTetrisManager:SendGetInfo()
  DataCenter.SeasonSelectLocationGameManager:SendGetRank(1)
end

function SeasonSelectLocationGameMain:UpdateData()
  return true
end

function SeasonSelectLocationGameMain:UpdateUi()
  self:UpdateBottomInfo()
end

function SeasonSelectLocationGameMain:UpdateBottomInfo()
  self.textTimes:SetActive(true)
  local inGame = DataCenter.SeasonSelectLocationGameManager:IsInGame()
  self.btnStart:SetActive(not inGame)
  self.p_btn_resume:SetActive(inGame)
  local leftTimes = DataCenter.SeasonSelectLocationGameManager:GetLeftTimes()
  self.textTimes:SetText(CS.GameEntry.Localization:GetString("zone_selection_location_game_name_UI_6") .. ": " .. leftTimes)
end

function SeasonSelectLocationGameMain:UpdateRank()
  self.goTemplate:GameObjectRecycleAll()
  self.transRankRoot:RemoveComponents(rank_item_script)
  local rankData = DataCenter.SeasonSelectLocationGameManager:GetRankData(1)
  if rankData == nil or table.IsNullOrEmpty(rankData.rankList) then
    return
  end
  local rankList = rankData.rankList
  for _, rank in pairs(rankList) do
    local name = "rank_cell_" .. self.CreateIndex
    self.CreateIndex = self.CreateIndex + 1
    local goItem = self.goTemplate:GameObjectSpawn(self.transRankRoot.transform)
    goItem.name = name
    goItem:SetActive(true)
    local comp = self.transRankRoot:AddComponent(rank_item_script, name)
    comp:ReInit(rank)
  end
end

function SeasonSelectLocationGameMain:ResetBottomInfo()
  self.textTimes:SetActive(false)
  self.btnStart:SetActive(false)
end

function SeasonSelectLocationGameMain:UpdateDailyRewardState()
end

function SeasonSelectLocationGameMain:OnBtnHelpClick()
  local activityData = DataCenter.SeasonTetrisManager:GetActData()
  if activityData == nil then
    return
  end
  local param = {}
  param.howToPlayList = activityData.howtoplay
  param.story = activityData.story
  param.defaultTitle = activityData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function SeasonSelectLocationGameMain:OnBtnSwitchClick()
  local rankData = DataCenter.SeasonSelectLocationGameManager:GetRankData(1, 0)
  if rankData ~= nil then
    local param = {}
    param.DefaultTab = 0
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonSelectLocationGameRank, {anim = true}, param)
  end
end

function SeasonSelectLocationGameMain:OnBtnStartClick()
  local past = UITimeManager:GetInstance():GetServerTime() - self.LastClick
  if past < self.Cd then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("zone_selection_location_UI_57"))
    return
  end
  local leftTimes = DataCenter.SeasonSelectLocationGameManager:GetLeftTimes()
  if leftTimes <= 0 then
    UIUtil.ShowTips(Localization:GetString("zone_selection_location_tips_7"))
    return
  end
  local tips = Localization:GetString("zone_selection_location_UI_56")
  
  local function rightCallback()
  end
  
  local function leftCallback()
    DataCenter.SeasonTetrisManager:SendStart()
    self.LastClick = UITimeManager:GetInstance():GetServerTime()
  end
  
  UIUtil.ShowMessage(tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, leftCallback, rightCallback)
end

function SeasonSelectLocationGameMain:OnResumeClicked()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTetrisGame)
end

function SeasonSelectLocationGameMain:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonSelectLocationGameReward)
end

function SeasonSelectLocationGameMain:OnGetInfoUpdate(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function SeasonSelectLocationGameMain:OnStartUpdate(evt)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTetrisGame)
  self:UpdateBottomInfo()
end

function SeasonSelectLocationGameMain:OnRankUpdate(evt)
  local key = evt
  if key == DataCenter.SeasonSelectLocationGameManager:GetRankCacheKey(1, 0) then
    self:UpdateRank()
  end
end

function SeasonSelectLocationGameMain:OnGameViewClosed()
  self.LastClick = 0
  self:UpdateBottomInfo()
end

function SeasonSelectLocationGameMain:Update1000MS()
  if self.ActData ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftTime = math.max(0, self.ActData.endTime - now)
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

return SeasonSelectLocationGameMain
