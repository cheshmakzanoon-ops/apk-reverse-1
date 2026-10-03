local UIIdleGameTaskEventAllianceHelpView = BaseClass("UIIdleGameTaskEventAllianceHelpView", UIBaseView)
local base = UIBaseView
local T11IdleGameEventData = require("DataCenter/T11IdleGame/IdleBattle/Data/T11IdleGameEventData")
local UIIdleGameTaskEventInvitePlayerItemComponent = require("UI.T11IdleGame.T11IdleGameTaskEventDetail.Component.UIIdleGameTaskEventInvitePlayerItemComponent")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local sendMsgTime = 0

function UIIdleGameTaskEventAllianceHelpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local userData = self:GetUserData()
  self.playerUid = userData.playerUid
  self.eventUuid = userData.eventUuid
  self.idleGameEventMsg = userData.idleGameEventMsg
  self.helpTimesDaily = userData.helpTimesDaily
  self:RefreshView(userData)
end

function UIIdleGameTaskEventAllianceHelpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIdleGameTaskEventAllianceHelpView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textEventTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textEventDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compOwnerPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 5)
  self.textRewardTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textParticipateTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.scrollRectPlayerList = self.viewSkin:AddComponent(self, UIScrollRect, 9)
  self.compHeadIconList = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.btnOK = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnOK:SetOnClick(function()
    self:OnBtnOKClick()
  end)
  self.textBtnOk = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
end

function UIIdleGameTaskEventAllianceHelpView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textEventTitle = nil
  self.textEventDesc = nil
  self.compOwnerPlayerHead = nil
  self.textRewardTips = nil
  self.compRewardContent = nil
  self.textParticipateTip = nil
  self.scrollRectPlayerList = nil
  self.compHeadIconList = nil
  self.btnOK = nil
  self.textBtnOk = nil
  self.btnShare = nil
end

function UIIdleGameTaskEventAllianceHelpView:DataDefine()
  self.canClickJoin = false
  self.itemReqs = {}
  self.itemList = {}
  self.playerHeadScriptList = {}
  self.playerHeadReqsList = {}
  self.totalPlayerInfoList = {}
  self.textEventTitle:SetText("")
  self.textEventDesc:SetText("")
  self.textRewardTips:SetText("")
  self.textParticipateTip:SetText("")
  UIGray.SetGray(self.btnOK.transform, true, false)
  self.btnOK:SetActive(false)
  self.textBtnOk:SetLocalText("t11_idle_game_button_48")
  self.scrollRectPlayerList:SetVerticalNormalizedPosition(1)
end

function UIIdleGameTaskEventAllianceHelpView:DataDestroy()
  self.canClickJoin = false
  self.gameEventData = nil
  self.eventCfgData = nil
  self.questCfgData = nil
  self.shareConfig = nil
  self:ClearPlayerInfoContent()
  self:ClearRewardContent()
end

function UIIdleGameTaskEventAllianceHelpView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11IdleGameTaskEventInvitePlayers, self.RefreshView)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.RefreshHead)
  self:AddUIListener(EventId.T11IdleGameTaskEventAllHelpViewRefresh, self.AddMySelfToPlayerHeads)
end

function UIIdleGameTaskEventAllianceHelpView:OnRemoveListener()
  self:RemoveUIListener(EventId.T11IdleGameTaskEventInvitePlayers, self.RefreshView)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.RefreshHead)
  self:RemoveUIListener(EventId.T11IdleGameTaskEventAllHelpViewRefresh, self.AddMySelfToPlayerHeads)
  base.OnRemoveListener(self)
end

function UIIdleGameTaskEventAllianceHelpView:RefreshView(param)
  local eventUuid = param.eventUuid
  local idleGameEventMsg = param.idleGameEventMsg
  self.helpTimesDaily = param.helpTimesDaily
  if eventUuid ~= self.eventUuid then
    return
  end
  self:InitData(idleGameEventMsg)
  self:RefreshText()
  self:RefreshReward()
  self:RefreshHead()
  self:RefreshPlayerList()
  self:RefreshBtns()
end

function UIIdleGameTaskEventAllianceHelpView:InitData(idleGameEventMsg)
  self.gameEventData = T11IdleGameEventData.New()
  self.gameEventData:UpdateData(idleGameEventMsg)
  self.eventCfgData = DataCenter.T11IdleGameTemplateManager:GetGameEventTemplateById(self.gameEventData.eventId)
  if self.eventCfgData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventAllianceHelpView:InitData call with nil eventCfgData")
    return
  end
  self.questCfgData = DataCenter.QuestTemplateManager:GetQuestTemplate(self.gameEventData.questId)
  if self.questCfgData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventAllianceHelpView:InitData call with nil self.questCfgData")
  end
  self.shareConfig = LocalController:instance():getLine(TableName.LW_IDLE_GAME_SHARE, tonumber(self.eventCfgData.share_id))
  if self.shareConfig == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventAllianceHelpView: RefreshReward event\232\161\168\228\184\173\228\184\173share_id\228\184\141\229\156\168share\232\161\168\228\184\173" .. self.eventCfgData.id)
  end
  if self.questCfgData.type2 ~= Const.T11GameEventCompleteType.IDLE_GAME_ALLIANCE_HELP then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventAllianceHelpView:\229\136\134\228\186\171\231\149\140\233\157\162\230\137\147\229\188\128\239\188\140\229\175\185\229\186\148\231\154\132\230\158\154\228\184\190\231\177\187\229\158\139\229\177\133\231\132\182\228\184\141\230\152\175\229\136\134\228\186\171\231\177\187\229\158\139\239\188\159\239\188\159")
  end
end

function UIIdleGameTaskEventAllianceHelpView:RefreshText()
  local strList = string.split(self.eventCfgData.special_quest_name, ";")
  if #strList == 1 then
    self.textEventTitle:SetText(Localization:GetString(strList[1]))
  elseif #strList == 2 then
    self.textEventTitle:SetText(Localization:GetString(strList[1], strList[2]))
  else
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventItem:RefreshView special_quest_name format error, strList count > 2")
  end
  local isSelfParticipateEvent = self:IsSelfParticipateEvent()
  if isSelfParticipateEvent then
    self.textParticipateTip:SetLocalText("t11_idle_game_desc_50")
  else
    self.textParticipateTip:SetLocalText("t11_idle_game_desc_74")
  end
  local eventDescStr = self:GetRequirementDesc()
  self.textEventDesc:SetText(eventDescStr)
  local dailyGetLimit = LuaEntry.DataConfig:TryGetStr("idle_game_para", "k4", 5)
  self.textRewardTips:SetText(Localization:GetString("t11_idle_game_desc_49", self.helpTimesDaily, dailyGetLimit))
end

function UIIdleGameTaskEventAllianceHelpView:RefreshReward()
  local rewardId = tonumber(self.shareConfig.join_reward)
  local line = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
  if line == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventAllianceHelpView: RefreshReward \228\184\139\229\143\145\231\154\132\229\165\150\229\138\177\228\184\141\229\156\168 Reward \232\161\168\228\184\173\239\188\154" .. rewardId)
    return
  end
  self:ClearRewardContent()
  local showRewardList = {}
  local itemValues = line:getValue("item") or ""
  local numValues = line:getValue("num") or ""
  if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
    local ids = string.split(itemValues, "|")
    local nums = string.split(numValues, "|")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        oneData.count = nums[i] or 0
        oneData.rewardType = RewardType.GOODS
        table.insert(showRewardList, oneData)
      end
    end
  end
  self:RefreshRewardList(showRewardList, self.compRewardContent)
end

function UIIdleGameTaskEventAllianceHelpView:RefreshHead()
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.playerUid, true)
  if info == nil then
    SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, self.playerUid)
    return
  end
  self.compOwnerPlayerHead:SetHeadAndFrame(info.uid, info.pic, info.picVer, false, info.headSkinId, info.headSkinET)
  self.compOwnerPlayerHead:SetEnableClickShowInfo(true, true)
end

function UIIdleGameTaskEventAllianceHelpView:RefreshPlayerList()
  self:ClearPlayerInfoContent()
  local invitePlayerInfoList = DataCenter.T11IdleGameDataManager:GetInvitePlayerInfoList(self.eventUuid)
  self.totalPlayerInfoList = DeepCopy(invitePlayerInfoList)
  local totalNum = tonumber(self.shareConfig.need_num)
  local remainDataNum = totalNum - #self.totalPlayerInfoList
  for i = 1, remainDataNum do
    table.insert(self.totalPlayerInfoList, {isEmptyPlace = true})
  end
  self:RefreshPlayerHeads(self.totalPlayerInfoList, self.compHeadIconList)
end

function UIIdleGameTaskEventAllianceHelpView:RefreshBtns()
  self.btnOK:SetActive(true)
  local invitePlayerInfoList = DataCenter.T11IdleGameDataManager:GetInvitePlayerInfoList(self.eventUuid)
  self.btnShare:SetActive(self.playerUid == LuaEntry.Player.uid and #invitePlayerInfoList < tonumber(self.shareConfig.need_num))
  local isSelfParticipateEvent = self:IsSelfParticipateEvent()
  UIGray.SetGray(self.btnOK.transform, isSelfParticipateEvent, not isSelfParticipateEvent)
  if isSelfParticipateEvent then
    self.textBtnOk:SetLocalText("t11_idle_game_button_48")
  else
    self.textBtnOk:SetLocalText("t11_idle_game_button_47")
  end
end

function UIIdleGameTaskEventAllianceHelpView:GetRequirementDesc()
  local requirementStr = ""
  if not string.IsNullOrEmpty(self.eventCfgData.quest_para) then
    local strList = string.split(self.eventCfgData.quest_para, ";")
    requirementStr = Localization:GetString(self.questCfgData.desc, table.unpack(strList))
  else
    requirementStr = Localization:GetString(self.questCfgData.desc, "0", self.questCfgData.para2)
  end
  if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_LEVEL then
    return requirementStr
  end
  local curNum = self.gameEventData.num
  local targetNum = self.questCfgData.para2
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  requirementStr = requirementStr .. " (" .. string.GetFormattedStr(curNum) .. "/" .. targetNum .. ")"
  return requirementStr
end

function UIIdleGameTaskEventAllianceHelpView:IsSelfParticipateEvent()
  local invitePlayerInfoList = DataCenter.T11IdleGameDataManager:GetInvitePlayerInfoList(self.eventUuid)
  for i = 1, #invitePlayerInfoList do
    if not invitePlayerInfoList[i].isEmptyPlace and invitePlayerInfoList[i].uid and invitePlayerInfoList[i].uid == LuaEntry.Player.uid then
      return true
    end
  end
  return false
end

function UIIdleGameTaskEventAllianceHelpView:ClearRewardContent()
  if table.count(self.itemList) > 0 then
    self.compRewardContent:RemoveComponents(UICommonResItem)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

function UIIdleGameTaskEventAllianceHelpView:RefreshRewardList(rewardList, contentScript)
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(contentScript.transform)
        item.transform:Set_localScale(0.8, 0.8, 1)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = contentScript:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
        table.insert(self.itemList, cell)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

function UIIdleGameTaskEventAllianceHelpView:ClearPlayerInfoContent()
  if table.count(self.playerHeadScriptList) > 0 then
    self.compHeadIconList:RemoveComponents(UIIdleGameTaskEventInvitePlayerItemComponent)
    self.playerHeadScriptList = {}
  end
  if table.count(self.playerHeadReqsList) then
    for _, req in pairs(self.playerHeadReqsList) do
      req:Destroy()
    end
    self.playerHeadReqsList = {}
  end
end

function UIIdleGameTaskEventAllianceHelpView:RefreshPlayerHeads(invitePlayerInfoList, contentScript)
  if not table.IsNullOrEmpty(invitePlayerInfoList) then
    for i, data in pairs(invitePlayerInfoList) do
      local req = self:GameObjectInstantiateAsync(Const.InvitePlayerItemPath, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "UIIdleGameTaskEventInvitePlayerItemComponent" .. i
        item:SetActive(true)
        item.transform:SetParent(contentScript.transform)
        item.transform:Set_localScale(1.4, 1.4, 1)
        item.transform:Set_sizeDelta(90, 90)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = contentScript:AddComponent(UIIdleGameTaskEventInvitePlayerItemComponent, item.name)
        cell:ReInit(data)
        table.insert(self.playerHeadScriptList, cell)
        if #self.playerHeadScriptList == #invitePlayerInfoList then
          self.canClickJoin = true
        end
      end)
      table.insert(self.playerHeadReqsList, req)
    end
  end
end

function UIIdleGameTaskEventAllianceHelpView:OnBtnPanelClick()
  self.view.ctrl:CloseSelf()
end

function UIIdleGameTaskEventAllianceHelpView:OnBtnCloseClick()
  self.view.ctrl:CloseSelf()
end

function UIIdleGameTaskEventAllianceHelpView:OnBtnOKClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < sendMsgTime + 2000 then
    return
  end
  sendMsgTime = curTime
  if not self.canClickJoin then
    return
  end
  local isSelfParticipateEvent = self:IsSelfParticipateEvent()
  if isSelfParticipateEvent then
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("multiply_door_tips_027")
    return
  end
  local invitePlayerInfoList = DataCenter.T11IdleGameDataManager:GetInvitePlayerInfoList(self.eventUuid)
  if #invitePlayerInfoList >= tonumber(self.shareConfig.need_num) then
    UIUtil.ShowTipsId("idle_game_event_help_finish")
    return
  end
  DataCenter.T11IdleGameDataManager:SendIdleGameEventHelpMessage(self.playerUid, self.gameEventData.uuid, self.eventCfgData.id)
end

function UIIdleGameTaskEventAllianceHelpView:OnBtnShareClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("idle_game_event_share_need_alliance")
    return
  end
  local canShareAllianceHelp = DataCenter.T11IdleGameDataManager:CanShareAllianceHelp()
  if not canShareAllianceHelp then
    UIUtil.ShowTipsId("idle_game_event_share_cd")
    return
  end
  local invitePlayerInfoList = DataCenter.T11IdleGameDataManager:GetInvitePlayerInfoList(self.eventUuid)
  if #invitePlayerInfoList >= tonumber(self.shareConfig.need_num) then
    UIUtil.ShowTipsId("idle_game_event_help_finish")
    return
  end
  DataCenter.T11IdleGameDataManager:ShareToChat(self.playerUid, self.eventUuid, self.gameEventData.eventId, self.gameEventData.questId)
end

function UIIdleGameTaskEventAllianceHelpView:AddMySelfToPlayerHeads(msg)
  if table.IsNullOrEmpty(self.totalPlayerInfoList) then
    return
  end
  local playerNum = 0
  for i = 1, #self.totalPlayerInfoList do
    if not self.totalPlayerInfoList[i].isEmptyPlace then
      playerNum = playerNum + 1
    end
  end
  local playerShowLineCount = math.ceil((playerNum + 1) / 5)
  local maxLineCount = math.ceil(#self.totalPlayerInfoList / 5)
  self:ScrollToTargetLine(playerShowLineCount, maxLineCount)
  if playerNum == #self.totalPlayerInfoList then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventAllianceHelpView: AddMySelfToPlayerHeads \228\186\186\230\149\176\229\183\178\231\187\143\230\187\161\228\186\134\239\188\140\230\128\142\228\185\136\232\191\152\229\156\168\230\183\187\229\138\160\232\135\170\229\183\177\239\188\129")
    return
  end
  local playerInfo = {}
  playerInfo.uid = LuaEntry.Player.uid
  playerInfo.pic = LuaEntry.Player.pic
  playerInfo.picVer = LuaEntry.Player.picVer
  playerInfo.headSkinPath = LuaEntry.Player:GetHeadBgImg()
  playerInfo.isEmptyPlace = false
  local invitePlayerInfoList = DataCenter.T11IdleGameDataManager:GetInvitePlayerInfoList(self.eventUuid)
  invitePlayerInfoList[playerNum + 1] = playerInfo
  self.totalPlayerInfoList[playerNum + 1] = playerInfo
  self.playerHeadScriptList[playerNum + 1]:ReInit(playerInfo, true)
  self.helpTimesDaily = self.helpTimesDaily + 1
  local dailyGetLimit = LuaEntry.DataConfig:TryGetStr("idle_game_para", "k4", 5)
  if self.helpTimesDaily > tonumber(dailyGetLimit) then
    self.helpTimesDaily = tonumber(dailyGetLimit)
  end
  self.gameEventData.num = self.gameEventData.num + 1
  if self.gameEventData.num > self.questCfgData.para2 then
    self.gameEventData.num = self.questCfgData.para2
  end
  self:RefreshText()
  self:RefreshBtns()
  local reward = msg.reward
  if reward then
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.RewardManager:ShowCommonReward(msg)
      DataCenter.RewardManager:AddRewardsAndRes(msg)
    end, 0.35)
  end
end

function UIIdleGameTaskEventAllianceHelpView:ScrollToTargetLine(lineCount, maxLineCount)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compHeadIconList.transform)
  local contentPosY = 0
  if lineCount <= 2 then
    self.scrollRectPlayerList:SetVerticalNormalizedPosition(1)
  elseif 2 < lineCount and lineCount < maxLineCount then
    contentPosY = (lineCount - 2) * 133
    self.compHeadIconList:SetAnchoredPositionXY(0, contentPosY)
  elseif maxLineCount <= lineCount then
    self.scrollRectPlayerList:SetVerticalNormalizedPosition(0)
  end
end

return UIIdleGameTaskEventAllianceHelpView
