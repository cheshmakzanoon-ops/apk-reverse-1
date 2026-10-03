local MailAlCompeteWeekReport = BaseClass("MailAlCompeteWeekReport", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local AllianceCompeteScheduleItem = require("UI.UIAllianceCompete.UIAllianceCompeteSchedule.Component.AllianceCompeteScheduleItem")
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local Win_path = "Win"
local txt_WinTime_path = "Win/txt_WinTime"
local img_Win_path = "Win/img_Win"
local txt_Dialog1_Win_path = "Win/txt_Dialog1_Win"
local img_Alliance_Win_path = "Win/img_Alliance_Win"
local img_Line_Win_path = "Win/img_Line_Win"
local txt_AllianceName_Win_path = "Win/txt_AllianceName_Win"
local txt_Dialog2_Win_path = "Win/txt_Dialog2_Win"
local Fail_path = "Fail"
local txt_FailTime_path = "Fail/txt_FailTime"
local img_Fail_path = "Fail/img_Fail"
local txt_Dialog1_Fail_path = "Fail/txt_Dialog1_Fail"
local img_Alliance_Fail_path = "Fail/img_Alliance_Fail"
local img_Line_Fail_path = "Fail/img_Line_Fail"
local txt_AllianceName_Fail_path = "Fail/txt_AllianceName_Fail"
local txt_Dialog2_Fail_path = "Fail/txt_Dialog2_Fail"
local Win_Reward_path = "Win_Reward"
local txt_Reward_path = "Win_Reward/txt_Reward"
local btn_Receive_path = "Win_Reward/btn_Receive"
local txt_Receive_path = "Win_Reward/btn_Receive/txt_Receive"
local RewardGrid_path = "Win_Reward/RewardGrid"
local MVP_path = "MVP"
local txt_MVP_path = "MVP/txt_MVP"
local img_MVP_BG_path = "MVP/img_MVP_BG"
local txt_MVP_Name_path = "MVP/txt_MVP_Name"
local img_MVP_Icon_path = "MVP/img_MVP_BG/UIPlayerHead/HeadIcon"
local Competition_path = "Competition"
local CompetitionContent_path = "Competition/CompetitionContent"
local CompetitionTitle_path = "Competition/CompetitionContent/CompetitonTitle"
local txt_Date_path = "Competition/CompetitionContent/CompetitonTitle/txt_Date"
local txt_Match_path = "Competition/CompetitionContent/CompetitonTitle/txt_Match"
local txt_WinningPoints_path = "Competition/CompetitionContent/CompetitonTitle/txt_WinningPoints"
local txt_TheWinner_path = "Competition/CompetitionContent/CompetitonTitle/txt_TheWinner"
local CompetitionContentList_path = "Competition/CompetitionContent/CompetitionContentList"
local LFAllianceBattleActMailView_CompetitionItem_path = "temp/LFAllianceBattleActMailView_CompetitionItem"
local AllianceCompeteScheduleItem_path = "temp/AllianceCompeteScheduleItem"
local AllianceCompeteRewardItem_path = "temp/UICommonResItem"
local LFAllianceBattleActMailView_RewardItem_path = "temp/LFAllianceBattleActMailView_RewardItem"
local txt_Received_path = "Win_Reward/txt_Received"
local txt_NoReward_path = "Win_Reward/txt_NoReward"
local title_path = "Title"
local serverNameL_path = "Title/serverNameL"
local serverNameR_path = "Title/serverNameR"
local alNameL_path = "Title/alNameL"
local alNameR_path = "Title/alNameR"
local titleResultWin_path = "Title/win_bg/result_win"
local titleResultLose_path = "Title/lose_bg/result_lose"
local titleResultWinBg_path = "Title/win_bg"
local titleResultLoseBg_path = "Title/lose_bg"

local function OnCreate(self)
  base.OnCreate(self)
  self.Win = self:AddComponent(UIBaseContainer, Win_path)
  self.txt_WinTime = self:AddComponent(UIText, txt_WinTime_path)
  self.img_Win = self:AddComponent(UIImage, img_Win_path)
  self.txt_Dialog1_Win = self:AddComponent(UIText, txt_Dialog1_Win_path)
  self.img_Alliance_Win = self:AddComponent(UIImage, img_Alliance_Win_path)
  self.img_Line_Win = self:AddComponent(UIImage, img_Line_Win_path)
  self.txt_AllianceName_Win = self:AddComponent(UIText, txt_AllianceName_Win_path)
  self.txt_Dialog2_Win = self:AddComponent(UIText, txt_Dialog2_Win_path)
  self.Fail = self:AddComponent(UIBaseContainer, Fail_path)
  self.txt_FailTime = self:AddComponent(UIText, txt_FailTime_path)
  self.img_Fail = self:AddComponent(UIImage, img_Fail_path)
  self.txt_Dialog1_Fail = self:AddComponent(UIText, txt_Dialog1_Fail_path)
  self.img_Alliance_Fail = self:AddComponent(UIImage, img_Alliance_Fail_path)
  self.img_Line_Fail = self:AddComponent(UIImage, img_Line_Fail_path)
  self.txt_AllianceName_Fail = self:AddComponent(UIText, txt_AllianceName_Fail_path)
  self.txt_Dialog2_Fail = self:AddComponent(UIText, txt_Dialog2_Fail_path)
  self.Win_Reward = self:AddComponent(UIBaseContainer, Win_Reward_path)
  self.txt_Reward = self:AddComponent(UIText, txt_Reward_path)
  self.btn_Receive = self:AddComponent(UIButton, btn_Receive_path)
  self.btn_Receive:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickClaimRewards()
  end)
  self.txt_Receive = self:AddComponent(UIText, txt_Receive_path)
  self.RewardGrid = self:AddComponent(UIBaseContainer, RewardGrid_path)
  self.MVP = self:AddComponent(UIBaseContainer, MVP_path)
  self.txt_MVP = self:AddComponent(UIText, txt_MVP_path)
  self.img_MVP_BG = self:AddComponent(UIImage, img_MVP_BG_path)
  self.txt_MVP_Name = self:AddComponent(UIText, txt_MVP_Name_path)
  self.img_MVP_Icon = self:AddComponent(UIPlayerHead, img_MVP_Icon_path)
  self.Competition = self:AddComponent(UIBaseContainer, Competition_path)
  self.CompetitionContent = self:AddComponent(UIBaseContainer, CompetitionContent_path)
  self.CompetitionTitle = self:AddComponent(UIText, CompetitionTitle_path)
  self.txt_Date = self:AddComponent(UIText, txt_Date_path)
  self.txt_Match = self:AddComponent(UIText, txt_Match_path)
  self.txt_WinningPoints = self:AddComponent(UIText, txt_WinningPoints_path)
  self.txt_TheWinner = self:AddComponent(UIText, txt_TheWinner_path)
  self.CompetitionContentList = self:AddComponent(UIBaseContainer, CompetitionContentList_path)
  self.LFAllianceBattleActMailView_CompetitionItem = self:AddComponent(UIBaseContainer, LFAllianceBattleActMailView_CompetitionItem_path)
  self.AllianceCompeteScheduleItem = self:AddComponent(UIBaseContainer, AllianceCompeteScheduleItem_path)
  self.AllianceCompeteScheduleItem.gameObject:GameObjectCreatePool()
  self.AllianceCompeteRewardItem = self:AddComponent(UIBaseContainer, AllianceCompeteRewardItem_path)
  self.AllianceCompeteRewardItem.gameObject:GameObjectCreatePool()
  self.LFAllianceBattleActMailView_RewardItem = self:AddComponent(UIBaseContainer, LFAllianceBattleActMailView_RewardItem_path)
  self.txt_Received = self:AddComponent(UIText, txt_Received_path)
  self.txt_NoReward = self:AddComponent(UIText, txt_NoReward_path)
  self.titleN = self:AddComponent(UIBaseContainer, title_path)
  self.serverNameLN = self:AddComponent(UIText, serverNameL_path)
  self.serverNameRN = self:AddComponent(UIText, serverNameR_path)
  self.alNameLN = self:AddComponent(UIText, alNameL_path)
  self.alNameRN = self:AddComponent(UIText, alNameR_path)
  self.titleResultWinN = self:AddComponent(UIText, titleResultWin_path)
  self.titleResultLoseN = self:AddComponent(UIText, titleResultLose_path)
  self.titleResultWinBgN = self:AddComponent(UIText, titleResultWinBg_path)
  self.titleResultLoseBgN = self:AddComponent(UIText, titleResultLoseBg_path)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListner(self)
  base.OnRemoveListener(self)
end

local function setData(self, mailInfo)
  self.mailInfo = mailInfo
  self:parseContent()
  self:Init()
end

local function parseContent(self)
  if self.mailInfo == nil then
    return
  end
  if string.IsNullOrEmpty(self.mailInfo.contents) then
    return
  end
  local contentData = rapidjson.decode(self.mailInfo.contents)
  local data = contentData.obj
  local alInfo = {}
  alInfo.abbr = data.alInfo.abbr
  alInfo.name = data.alInfo.name
  alInfo.icon = data.alInfo.icon
  alInfo.serverId = data.alInfo.serverId
  local vsAlInfo = {}
  vsAlInfo.abbr = data.vsAlInfo and data.vsAlInfo.abbr or "   "
  vsAlInfo.name = data.vsAlInfo and data.vsAlInfo.name or ""
  vsAlInfo.icon = data.vsAlInfo and data.vsAlInfo.icon or ""
  vsAlInfo.serverId = data.vsAlInfo and data.vsAlInfo.serverId or ""
  local mvpPlayer = {}
  mvpPlayer.uid = data.mvpPlayer.uid
  mvpPlayer.pic = data.mvpPlayer.pic
  mvpPlayer.picVer = data.mvpPlayer.picVer
  mvpPlayer.name = data.mvpPlayer.name
  self.allianceChanged = data.inAlliance == 0
  local weekInfo = {}
  table.walk(data.weekInfo, function(key, v)
    if v ~= nil then
      weekInfo[v.day] = {
        score = v.score,
        isWin = v.isWin,
        name = v.name
      }
    end
  end)
  local weekRewards = {}
  local rewardData = contentData.b
  if rewardData and rewardData.reward and rewardData.reward.rewardInfo then
    weekRewards = rewardData.reward.rewardInfo
  end
  self.alInfo = alInfo
  self.vsAlInfo = vsAlInfo
  self.mvpPlayer = mvpPlayer
  self.weekInfo = weekInfo
  self.curIsWin = data.weekWin == 1
  self.minScore = data.minScore
  self.weekRewards = weekRewards
end

local function Init(self)
  self:ShowTop()
  self:ShowMVP()
  self:ShowCompetitionSituation()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

local function ShowTop(self)
  self.txt_Received:SetLocalText(170003)
  local isVictory = self.curIsWin
  self.Win:SetActive(false)
  self.Fail:SetActive(false)
  self.titleN:SetActive(true)
  self.serverNameLN:SetText("#" .. self.alInfo.serverId)
  self.serverNameRN:SetText("#" .. self.vsAlInfo.serverId)
  self.alNameLN:SetText(string.format("[%s] %s", self.alInfo.abbr, self.alInfo.name))
  self.alNameRN:SetText(string.format("[%s] %s", self.vsAlInfo.abbr, self.vsAlInfo.name))
  if isVictory then
    self.titleResultWinN:SetLocalText(372108)
    self.titleResultWinBgN:SetActive(true)
    self.titleResultLoseBgN:SetActive(false)
    self.Win_Reward:SetActive(true)
    self:ShowVictoryReward()
  else
    self.titleResultLoseN:SetLocalText(372109)
    self.titleResultWinBgN:SetActive(false)
    self.titleResultLoseBgN:SetActive(true)
    self.Win_Reward:SetActive(false)
  end
end

local function ShowVictoryReward(self)
  self.txt_Reward:SetLocalText(361053)
  self.txt_Receive:SetLocalText(170004)
  local tabReward = self.weekRewards
  local rt_Txt_Reward = self.txt_Reward.rectTransform
  local h_Txt_Reward = rt_Txt_Reward.rect.height
  local win_Reward = self.Win_Reward.rectTransform
  local curX = win_Reward.sizeDelta.x
  local totalH = 164
  local offsetY = 10
  if #tabReward == 0 then
    self.txt_Reward:SetActive(false)
    self.RewardGrid:SetActive(false)
    self.btn_Receive:SetActive(false)
    self.txt_Received:SetActive(false)
    if self.allianceChanged then
      self.txt_NoReward:SetLocalText(372166)
    else
      self.txt_NoReward:SetLocalText(361070, self.minScore)
    end
    self.txt_NoReward:SetActive(true)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt_NoReward.rectTransform)
    local rt_txt_NoReward = self.txt_NoReward.rectTransform
    local h_txt_NoReward = rt_txt_NoReward.rect.height
    totalH = h_Txt_Reward + h_txt_NoReward
    offsetY = 0
  else
    self.txt_Reward:SetActive(true)
    self.RewardGrid:SetActive(true)
    self.txt_NoReward:SetActive(false)
    if self.mailInfo.rewardStatus == 0 then
      self.btn_Receive:SetActive(true)
      self.txt_Received:SetActive(false)
    elseif self.mailInfo.rewardStatus == 1 then
      self.btn_Receive:SetActive(false)
      self.txt_Received:SetActive(true)
    end
    self.RewardGrid:RemoveComponents(MailRewardItem)
    self.AllianceCompeteRewardItem.gameObject:GameObjectRecycleAll()
    for i, v in ipairs(tabReward) do
      local tempType = v.type
      local itemId = v.id
      local count = tonumber(v.num)
      local item = self.AllianceCompeteRewardItem.gameObject:GameObjectSpawn(self.RewardGrid.transform)
      item.name = "item" .. i
      local obj = self.RewardGrid:AddComponent(MailRewardItem, item.name)
      local param = {}
      param.itemId = itemId
      param.rewardType = tempType
      param.count = count
      obj:RefreshData(param)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.RewardGrid.rectTransform)
  end
end

local function ShowMVP(self)
  if self.curIsWin then
    self.txt_MVP:SetLocalText(361047, self.alInfo.name, self.vsAlInfo.name)
  else
    self.txt_MVP:SetLocalText(361048, self.alInfo.name, self.vsAlInfo.name)
  end
  self.img_MVP_Icon:SetData(self.mvpPlayer.uid, self.mvpPlayer.pic, self.mvpPlayer.picVer)
  self.txt_MVP_Name:SetText(self.mvpPlayer.name)
end

local function ShowCompetitionSituation(self)
  self.txt_Date:SetLocalText(361016)
  self.txt_Match:SetLocalText(361017)
  self.txt_WinningPoints:SetLocalText(361018)
  self.txt_TheWinner:SetLocalText(361019)
  self.CompetitionContentList:RemoveComponents(AllianceCompeteScheduleItem)
  self.AllianceCompeteScheduleItem.gameObject:GameObjectRecycleAll()
  local list = self.weekInfo
  if list then
    for i = 1, table.length(list) do
      local item = self.AllianceCompeteScheduleItem.gameObject:GameObjectSpawn(self.CompetitionContentList.transform)
      item.name = "item" .. i
      local obj = self.CompetitionContentList:AddComponent(AllianceCompeteScheduleItem, item.name)
      obj:RefreshData(list[i], i, 0, true)
    end
  end
end

local function OnClickClaimRewards(self)
  DataCenter.MailDataManager:RewardMail(self.mailInfo.uid)
  self.btn_Receive:SetActive(false)
  self.txt_Received:SetActive(true)
  self.mailInfo.rewardStatus = 1
end

MailAlCompeteWeekReport.OnCreate = OnCreate
MailAlCompeteWeekReport.OnDestroy = OnDestroy
MailAlCompeteWeekReport.OnAddListener = OnAddListener
MailAlCompeteWeekReport.OnRemoveListner = OnRemoveListner
MailAlCompeteWeekReport.setData = setData
MailAlCompeteWeekReport.parseContent = parseContent
MailAlCompeteWeekReport.Init = Init
MailAlCompeteWeekReport.ShowTop = ShowTop
MailAlCompeteWeekReport.ShowVictoryReward = ShowVictoryReward
MailAlCompeteWeekReport.ShowMVP = ShowMVP
MailAlCompeteWeekReport.ShowCompetitionSituation = ShowCompetitionSituation
MailAlCompeteWeekReport.OnClickClaimRewards = OnClickClaimRewards
return MailAlCompeteWeekReport
