local UILWSeasonOutpostFixS5View = BaseClass("UILWSeasonOutpostFixS5View", UIBaseView)
local base = UIBaseView
local RankItem = require("UI.LWSeason5.UILWSeasonOutpostFixS5.Component.UILWSeasonOutpostFixS5Item")
local RankALL = require("UI.LWSeason5.UILWSeasonOutpostFixS5.Component.UILWSeasonOutpostFixS5Rank")
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
local panel_path = "panel"
local t3_path = "Root/ScrollView/t3"
local t2_path = "Root/ScrollView/t2"
local t1_path = "Root/ScrollView/t1"
local progress_build_path = "Root/ScrollView/progressBuild"
local progress_text_path = "Root/ScrollView/progressBuild/progressBg/progressText"
local rank_list_item1_path = "Root/ScrollView/Viewport/Content/RankListItem1"
local rank_list_item2_path = "Root/ScrollView/Viewport/Content/RankListItem2"
local rank_list_item3_path = "Root/ScrollView/Viewport/Content/RankListItem3"
local text_title_path = "Root/TopBar/TextTitle"
local title_text_path = "Root/TopBar/TitleText"
local desc_text_path = "Root/TopBar/DescText"
local btn_rank_path = "Root/TopBar/BtnRank"
local btn_rank_text_path = "Root/TopBar/BtnRank/BtnRankText"
local btn_go_path = "Root/BottomBar/BtnGo"
local btn_text_path = "Root/BottomBar/BtnGo/BtnText"
local btn_back_path = "Root/BottomBar/BtnBack"
local tip_fix_text_path = "Root/BottomBar/TipFixText"
local rank_all_path = "Root/RankAll"
local full_rank_btn_path = "Root/ScrollView/t3/fullRankBtn"
local empty_path = "Root/ScrollView/empty"
local viewport_path = "Root/ScrollView/Viewport"

function UILWSeasonOutpostFixS5View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.rank_all:SetActive(false)
  self.actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type)
  self.mySourceServerId = LuaEntry.Player:GetSourceServerId()
  self.cityId, self.serverId = SeasonUtil.GetOutpostId(self.mySourceServerId)
  self:UpdateData(FetchOutpostRepairInfo.GetRepairInfo(self.serverId, self.cityId, true, true))
  SFSNetwork.SendMessage(MsgDefines.FetchOutpostList)
end

function UILWSeasonOutpostFixS5View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostFixS5View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostRepairInfoUpdate, self.UpdateData)
end

function UILWSeasonOutpostFixS5View:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostRepairInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonOutpostFixS5View:ComponentDefine()
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
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
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank_text = self:AddComponent(UITextMeshProUGUIEx, btn_rank_text_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.tip_fix_text = self:AddComponent(UITextMeshProUGUIEx, tip_fix_text_path)
  self.full_rank_btn = self:AddComponent(UIButton, full_rank_btn_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_title:SetLocalText("war_zone_outpost_1")
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
      howToPlayList = {500003}
    })
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

function UILWSeasonOutpostFixS5View:ComponentDestroy()
  self.btn_back = nil
  self.t3 = nil
  self.t2 = nil
  self.t1 = nil
  self.progress_build = nil
  self.progress_text = nil
  self.rank_list_item1 = nil
  self.rank_list_item2 = nil
  self.rank_list_item3 = nil
  self.text_title = nil
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
end

function UILWSeasonOutpostFixS5View:UpdateData(data)
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

return UILWSeasonOutpostFixS5View
