local base = UIBaseView
local UILWSeasonDistributeAwardView = BaseClass("UILWSeasonDistributeAwardView", base)
local Localization = CS.GameEntry.Localization
local backBtn_path = "panel"
local clostBtn_path = "UICommonMiniPopUpTitle/Common_bg_orange/CloseBtn"
local saveBtn_path = "UICommonMiniPopUpTitle/Common_bg_orange/SaveBtn"
local rankIcon_path = "UICommonMiniPopUpTitle/Common_bg_orange/MemberInfo/RankIcon"
local memberName_path = "UICommonMiniPopUpTitle/Common_bg_orange/MemberInfo/NameText"
local rankText1_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/Rank1"
local rankText2_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/Rank2"
local rankText3_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/Rank3"
local rankText4_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/Rank4"
local memberHead_path = "UICommonMiniPopUpTitle/Common_bg_orange/MemberInfo/UIPlayerHead"
local rewardCount1_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward1/count1"
local rewardCount2_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward2/count2"
local rewardCount3_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward3/count3"
local rewardCount4_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward4/count4"
local rewardSelect1_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward1/select1"
local rewardSelect2_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward2/select2"
local rewardSelect3_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward3/select3"
local rewardSelect4_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward4/select4"
local selectBtn1_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward1/selectBtn1"
local selectBtn2_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward2/selectBtn2"
local selectBtn3_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward3/selectBtn3"
local selectBtn4_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward4/selectBtn4"
local rankDes1_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/rankDes1"
local rankDes2_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/rankDes2"
local rankDes3_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/rankDes3"
local rankDes4_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/rankDes4"
local rewardObj1_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward1"
local rewardObj2_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward2"
local rewardObj3_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward3"
local rewardObj4_path = "UICommonMiniPopUpTitle/Common_bg_orange/rewards/reward4"
local bg_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/bg"
local bg1_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/bg (1)"
local bg2_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/bg (2)"
local bg3_path = "UICommonMiniPopUpTitle/Common_bg_orange/RankInfo/bg (3)"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  local eventId = {}
  local eventIds = DataCenter.SeasonDataManager:GetSeasonHeroEventIds()
  for i = 1, 4 do
    local comp = self["rankDes" .. tostring(i)]
    local bgComp = self["bg" .. tostring(i)]
    if comp ~= nil then
      comp:SetActive(false)
      if i <= table.count(eventIds) then
        table.insert(eventId, toInt(eventIds[i]))
        local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, eventIds[i])
        if heroEventMeta then
          comp:SetActive(true)
          comp:SetText(Localization:GetString("season_extra_reward_rank_title", Localization:GetString(heroEventMeta.name)))
        end
      end
    end
    if bgComp ~= nil then
      bgComp:SetActive(i <= table.count(eventIds))
    end
  end
  SFSNetwork.SendMessage(MsgDefines.LWSeasonSettlementMemberDetail, self.data.uid, eventId)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.backBtn = self:AddComponent(UIButton, backBtn_path)
  self.clostBtn = self:AddComponent(UIButton, clostBtn_path)
  self.saveBtn = self:AddComponent(UIButton, saveBtn_path)
  self.rankIcon = self:AddComponent(UIImage, rankIcon_path)
  self.memberName = self:AddComponent(UIText, memberName_path)
  self.rankText1 = self:AddComponent(UIText, rankText1_path)
  self.rankText2 = self:AddComponent(UIText, rankText2_path)
  self.rankText3 = self:AddComponent(UIText, rankText3_path)
  self.rankText4 = self:AddComponent(UIText, rankText4_path)
  self.memberHead = self:AddComponent(UIBaseContainer, memberHead_path)
  self.rewardCount1 = self:AddComponent(UIText, rewardCount1_path)
  self.rewardCount2 = self:AddComponent(UIText, rewardCount2_path)
  self.rewardCount3 = self:AddComponent(UIText, rewardCount3_path)
  self.rewardCount4 = self:AddComponent(UIText, rewardCount4_path)
  self.rewardSelect1 = self:AddComponent(UIBaseContainer, rewardSelect1_path)
  self.rewardSelect2 = self:AddComponent(UIBaseContainer, rewardSelect2_path)
  self.rewardSelect3 = self:AddComponent(UIBaseContainer, rewardSelect3_path)
  self.rewardSelect4 = self:AddComponent(UIBaseContainer, rewardSelect4_path)
  self.selectBtn1 = self:AddComponent(UIButton, selectBtn1_path)
  self.selectBtn2 = self:AddComponent(UIButton, selectBtn2_path)
  self.selectBtn3 = self:AddComponent(UIButton, selectBtn3_path)
  self.selectBtn4 = self:AddComponent(UIButton, selectBtn4_path)
  self.rankDes1 = self:AddComponent(UIText, rankDes1_path)
  self.rankDes2 = self:AddComponent(UIText, rankDes2_path)
  self.rankDes3 = self:AddComponent(UIText, rankDes3_path)
  self.rankDes4 = self:AddComponent(UIText, rankDes4_path)
  self.rewardObj1 = self:AddComponent(UIBaseContainer, rewardObj1_path)
  self.rewardObj2 = self:AddComponent(UIBaseContainer, rewardObj2_path)
  self.rewardObj3 = self:AddComponent(UIBaseContainer, rewardObj3_path)
  self.rewardObj4 = self:AddComponent(UIBaseContainer, rewardObj4_path)
  self.bg1 = self:AddComponent(UIImage, bg_path)
  self.bg2 = self:AddComponent(UIImage, bg1_path)
  self.bg3 = self:AddComponent(UIImage, bg2_path)
  self.bg4 = self:AddComponent(UIImage, bg3_path)
  self.playerIcon = self:AddComponent(UICommonHead, memberHead_path)
  self.playerBtn = self:AddComponent(UIButton, memberHead_path)
  self.playerBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.data.uid)
  end)
  self.selectBtn4:SetOnClick(function()
    self:SetSelect(4)
  end)
  self.selectBtn3:SetOnClick(function()
    self:SetSelect(3)
  end)
  self.selectBtn2:SetOnClick(function()
    self:SetSelect(2)
  end)
  self.selectBtn1:SetOnClick(function()
    self:SetSelect(1)
  end)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.clostBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.saveBtn:SetOnClick(function()
    self:SaveBtnClick()
  end)
  self.rewardSelect1:SetActive(false)
  self.rewardSelect2:SetActive(false)
  self.rewardSelect3:SetActive(false)
  self.rewardSelect4:SetActive(false)
  self.curSelect = 0
end

local function ComponentDestroy(self)
  self.playerIcon = nil
  self.playerBtn = nil
  self.curSelect = nil
  self.backBtn = nil
  self.clostBtn = nil
  self.saveBtn = nil
  self.rankIcon = nil
  self.memberName = nil
  self.rankText1 = nil
  self.rankText2 = nil
  self.rankText3 = nil
  self.rankText4 = nil
  self.memberHead = nil
  self.rewardCount1 = nil
  self.rewardCount2 = nil
  self.rewardCount3 = nil
  self.rewardCount4 = nil
  self.rewardSelect1 = nil
  self.rewardSelect2 = nil
  self.rewardSelect3 = nil
  self.rewardSelect4 = nil
  self.selectBtn1 = nil
  self.selectBtn2 = nil
  self.selectBtn3 = nil
  self.selectBtn4 = nil
  self.rankDes1 = nil
  self.rankDes2 = nil
  self.rankDes3 = nil
  self.rankDes4 = nil
  self.rewardObj1 = nil
  self.rewardObj2 = nil
  self.rewardObj3 = nil
  self.rewardObj4 = nil
  self.bg1 = nil
  self.bg2 = nil
  self.bg3 = nil
  self.bg4 = nil
end

local function DataDefine(self)
  self.data = self:GetUserData()
end

local function DataDestroy(self)
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRewardInfo)
  self:AddUIListener(EventId.LWSeasonAllianceRewardMemberDetailInfo, self.UpdateMemberDetailInfo)
  self:AddUIListener(EventId.LWSeasonAllianceSettlementMemberRewardInfo, self.DistributeRewardSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRewardInfo)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardMemberDetailInfo, self.UpdateMemberDetailInfo)
  self:RemoveUIListener(EventId.LWSeasonAllianceSettlementMemberRewardInfo, self.DistributeRewardSuccess)
  base.OnRemoveListener(self)
end

local function RefreshView(self)
  local userId = self.data.uid
  local userPic = self.data.pic
  local userPicVer = self.data.picVer
  self.playerIcon:SetData(userId, userPic, userPicVer, true, self.data.headBg)
  self.memberName:SetText(self.data.name)
  self.rankIcon:LoadSprite(LWAlMemberRankParam[self.data.rank].Icon)
  local rewardIndex = DataCenter.SeasonRewardDataManager:GetAllianceReweardMemberAssignedRewardIndex(self.data.uid)
  local selectIndex = DataCenter.SeasonRewardDataManager:GetRewardSelectByRewardIndex(rewardIndex)
  self.preRewardIndex = rewardIndex
  if 0 < rewardIndex and 0 < selectIndex then
    self:SetSelect(selectIndex)
  end
  self:RefreshRewardInfo()
  self:RefreshMemberDetailInfo()
end

local function SetSelect(self, index)
  if self.curSelect == index then
    self.curSelect = 0
    self["rewardSelect" .. index]:SetActive(false)
  else
    if self.curSelect ~= nil and self.curSelect > 0 then
      self["rewardSelect" .. self.curSelect]:SetActive(false)
    end
    self["rewardSelect" .. index]:SetActive(true)
    self.curSelect = index
  end
end

local function RefreshRewardInfo(self)
  local rewardTier = DataCenter.SeasonRewardDataManager:GetOpenRewardTier()
  self.rewardRemain = DataCenter.SeasonRewardDataManager:GetRewardRemain(rewardTier)
  local size = #self.rewardRemain
  if size ~= 0 then
    for i = 1, 4 do
      self["rewardObj" .. i]:SetActive(i <= size)
      if i <= size then
        self["rewardCount" .. i]:SetText(Localization:GetString("season_reward_ui_010", self.rewardRemain[i]))
      end
    end
  end
end

local function RefreshMemberDetailInfo(self)
  local member = DataCenter.SeasonRewardDataManager:GetAllianceReweardMemberInfo(self.data.uid)
  local eventIds = DataCenter.SeasonDataManager:GetSeasonHeroEventIds()
  for i = 1, 4 do
    local comp = self["rankText" .. tostring(i)]
    if comp ~= nil then
      if i <= table.count(eventIds) then
        local rank = member:GetRankData(eventIds[i])
        comp:SetText(rank)
        comp:SetActive(true)
      else
        comp:SetActive(false)
      end
    end
  end
  local rewardIndex = DataCenter.SeasonRewardDataManager:GetAllianceReweardMemberAssignedRewardIndex(self.data.uid)
  self.preRewardIndex = rewardIndex
end

local function SaveBtnClick(self)
  if self.curSelect == 0 then
    if self.preRewardIndex ~= self.curSelect then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonSettlementMemberRewardCancel, self.data.uid)
    else
      self.ctrl:CloseSelf()
    end
    return
  end
  local rewardIndex = DataCenter.SeasonRewardDataManager:GetRewardIndexBySelectIndex(self.curSelect)
  if -1 < rewardIndex and self.preRewardIndex ~= rewardIndex then
    if self.rewardRemain[self.curSelect] == 0 then
      UIUtil.ShowTipsId("season_s3_rank_reward_28")
      return
    end
    SFSNetwork.SendMessage(MsgDefines.LWSeasonSettlementMemberReward, self.data.uid, rewardIndex)
  else
    self.ctrl:CloseSelf()
  end
end

local function DistributeRewardSuccess(self)
  UIUtil.ShowTipsId("season_reward_ui_018")
  self.ctrl:CloseSelf()
end

local function UpdateMemberDetailInfo(self)
  self:RefreshRewardInfo()
  self:RefreshMemberDetailInfo()
end

UILWSeasonDistributeAwardView.OnCreate = OnCreate
UILWSeasonDistributeAwardView.OnDestroy = OnDestroy
UILWSeasonDistributeAwardView.OnEnable = OnEnable
UILWSeasonDistributeAwardView.OnDisable = OnDisable
UILWSeasonDistributeAwardView.ComponentDefine = ComponentDefine
UILWSeasonDistributeAwardView.ComponentDestroy = ComponentDestroy
UILWSeasonDistributeAwardView.DataDefine = DataDefine
UILWSeasonDistributeAwardView.DataDestroy = DataDestroy
UILWSeasonDistributeAwardView.OnAddListener = OnAddListener
UILWSeasonDistributeAwardView.OnRemoveListener = OnRemoveListener
UILWSeasonDistributeAwardView.SaveBtnClick = SaveBtnClick
UILWSeasonDistributeAwardView.RefreshView = RefreshView
UILWSeasonDistributeAwardView.SetSelect = SetSelect
UILWSeasonDistributeAwardView.RefreshRewardInfo = RefreshRewardInfo
UILWSeasonDistributeAwardView.RefreshMemberDetailInfo = RefreshMemberDetailInfo
UILWSeasonDistributeAwardView.DistributeRewardSuccess = DistributeRewardSuccess
UILWSeasonDistributeAwardView.UpdateMemberDetailInfo = UpdateMemberDetailInfo
return UILWSeasonDistributeAwardView
