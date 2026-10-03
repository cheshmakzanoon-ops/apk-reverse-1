local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SandWormFishingMain = BaseClass("SandWormFishingMain", base)
local Localization = CS.GameEntry.Localization
local SandWormFishingRankItem = require("UI.UISandWormFishing.UISandWormFishingRank.Component.SandWormFishingRankItem")
local name_path = "LeftTop/Name"
local desc_path = "LeftTop/Desc"
local time_path = "LeftTop/TimeContent/Time"
local intro_btn_path = "RightTop/IntroBtn"
local btn_rank_path = "RightTop/BtnRank"
local btn_reward_path = "RightTop/BtnReward"
local btn_record_path = "RightTop/BtnRecord"
local empty_tip_path = "Bottom/emptyTip"
local text1_path = "Bottom/text1"
local content_path = "Bottom/ScrollView/Viewport/Content"
local toggle1_path = "Bottom/selectContent/Toggle1"
local checkmark_text_toggle1_path = "Bottom/selectContent/Toggle1/CheckmarkTextToggle1"
local toggle2_path = "Bottom/selectContent/Toggle2"
local checkmark_text_toggle2_path = "Bottom/selectContent/Toggle2/CheckmarkTextToggle2"
local select_content_path = "Bottom/selectContent"
local red_point_path = "RightTop/BtnReward/RedPoint"
local level_path = "Bottom/head/level"
local TabType = {LevelRank = 1, DamageRank = 2}

function SandWormFishingMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SandWormFishingMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SandWormFishingMain:ComponentDefine()
  self.text1 = self:AddComponent(UITextMeshProUGUIEx, text1_path)
  self.text1:SetLocalText("season_s3_activity_1000074_desc02")
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
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
      self:OnClickToggle(TabType.LevelRank)
    end
  end)
  self.checkmark_text_toggle1 = self:AddComponent(UITextMeshProUGUIEx, checkmark_text_toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetOnValueChanged(function(bool)
    if bool then
      self:OnClickToggle(TabType.DamageRank)
    end
  end)
  self.checkmark_text_toggle2 = self:AddComponent(UITextMeshProUGUIEx, checkmark_text_toggle2_path)
  self.select_content = self:AddComponent(UIBaseComponent, select_content_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
end

function SandWormFishingMain:ComponentDestroy()
  self:RemoveList()
  self.name = nil
  self.text1 = nil
  self.desc = nil
  self.time = nil
  self.icon = nil
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
  self.level = nil
end

function SandWormFishingMain:OnEnable()
  base.OnEnable(self)
end

function SandWormFishingMain:OnDisable()
  base.OnDisable(self)
end

function SandWormFishingMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnSandWormFishingRankRefresh, self.RefreshCurList)
end

function SandWormFishingMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnSandWormFishingRankRefresh, self.RefreshCurList)
end

function SandWormFishingMain:SetData(activityId)
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
    self.empty_tip:SetLocalText("371004")
    self:OnClickToggle(TabType.LevelRank)
  end
end

function SandWormFishingMain:RefreshTop()
  self.name:SetLocalText(self.data.activityName)
  self.desc:SetLocalText(self.data.bannerTittle)
  self:Update1000MS()
  self:RefreshAwardRedPoint()
end

function SandWormFishingMain:RefreshAwardRedPoint()
end

function SandWormFishingMain:RemoveList()
  self.content:RemoveComponents(SandWormFishingRankItem)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqs = {}
end

function SandWormFishingMain:RefreshCurList()
  self:RemoveList()
  local rawList = DataCenter.SandWormFishingDataManager:GetRankList(self.curTab, UITimeManager:GetInstance():GetNowWeekdayIndex())
  if #rawList == 0 then
    self.empty_tip:SetActive(true)
    return
  end
  local list = {}
  local count = math.min(#rawList, 3)
  for i = 1, count do
    table.insert(list, rawList[i])
  end
  self.empty_tip:SetActive(false)
  for i = 1, #list do
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.WormFishingRankItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "SandWormFishingRankItem" .. i
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(SandWormFishingRankItem, item.name)
      obj:RefreshItem(list[i], i, self.curTab)
    end)
  end
end

function SandWormFishingMain:OnClickToggle(tabType)
  if tabType == self.curTab then
    return
  end
  self.curTab = tabType
  local today = UITimeManager:GetInstance():GetNowWeekdayIndex()
  DataCenter.SandWormFishingDataManager:FetchRankList(tabType, today)
  if tabType == TabType.LevelRank then
    self.checkmark_text_toggle1:SetActive(true)
    self.checkmark_text_toggle2:SetActive(false)
    self.level:SetLocalText(100082)
  else
    self.checkmark_text_toggle1:SetActive(false)
    self.checkmark_text_toggle2:SetActive(true)
    self.level:SetLocalText(110186)
  end
  self:RefreshCurList()
end

function SandWormFishingMain:Update1000MS()
  local endTime = 0
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SandWormFishing.Type)
  if actList and actList[1] then
    endTime = actList[1].endTime
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(endTime - now)
  self.time:SetText(countdown)
end

function SandWormFishingMain:OnClickIntroBtn()
  if self.data and self.data.story then
    local param = {}
    param.activityId = self.data.activityId
    param.activityRulesStr = Localization:GetString(self.data.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SandWormFishingMain:OnClickRecordBtn()
end

function SandWormFishingMain:OnClickRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISandWormFishingReward, {anim = true})
end

function SandWormFishingMain:OnClickRankBtn()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISandWormFishingRank, {anim = true})
  end
end

return SandWormFishingMain
