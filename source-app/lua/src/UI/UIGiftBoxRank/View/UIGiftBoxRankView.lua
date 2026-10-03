local UIGiftBoxRankView = BaseClass("UIGiftBoxRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGiftBoxRankItem = require("UI.UIGiftBoxRank.Component.UIGiftBoxRankItem")
local UIGiftBoxRankRewardItem = require("UI.UIGiftBoxRank.Component.UIGiftBoxRankRewardItem")
local ToggleType = {
  None = 0,
  Rank = 1,
  Reward = 2
}
local SegmentName = {
  [ToggleType.Rank] = 2800053,
  [ToggleType.Reward] = 2800055
}

function UIGiftBoxRankView:OnCreate()
  base.OnCreate(self)
  self.curSegment = ToggleType.None
  self._desc1_txt = self:AddComponent(UIText, "safeArea/Desc1")
  self._desc2_txt = self:AddComponent(UIText, "safeArea/Desc2")
  self._desc2_txt:SetLocalText(2800061)
  self._desc3_txt = self:AddComponent(UIText, "safeArea/Scroll View/Viewport/Content/Desc3")
  self._desc3_txt:SetActive(false)
  self._desc4_txt = self:AddComponent(UIText, "safeArea/Scroll View/Viewport/Content/Desc4")
  self._desc4_txt:SetActive(false)
  self._desc5_txt = self:AddComponent(UIText, "safeArea/Scroll View/Viewport/Content/Desc5")
  self._desc5_txt:SetActive(false)
  self._desc6_txt = self:AddComponent(UIText, "safeArea/Scroll View/Viewport/Content/Desc6")
  self._desc6_txt:SetActive(false)
  self._desc_list = {
    self._desc3_txt,
    self._desc4_txt,
    self._desc5_txt,
    self._desc6_txt
  }
  self._selfRank_txt = self:AddComponent(UIText, "safeArea/RankingContent/SelfObj/RankIconNum")
  self._selfRank_img = self:AddComponent(UIImage, "safeArea/RankingContent/SelfObj/RankIcon")
  self._selfName_txt = self:AddComponent(UIText, "safeArea/RankingContent/SelfObj/NameTxt")
  self._selfScore_txt = self:AddComponent(UIText, "safeArea/RankingContent/SelfObj/ScoreTxt")
  self._selfNoRank_txt = self:AddComponent(UIText, "safeArea/RankingContent/SelfObj/NoRankText")
  self._selfNoRank_txt:SetLocalText(2800057)
  self._selfHead = self:AddComponent(UICommonHead, "safeArea/RankingContent/SelfObj/playerFlag/UIPlayerHead")
  self._self_reward = self:AddComponent(UIGiftBoxRankRewardItem, "safeArea/RewardContent/SelfReward")
  self.segmentN = self:AddComponent(UIBaseContainer, "safeArea/ToggleGroup")
  self.segmentTbN = {}
  for i = 1, 2 do
    local segment = self:AddComponent(UIBaseContainer, "safeArea/ToggleGroup/Toggle" .. i)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickSegment(i)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local selectTxt = segment:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(SegmentName[i])
    local unselectTxt = segment:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(SegmentName[i])
    local red = segment:AddComponent(UIBaseContainer, "RedDot1")
    local newSeg = {
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      redN = red,
      btnN = btn
    }
    table.insert(self.segmentTbN, newSeg)
  end
  self.scroll_rank_view = self:AddComponent(UIScrollView, "safeArea/RankingContent/Container1Go/RectScroll1")
  self.scroll_rank_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scroll_rank_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.scroll_reward_view = self:AddComponent(UIScrollView, "safeArea/RewardContent/Container1Go/RectScroll2")
  self.scroll_reward_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scroll_reward_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self._noRank_txt = self:AddComponent(UIText, "safeArea/RankingContent/TxtEmpty")
  self._tips_txt = self:AddComponent(UIText, "safeArea/BottomBar/tips")
  self._building_img = self:AddComponent(UIImage, "BuildingIcon")
  self._ranking_content = self:AddComponent(UIBaseContainer, "safeArea/RankingContent")
  self._reward_content = self:AddComponent(UIBaseContainer, "safeArea/RewardContent")
  self.panelTbN = {
    self._ranking_content,
    self._reward_content
  }
end

function UIGiftBoxRankView:OnDestroy()
  self.actEnd = nil
  self.curSegment = nil
  self:ClearRankScroll()
  self:ClearRewardScroll()
  base.OnDestroy(self)
end

function UIGiftBoxRankView:OnEnable()
  base.OnEnable(self)
  self._noRank_txt:SetActive(false)
end

function UIGiftBoxRankView:OnDisable()
  base.OnDisable(self)
end

function UIGiftBoxRankView:SetData(actId, activityId)
  self.activityId = tonumber(string.match(tostring(actId), "(%d+)"))
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(self.activityId))
  if actData then
    self.actEndTime = actData.endTime
  end
  self:Update1000MS()
  self:ShowDecorationText()
  self:SelectSegment(ToggleType.Rank)
end

function UIGiftBoxRankView:Update1000MS()
  if self.actEndTime and not self.actEnd then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.actEndTime then
      self.actEnd = true
      UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        EventManager:GetInstance():Broadcast(EventId.ActGiftBoxTimeEnd)
      end, nil, function()
        EventManager:GetInstance():Broadcast(EventId.ActGiftBoxTimeEnd)
      end)
      return
    end
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.actEndTime - curTime)
    self._tips_txt:SetLocalText(2800060, timeStr)
  end
end

function UIGiftBoxRankView:ShowDecorationText()
  local template = DataCenter.ActGiftBoxData:GetActTemplateByActId(tonumber(self.activityId))
  local buildingId = template.show_building
  local decorationBuildingExist = buildingId and buildingId ~= 0
  self._building_img:SetActive(decorationBuildingExist)
  self._desc1_txt:SetActive(decorationBuildingExist)
  self._desc2_txt:SetActive(decorationBuildingExist)
  if decorationBuildingExist then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId, 0)
    self._desc1_txt:SetLocalText(buildTemplate.name)
    self._building_img:LoadSpriteAuto(buildTemplate:GetBuildIconOutCity())
    local count = 1
    for k, v in pairs(buildTemplate.building_effect_last) do
      local desc = WorkerUtil.GetEffectText(k, v)
      if count <= #self._desc_list then
        self._desc_list[count]:SetText(desc)
        self._desc_list[count]:SetActive(true)
      end
      count = count + 1
    end
  end
end

function UIGiftBoxRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftBoxRankUpdate, self.OnRefresh)
end

function UIGiftBoxRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftBoxRankUpdate, self.OnRefresh)
end

function UIGiftBoxRankView:OnRefresh()
  if self.curSegment == ToggleType.Rank then
    self:OnRefreshRank()
  elseif self.curSegment == ToggleType.Reward then
    self:OnRefreshReward()
  end
end

function UIGiftBoxRankView:RefreshRank()
  SFSNetwork.SendMessage(MsgDefines.GetGiftBoxRank, tonumber(self.activityId))
end

function UIGiftBoxRankView:OnRefreshRank()
  PostEventLog.Track(PostEventLog.Defines.OpenGiftBoxGetKeyPanel, {tab = 1})
  self.actData = DataCenter.ActGiftBoxData:GetInfoByActId(tonumber(self.activityId))
  local dataReach = self.actData:IsRankDataReach()
  if self.actData and dataReach then
    if LuaEntry.Player:IsInAlliance() then
      local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      self._selfName_txt:SetText("[" .. allInfo.abbr .. "]" .. LuaEntry.Player.name)
    else
      self._selfName_txt:SetText(LuaEntry.Player.name)
    end
    if self.actData.selfRank == -1 then
      self._selfRank_txt:SetLocalText(2800058)
      self._selfNoRank_txt:SetActive(true)
    else
      self._selfRank_txt:SetText(self.actData.selfRank)
      self._selfNoRank_txt:SetActive(false)
    end
    self._selfScore_txt:SetText(self.actData.selfRankScore)
    self._selfScore_txt:SetColor(Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1))
    self._selfHead:SetData(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
    self:ClearRankScroll()
    self.rankList = self.actData:GetRankList()
    self.rewardArr = self.actData:GetRewardArr()
    local selfRank = self.actData.selfRank
    self:SetRankIcon(selfRank)
    if self.rankList and #self.rankList > 0 then
      self.scroll_rank_view:SetTotalCount(#self.rankList)
      self.scroll_rank_view:RefillCells()
    else
      self._noRank_txt:SetActive(true)
      self._noRank_txt:SetLocalText(110534)
    end
  end
end

function UIGiftBoxRankView:RefreshReward()
  SFSNetwork.SendMessage(MsgDefines.GetGiftBoxRank, tonumber(self.activityId))
end

function UIGiftBoxRankView:OnRefreshReward()
  PostEventLog.Track(PostEventLog.Defines.OpenGiftBoxGetKeyPanel, {tab = 2})
  self.actData = DataCenter.ActGiftBoxData:GetInfoByActId(tonumber(self.activityId))
  local dataReach = self.actData:IsRankDataReach()
  if self.actData and dataReach then
    self:ClearRewardScroll()
    self.rankList = self.actData:GetRankList()
    self.rewardArr = self.actData:GetRewardArr()
    if self.rewardArr and #self.rewardArr > 0 then
      self.scroll_reward_view:SetTotalCount(#self.rewardArr)
      self.scroll_reward_view:RefillCells()
    else
      self._noRank_txt:SetActive(true)
      self._noRank_txt:SetLocalText(110534)
    end
    self:RefreshSelfReward(self.actData.selfRank)
  end
end

function UIGiftBoxRankView:SetRankIcon(rank)
  self._selfRank_img:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      self._selfRank_img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif rank == 2 then
      self._selfRank_img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif rank == 3 then
      self._selfRank_img:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
    end
  end
end

function UIGiftBoxRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_rank_view:AddComponent(UIGiftBoxRankItem, itemObj)
  cellItem:RefreshData(self.rankList[index], self.rewardArr)
end

function UIGiftBoxRankView:OnRankItemMoveOut(itemObj, index)
  self.scroll_rank_view:RemoveComponent(itemObj.name, UIGiftBoxRankItem)
end

function UIGiftBoxRankView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_reward_view:AddComponent(UIGiftBoxRankRewardItem, itemObj)
  local data = {}
  data.beginRank = self.rewardArr[index].startN
  data.endRank = self.rewardArr[index].endN
  data.uid = nil
  cellItem:RefreshData(data, self.rewardArr[index].reward, BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnBeginDrag), BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnEndDrag), BindCallback(self.scroll_reward_view, self.scroll_reward_view.OnDrag))
end

function UIGiftBoxRankView:OnRewardItemMoveOut(itemObj, index)
  self.scroll_reward_view:RemoveComponent(itemObj.name, UIGiftBoxRankRewardItem)
end

function UIGiftBoxRankView:ClearRankScroll()
  self.scroll_rank_view:ClearCells()
  self.scroll_rank_view:RemoveComponents(UIGiftBoxRankItem)
end

function UIGiftBoxRankView:ClearRewardScroll()
  self.scroll_reward_view:ClearCells()
  self.scroll_reward_view:RemoveComponents(UIGiftBoxRankRewardItem)
end

function UIGiftBoxRankView:RefreshSelfReward(selfRank)
  for k, v in ipairs(self.rewardArr) do
    if selfRank >= v.startN and selfRank <= v.endN then
      self._self_reward:RefreshData({
        uid = LuaEntry.Player.uid,
        beginRank = v.startN,
        endRank = v.endN
      }, v.reward)
      return
    end
  end
  self._self_reward:RefreshData({
    uid = LuaEntry.Player.uid,
    beginRank = -1,
    endRank = -1
  }, nil)
end

function UIGiftBoxRankView:OnClickSegment(index)
  self:SelectSegment(index)
end

function UIGiftBoxRankView:SelectSegment(seg)
  self.curSegment = seg
  for i, v in ipairs(self.segmentTbN) do
    if i == seg then
      v.selectN:SetActive(true)
    else
      v.selectN:SetActive(false)
    end
  end
  for i = 1, 2 do
    if i == seg then
      self.panelTbN[i]:SetActive(true)
      self:ShowPanel()
    else
      self.panelTbN[i]:SetActive(false)
    end
  end
end

function UIGiftBoxRankView:ShowPanel()
  if self.curSegment == ToggleType.Rank then
    self:RefreshRank()
  elseif self.curSegment == ToggleType.Reward then
    self:RefreshReward()
  end
end

return UIGiftBoxRankView
