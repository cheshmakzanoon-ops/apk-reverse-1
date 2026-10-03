local AllyDuelHistoryReward = BaseClass("AllyDuelHistoryReward", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local EX_PATH = "Assets/Main/TextureEx/UIActivityBg/AllyDuel/%s.png"

function AllyDuelHistoryReward:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelHistoryReward:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelHistoryReward:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.rawImgIcon = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.rawImgTop = self.viewSkin:AddComponent(self, UIRawImage, 5)
end

function AllyDuelHistoryReward:ComponentDestroy()
  self.viewSkin = nil
  self.textTitleTxt = nil
  self.rawImgIcon = nil
  self.btnInfo = nil
  self.compContent = nil
  self.rawImgTop = nil
end

function AllyDuelHistoryReward:DataDefine()
end

function AllyDuelHistoryReward:DataDestroy()
  self:RemoveReward()
end

function AllyDuelHistoryReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.UpdateLeagueReward)
end

function AllyDuelHistoryReward:OnRemoveListener()
  self:RemoveUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.UpdateLeagueReward)
  base.OnRemoveListener(self)
end

function AllyDuelHistoryReward:OnBtnInfoClick()
  UIUtil.ShowBubbleTips(self.requireStr, self.btnInfo.transform.position, 0, -20, -20)
end

function AllyDuelHistoryReward:SetData(rewardInfo, num, segment, bWin)
  self.num = num
  self.bWin = bWin
  local curScore = string.format(" %s ", string.GetFormattedSeparatorNum(self.num))
  self.requireStr = Localization:GetString(self.bWin and 372643 or 372644, curScore)
  self.textTitleTxt:SetLocalText(bWin and 372640 or 372641)
  self:SetSegment(segment, bWin)
  self:UpdateList(rewardInfo)
end

function AllyDuelHistoryReward:SetSegment(segment, bWin)
  local exNum = 3
  if segment == SegmentType.Diamond then
    exNum = 1
  elseif segment == SegmentType.Gold then
    exNum = 2
  end
  self.segment = segment
  self.rawImgTop:LoadSpriteAuto(string.format(EX_PATH, bWin and "lrb_lianmengduijue_liansai_jianlibiaoti" or "lrb_lianmengduijue_liansai_cijijianlibiaoti"))
  self.rawImgIcon:LoadSpriteAuto(string.format(EX_PATH, "lrb_LMDJ_duanwei_" .. exNum))
end

function AllyDuelHistoryReward:RemoveReward()
  self.compContent:RemoveComponents(UICommonResItem)
  if self.itemReqs then
    for _, v in pairs(self.itemReqs) do
      v:Destroy()
    end
  end
  self.itemReqs = {}
end

function AllyDuelHistoryReward:CheckRewardsChanged(rewardsList)
  if table.IsNullOrEmpty(self.rewardsList) or table.IsNullOrEmpty(rewardsList) then
    return true
  end
  if #self.rewardsList ~= #rewardsList then
    return true
  end
  for i, reward in ipairs(rewardsList) do
    local curInfo = self.rewardsList[i]
    if curInfo == nil then
      return true
    end
    if curInfo.itemId ~= reward.itemId then
      return true
    end
    if curInfo.count ~= reward.count then
      return true
    end
  end
  return false
end

function AllyDuelHistoryReward:UpdateList(rewardInfo)
  local rewardsList
  if rewardInfo == nil then
    rewardsList = {}
  else
    rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo) or {}
  end
  for i, v in ipairs(rewardsList) do
    if v.rewardType == RewardType.GOLD then
      local tempR = v
      table.remove(rewardsList, i)
      table.insert(rewardsList, 1, tempR)
      break
    end
  end
  if not self:CheckRewardsChanged(rewardsList) then
    return
  end
  self.rewardsList = rewardsList
  self:RemoveReward()
  for i, reward in ipairs(rewardsList) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.compContent.transform)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.compContent:AddComponent(UICommonResItem, nameStr)
      cell:SetLocalScale(ResetScale)
      cell:SetSizeDelta(ResetCommonResSize)
      cell:ReInit(reward)
    end)
  end
end

function AllyDuelHistoryReward:SetLeague(segment)
  self:SetSegment(segment, true)
  self:UpdateLeagueReward()
end

function AllyDuelHistoryReward:UpdateLeagueReward()
  local rewardInfos, require = DataCenter.LeagueMatchManager:GetRewardInfo(3, self.segment)
  if rewardInfos == nil then
    return
  end
  if require and 0 < require then
    local curScore = DataCenter.LeagueMatchManager:GetMyScoreThisMonth()
    local color = require > curScore and "FF5645" or "2AC21E"
    curScore = string.format("<color=#%s> %s </color>", color, string.GetFormattedSeparatorNum(math.floor(curScore)))
    require = string.GetFormattedSeparatorNum(require)
    self.requireStr = Localization:GetString("alliance_duel_tips10030", curScore, require)
  end
  local myCur = DataCenter.LeagueMatchManager:GetMyAllyCurRank() or 1
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
        if fromI == toI then
          self.textTitleTxt:SetLocalText(459021, fromI)
          break
        end
        self.textTitleTxt:SetLocalText(459021, fromI .. "~" .. toI)
        break
      end
    end
  end
  if rewardInfo == nil then
    self.textTitleTxt:SetText("")
  end
  self:UpdateList(rewardInfo ~= nil and rewardInfo.reward or nil)
end

return AllyDuelHistoryReward
