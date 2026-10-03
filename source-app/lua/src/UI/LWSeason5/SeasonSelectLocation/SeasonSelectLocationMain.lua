local SeasonSelectLocationMain = BaseClass("SeasonSelectLocationMain", UIBaseContainer)
local SeasonSelectLocationMapComp = require("UI/LWSeason5/SeasonSelectLocation/Comp/SeasonSelectLocationMapComp")
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function SeasonSelectLocationMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonSelectLocationMain:OnDestroy()
  DataCenter.SeasonSelectLocationManager:ClearPosData()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnHelp = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnHelp:SetOnClick(function()
    self:OnBtnHelpClick()
  end)
  self.compMapAbstract = self.viewSkin:AddComponent(self, SeasonSelectLocationMapComp, 2)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compMapReal = self.viewSkin:AddComponent(self, SeasonSelectLocationMapComp, 6)
  self.textRuleTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textActName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textRuleDesc = self.viewSkin:AddComponent(self, UILWScienceDetailDesc, 10)
  local p_btn_game_path = "Root/top/p_btn_game"
  self.p_btn_game = self:AddComponent(UIButton, p_btn_game_path)
  self.p_btn_game:SetOnClick(BindCallback(self, self.OnGotoGameClicked))
  local p_text_btn_game_path = "Root/top/p_btn_game/p_text_btn_game"
  self.p_text_btn_game = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_game_path)
  local mid_path = "Root/mid"
  self.mid = self:AddComponent(UIAnimator, mid_path)
end

function SeasonSelectLocationMain:ComponentDestroy()
  self.viewSkin = nil
  self.btnHelp = nil
  self.compMapAbstract = nil
  self.textTime = nil
  self.btnSwitch = nil
  self.textServer = nil
  self.compMapReal = nil
  self.textRuleTitle = nil
  self.textScore = nil
  self.textActName = nil
  self.textRuleDesc = nil
  self.p_btn_game = nil
  self.p_text_btn_game = nil
  self.mid = nil
end

function SeasonSelectLocationMain:SetData(actId, actData)
  self.ActId = actId
  self.ActData = actData
  self:ReInit()
end

function SeasonSelectLocationMain:DataDefine()
  self.AnimToReal = "V_ui_S5_SeasonSelectLocationMain_switch"
  self.AnimToAbstract = "V_ui_S5_SeasonSelectLocationMain_switch1"
end

function SeasonSelectLocationMain:DataDestroy()
  if self.AnimDelay ~= nil then
    self.AnimDelay:Stop()
    self.AnimDelay = nil
  end
end

function SeasonSelectLocationMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSelectLocationPosDataUpdate, self.OnPosDataUpdate)
end

function SeasonSelectLocationMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSelectLocationPosDataUpdate, self.OnPosDataUpdate)
  base.OnRemoveListener(self)
end

function SeasonSelectLocationMain:ReInit()
  if self:InitData() then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonSelectLocationMain:InitData()
  self.RealMap = true
  self.TransAnim = false
  return true
end

function SeasonSelectLocationMain:InitUi()
  self.textActName:SetLocalText(self.ActData.bannerTittle)
  self.textRuleTitle:SetLocalText("zone_selection_location_UI_3")
  self.textRuleDesc:SetLocalText("zone_selection_location_UI_4")
  self.compMapReal:ReInit()
  self.compMapAbstract:ReInit()
  self:SwitchMap(self.RealMap, false)
  DataCenter.SeasonSelectLocationManager:SendGetInfo()
  self.p_btn_game:SetActive(DataCenter.ActivityListDataManager:IsActivityOpen(EnumActivity.SeasonSelectLocationGame.Type))
end

function SeasonSelectLocationMain:SwitchMap(real, anim)
  local animName = self.RealMap and self.AnimToReal or self.AnimToAbstract
  local delay = anim and 1 or 0
  local _, time = self.mid:GetAnimationReturnTime(animName)
  time = anim and 0 or time
  self.mid:Play(animName, 0, time)
  self.TransAnim = true
  self.AnimDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.TransAnim = false
  end, delay)
end

function SeasonSelectLocationMain:UpdateData()
  self.MyData = DataCenter.SeasonSelectLocationManager:GetMyData()
  return true
end

function SeasonSelectLocationMain:UpdateUi()
  self:UpdateBottom()
end

function SeasonSelectLocationMain:UpdateBottom()
  if self.MyData == nil then
    self.textServer:SetLocalText("zone_selection_location_UI_5", LuaEntry.Player.serverId)
    self.textScore:SetLocalText("zone_selection_location_UI_7", 0)
  else
    if 0 <= self.MyData.Pos then
      local areaName = ""
      local skinCell = DataCenter.SeasonSelectLocationManager:GetWorldSkinCell(self.MyData.Pos)
      if skinCell ~= nil then
        areaName = CS.GameEntry.Localization:GetString(skinCell.aliases)
      end
      self.textServer:SetLocalText("zone_selection_location_UI_6", LuaEntry.Player.serverId, areaName)
    end
    self.textScore:SetLocalText("zone_selection_location_UI_7", string.GetFormattedSeparatorNum(self.MyData.Score))
  end
end

function SeasonSelectLocationMain:Update1000MS()
  local activityData = DataCenter.SeasonSelectLocationManager:GetActData()
  if activityData == nil then
    return
  end
  if activityData:IsSelectStage() then
    local leftTime = activityData.SelectEndTime - UITimeManager:GetInstance():GetServerTime()
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    return
  end
  local leftTime = activityData.EndTime - UITimeManager:GetInstance():GetServerTime()
  if leftTime <= 0 then
    return
  end
  self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
end

function SeasonSelectLocationMain:OnBtnHelpClick()
  local activityData = DataCenter.SeasonSelectLocationManager:GetActData()
  if activityData == nil or activityData.ActData == nil then
    return
  end
  local actData = activityData.ActData
  local param = {}
  param.howToPlayList = actData.howtoplay
  param.story = actData.story
  param.defaultTitle = actData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function SeasonSelectLocationMain:OnBtnSwitchClick()
  if self.TransAnim then
    return
  end
  self.TransAnim = true
  self.RealMap = not self.RealMap
  self:SwitchMap(self.RealMap, true)
end

function SeasonSelectLocationMain:OnPosDataUpdate(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function SeasonSelectLocationMain:OnGotoGameClicked()
  local act_type = EnumActivity.SeasonSelectLocationGame.Type
  local seasonType = SeasonUtil.GetSeasonType(true)
  if seasonType == SeasonMapType.NineNation then
    local activityId
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(act_type)
    if dataList ~= nil and 0 < #dataList then
      activityId = tostring(dataList[1].id)
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSingleActivityContainer) then
        EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerOpenPanel, {activityId = activityId})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, activityId)
      end
    else
      UIUtil.ShowTipsId("season_tips137")
    end
  else
    UIUtil.ShowTipsId("season_tips137")
  end
end

return SeasonSelectLocationMain
