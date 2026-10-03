local AllyDuelLeagueRank = BaseClass("AllyDuelLeagueRank", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllyDuelLeagueRankItem = require("UI.UIAllyDuel.Component.AllyDuelLeagueRank.AllyDuelLeagueRankItem")
local SpritePath = {
  [0] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanqupaiming_lose.png",
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanqupaiming_win.png"
}

function AllyDuelLeagueRank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelLeagueRank:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelLeagueRank:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.title = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.timeTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.cupBg = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.cup = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.grade = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.upGrade = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.downGrade = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.counting = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 10)
  self.infoBtn = self.viewSkin:AddComponent(self, UIButton, 11)
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.tipCloseBtn = self.viewSkin:AddComponent(self, UIButton, 12)
  self.tipCloseBtn:SetOnClick(function()
    self:OnTipCloseBtnClick()
  end)
  self.tip = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.tipBg = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.titleGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.btnRewardInfo = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnRewardInfo:SetOnClick(function()
    self:OnBtnRewardInfoClick()
  end)
  self.btnMore = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnMore:SetOnClick(function()
    self:OnBtnMoreClick()
  end)
  self.compRewards = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.submitTip = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.compGrading = self.viewSkin:AddComponent(self, UIHorizontalOrVerticalLayoutGroup, 20)
end

function AllyDuelLeagueRank:ComponentDestroy()
  self.viewSkin = nil
  self.title = nil
  self.timeTxt = nil
  self.cupBg = nil
  self.cup = nil
  self.grade = nil
  self.upGrade = nil
  self.downGrade = nil
  self.counting = nil
  self.content = nil
  self.scrollView = nil
  self.infoBtn = nil
  self.tipCloseBtn = nil
  self.tip = nil
  self.tipBg = nil
  self.titleGroup = nil
  self.btnRewardInfo = nil
  self.btnMore = nil
  self.compRewards = nil
  self.submitTip = nil
  self.compGrading = nil
end

function AllyDuelLeagueRank:DataDefine()
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.tip:SetActive(false)
  self.week = {}
  self.rewards = {}
  for i = 1, 5 do
    if i < 5 then
      self.week[i] = self.tipBg:AddComponent(UIImage, "week" .. i)
      local text = self.tipBg:AddComponent(UITextMeshProUGUIEx, "text" .. i)
      text:SetLocalText(459009, i)
      local text2 = self.titleGroup:AddComponent(UITextMeshProUGUIEx, "week" .. i)
      text2:SetLocalText(459009, i)
    end
  end
  DataCenter.LeagueMatchManager:CheckSeasonGradePopSign()
end

function AllyDuelLeagueRank:DataDestroy()
  self:RemoveReward()
  self:ClearScroll()
  self.allianceList = nil
end

function AllyDuelLeagueRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnLeagueMatchGroupUpdate, self.RefreshAll)
  self:AddUIListener(EventId.OnLastLeagueMatchGroupInfoUpdate, self.RefreshAll)
  self:AddUIListener(EventId.AllyDuelLeagueRankItemTip, self.ShowTip)
  self:AddUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.UpdateReward)
end

function AllyDuelLeagueRank:OnRemoveListener()
  self:RemoveUIListener(EventId.OnLeagueMatchGroupUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.OnLastLeagueMatchGroupInfoUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.AllyDuelLeagueRankItemTip, self.ShowTip)
  self:RemoveUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.UpdateReward)
  base.OnRemoveListener(self)
end

function AllyDuelLeagueRank:OnHistoryBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelLeagueHistory, {anim = true})
end

function AllyDuelLeagueRank:OnInfoBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIUtil.ShowIntro(Localization:GetString("100239"), Localization:GetString("100239"), Localization:GetString("459036"))
end

function AllyDuelLeagueRank:OnTipCloseBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.tip:SetActive(false)
end

function AllyDuelLeagueRank:OnBtnRewardInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if string.IsNullOrEmpty(self.requireStr) then
    return
  end
  UIUtil.ShowBubbleTips(self.requireStr, self.btnRewardInfo.transform.position, 0, -20, -20)
end

function AllyDuelLeagueRank:OnBtnMoreClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.view:OnClickRewardBtn()
end

function AllyDuelLeagueRank:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cell = self.scrollView:AddComponent(AllyDuelLeagueRankItem, itemObj)
  cell:Refresh(self.allianceList[index], index <= self.upCount, index > #self.allianceList - self.downCount)
end

function AllyDuelLeagueRank:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, AllyDuelLeagueRankItem)
end

function AllyDuelLeagueRank:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(AllyDuelLeagueRankItem)
end

function AllyDuelLeagueRank:ShowTip(param)
  self.tip:SetActive(true)
  local data, pos = param.data, param.pos
  local arr = string.split(data, ";")
  self.tipBg:SetPosition(pos)
  for i = 1, 4 do
    if arr[i] == nil then
      self.week[i]:SetActive(false)
    else
      self.week[i]:SetActive(true)
      self.week[i]:LoadSpriteAuto(SpritePath[tonumber(arr[i])])
    end
  end
end

function AllyDuelLeagueRank:ShowPanel()
  DataCenter.LeagueMatchManager:TryUpdateLeagueMatchGroup()
  local weekCount = DataCenter.LeagueMatchManager:GetWeekCount()
  DataCenter.LeagueMatchManager:FetchAlBattleAllWeekVsInfo(weekCount)
  self:RefreshAll()
end

function AllyDuelLeagueRank:RefreshAll()
  local isSubmitting = DataCenter.LeagueMatchManager:CheckIsSubmitting()
  self.submitTip:SetActive(isSubmitting)
  local baseInfo = DataCenter.LeagueMatchManager:GetLeagueMatchBaseInfo()
  self.endTime = baseInfo ~= nil and baseInfo.seasonEndTime or 0
  local season = baseInfo ~= nil and baseInfo.season or 0
  self.title:SetLocalText("459001", season)
  local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
  if not duelInfo then
    return
  end
  DataCenter.LeagueMatchManager:SetCup(self.cup, self.cupBg, self.grade)
  local upCount, downCount = DataCenter.LeagueMatchManager:GetUpDownCount()
  local prev, next = DataCenter.LeagueMatchManager:GetGroupName()
  self.upGrade:SetActive(0 < upCount)
  local cnt = 0
  if 0 < upCount then
    cnt = cnt + 1
    self.upGrade:SetLocalText(459011, upCount, next)
  end
  self.downGrade:SetActive(0 < downCount)
  if 0 < downCount then
    cnt = cnt + 1
    self.downGrade:SetLocalText(459012, downCount, prev)
  end
  local bCSow = upCount + downCount <= 0
  self.counting:SetActive(bCSow)
  if bCSow then
    self.compGrading:SetPaddingLeft(28)
  else
    self.compGrading:SetPaddingLeft(75)
  end
  local maxX, maxY = self.scrollView:GetOffsetMaxXY()
  if 1 < cnt then
    self.scrollView:SetOffsetMaxXY(maxX, -727)
  else
    self.scrollView:SetOffsetMaxXY(maxX, -670)
  end
  self.upCount, self.downCount = upCount, downCount
  self:RefreshRank()
  self:RefreshReward()
  self:Update1000MS()
end

function AllyDuelLeagueRank:RefreshRank()
  self.allianceList = DataCenter.LeagueMatchManager:GetLastOrCurMatchGroupInfo()
  local cnt = #self.allianceList
  if cnt == 0 then
    self:ClearScroll()
  else
    self.scrollView:SetTotalCount(cnt)
    self.scrollView:RefillCells()
  end
  for i, al in ipairs(self.allianceList) do
    if al.allianceId == LuaEntry.Player:GetAllianceUid() then
      self.scrollView:ScrollToCell(i, 1000)
      break
    end
  end
end

function AllyDuelLeagueRank:RefreshReward()
  DataCenter.LeagueMatchManager:GetLeagueMatchRewardInfoReq(3)
  self:UpdateReward()
end

function AllyDuelLeagueRank:UpdateReward()
  local curSegment = DataCenter.LeagueMatchManager:GetSegment()
  local rewardInfos, require = DataCenter.LeagueMatchManager:GetRewardInfo(3, curSegment)
  if rewardInfos == nil then
    return
  end
  if require and 0 < require then
    local curScore = DataCenter.LeagueMatchManager:GetMyScoreThisMonth()
    local color = require > curScore and "FF5645" or "25FF00"
    curScore = string.format("<color=#%s> %s </color>", color, string.GetFormattedSeparatorNum(math.floor(curScore)))
    require = string.GetFormattedSeparatorNum(require)
    self.requireStr = Localization:GetString("alliance_duel_tips10030", curScore, require)
  else
    self.requireStr = nil
  end
  local myCur = DataCenter.LeagueMatchManager:GetMyAllyCurRank()
  local curRankInAlly = DataCenter.LeagueMatchManager:GetCurRankInAlly() or 1
  local rewardInfo
  if myCur and curRankInAlly then
    for _, v in pairs(rewardInfos) do
      local fromI = v.start
      local toI = v["end"]
      if myCur >= fromI and myCur <= toI then
        local rewardList = v.userRankRewards
        for _, vv in pairs(rewardList) do
          local from = vv.start
          local to = vv["end"]
          if curRankInAlly >= from and curRankInAlly <= to then
            rewardInfo = vv
            break
          end
        end
      end
      if rewardInfo ~= nil then
        break
      end
    end
  end
  local rewardsList, rewardCount
  if rewardInfo == nil then
    rewardsList = {}
    rewardCount = 0
  else
    rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo.reward) or {}
    for i, v in ipairs(rewardsList) do
      if v.rewardType == RewardType.GOLD then
        local tempR = v
        table.remove(rewardsList, i)
        table.insert(rewardsList, 1, tempR)
        break
      end
    end
    rewardCount = #rewardsList
  end
  self:RemoveReward()
  local scale = 0.7
  for i = 1, rewardCount do
    local reward = rewardsList[i]
    self.rewards[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.compRewards.transform)
      transform:Set_localScale(scale, scale, scale)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.compRewards:AddComponent(UICommonResItem, nameStr)
      cell:SetSizeDelta(ResetCommonResSize)
      cell:ReInit(reward)
    end)
  end
end

function AllyDuelLeagueRank:RemoveReward()
  self.compRewards:RemoveComponents(UICommonResItem)
  if self.rewards then
    for _, v in pairs(self.rewards) do
      v:Destroy()
    end
  end
  self.rewards = {}
end

function AllyDuelLeagueRank:Update1000MS()
  if self.endTime == nil or self.endTime == 0 then
    return
  end
  local UITMgr = UITimeManager:GetInstance()
  local curTime = UITMgr:GetServerTime()
  local leftTime = self.endTime - curTime
  if 0 < leftTime then
    self.timeTxt:SetText(UITMgr:MilliSecondToFmtString(leftTime))
  else
    self.timeTxt:SetLocalText(370100)
  end
end

return AllyDuelLeagueRank
