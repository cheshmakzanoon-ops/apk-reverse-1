local UILWSeasonFixOutpostS6 = BaseClass("UILWSeasonFixOutpostS6", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local RankItem = require("UI.LWSeason6.Outpost.UILWSeasonOutpostMainUIS6.Component.UILWSeasonFixOutpostS6Item")
local RankALL = require("UI.LWSeason6.Outpost.UILWSeasonOutpostMainUIS6.Component.UILWSeasonFixOutpostS6Rank")
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
local btn_back_path = "Root/BtnBack"
local t3_path = "Root/ScrollView/t3"
local t2_path = "Root/ScrollView/t2"
local t1_path = "Root/ScrollView/t1"
local progress_build_path = "Root/ScrollView/progressBuild"
local progress_text_path = "Root/ScrollView/progressBuild/progressBg/progressText"
local rank_list_item1_path = "Root/ScrollView/Viewport/Content/RankListItem1"
local rank_list_item2_path = "Root/ScrollView/Viewport/Content/RankListItem2"
local rank_list_item3_path = "Root/ScrollView/Viewport/Content/RankListItem3"
local title_text_path = "Root/TopBar/TitleText"
local desc_text_path = "Root/TopBar/DescText"
local btn_rank_path = "Root/TopBar/BtnRank"
local btn_rank_text_path = "Root/TopBar/BtnRank/BtnRankText"
local btn_go_path = "Root/BottomBar/BtnGo"
local btn_text_path = "Root/BottomBar/BtnGo/BtnText"
local tip_fix_text_path = "Root/BottomBar/TipFixText"
local rank_all_path = "Root/RankAll"
local full_rank_btn_path = "Root/ScrollView/t3/fullRankBtn"
local empty_path = "Root/ScrollView/empty"
local viewport_path = "Root/ScrollView/Viewport"
local progress_path = "Root/TopBar/progress"
local battle_step1_path = "Root/TopBar/progress/progressBg/battleStep1"
local battle_step2_path = "Root/TopBar/progress/progressBg/battleStep2"
local battle_step3_path = "Root/TopBar/progress/progressBg/battleStep3"
local battle_step4_path = "Root/TopBar/progress/progressBg/battleStep4"

function UILWSeasonFixOutpostS6:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self:ComponentDefine()
  self.rank_all:SetActive(false)
  SFSNetwork.SendMessage(MsgDefines.FetchOutpostList)
end

function UILWSeasonFixOutpostS6:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFixOutpostS6:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostRepairInfoUpdate, self.UpdateData)
end

function UILWSeasonFixOutpostS6:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostRepairInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonFixOutpostS6:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.empty = self:AddComponent(UITextMeshProUGUIEx, empty_path)
  self.viewport = self:AddComponent(UIImage, viewport_path)
  self.rank_all = self:AddComponent(RankALL, rank_all_path)
  self.t3 = self:AddComponent(UITextMeshProUGUIEx, t3_path)
  self.t2 = self:AddComponent(UITextMeshProUGUIEx, t2_path)
  self.t1 = self:AddComponent(UITextMeshProUGUIEx, t1_path)
  self.progress_build = self:AddComponent(UISlider, progress_build_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
  self.rank_list_item1 = self:AddComponent(RankItem, rank_list_item1_path)
  self.rank_list_item2 = self:AddComponent(RankItem, rank_list_item2_path)
  self.rank_list_item3 = self:AddComponent(RankItem, rank_list_item3_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank_text = self:AddComponent(UITextMeshProUGUIEx, btn_rank_text_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.tip_fix_text = self:AddComponent(UITextMeshProUGUIEx, tip_fix_text_path)
  self.full_rank_btn = self:AddComponent(UIButton, full_rank_btn_path)
  self.progress = self:AddComponent(UISlider, progress_path)
  self.battle_step1 = self:AddComponent(UIButton, battle_step1_path)
  self.battle_step2 = self:AddComponent(UIButton, battle_step2_path)
  self.battle_step3 = self:AddComponent(UIButton, battle_step3_path)
  self.battle_step4 = self:AddComponent(UIButton, battle_step4_path)
  self.battle_step1:SetOnClick(function()
    self:ShowStageInfo(1, self.battle_step1)
  end)
  self.battle_step2:SetOnClick(function()
    self:ShowStageInfo(2, self.battle_step2)
  end)
  self.battle_step3:SetOnClick(function()
    self:ShowStageInfo(3, self.battle_step3)
  end)
  self.battle_step4:SetOnClick(function()
    self:ShowStageInfo(4, self.battle_step4)
  end)
  self.t3:SetLocalText("war_zone_outpost_7")
  self.t2:SetLocalText("war_zone_outpost_6")
  self.t1:SetLocalText("war_zone_outpost_5")
  self.progress_build:SetValue(0)
  self.progress_text:SetLocalText("war_zone_outpost_4", 0, 0)
  self.title_text:SetLocalText("war_zone_outpost_2")
  self.desc_text:SetLocalText("war_zone_outpost_16")
  self.btn_text:SetLocalText("war_zone_outpost_18")
  self.tip_fix_text:SetText("")
  self.btn_rank_text:SetLocalText("100092")
  self.btn_rank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600009}
    })
  end)
  self.btn_back:SetOnClick(function()
    if self.view then
      self.view.ctrl:CloseSelf()
    else
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostMainUIS6)
    end
  end)
  self.btn_go:SetOnClick(function()
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, mySourceServerId)
    if meta ~= nil then
      meta:JumpTo()
    end
  end)
  self.full_rank_btn:SetOnClick(function()
    if self.rank_list_item1 ~= nil and self.actData ~= nil and self.rankArr ~= nil then
      self.rank_all:SetActive(true)
      self.rank_all:ReInit(self.rank_list_item1.gameObject, self.actData, self.outpostInfo, self.rankArr)
    else
      UIUtil.ShowTipsId("avatar_tips006")
    end
  end)
  self.full_rank_btn:SetActive(false)
end

function UILWSeasonFixOutpostS6:ComponentDestroy()
  self.btn_back = nil
  self.t3 = nil
  self.t2 = nil
  self.t1 = nil
  self.progress_build = nil
  self.progress_text = nil
  self.rank_list_item1 = nil
  self.rank_list_item2 = nil
  self.rank_list_item3 = nil
  self.title_text = nil
  self.desc_text = nil
  self.btn_rank = nil
  self.btn_rank_text = nil
  self.btn_go = nil
  self.btn_text = nil
  self.tip_fix_text = nil
  self.rank_all = nil
  self.full_rank_btn = nil
  self.empty = nil
  self.viewport = nil
  self.progress = nil
  self.battle_step1 = nil
  self.battle_step2 = nil
  self.battle_step3 = nil
  self.battle_step4 = nil
end

function UILWSeasonFixOutpostS6:ShowStageInfo(index, btn)
  if self.dataList == nil or btn == nil or self.dataList[index] == nil then
    return
  end
  local put_start_time = self.dataList[index].put_start_time
  if put_start_time == nil then
    return
  end
  local title = Localization:GetString("s6_outpost_title_7")
  local timeStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(put_start_time, false, false)
  local msg = Localization:GetString("110129", timeStr)
  UIUtil.ShowButtonTips(btn, title, msg, true)
end

function UILWSeasonFixOutpostS6:Refresh(index, actData, cityInfo, dataList)
  self.actData = actData
  self.cityInfo = cityInfo
  self.dataList = dataList
  self.index = toInt(index)
  self.cityId = cityInfo.cityId
  self.serverId = cityInfo.serverId
  self.repairInfo = cityInfo.repairInfo or FetchOutpostRepairInfo.GetRepairInfo(self.serverId, self.cityId, true, true)
  if self.actData and self:AsyncLoadDone() then
    self:UpdateData(self.repairInfo)
  end
end

function UILWSeasonFixOutpostS6:UpdateProgress(index, battle_step)
  if self.index == index then
    battle_step:SetSizeDeltaXY(72, 72)
    battle_step:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_QSZ_bar_yuanxing_3.png")
  elseif index > self.index then
    battle_step:SetSizeDeltaXY(72, 72)
    battle_step:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_QSZ_bar_yuanxing_1.png")
  else
    battle_step:SetSizeDeltaXY(72, 72)
    battle_step:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_QSZ_bar_yuanxing_2.png")
  end
end

function UILWSeasonFixOutpostS6:UpdateData(data)
  if not self.actData or not self:AsyncLoadDone() then
    return
  end
  self:UpdateProgress(1, self.battle_step1)
  self:UpdateProgress(2, self.battle_step2)
  self:UpdateProgress(3, self.battle_step3)
  self:UpdateProgress(4, self.battle_step4)
  if self.index == 1 then
    self.progress:SetValue(0)
  elseif self.index == 2 then
    self.progress:SetValue(0.33)
  elseif self.index == 3 then
    self.progress:SetValue(0.66)
  elseif self.index == 4 then
    self.progress:SetValue(1)
  end
  if data == nil then
    data = self.repairInfo
  end
  if data ~= nil then
    local can_show_rank = self.actData ~= nil and data ~= nil
    local rankArr
    local outpostInfo = data.outpostInfo or {}
    local repairRank = data.repairRank
    if repairRank then
      rankArr = repairRank.rankArr
    end
    if rankArr and 0 < #rankArr then
      table.sort(rankArr, function(a, b)
        return a.rank < b.rank
      end)
      can_show_rank = can_show_rank and 3 < #rankArr
      self.empty:SetActive(false)
      self.viewport:SetActive(true)
      self.rank_list_item1:ReInit(1, rankArr[1], false)
      self.rank_list_item2:ReInit(2, rankArr[2], false)
      self.rank_list_item3:ReInit(3, rankArr[3], false)
    else
      can_show_rank = false
      self.empty:SetActive(true)
      self.viewport:SetActive(false)
      self.empty:SetLocalText("war_zone_outpost_84")
    end
    self.outpostInfo = outpostInfo
    self.rankArr = rankArr
    self.full_rank_btn:SetActive(can_show_rank)
    if can_show_rank and self.rank_all:GetActive() then
      self.rank_all:ReInit(self.rank_list_item1.gameObject, self.actData, outpostInfo, rankArr)
    end
    local canRepairCount = 0
    if self.actData then
      local needPoint = toInt(self.actData.para)
      local hasPoint = toInt(outpostInfo.repairScore)
      canRepairCount = toInt(self.actData.para_4)
      self.progress_text:SetLocalText("war_zone_outpost_4", hasPoint, needPoint)
      if 0 < needPoint then
        self.progress_build:SetValue(hasPoint / needPoint)
      else
        self.progress_build:SetValue(0)
      end
      if needPoint <= hasPoint then
        self.btn_text:SetLocalText("war_zone_outpost_25")
        self.tip_fix_text:SetText("")
        return
      else
        self.btn_text:SetLocalText("war_zone_outpost_18")
      end
    end
    local repairCount = toInt(data.repairCount)
    self.tip_fix_text:SetLocalText("140403", canRepairCount - repairCount)
  end
end

return UILWSeasonFixOutpostS6
