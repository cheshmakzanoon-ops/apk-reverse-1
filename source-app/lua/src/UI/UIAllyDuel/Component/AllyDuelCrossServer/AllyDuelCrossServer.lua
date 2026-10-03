local base = UIBaseView
local AllyDuelCrossServer = BaseClass("AllyDuelCrossServer", base)
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local title_path = "startGo/middleGo/titleTxt"
local subTitle_path = "startGo/middleGo/desTxt"
local actTime_path = "startGo/middleGo/timeTxt"
local cdTip_path = "startGo/middleGo/timeTxt/cdTip"
local cdTime_path = "startGo/middleGo/timeTxt/cdTxt"
local alNameL_path = "startGo/redGo/redAllianceGo/redAllianceNameTxt"
local alNameR_path = "startGo/blueGo/blueAllianceGo/blueAllianceNameTxt"
local attackBtn_path = "startGo/Normal/attackBtn"
local attackBtnTxt_path = "startGo/Normal/attackBtn/attackTxt"
local attackTip_path = "startGo/Normal/attackTip"
local normal_path = "startGo/Normal"
local infoBtn_path = "rightLayer/infoBtn"
local desc_btn_path = "rightLayer/DescBtn"
local desc_text_path = "rightLayer/DescBtn/DescIcon/DescText"
local season5_path = "startGo/Season5"
local back_btn_path = "startGo/Season5/backBtn"
local back_txt_path = "startGo/Season5/backBtn/backTxt"
local go_btn_path = "startGo/Season5/goBtn"
local go_txt_path = "startGo/Season5/goBtn/goTxt"
local go_pos_txt_path = "startGo/Season5/goBtn/goPosTxt"
local go_btn2_path = "startGo/Season5/goBtn2"
local go_txt2_path = "startGo/Season5/goBtn2/goTxt2"
local go_pos_txt2_path = "startGo/Season5/goBtn2/goPosTxt2"
local flag1_path = "startGo/Season5/flag1"
local flag2_path = "startGo/Season5/flag2"
local CrossServerActivityState = {
  Preview = 1,
  Processing = 2,
  Over = 3
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetText(Localization:GetString("110214"))
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.subTitleN:SetText(Localization:GetString("372418"))
  self.actTimeN = self:AddComponent(UIBaseContainer, actTime_path)
  self.cdTipN = self:AddComponent(UIText, cdTip_path)
  self.cdTimeN = self:AddComponent(UIText, cdTime_path)
  self.allianceFlagLN = self:AddComponent(UIImage, "startGo/redGo/redAllianceIcon/FlagRed")
  self.allianceFlagRN = self:AddComponent(UIImage, "startGo/blueGo/blueAllianceIcon/FlagBlue")
  self.alNameLN = self:AddComponent(UIText, alNameL_path)
  self.alNameRN = self:AddComponent(UIText, alNameR_path)
  self.costTips = self:AddComponent(UITextMeshProUGUIEx, "startGo/costTips")
  self.attackBtnN = self:AddComponent(UIButton, attackBtn_path)
  self.attackBtnN:SetOnClick(function()
    if self.curStatus == CrossServerActivityState.Processing and DataCenter.LWZombieRushManager:IsChallenging() then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:OnClickAttackBtn()
      end, function()
      end)
      return
    end
    self:OnClickAttackBtn()
  end)
  self.attackBtnTxtN = self:AddComponent(UIText, attackBtnTxt_path)
  self.attackTipN = self:AddComponent(UIText, attackTip_path)
  self.normal = self:AddComponent(UIBaseComponent, normal_path)
  self.season5 = self:AddComponent(UIBaseContainer, season5_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:ConditionCheck(function()
      self:OnClickBackBtn()
    end)
  end)
  self.back_txt = self:AddComponent(UITextMeshProUGUIEx, back_txt_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:ConditionCheck(function()
      self:OnClickGoBtn(1)
    end)
  end)
  self.go_txt = self:AddComponent(UITextMeshProUGUIEx, go_txt_path)
  self.go_pos_txt = self:AddComponent(UITextMeshProUGUIEx, go_pos_txt_path)
  self.go_btn2 = self:AddComponent(UIButton, go_btn2_path)
  self.go_btn2:SetOnClick(function()
    self:ConditionCheck(function()
      self:OnClickGoBtn(2)
    end)
  end)
  self.go_txt2 = self:AddComponent(UITextMeshProUGUIEx, go_txt2_path)
  self.go_pos_txt2 = self:AddComponent(UITextMeshProUGUIEx, go_pos_txt2_path)
  self.flag1 = self:AddComponent(UIImage, flag1_path)
  self.flag2 = self:AddComponent(UIImage, flag2_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.itemNumTxt = self:AddComponent(UIText, "startGo/Normal/attackBtn/ItemNum")
  self.itemNumTxt:SetActive(false)
  self.itemNumImg = self:AddComponent(UIImage, "startGo/Normal/attackBtn/ItemNum/ItemImage")
  self.itemNumImg:LoadSpriteAuto(DataCenter.ItemTemplateManager:GetIconPath(SpecialItemId.ITEM_MOVE_CITY))
  self.attackCdTxt = self:AddComponent(UIText, "startGo/Normal/attackBtn/attackCdTxt")
  self.attackCdTxt:SetActive(false)
  self.desc_btn = self:AddComponent(UIButton, desc_btn_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.desc_text:SetLocalText("gogncheng_liantu_tips1001")
  self.desc_btn:SetOnClick(function()
    self:OnDescBtnClick()
  end)
  self.back_txt:SetLocalText(GameDialogDefine.BACK)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.cdTipN = nil
  self.cdTimeN = nil
  self.allianceFlagLN = nil
  self.allianceFlagRN = nil
  self.alNameLN = nil
  self.alNameRN = nil
  self.attackBtnN = nil
  self.attackBtnTxtN = nil
  self.attackTipN = nil
  self.infoBtnN = nil
  self.desc_btn = nil
  self.desc_text = nil
  self.season5 = nil
  self.back_btn = nil
  self.back_txt = nil
  self.go_btn = nil
  self.go_txt = nil
  self.go_pos_txt = nil
  self.go_btn2 = nil
  self.go_txt2 = nil
  self.go_pos_txt2 = nil
end

local function DataDefine(self)
  self.activityInfo = nil
  self.eventInfo = nil
  self.isCrossServerOpen = nil
  self.crossReason = {
    CanCrossServerReason.Disable,
    CanCrossServerReason.Disable
  }
  self.curStatus = nil
end

local function DataDestroy(self)
  self.activityInfo = nil
  self.eventInfo = nil
  self.isCrossServerOpen = nil
  self.crossReason = nil
  self.curStatus = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllyDuelRecommendPointRefresh, self.RefreshJumpBtns)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.RefreshJumpBtns)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllyDuelRecommendPointRefresh, self.RefreshJumpBtns)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.RefreshJumpBtns)
  base.OnRemoveListener(self)
end

local function ShowPanel(self)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not self.activityInfo then
    return
  end
  self.eventInfo = self.activityInfo:GetEventInfo()
  if not self.eventInfo then
    return
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  self:FetchRecommendPoint()
  local isMoveToAttack = self:IsMoveToAttack()
  self.attackBtnTxtN:SetLocalText(isMoveToAttack and 100150 or GameDialogDefine.BACK)
  local myAllianceId = LuaEntry.Player.allianceId
  local allianceList = self.eventInfo.vsAllianceList
  local targetServerId = DataCenter.AllianceCompeteDataManager:GetFightServerId()
  self.costTips:SetText("")
  table.walk(allianceList, function(k, v)
    local name = string.IsNullOrEmpty(v.alName) and Localization:GetString("372814") or string.format([[
#%s [%s]
%s]], v.serverId, v.abbr, v.alName)
    if k == myAllianceId then
      self.alNameLN:SetText(name)
      self.allianceFlagLN:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, v.icon))
      if not isMoveToAttack then
        self.attackTipN:SetText(Localization:GetString("372419", v.serverId, v.abbr))
      end
    else
      self.enemyAbbr = v.abbr
      self.alNameRN:SetText(name)
      if not string.IsNullOrEmpty(v.alName) then
        self.allianceFlagRN:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, v.icon))
      else
        self.allianceFlagRN:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, 1))
      end
      if isMoveToAttack then
        self.attackTipN:SetText(Localization:GetString("372419", v.serverId, v.abbr))
      end
    end
  end)
  self:RefreshJumpBtns()
  self:Update1000MS()
end

function AllyDuelCrossServer:RefreshJumpBtns()
  self.normal:SetActive(false)
  self.season5:SetActive(true)
  local go, go2 = DataCenter.AllianceCompeteDataManager:GetPoint()
  if go then
    self.go_pos_txt:SetActive(true)
    self.go_pos_txt:SetText(UIUtil.FormatServerAllianceName(go.server, self.enemyAbbr))
    self.crossReason[1] = CrossServerUtil.GetCrossEnableReason(go.server)
  else
    self.go_pos_txt:SetActive(false)
  end
  if go2 then
    self.go_pos_txt2:SetText(UIUtil.FormatServerAllianceName(go2.server, self.enemyAbbr))
    self.crossReason[2] = CrossServerUtil.GetCrossEnableReason(go2.server)
    if self.crossReason[2] == CanCrossServerReason.Disable then
      self.flag2:SetActive(false)
      self.go_btn2:SetActive(false)
    else
      self.flag2:SetActive(true)
      self.go_btn2:SetActive(true)
    end
  else
    self.flag2:SetActive(false)
    self.go_btn2:SetActive(false)
  end
  if SeasonUtil.GetSourceSeasonType() == SeasonMapType.NineNation then
    local targetServerId = DataCenter.AllianceCompeteDataManager:GetFightServerId()
    self.costTips:SetText("")
    self.flag1:SetActive(true)
  else
    self.flag1:SetActive(false)
  end
end

local function FetchRecommendPoint(self)
  CrossServerUtil.TryGetCrossEnableServerList(true)
  DataCenter.AllianceCompeteDataManager:FetchAllianceBattlePoint()
end

local function Update1000MS(self)
  self.go_txt:SetLocalText(100150)
  self.go_txt2:SetLocalText(100150)
  if not self.eventInfo then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local _, startT, endT = self.eventInfo:CheckIfShowCrossServer()
  if now < startT then
    self.cdTipN:SetText(Localization:GetString("372114"))
    self.endTime = startT
    self.cdTimeN:SetActive(true)
    CS.UIGray.SetGray(self.go_btn.transform, true, true)
    CS.UIGray.SetGray(self.go_btn2.transform, true, true)
    self.isCrossServerOpen = false
    self.curStatus = CrossServerActivityState.Preview
  elseif now < endT then
    self.cdTipN:SetText(Localization:GetString("372420"))
    self.endTime = endT
    self.cdTimeN:SetActive(true)
    self.crossMoveCDEnd = DataCenter.LeagueMatchManager:GetCrossMoveCDEnd()
    if self.eventInfo:IsBye() then
      CS.UIGray.SetGray(self.go_btn.transform, true, true)
      CS.UIGray.SetGray(self.go_btn2.transform, true, true)
      self.flag2:SetActive(false)
      self.go_btn2:SetActive(false)
      self.isCrossServerOpen = false
    elseif now < self.crossMoveCDEnd then
      local hideCD
      if SeasonUtil.GetSourceSeasonType() == SeasonMapType.NineNation then
        hideCD = SeasonUtil.IsInSameGroup(DataCenter.AllianceCompeteDataManager:GetFightServerId(), ServerEnum.Login)
      else
        hideCD = DataCenter.AllianceCompeteDataManager:GetFightServerId() == LuaEntry.Player:GetSelfServerId()
      end
      if hideCD then
        local serverDisable1 = self.crossReason[1] == CanCrossServerReason.Disable
        local serverDisable2 = self.crossReason[2] == CanCrossServerReason.Disable
        CS.UIGray.SetGray(self.go_btn.transform, serverDisable1, true)
        CS.UIGray.SetGray(self.go_btn2.transform, serverDisable2, true)
        self.isCrossServerOpen = true
      else
        CS.UIGray.SetGray(self.go_btn.transform, true, true)
        CS.UIGray.SetGray(self.go_btn2.transform, true, true)
        local remainT = self.crossMoveCDEnd - now
        self.go_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainT))
        self.go_txt2:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainT))
        self.isCrossServerOpen = false
      end
    else
      local serverDisable1 = self.crossReason[1] == CanCrossServerReason.Disable
      local serverDisable2 = self.crossReason[2] == CanCrossServerReason.Disable
      CS.UIGray.SetGray(self.go_btn.transform, serverDisable1, true)
      CS.UIGray.SetGray(self.go_btn2.transform, serverDisable2, true)
      self.isCrossServerOpen = true
    end
    if self.curStatus == CrossServerActivityState.Preview then
      self:FetchRecommendPoint()
    end
    self.curStatus = CrossServerActivityState.Processing
  else
    self.endTime = nil
    self.cdTipN:SetText(Localization:GetString("370100"))
    self.cdTimeN:SetActive(false)
    CS.UIGray.SetGray(self.go_btn.transform, true, true)
    CS.UIGray.SetGray(self.go_btn2.transform, true, true)
    self.isCrossServerOpen = false
    self.curStatus = CrossServerActivityState.Over
  end
  if self.endTime then
    local remainT = self.endTime - now
    if 0 < remainT then
      self.cdTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainT))
    end
  end
end

function AllyDuelCrossServer:OnClickGoBtn(index)
  local point1, point2 = DataCenter.AllianceCompeteDataManager:GetPoint()
  local point = index == 1 and point1 or point2
  if not point then
    return
  end
  local targetPointId = point.pointId
  local targetServerId = point.server
  if SeasonUtil.GetSourceSeasonType() == SeasonMapType.NineNation then
    if SeasonUtil.IsInSameGroup(targetServerId) and self.crossReason[index] ~= CanCrossServerReason.Disable then
      CrossServerUtil.JumpToServerByServerId(targetServerId, MoveCrossServerType.BackToSrcServer, targetPointId, nil, true)
    else
      self:OnClickGoBtnToGoOutside(index, targetServerId, targetPointId)
    end
  elseif targetServerId == LuaEntry.Player:GetSourceServerId() then
    CrossServerUtil.BackToSrcServer(targetPointId, true)
  else
    self:OnClickGoBtnToGoOutside(index, targetServerId, targetPointId)
  end
end

function AllyDuelCrossServer:OnClickGoBtnToGoOutside(index, targetServerId, targetPointId)
  if not self.isCrossServerOpen then
    UIUtil.ShowTipsId(500022)
    return
  end
  if self.crossReason[index] == CanCrossServerReason.Disable then
    UIUtil.ShowTipsId("alliance_duel_cross_tips01")
    return
  end
  if self.view.ctrl:CheckIfEnemyAllyExist(self.eventInfo) then
    CrossServerUtil.JumpToServerByServerId(targetServerId, MoveCrossServerType.AllianceDuel, targetPointId, MoveCityCameraHeight, true)
  end
end

function AllyDuelCrossServer:OnClickBackBtn()
  CrossServerUtil.BackToRecommendRallyPoint()
end

function AllyDuelCrossServer:ConditionCheck(callback)
  if self.curStatus == CrossServerActivityState.Processing then
    if self.eventInfo and self.eventInfo:IsBye() then
      UIUtil.ShowTipsId("world_tip10010")
      return
    end
  elseif self.curStatus == CrossServerActivityState.Preview then
    UIUtil.ShowTips(Localization:GetString("alliance_duel_war_tips01"))
    return
  elseif self.curStatus == CrossServerActivityState.Over then
    UIUtil.ShowTips(Localization:GetString("370100"))
    return
  else
    return
  end
  if self.curStatus == CrossServerActivityState.Processing and DataCenter.LWZombieRushManager:IsChallenging() then
    UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      callback()
    end, function()
    end)
    return
  end
  callback()
end

local function OnClickAttackBtn(self)
  if self.curStatus == CrossServerActivityState.Processing then
    if self.eventInfo and self.eventInfo:IsBye() then
      UIUtil.ShowTipsId("world_tip10010")
      return
    end
    local isMoveToAttack = self:IsMoveToAttack()
    if isMoveToAttack then
      local targetServerId = DataCenter.AllianceCompeteDataManager:GetFightServerId()
      local pointId = DataCenter.AllianceCompeteDataManager:GetRecommendPoint()
      if pointId == nil or pointId == 0 then
        pointId = LuaEntry.Player:GetMainWorldPos()
      end
      if targetServerId == LuaEntry.Player:GetSourceServerId() then
        CrossServerUtil.BackToSrcServer(pointId, true)
      else
        if not self.isCrossServerOpen then
          UIUtil.ShowTipsId(500022)
          return
        end
        if self.view.ctrl:CheckIfEnemyAllyExist(self.eventInfo) then
          CrossServerUtil.JumpToServerByServerId(targetServerId, MoveCrossServerType.AllianceDuel, pointId, MoveCityCameraHeight, true)
        end
      end
    else
      local pointId = DataCenter.AllianceCompeteDataManager:GetRecommendPoint()
      if pointId == nil or pointId == 0 then
        pointId = LuaEntry.Player:GetMainWorldPos()
      end
      CrossServerUtil.BackToSrcServer(pointId, true)
    end
  elseif self.curStatus == CrossServerActivityState.Preview then
    UIUtil.ShowTips(Localization:GetString("E100172"))
  elseif self.curStatus == CrossServerActivityState.Over then
    UIUtil.ShowTips(Localization:GetString("370100"))
  end
end

local function OnClickInfoBtn(self)
  UIUtil.ShowIntro(Localization:GetString("110214"), Localization:GetString("110223"), Localization:GetString("110221"))
end

local function OnGotoPoint(self, data)
end

function AllyDuelCrossServer:IsMoveToAttack()
  if LuaEntry.Player.crossFightSrcServerId == -1 or LuaEntry.Player.serverId ~= DataCenter.AllianceCompeteDataManager:GetFightServerId() then
    return true
  end
  return false
end

function AllyDuelCrossServer:OnDescBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 4)
end

AllyDuelCrossServer.OnCreate = OnCreate
AllyDuelCrossServer.OnEnable = OnEnable
AllyDuelCrossServer.OnDisable = OnDisable
AllyDuelCrossServer.OnDestroy = OnDestroy
AllyDuelCrossServer.OnAddListener = OnAddListener
AllyDuelCrossServer.OnRemoveListener = OnRemoveListener
AllyDuelCrossServer.ComponentDefine = ComponentDefine
AllyDuelCrossServer.ComponentDestroy = ComponentDestroy
AllyDuelCrossServer.DataDefine = DataDefine
AllyDuelCrossServer.DataDestroy = DataDestroy
AllyDuelCrossServer.ShowPanel = ShowPanel
AllyDuelCrossServer.RefreshAll = RefreshAll
AllyDuelCrossServer.Update1000MS = Update1000MS
AllyDuelCrossServer.FetchRecommendPoint = FetchRecommendPoint
AllyDuelCrossServer.OnClickAttackBtn = OnClickAttackBtn
AllyDuelCrossServer.OnClickInfoBtn = OnClickInfoBtn
AllyDuelCrossServer.OnGotoPoint = OnGotoPoint
return AllyDuelCrossServer
