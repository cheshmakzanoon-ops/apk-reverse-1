local base = require("UI.UIRaceEntrance.Component.ActDownloadNodeBase")
local DesertBattleActivityMainRoot = BaseClass("DesertBattleActivityMainRoot", base)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.ActDragonManager
local UITimeMgr = UITimeManager:GetInstance()
local DesertBattleMainToggle = require("UI.UIActivityCenterTable.Component.DesertBattle.Component.DesertBattleMainToggle")
local PREFAB_BG_IDLE = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/Main/DesertBattleMainBgIdle.prefab"
local PREFAB_BG_BATTLE = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/Main/DesertBattleMainBgBattle.prefab"
local PREFAB_IDLE = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/Main/DesertBattleMainIdle.prefab"
local PREFAB_BATTLE = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/Main/DesertBattleMainBattle.prefab"
local CLS_IDLE = "UI.UIActivityCenterTable.Component.DesertBattle.Component.DesertBattleMainIdle"
local CLS_BATTLE = "UI.UIActivityCenterTable.Component.DesertBattle.Component.DesertBattleMainBattle"
local UI_STATE = {
  EMPTY = 0,
  IDLE = 1,
  BATTLE = 2
}
local BTN_STATE = {
  EMPTY = 0,
  DSB = 1,
  CHANGE = 2,
  PLAYER = 3,
  SIGNUP = 4,
  GO = 5,
  WATCH = 6,
  GIVE_UP = 7,
  RECOVER = 8
}
local CHECK_SYNC_TIME = 60000

function DesertBattleActivityMainRoot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DesertBattleActivityMainRoot:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DesertBattleActivityMainRoot:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compMask = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textTimeTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compGroup = self.viewSkin:AddComponent(self, DesertBattleMainToggle, 4)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnRule = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRule:SetOnClick(function()
    self:OnBtnRuleClick()
  end)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnShop = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnShop:SetOnClick(function()
    self:OnBtnShopClick()
  end)
  self.btnBattleResult = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnBattleResult:SetOnClick(function()
    self:OnBtnBattleResultClick()
  end)
  self.btnBattlePlayer = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnBattlePlayer:SetOnClick(function()
    self:OnBtnBattlePlayerClick()
  end)
  self.btnLog = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnLog:SetOnClick(function()
    self:OnBtnLogClick()
  end)
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.compDsbState = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.textDsbStateTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compBottom = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.btnBottom1 = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnBottom1:SetOnClick(function()
    self:OnBtnBottom1Click()
  end)
  self.btnBottom2 = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnBottom2:SetOnClick(function()
    self:OnBtnBottom2Click()
  end)
  self.btnBottom3 = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnBottom3:SetOnClick(function()
    self:OnBtnBottom3Click()
  end)
  self.textBtnBottom1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textBtnBottom2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textBtnBottom3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compDesertBattleMainRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.compTipGo = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
end

function DesertBattleActivityMainRoot:ComponentDestroy()
  self.viewSkin = nil
  self.compMask = nil
  self.textTimeTitle = nil
  self.textRemainTime = nil
  self.compGroup = nil
  self.textTitle = nil
  self.btnRule = nil
  self.btnInfo = nil
  self.btnShop = nil
  self.btnBattleResult = nil
  self.btnBattlePlayer = nil
  self.btnLog = nil
  self.compCenter = nil
  self.compDsbState = nil
  self.textDsbStateTips = nil
  self.compBottom = nil
  self.btnBottom1 = nil
  self.btnBottom2 = nil
  self.btnBottom3 = nil
  self.textBtnBottom1 = nil
  self.textBtnBottom2 = nil
  self.textBtnBottom3 = nil
  self.compDesertBattleMainRoot = nil
  self.compTipGo = nil
end

function DesertBattleActivityMainRoot:DataDefine()
  self.uiState = UI_STATE.EMPTY
  self.bgComps = {}
  self.centerComps = {}
  self.btnInfos = {
    b1 = BTN_STATE.EMPTY,
    s1 = true,
    b2 = BTN_STATE.EMPTY,
    s2 = true,
    b3 = BTN_STATE.EMPTY,
    s3 = true
  }
  self.compGroup:SetData(BindCallback(self, self.OnToggle))
  self.curTabIdx = ActMgr:GetCurGroupIdx()
  if self.curTabIdx == 0 then
    self.curTabIdx = 1
  end
  self.actInfo = ActMgr:GetActInfo()
  self.dragonInfo = ActMgr:GetGroup(self.curTabIdx)
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  self.textTitle:SetLocalText(458007)
end

function DesertBattleActivityMainRoot:DataDestroy()
  self.uiState = UI_STATE.EMPTY
  self.bgComps = nil
  self.centerComps = nil
end

function DesertBattleActivityMainRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshView)
  self:AddUIListener(EventId.DragonInfoRefresh, self.RefreshView)
  self:AddUIListener(EventId.BattleFieldCanEnterPush, self.OnBattleFieldCanEnterPush)
end

function DesertBattleActivityMainRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshView)
  self:RemoveUIListener(EventId.DragonInfoRefresh, self.RefreshView)
  self:RemoveUIListener(EventId.BattleFieldCanEnterPush, self.OnBattleFieldCanEnterPush)
  base.OnRemoveListener(self)
end

function DesertBattleActivityMainRoot:OnBtnRuleClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertRules, {anim = true}, BattleFieldType.Desert)
end

function DesertBattleActivityMainRoot:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleDetail, BattleFieldType.Desert)
end

function DesertBattleActivityMainRoot:OnBtnShopClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.HonorShop)
end

function DesertBattleActivityMainRoot:OnBtnBattleResultClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleHistory)
end

function DesertBattleActivityMainRoot:OnBtnBattlePlayerClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertSelectUserV2, {anim = true}, {
    group = self.curTabIdx
  })
end

function DesertBattleActivityMainRoot:OnBtnLogClick()
  SFSNetwork.SendMessage(MsgDefines.DragonOperateLog)
end

function DesertBattleActivityMainRoot:OnBtnBottom1Click()
  if self.btnInfos.b1 == BTN_STATE.DSB then
    BattlefieldDsbDuelUtils.ActInfo:OpenActWindow()
  elseif self.btnInfos.b1 == BTN_STATE.CHANGE then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldSelectTime, {anim = true}, self.curTabIdx)
  elseif self.btnInfos.b1 == BTN_STATE.SIGNUP then
    if LuaEntry.Player:IsInAlliance() then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local signUp = self.dragonInfo ~= nil and self.dragonInfo.signUp or 0
      if curTime < self.actInfo.stopSignUpTime then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldSelectTime, {anim = true}, self.curTabIdx)
      elseif signUp == ActMgr.SignUpState.NoSignUp then
        UIUtil.ShowTipsId(458151)
      end
    else
      UIUtil.ShowTipsId(390856)
    end
  elseif self.btnInfos.b1 == BTN_STATE.GO then
    BattleFieldUtil.ClearBattleFieldCanEnterFlag(BattleFieldType.Desert)
    ActMgr:TryEnterBattlefield()
  end
end

function DesertBattleActivityMainRoot:OnBattleFieldCanEnterPush(worldType)
  if worldType ~= nil and toInt(worldType) ~= BattleFieldType.Desert then
    return
  end
  self:RefreshTipGo()
end

function DesertBattleActivityMainRoot:OnBtnBottom2Click()
  if self.btnInfos.b2 == BTN_STATE.PLAYER then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertSelectUserV2, {anim = true}, {
      group = self.curTabIdx
    })
  elseif self.btnInfos.b2 == BTN_STATE.WATCH then
    if not ActMgr:CheckCanWatch(self.curTabIdx) then
      UIUtil.ShowTipsId("Desert_strom_tips1057")
      return
    end
    ActMgr:TryEnterBattlefield(self.curTabIdx)
  end
end

function DesertBattleActivityMainRoot:OnBtnBottom3Click()
  local hadTeam2 = self.actInfo ~= nil and self.actInfo.hadTeam2 or 0
  if self.btnInfos.b3 == BTN_STATE.RECOVER and hadTeam2 == 2 then
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("Desert_strom_tips1080"),
      btnNum = 2,
      showToggle = false,
      cdConfirm = 10,
      delayConfirm = {delayTime = 10},
      sureAction = function()
        SFSNetwork.SendMessage(MsgDefines.DragonTeamGroupOpen)
      end
    })
  elseif self.btnInfos.b3 == BTN_STATE.GIVE_UP and hadTeam2 == 1 then
    local cdTime = self.actInfo ~= nil and self.actInfo.groupOpenCDEndTime or 0
    local remainTime = cdTime - UITimeManager:GetInstance():GetServerSeconds()
    if 0 < remainTime then
      UIUtil.ShowTipsId("Desert_strom_tips1081")
      return
    end
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("Desert_strom_tips1038"),
      btnNum = 2,
      showToggle = false,
      cdConfirm = 10,
      delayConfirm = {delayTime = 10},
      sureAction = function()
        SFSNetwork.SendMessage(MsgDefines.DragonTeamGroupCancel)
      end
    })
  end
end

function DesertBattleActivityMainRoot:GetActType()
  return EnumActivity.ActDragon.Type
end

function DesertBattleActivityMainRoot:OnEnterNode()
  self:SendGetInfo()
end

function DesertBattleActivityMainRoot:LoadBg(uiState)
  if self.uiState ~= uiState then
    local curComp = self.bgComps[self.uiState]
    if curComp then
      curComp:SetActive(false)
    end
  end
  local curComp = self.bgComps[uiState]
  if curComp then
    curComp:SetActive(true)
    return
  end
  local prefab = uiState == UI_STATE.BATTLE and PREFAB_BG_BATTLE or PREFAB_BG_IDLE
  self.bgComps[uiState] = self:LoadComponentAsync(UIAsyncContainer, prefab, self.compMask, function()
    curComp = self.bgComps[uiState]
    if curComp then
      curComp:SetAsFirstSibling()
      curComp:SetAnchoredPositionXY(0, 0)
      curComp:SetLocalScaleXYZ(1, 1, 1)
      curComp:SetActive(uiState == self.uiState)
    end
  end)
end

function DesertBattleActivityMainRoot:LoadCenter(uiState)
  if self.uiState ~= uiState then
    local curComp = self.centerComps[self.uiState]
    if curComp then
      curComp:SetActive(false)
    end
  end
  if uiState == UI_STATE.EMPTY then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compCenter.rectTransform)
    return
  end
  local curComp = self.centerComps[uiState]
  if curComp then
    curComp:SetActive(true)
    curComp:RefreshView()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compCenter.rectTransform)
    return
  end
  local prefab = uiState == UI_STATE.IDLE and PREFAB_IDLE or PREFAB_BATTLE
  local cls = uiState == UI_STATE.IDLE and CLS_IDLE or CLS_BATTLE
  self.centerComps[uiState] = self:LoadComponentAsync(cls, prefab, self.compCenter, function()
    curComp = self.centerComps[uiState]
    if curComp then
      curComp:SetActive(uiState == self.uiState)
      if uiState == self.uiState then
        curComp:SetAnchoredPositionXY(0, 0)
        curComp:SetLocalScaleXYZ(1, 1, 1)
      end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compCenter.rectTransform)
  end)
  self.centerComps[uiState]:SetMain(self)
end

function DesertBattleActivityMainRoot:LoadUIState(uiState)
  self:LoadBg(uiState)
  self:LoadCenter(uiState)
  self.uiState = uiState
  self.btnBattlePlayer:SetActive(uiState == UI_STATE.BATTLE)
  self.compDsbState:SetActive(uiState == UI_STATE.EMPTY)
  local hadTeam2 = self.actInfo ~= nil and self.actInfo.hadTeam2 or 0
  local toggleShowFlag = hadTeam2 ~= 0
  self.compGroup:SetActive(toggleShowFlag)
  if toggleShowFlag then
    self.compGroup:SetSel(self.curTabIdx, hadTeam2 == 2)
  end
end

function DesertBattleActivityMainRoot:SendGetInfo()
  local curTime = UITimeMgr:GetServerTime()
  if self.lastInfoRequestTime == nil or curTime - self.lastInfoRequestTime > 3000 then
    ActMgr:ReqActInfo()
    self.lastInfoRequestTime = curTime
  end
end

function DesertBattleActivityMainRoot:OnToggle(idx, tf)
  if not tf then
    return
  end
  if idx == 2 then
    local hadTeam2 = self.actInfo ~= nil and self.actInfo.hadTeam2 or 0
    if hadTeam2 ~= 1 then
      local curTime = UITimeMgr:GetServerTime()
      local stopSignUpTime = self.actInfo ~= nil and self.actInfo.stopSignUpTime or 0
      if curTime >= stopSignUpTime then
        self.compGroup:SetSel(1, hadTeam2 == 2)
        UIUtil.ShowTipsId("Desert_strom_tips1037")
        return
      end
    end
  end
  self.curTabIdx = idx
  self:RefreshView()
end

function DesertBattleActivityMainRoot:UpdateData()
  if self.activityId == nil then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.btnInfos.b1 = BTN_STATE.EMPTY
  self.btnInfos.b2 = BTN_STATE.EMPTY
  self.btnInfos.b3 = BTN_STATE.EMPTY
  if self:CheckDsbAct() then
    self:ShowCantJoinNormalDesertBattle()
    return
  end
  self.compCenter:SetActive(true)
  self.actInfo = ActMgr:GetActInfo()
  self:CheckAssignedStateChange()
  local curTime = UITimeMgr:GetServerTime()
  local hadTeam2 = self.actInfo ~= nil and self.actInfo.hadTeam2 or 0
  local stopSignUpTime = self.actInfo ~= nil and self.actInfo.stopSignUpTime or 0
  if curTime > stopSignUpTime and self.curTabIdx == 2 and hadTeam2 ~= 1 then
    self.curTabIdx = 1
  end
  self.dragonInfo = ActMgr:GetGroup(self.curTabIdx)
  if self.actInfo == nil or self.actInfo.stopSignUpTime == nil or self.actInfo.actEndTime ~= nil then
    self:ShowActivityEnd()
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    self:ShowNoSignUp(true)
    return
  end
  local signUp = self.dragonInfo ~= nil and self.dragonInfo.signUp or 0
  if curTime <= self.actInfo.stopSignUpTime then
    self.textTimeTitle:SetLocalText("458016")
    self.endTime = self.actInfo.stopSignUpTime
    if self.curTabIdx == 2 and hadTeam2 == 2 then
      self.btnInfos.b3 = BTN_STATE.RECOVER
      self.btnInfos.s3 = false
    elseif signUp == ActMgr.SignUpState.NoSignUp then
      self.btnInfos.b1 = BTN_STATE.SIGNUP
      self.btnInfos.s1 = false
    elseif signUp == ActMgr.SignUpState.SignUp then
      self.btnInfos.b1 = BTN_STATE.CHANGE
      self.btnInfos.s1 = false
      self.btnInfos.b2 = BTN_STATE.PLAYER
      self.btnInfos.s2 = false
      if self.curTabIdx == 2 and DataCenter.AllianceBaseDataManager:IsR5() then
        self.btnInfos.b3 = BTN_STATE.GIVE_UP
        self.btnInfos.s3 = false
      end
    end
    self:RefreshBottom()
    self:LoadUIState(UI_STATE.IDLE)
    return
  elseif signUp == ActMgr.SignUpState.NoSignUp then
    self:ShowNoSignUp(false)
    return
  end
  self.btnInfos.b1 = BTN_STATE.GO
  self.btnInfos.s1 = true
  self.btnInfos.b2 = BTN_STATE.WATCH
  self.btnInfos.s2 = true
  local timeInfo = self.dragonInfo ~= nil and self.dragonInfo.timeInfo or nil
  if curTime <= self.actInfo.marchEndTime then
    self.textTimeTitle:SetLocalText(458150)
    self.endTime = self.actInfo.marchEndTime
  elseif curTime <= self.actInfo.battleOpenTime then
    self.textTimeTitle:SetLocalText(458153)
    self.endTime = self.actInfo.battleOpenTime
    if timeInfo ~= nil and curTime <= timeInfo.prepTime then
      self.endTime = timeInfo.prepTime
    end
  elseif timeInfo ~= nil and curTime <= timeInfo.prepTime then
    self.textTimeTitle:SetLocalText(458153)
    self.endTime = timeInfo.prepTime
  elseif timeInfo ~= nil and curTime <= timeInfo.battleOpenTime then
    self.textTimeTitle:SetLocalText(458154)
    self.endTime = timeInfo.battleOpenTime
    local tmpGroup = ActMgr:GetMyGroup()
    if tmpGroup and tmpGroup.group == self.curTabIdx then
      self.btnInfos.s1 = false
    end
    self.btnInfos.s2 = false
  elseif timeInfo ~= nil and curTime <= timeInfo.endTime then
    self.textTimeTitle:SetLocalText(458125)
    self.endTime = timeInfo.endTime
    local tmpGroup = ActMgr:GetMyGroup()
    if tmpGroup and tmpGroup.group == self.curTabIdx then
      self.btnInfos.s1 = false
    end
    self.btnInfos.s2 = false
  else
    self.btnInfos.b2 = BTN_STATE.EMPTY
    self:ShowActivityEnd()
    return
  end
  local matchResult = self.dragonInfo ~= nil and self.dragonInfo.matchResult or 0
  if matchResult == 1 then
  elseif matchResult == 2 or matchResult == 3 or matchResult == 4 then
    if matchResult ~= 4 then
      self.textTimeTitle:SetLocalText("458152")
    end
    self.btnInfos.s1 = true
    self.btnInfos.b2 = BTN_STATE.EMPTY
  end
  self:RefreshBottom()
  self:LoadUIState(UI_STATE.BATTLE)
  self:Update1000MS()
end

function DesertBattleActivityMainRoot:Update1000MS()
  local curTime = UITimeMgr:GetServerTime()
  local sendFlag = false
  if self.endTime ~= nil then
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.textRemainTime:SetText(UITimeMgr:MilliSecondToFmtString(remainTime))
    else
      sendFlag = true
    end
  elseif not self:CheckDsbAct() then
    sendFlag = true
  end
  if self.btnInfos.b3 ~= BTN_STATE.EMPTY then
    local hadTeam2 = self.actInfo ~= nil and self.actInfo.hadTeam2 or 0
    if hadTeam2 == 1 then
      local cdTime = self.actInfo ~= nil and self.actInfo.groupOpenCDEndTime or 0
      local remainTime = cdTime - UITimeMgr:GetServerSeconds()
      if 0 < remainTime then
        local str = Localization:GetString("Desert_strom_tips1039") .. "\n" .. UITimeMgr:SecondToFmtStringWithoutDay(remainTime)
        self.textBtnBottom3:SetText(str)
      else
        self.textBtnBottom3:SetLocalText("Desert_strom_tips1039")
      end
    end
  end
  if self.uiState == UI_STATE.BATTLE and self.btnInfos.b2 == BTN_STATE.WATCH then
    self:TryReqBattleInfo(curTime)
  end
  if sendFlag then
    self:SendGetInfo()
  end
end

function DesertBattleActivityMainRoot:TryReqBattleInfo(curTime)
  local lastSyncTime = ActMgr.lastSyncTime or 0
  local lastReqGroup = ActMgr.lastReqGroup or 0
  if curTime - lastSyncTime >= CHECK_SYNC_TIME or lastReqGroup ~= self.curTabIdx then
    ActMgr:RequestBattleInfo(false, self.curTabIdx)
  end
end

function DesertBattleActivityMainRoot:ShowActivityEnd()
  self.btnInfos.b1 = BTN_STATE.GO
  self.btnInfos.s1 = true
  self:RefreshBottom()
  self:LoadUIState(UI_STATE.BATTLE)
  self.btnBattlePlayer:SetActive(false)
  self.textTimeTitle:SetLocalText(372420)
  self:SetEndTime()
  self:Update1000MS()
end

function DesertBattleActivityMainRoot:ShowNoSignUp(bGray)
  self.btnInfos.b1 = BTN_STATE.SIGNUP
  self.btnInfos.s1 = bGray
  self:RefreshBottom()
  self:LoadUIState(UI_STATE.IDLE)
  self.btnBattlePlayer:SetActive(false)
  self.textTimeTitle:SetLocalText(372420)
  self:SetEndTime()
  self:Update1000MS()
end

function DesertBattleActivityMainRoot:CheckDsbAct()
  return BattlefieldDsbDuelUtils.ActInfo:IsRegistered() and BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase()
end

function DesertBattleActivityMainRoot:ShowCantJoinNormalDesertBattle()
  self.btnInfos.b1 = BTN_STATE.DSB
  self.btnInfos.s1 = false
  self:RefreshBottom()
  self:LoadUIState(UI_STATE.EMPTY)
  self.compCenter:SetActive(false)
  self.btnBattlePlayer:SetActive(false)
  self.textDsbStateTips:SetLocalText("dsb_duel_interface_1060")
  self:SetEndTime()
  self:Update1000MS()
end

function DesertBattleActivityMainRoot:SetEndTime()
  self.endTime = nil
  if self.actInfo and self.actInfo.actEndTime ~= nil then
    self.endTime = self.actInfo.actEndTime
  elseif self.activityData ~= nil then
    self.endTime = self.activityData.endTime
  end
end

function DesertBattleActivityMainRoot:RefreshBottom()
  local btnCnt = 0
  btnCnt = btnCnt + self:SetBtnShow(self.btnBottom1, self.textBtnBottom1, self.btnInfos.b1, self.btnInfos.s1)
  btnCnt = btnCnt + self:SetBtnShow(self.btnBottom2, self.textBtnBottom2, self.btnInfos.b2, self.btnInfos.s2)
  btnCnt = btnCnt + self:SetBtnShow(self.btnBottom3, self.textBtnBottom3, self.btnInfos.b3, self.btnInfos.s3)
  local scale = btnCnt <= 2 and 0.85 or 0.7
  self.compBottom:SetLocalScaleXYZ(scale, scale, scale)
  local posOff = btnCnt <= 2 and 0 or 50
  local _, y, z = self.compBottom:GetLocalPositionXYZ()
  self.compBottom:SetLocalPositionXYZ(posOff, y, z)
  self:RefreshTipGo()
end

function DesertBattleActivityMainRoot:RefreshTipGo()
  local myGroup = ActMgr:GetMyGroup()
  local bMyGroup = myGroup and myGroup.group == self.curTabIdx
  local show = bMyGroup and self.btnBottom1:GetActive() and self.btnInfos.b1 == BTN_STATE.GO and BattleFieldUtil.GetBattleFieldCanEnterFlag(BattleFieldType.Desert)
  self.compTipGo:SetActive(show)
  if not show then
    return
  end
  local x = self.btnBottom1:GetLocalPositionXYZ()
  local _, y, z = self.compTipGo:GetLocalPositionXYZ()
  self.compTipGo:SetLocalPositionXYZ(x, y, z)
end

function DesertBattleActivityMainRoot:SetBtnShow(btn, text, s, b)
  btn:SetActive(s ~= BTN_STATE.EMPTY)
  if s == BTN_STATE.EMPTY then
    return 0
  end
  CS.UIGray.SetGray(btn.transform, b, not b)
  if s == BTN_STATE.DSB then
    text:SetLocalText("dsb_duel_tips_1033")
  elseif s == BTN_STATE.CHANGE then
    text:SetLocalText(458018)
  elseif s == BTN_STATE.PLAYER then
    text:SetLocalText(458019)
  elseif s == BTN_STATE.SIGNUP then
    text:SetLocalText(302024)
  elseif s == BTN_STATE.GO then
    text:SetLocalText(458006)
  elseif s == BTN_STATE.WATCH then
    text:SetLocalText("Desert_strom_tips1032")
  elseif s == BTN_STATE.GIVE_UP then
    text:SetLocalText("Desert_strom_tips1039")
  elseif s == BTN_STATE.RECOVER then
    text:SetLocalText("Desert_strom_tips1082")
  end
  return 1
end

function DesertBattleActivityMainRoot:CheckAssignedStateChange()
  local editorUid = self.actInfo ~= nil and self.actInfo.editorUid or nil
  if string.IsNullOrEmpty(editorUid) or editorUid == LuaEntry.Player:GetUid() then
    return
  end
  local myInfo = ActMgr:GetMyGroup()
  local eTime = self.actInfo.stopSignUpTime or 0
  local sGroup, sAssigned, sPeriod, sETime = BattleFieldUtil.GetAssignedInfo(BattleFieldType.Desert)
  if sETime ~= 0 and sETime ~= eTime then
    sGroup, sAssigned, sPeriod, sETime = 0, 0, 0, 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if myInfo == nil then
    if sGroup == 0 then
      return
    end
    local sInfo = ActMgr:GetGroup(sGroup)
    local timeInfo = sInfo ~= nil and sInfo.timeInfo or nil
    local endTime = timeInfo ~= nil and timeInfo.endTime or 0
    if endTime == 0 or curTime >= endTime then
      return
    end
    local param = {
      bfType = BattleFieldType.Desert,
      groupIdx = sGroup,
      assigned = sAssigned,
      battlePeriod = sPeriod,
      editorUid = editorUid,
      inGroup = false
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldAssignedState, {anim = false}, param)
    BattleFieldUtil.SaveAssignedInfo(BattleFieldType.Desert, 0, 0, 0, eTime)
  else
    local assigned = myInfo.assigned or 0
    if assigned == 0 then
      return
    end
    local timeInfo = myInfo.timeInfo or nil
    local endTime = timeInfo ~= nil and timeInfo.endTime or 0
    if endTime == 0 or curTime >= endTime then
      return
    end
    local group = myInfo.group
    local battlePeriod = myInfo.battlePeriod
    if 0 < group and 0 < assigned and (sGroup ~= group or sAssigned ~= assigned or eTime ~= sETime) then
      local param = {
        bfType = BattleFieldType.Desert,
        groupIdx = group,
        assigned = assigned,
        battlePeriod = battlePeriod,
        editorUid = editorUid,
        inGroup = true
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldAssignedState, {anim = false}, param)
      BattleFieldUtil.SaveAssignedInfo(BattleFieldType.Desert, group, assigned, battlePeriod, eTime)
    end
  end
end

return DesertBattleActivityMainRoot
