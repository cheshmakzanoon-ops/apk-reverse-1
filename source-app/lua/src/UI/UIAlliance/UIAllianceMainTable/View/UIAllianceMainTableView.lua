local AllianceMain = require("UI.UIAlliance.UIAllianceMainTable.Component.AllianceMain")
local AllianceManage = require("UI.UIAlliance.UIAllianceMainTable.Component.AllianceManage")
local AllianceMember = require("UI.UIAlliance.UIAllianceMemberDetail.Component.AllianceMember")
local UIAllianceCareer = require("UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareer")
local UIAllianceMainTableView = BaseClass("UIAllianceMainTableView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local toogle1_path = "ImgBg/Tab/Toggle1"
local toogle2_path = "ImgBg/Tab/Toggle2"
local toogle3_path = "ImgBg/Tab/Toggle3"
local toogle4_path = "ImgBg/Tab/Toggle4"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local goback_btn_path = "UICommonPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonPopUpTitle/panel"
local alliance_main_path = "ImgBg/AllianceMain"
local allianceMenberContainer_path = "ImgBg/AllianceMember"
local alliance_member_path = "ImgBg/AllianceMember/AllianceMember"
local alliance_manage_path = "ImgBg/AllianceManage"
local alliance_career_path = "ImgBg/UIAllianceCareer"
local guide_btn_path = "GuideShowNode"
local guide_hole_path = "GuideShowNode/HoleImg"
local guide_mask_path = "GuideShowNode/HoleImg/MaskImg"

local function OnCreate(self)
  base.OnCreate(self)
  local isPlayerInfo, defaultToggle = self:GetUserData()
  self.showInactiveTip = DataCenter.AllianceMemberDataManager:CheckIfNeedInactiveMemberBubble() > 0
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(GameDialogDefine.ALLIANCE)
  self.alliance_main = self:AddComponent(AllianceMain, alliance_main_path)
  self.allianceMemberContainer = self:AddComponent(UIBaseContainer, allianceMenberContainer_path)
  self.alliance_manage = self:AddComponent(AllianceManage, alliance_manage_path)
  self.alliance_career_go = self:AddComponent(UIBaseContainer, alliance_career_path)
  self.toogle1 = self:AddComponent(UIToggle, toogle1_path)
  self.toogle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle1.choose = self.toogle1:AddComponent(UIBaseContainer, "Choose")
  self.toogle1.redPoint = self.toogle1:AddComponent(UIBaseContainer, "ImgWarn")
  self.toogle1.redPoint.text = self.toogle1.redPoint:AddComponent(UIText, "TxtNum")
  self.toogle2 = self:AddComponent(UIToggle, toogle2_path)
  self.toogle2:SetOnValueChanged(function(tf)
    if tf then
      if not self.alliance_member then
        self.alliance_member = self:AddComponent(AllianceMember, alliance_member_path)
      end
      self:ToggleControlBorS()
    end
  end)
  self.toogle2.choose = self.toogle2:AddComponent(UIBaseContainer, "Choose")
  self.toogle2.redPoint = self.toogle2:AddComponent(UIBaseContainer, "ImgWarn")
  self.toogle2.redPoint.text = self.toogle2.redPoint:AddComponent(UIText, "TxtNum")
  self.toogle3 = self:AddComponent(UIToggle, toogle3_path)
  self.toogle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toogle3.choose = self.toogle3:AddComponent(UIBaseContainer, "Choose")
  self.toogle3.redPoint = self.toogle3:AddComponent(UIBaseContainer, "ImgWarn")
  self.toogle3.redPoint.text = self.toogle3.redPoint:AddComponent(UIText, "TxtNum")
  self.toogle4 = self:AddComponent(UIToggle, toogle4_path)
  self.toogle4:SetOnValueChanged(function(tf)
    if tf then
      if not self.alliance_career then
        self.alliance_career = self:AddComponent(UIAllianceCareer, alliance_career_path)
      end
      self:ToggleControlBorS()
    end
  end)
  self.toogle4.choose = self.toogle4:AddComponent(UIBaseContainer, "Choose")
  self.toogle4.redPoint = self.toogle4:AddComponent(UIBaseContainer, "ImgWarn")
  self.toogle4.redPoint.text = self.toogle4.redPoint:AddComponent(UIText, "TxtNum")
  self.toogle4:SetActive(DataCenter.AllianceCareerManager:Enabled())
  self.toogle1:SetIsOn(not defaultToggle or defaultToggle == 1)
  self.toogle2:SetIsOn(defaultToggle and defaultToggle == 2)
  self.toogle3:SetIsOn(defaultToggle and defaultToggle == 3)
  self.toogle4:SetIsOn(defaultToggle and defaultToggle == 4)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    if isPlayerInfo then
      self.ctrl:CloseAll()
    else
      self.ctrl:CloseSelf()
    end
  end)
  self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
  self.goback_btn:SetActive(isPlayerInfo)
  self.goback_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.needShowSelfRank = true
  self:TryShowRecommendList()
  if not self:TryShowAlMoveTip() and not self:TryShowSettingTip() then
    self:TryShowRemoveInaciveTip()
  end
  self.needGuideRefresh = false
end

local function OnDestroy(self)
  self.txt_title = nil
  self.toogle1.redPoint.text = nil
  self.toogle1.redPoint = nil
  self.toogle1 = nil
  self.toogle2.redPoint.text = nil
  self.toogle2.redPoint = nil
  self.toogle2 = nil
  self.toogle3.redPoint.text = nil
  self.toogle3.redPoint = nil
  self.toogle3 = nil
  self.alliance_main = nil
  self.alliance_manage = nil
  self.alliance_career = nil
  self.alliance_career_go = nil
  self.close_btn = nil
  self.return_btn = nil
  self.showInactiveTip = nil
  base.OnDestroy(self)
end

local function ToggleControlBorS(self)
  self.toogle1.choose:SetActive(self.toogle1:GetIsOn())
  self.toogle2.choose:SetActive(self.toogle2:GetIsOn())
  self.toogle3.choose:SetActive(self.toogle3:GetIsOn())
  self.toogle4.choose:SetActive(self.toogle4:GetIsOn())
  self.alliance_main:SetActive(self.toogle1:GetIsOn())
  self.allianceMemberContainer:SetActive(self.toogle2:GetIsOn())
  self.alliance_manage:SetActive(self.toogle3:GetIsOn())
  self.alliance_career_go:SetActive(self.toogle4:GetIsOn())
  if self.toogle1:GetIsOn() then
    self.txt_title:SetLocalText(390002)
  elseif self.toogle2:GetIsOn() then
    self.txt_title:SetLocalText(390199)
    DataCenter.AllianceMemberDataManager:SetCheckedInactiveMember(true)
    DataCenter.AllianceMemberDataManager:SetInactiveMemberBubbleT()
    DataCenter.BuildBubbleManager:UpdateAllianceSignal()
    self.inactiveCount = DataCenter.AllianceMemberDataManager:GetInactivePlayerCount()
    if DataCenter.AllianceBaseDataManager:IsR4orR5() and self.inactiveCount > 0 then
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClearAllianceMember, SaveGuideDoneValue)
    end
    self:OnRefreshMemberRedPoint()
  elseif self.toogle3:GetIsOn() then
    self.txt_title:SetLocalText(280012)
  elseif self.toogle4:GetIsOn() then
    self.txt_title:SetLocalText(tonumber(GameDialogDefine.ALLIANCE_CAREER))
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ToggleControlBorS()
  self:OnRefreshMainRedPot()
  self:OnRefreshMemberRedPoint()
  self:OnRefreshManageRedPot()
  self:OnRefreshCareerRedPot()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function TryShowRecommendList(self)
  local hasRecommend = DataCenter.AllianceMemberDataManager:CheckIfHasRecommendMember()
  if hasRecommend then
    SFSNetwork.SendMessage(MsgDefines.GetAlMemberRecommendList)
  end
end

local function TryShowSettingTip(self)
  local needTip = DataCenter.AllianceBaseDataManager:CheckIfNeedSettingTip()
  if needTip then
    UIUtil.ShowMessage(Localization:GetString("141093"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.toogle3:SetIsOn(true)
    end, nil)
    return true
  else
    return false
  end
end

local function TryShowAlMoveTip(self)
  if DataCenter.AllianceBaseDataManager:CheckIfNeedMoveTipOnOpen() then
    SFSNetwork.SendMessage(MsgDefines.WorldAlMove, 1)
    DataCenter.AllianceBaseDataManager:UpdateShowMoveTipTimes(1)
    return true
  else
    return false
  end
end

local function TryShowRemoveInaciveTip(self)
  if self.showInactiveTip then
    local strK = "RemoveAllianceInactive_" .. LuaEntry.Player.uid
    local lastTimeS = CS.GameEntry.Setting:GetInt(strK, 0)
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, serverTime)
    if not sameDay then
      UIUtil.ShowMessage(Localization:GetString("391100"), 2, "110003", GameDialogDefine.CANCEL, function()
        self.toogle2:SetIsOn(true)
      end, nil)
      CS.GameEntry.Setting:SetInt(strK, serverTime)
      return true
    end
  end
  return false
end

local function OnRefreshMainRedPot(self)
  local count = self.ctrl:GetToggleRedPointCount(1)
  if 0 < count then
    self.toogle1.redPoint:SetActive(true)
    self.toogle1.redPoint.text:SetText(count)
  else
    self.toogle1.redPoint:SetActive(false)
  end
end

local function OnRefreshMemberRedPoint(self)
  local count = self.ctrl:GetToggleRedPointCount(5)
  if 0 < count then
    self.toogle2.redPoint:SetActive(true)
    self.toogle2.redPoint.text:SetText(count)
  else
    self.toogle2.redPoint:SetActive(false)
  end
end

local function OnRefreshManageRedPot(self)
  local count = self.ctrl:GetToggleRedPointCount(2)
  if 0 < count then
    self.toogle3.redPoint:SetActive(true)
    self.toogle3.redPoint.text:SetText(count)
  else
    self.toogle3.redPoint:SetActive(false)
  end
end

local function OnRefreshCareerRedPot(self)
  local count = self.ctrl:GetToggleRedPointCount(4)
  if 0 < count then
    self.toogle4.redPoint:SetActive(true)
    self.toogle4.redPoint.text:SetText(count)
  else
    self.toogle4.redPoint:SetActive(false)
  end
end

local function OnShowAllianceMemberTips(self, uid, rank, posX, posY, name)
  self.ctrl:OnShowAllianceMemberTips(uid, rank, posX, posY, name)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceWarUpdate, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.UpdateAllianceGiftNum, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.OnAllianceTaskRedChange, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.DailyQuestSuccess, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.DailyQuestReward, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.UpdateAlertData, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.RefreshAlertUI, self.OnRefreshMainRedPot)
  self:AddUIListener(EventId.AllianceQuitOK, self.AllianceQuit)
  self:AddUIListener(EventId.AllianceMember, self.OnAllianceMemberSignal)
  self:AddUIListener(EventId.RefreshAllianceCareer, self.OnRefreshAllianceCareerSignal)
  self:AddUIListener(EventId.OnGetRecommendAlPoint, self.OnRecvRecommendPoint)
  self:AddUIListener(EventId.DeclareWar, self.OnRefreshMainRedPot)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.UpdateAllianceGiftNum, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.DailyQuestSuccess, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.DailyQuestReward, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.OnAllianceTaskRedChange, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.UpdateAlertData, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.RefreshAlertUI, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.DeclareWar, self.OnRefreshMainRedPot)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.AllianceQuit)
  self:RemoveUIListener(EventId.AllianceMember, self.OnAllianceMemberSignal)
  self:RemoveUIListener(EventId.RefreshAllianceCareer, self.OnRefreshAllianceCareerSignal)
  self:RemoveUIListener(EventId.OnGetRecommendAlPoint, self.OnRecvRecommendPoint)
end

local function AllianceQuit(self)
  self.ctrl:CloseSelf()
end

local function OnAllianceMemberSignal(self)
  if self.alliance_career ~= nil then
    self.alliance_career:OnAllianceMemberSignal()
  end
  self:OnRefreshCareerRedPot()
end

local function OnRefreshAllianceCareerSignal(self)
  if self.alliance_career ~= nil then
    self.alliance_career:OnRefreshAllianceCareerSignal()
  end
  self:OnRefreshCareerRedPot()
end

local function OnRecvRecommendPoint(self, point)
  local pos1 = SceneUtils.IndexToTilePos(point, ForceChangeScene.World)
  local mainPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  local distance = math.ceil(SceneUtils.TileDistance(pos1, mainPos))
  local confDistance = LuaEntry.DataConfig:TryGetNum("union_move", "k1")
  if distance > confDistance then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoveCityTip, {anim = true}, {openType = 1, isInviteMove = false})
  end
end

local function DoSpecialGuide(self, guideParam)
  if guideParam ~= nil then
    self.guideState = 1
    self.guideParam = guideParam
    self.needGuideRefresh = true
    self:RefreshSpecialGuide()
  end
end

local function RefreshSpecialGuide(self)
  if self.needGuideRefresh then
    local param = self.guideParam[self.guideState]
    if param ~= nil then
      local btnType = param.btnType
      local cell = self.alliance_main:GetBtnCellByBtnType(btnType)
      if cell == nil then
        Logger.LogError("shimin ------------------------  cell == nil")
        self.needGuideRefresh = true
      else
        Logger.LogError("shimin ------------------------  cell ~= nil")
        self.needGuideRefresh = false
        if self.guide_btn == nil then
          self:GuideComponentDefine()
          self.guide_btn:SetActive(true)
          self.guide_mask.rectTransform:Set_sizeDelta(self.guide_btn.rectTransform.rect.width, self.guide_btn.rectTransform.rect.height)
        else
          self.guide_btn:SetActive(true)
        end
        self.guide_hole.transform.position = cell.transform.position + Vector3.New(0, -20, 0)
        self.guide_mask.transform.localPosition = -self.guide_hole.transform.localPosition
        if param.modelName ~= nil then
          local headParam = {}
          headParam.dialog = Localization:GetString(param.dialog)
          headParam.modelName = param.modelName
          headParam.modelPosition = param.modelPosition
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
            EventManager:GetInstance():Broadcast(EventId.RefreshUIGuideHeadTalk, headParam)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false}, headParam)
          end
        end
      end
    end
  end
end

local function GuideComponentDefine(self)
  self.guide_btn = self:AddComponent(UIButton, guide_btn_path)
  self.guide_btn:SetOnClick(function()
    self:OnClickGuideBtn()
  end)
  self.guide_hole = self:AddComponent(UIBaseContainer, guide_hole_path)
  self.guide_mask = self:AddComponent(UIBaseContainer, guide_mask_path)
end

local function OnClickGuideBtn(self)
  self.guideState = self.guideState + 1
  if self.guideState > table.count(self.guideParam) then
    self.guide_btn:SetActive(false)
    self.needGuideRefresh = false
    self.guideParam = nil
    if DataCenter.GuideManager:GetGuideType() == GuideType.AlliancePanelGuide then
      DataCenter.GuideManager:DoNext()
    end
  else
    self.needGuideRefresh = true
    self:RefreshSpecialGuide()
  end
end

local function CheckIfNeedShowSelfRank(self, switchStatus)
  local cacheStatus = self.needShowSelfRank
  if self.needShowSelfRank and switchStatus then
    self.needShowSelfRank = false
  end
  return cacheStatus
end

local function CheckIfShowMemberOnly(self)
  return false
end

UIAllianceMainTableView.OnCreate = OnCreate
UIAllianceMainTableView.OnDestroy = OnDestroy
UIAllianceMainTableView.ToggleControlBorS = ToggleControlBorS
UIAllianceMainTableView.OnEnable = OnEnable
UIAllianceMainTableView.OnDisable = OnDisable
UIAllianceMainTableView.OnRefreshMainRedPot = OnRefreshMainRedPot
UIAllianceMainTableView.OnRefreshMemberRedPoint = OnRefreshMemberRedPoint
UIAllianceMainTableView.OnAddListener = OnAddListener
UIAllianceMainTableView.OnRemoveListener = OnRemoveListener
UIAllianceMainTableView.OnRefreshManageRedPot = OnRefreshManageRedPot
UIAllianceMainTableView.OnShowAllianceMemberTips = OnShowAllianceMemberTips
UIAllianceMainTableView.AllianceQuit = AllianceQuit
UIAllianceMainTableView.TryShowRecommendList = TryShowRecommendList
UIAllianceMainTableView.TryShowSettingTip = TryShowSettingTip
UIAllianceMainTableView.OnRefreshCareerRedPot = OnRefreshCareerRedPot
UIAllianceMainTableView.OnAllianceMemberSignal = OnAllianceMemberSignal
UIAllianceMainTableView.OnRefreshAllianceCareerSignal = OnRefreshAllianceCareerSignal
UIAllianceMainTableView.TryShowAlMoveTip = TryShowAlMoveTip
UIAllianceMainTableView.OnRecvRecommendPoint = OnRecvRecommendPoint
UIAllianceMainTableView.DoSpecialGuide = DoSpecialGuide
UIAllianceMainTableView.GuideComponentDefine = GuideComponentDefine
UIAllianceMainTableView.OnClickGuideBtn = OnClickGuideBtn
UIAllianceMainTableView.RefreshSpecialGuide = RefreshSpecialGuide
UIAllianceMainTableView.CheckIfNeedShowSelfRank = CheckIfNeedShowSelfRank
UIAllianceMainTableView.TryShowRemoveInaciveTip = TryShowRemoveInaciveTip
UIAllianceMainTableView.CheckIfShowMemberOnly = CheckIfShowMemberOnly
return UIAllianceMainTableView
