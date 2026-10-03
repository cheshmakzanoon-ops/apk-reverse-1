local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SandWormHuntMain = BaseClass("SandWormHuntMain", base)
local Localization = CS.GameEntry.Localization
local SmallSandWormCell = require("UI.UISandWormHunt.SmallSandWormCell")
local BigSandWormCell = require("UI.UISandWormHunt.BigSandWormCell")
local name_path = "LeftTop/Name"
local desc_path = "LeftTop/Desc"
local time_path = "LeftTop/TimeContent/Time"
local icon_path = "LeftTop/SandWormObj/UIPlayerHead"
local slider_path = "LeftTop/SandWormObj/slider"
local ppt_btn_path = "LeftTop/SandWormObj/pptBtn"
local intro_btn_path = "RightTop/IntroBtn"
local btn_rank_path = "RightTop/BtnRank"
local btn_reward_path = "RightTop/BtnReward"
local btn_record_path = "RightTop/BtnRecord"
local empty_tip_path = "Bottom/emptyTip"
local content_path = "Bottom/ScrollView/Viewport/Content"
local toggle1_path = "Bottom/selectContent/Toggle1"
local checkmark_text_toggle1_path = "Bottom/selectContent/Toggle1/CheckmarkTextToggle1"
local toggle2_path = "Bottom/selectContent/Toggle2"
local checkmark_text_toggle2_path = "Bottom/selectContent/Toggle2/CheckmarkTextToggle2"
local select_content_path = "Bottom/selectContent"
local red_point_path = "RightTop/BtnReward/RedPoint"
local bg_path = "Bg"
local TabType = {SmallSandWorm = 1, BigSandWorm = 2}

function SandWormHuntMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SandWormHuntMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SandWormHuntMain:ComponentDefine()
  self.vfx = self:AddComponent(UIBaseComponent, "node_shachong")
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.playerHead = self:AddComponent(UICommonHead, icon_path)
  self.playerHead:SetFrameActive(false)
  self.slider = self:AddComponent(UIImage, slider_path)
  self.ppt_btn = self:AddComponent(UIButton, ppt_btn_path)
  self.ppt_btn:SetOnClick(function()
    self:OnClickPptBtn()
  end)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    self:OnClickIntroBtn()
  end)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank:SetOnClick(function()
    self:OnClickRankBtn()
  end)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_reward:SetOnClick(function()
    self:OnClickRewardBtn()
  end)
  self.btn_record = self:AddComponent(UIButton, btn_record_path)
  self.btn_record:SetOnClick(function()
    self:OnClickRecordBtn()
  end)
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.curTab = nil
  self.toggle1:SetOnValueChanged(function(bool)
    if bool then
      self:OnClickToggle(TabType.SmallSandWorm)
    end
  end)
  self.checkmark_text_toggle1 = self:AddComponent(UITextMeshProUGUIEx, checkmark_text_toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetOnValueChanged(function(bool)
    if bool then
      self:OnClickToggle(TabType.BigSandWorm)
    end
  end)
  self.checkmark_text_toggle2 = self:AddComponent(UITextMeshProUGUIEx, checkmark_text_toggle2_path)
  self.select_content = self:AddComponent(UIBaseComponent, select_content_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
end

function SandWormHuntMain:ComponentDestroy()
  self:RemoveList()
  self.name = nil
  self.desc = nil
  self.time = nil
  self.icon = nil
  self.slider = nil
  self.intro_btn = nil
  self.btn_rank = nil
  self.btn_reward = nil
  self.btn_record = nil
  self.empty_tip = nil
  self.content = nil
  self.toggle1 = nil
  self.checkmark_text_toggle1 = nil
  self.toggle2 = nil
  self.checkmark_text_toggle2 = nil
  self.select_content = nil
  self.red_point = nil
  self.ppt_btn = nil
  self.bg = nil
end

function SandWormHuntMain:OnEnable()
  base.OnEnable(self)
end

function SandWormHuntMain:OnDisable()
  base.OnDisable(self)
end

function SandWormHuntMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SmallSandWormListRefresh, self.RefreshSmallSandWormList)
  self:AddUIListener(EventId.BigSandWormListRefresh, self.RefreshBigSandWormList)
  self:AddUIListener(EventId.OnSandWormHuntRewardRefresh, self.RefreshAwardRedPoint)
end

function SandWormHuntMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SmallSandWormListRefresh, self.RefreshSmallSandWormList)
  self:RemoveUIListener(EventId.BigSandWormListRefresh, self.RefreshBigSandWormList)
  self:RemoveUIListener(EventId.OnSandWormHuntRewardRefresh, self.RefreshAwardRedPoint)
end

function SandWormHuntMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self:RefreshTop()
  if not LuaEntry.Player:IsInAlliance() then
    self.empty_tip:SetActive(true)
    self.empty_tip:SetLocalText("300707")
    self.select_content:SetActive(false)
  else
    self.empty_tip:SetLocalText("season_activity_1000069_desc06")
    self.select_content:SetActive(DataCenter.SandWormHuntDataManager:IsStageTwo())
    self:OnClickToggle(TabType.SmallSandWorm)
  end
end

function SandWormHuntMain:RefreshTop()
  local fillAmount = DataCenter.SandWormHuntDataManager:GetFillAmount()
  self.slider:SetFillAmount(fillAmount)
  self.playerHead:SetHead(nil, "Assets/Main/SeasonRes/S3/Sprites/Sandworm/mjc_S3_sc_zhujiemian_weizhishachong.png")
  self.name:SetLocalText(self.data.activityName)
  self.desc:SetLocalText(self.data.bannerTittle)
  self:Update1000MS()
  self:RefreshAwardRedPoint()
end

function SandWormHuntMain:RefreshAwardRedPoint()
  self.red_point:SetActive(DataCenter.SandWormHuntDataManager:GetCanReceive())
end

function SandWormHuntMain:RemoveList()
  self.content:RemoveComponents(SmallSandWormCell)
  self.content:RemoveComponents(BigSandWormCell)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqs = {}
end

function SandWormHuntMain:RefreshSmallSandWormList()
  if self.curTab ~= TabType.SmallSandWorm then
    return
  end
  self:RemoveList()
  local list = DataCenter.SandWormHuntDataManager:GetSmallSandWormList() or {}
  if #list == 0 then
    self.empty_tip:SetActive(true)
    return
  end
  self.empty_tip:SetActive(false)
  for i = 1, #list do
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.SmallSandWormCell, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "SmallSandWormCell" .. i
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(SmallSandWormCell, item.name)
      obj:SetData(list[i])
    end)
  end
end

function SandWormHuntMain:RefreshBigSandWormList()
  if self.curTab ~= TabType.BigSandWorm then
    return
  end
  self:RemoveList()
  local list = DataCenter.SandWormHuntDataManager:GetBigSandWormList() or {}
  if #list == 0 then
    self.empty_tip:SetActive(true)
    return
  end
  self.empty_tip:SetActive(false)
  for i = 1, #list do
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.BigSandWormCell, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "BigSandWormCell" .. i
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(BigSandWormCell, item.name)
      obj:SetData(list[i])
    end)
  end
end

function SandWormHuntMain:OnClickToggle(tabType)
  if tabType == self.curTab then
    return
  end
  self.curTab = tabType
  if tabType == TabType.SmallSandWorm then
    self.checkmark_text_toggle1:SetActive(true)
    self.checkmark_text_toggle2:SetActive(false)
    DataCenter.SandWormHuntDataManager:FetchSandWormList(SandWormType.Small)
    self:RefreshSmallSandWormList()
    self.bg:LoadSprite("Assets/Main/SeasonRes/S3/Textures/WormHunt/mjc_S3_sc_zhuye_bg.png")
    self.vfx:SetActive(false)
  else
    self.checkmark_text_toggle1:SetActive(false)
    self.checkmark_text_toggle2:SetActive(true)
    DataCenter.SandWormHuntDataManager:FetchSandWormList(SandWormType.Big)
    self:RefreshBigSandWormList()
    self.bg:LoadSprite("Assets/Main/SeasonRes/S3/Textures/WormHunt/mjc_S3_sc_zhuye_bg2.png")
    self.vfx:SetActive(true)
  end
end

function SandWormHuntMain:Update1000MS()
  local endTime = DataCenter.SandWormHuntDataManager:GetEndTime()
  if not endTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(endTime - now)
  self.time:SetText(countdown)
end

function SandWormHuntMain:OnClickPptBtn()
  if self.data and self.data.para_6 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = true}, tonumber(self.data.para_6))
  end
end

function SandWormHuntMain:OnClickIntroBtn()
  if self.data and self.data.story then
    local param = {}
    param.activityId = self.data.activityId
    param.activityRulesStr = Localization:GetString(self.data.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SandWormHuntMain:ClickTipBtn()
  local param = {}
  param.activityRulesStr = Localization:GetString(GetTableData(TableName.Activity, self.activityId, "desc"))
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function SandWormHuntMain:OnClickRecordBtn()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISandWormHistory, {anim = true})
  end
end

function SandWormHuntMain:OnClickRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISandWormReward, {anim = true})
end

function SandWormHuntMain:OnClickRankBtn()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISandWormRank, {anim = true})
  end
end

return SandWormHuntMain
