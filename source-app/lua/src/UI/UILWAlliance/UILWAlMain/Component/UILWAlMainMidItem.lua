local UILWAlMainMidItem = BaseClass("UILWAlMainMidItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local icon_path = "Icon"
local txt_path = "Text"
local click_btn_path = ""
local red_pot_path = "CommonRedPoint"
local time_go_path = "timeGo"
local time_text_path = "timeGo/countDownTxt"
local time_tip_text_path = "timeGo/countDownTipTxt"
local InactiveNodePath = "Assets/Main/Prefabs/UI/Alliance/AllianceInfo/UIAllianceInfoInactiveNode.prefab"
local UIAllianceInfoInactiveNode = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoInactiveNode")
local SalaryNodePrefabPath = "Assets/Main/Prefabs/UI/Alliance/Component/UIAllianceDailySalaryNode.prefab"
local UIAllianceDailySalaryNode = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceDailySalaryNode")

function UILWAlMainMidItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMainMidItem:OnDestroy()
  self:DelTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMainMidItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.eff_ui_s1_alliance_fire_02 = self:AddComponent(UIBaseComponent, "Eff_ui_S1_alliance_fire_02")
  self.eff_ui_s1_alliance_fire_02:SetActive(false)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.text = self:AddComponent(UIText, txt_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, red_pot_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.countDownGo = self:AddComponent(UIBaseContainer, time_go_path)
  self.countDownTxt = self:AddComponent(UIText, time_text_path)
  self.countDownTipTxt = self:AddComponent(UIText, time_tip_text_path)
end

function UILWAlMainMidItem:ComponentDestroy()
  if self.inactiveReq then
    self:GameObjectDestroy(self.inactiveReq)
    self.inactiveReq = nil
  end
  self.inactiveNode = nil
  if self.salaryReq then
    self:GameObjectDestroy(self.salaryReq)
    self.salaryReq = nil
  end
  self.salaryNode = nil
  self.icon = nil
  self.text = nil
  self.clickBtn = nil
  self.commonRedPoint = nil
  self.countDownGo = nil
  self.countDownTxt = nil
end

function UILWAlMainMidItem:DataDefine()
  self.type = 0
  self.clickCall = nil
end

function UILWAlMainMidItem:DataDestroy()
  self.type = nil
  self.clickCall = nil
end

function UILWAlMainMidItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMainMidItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMainMidItem:OnAddListener()
  self:AddUIListener(EventId.CloseUI, self.OnCloseUI)
  self:AddUIListener(EventId.PushAllianceHaveFriendsUpdate, self.OnFriendsUpdate)
  self:AddUIListener(EventId.PushAllianceFriendsLeaveUpdate, self.OnFriendsUpdate)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnFriendsUpdate)
  self:AddUIListener(EventId.AllianceWarEventRefresh, self.RefreshFire)
  self:AddUIListener(EventId.AllianceWarEventReminderChange, self.RefreshFire)
  self:AddUIListener(EventId.OnAllianceMilitaryStatusChange, self.OnAllianceMilitaryStatusChange)
  self:AddUIListener(EventId.UpdateMainAllianceRedCount, self.OnRefreshRedPot)
  self:AddUIListener(EventId.CampScienceRefreshRed, self.OnRefreshRedPot)
  base.OnAddListener(self)
end

function UILWAlMainMidItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PushAllianceHaveFriendsUpdate, self.OnFriendsUpdate)
  self:RemoveUIListener(EventId.PushAllianceFriendsLeaveUpdate, self.OnFriendsUpdate)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnFriendsUpdate)
  self:RemoveUIListener(EventId.AllianceWarEventRefresh, self.RefreshFire)
  self:RemoveUIListener(EventId.AllianceWarEventReminderChange, self.RefreshFire)
  self:RemoveUIListener(EventId.CloseUI, self.OnCloseUI)
  self:RemoveUIListener(EventId.OnAllianceMilitaryStatusChange, self.OnAllianceMilitaryStatusChange)
  self:RemoveUIListener(EventId.UpdateMainAllianceRedCount, self.OnRefreshRedPot)
  self:RemoveUIListener(EventId.CampScienceRefreshRed, self.OnRefreshRedPot)
  base.OnRemoveListener(self)
end

function UILWAlMainMidItem:OnCloseUI()
  self:OnRefreshRedPot()
end

function UILWAlMainMidItem:OnFriendsUpdate()
  if self.type == LWAlMainMidBtnType.Al_MakeFriends then
    local allyAllianceId = DataCenter.SeasonAllyFriendManager:GetFriendAllyId()
    if allyAllianceId ~= nil and allyAllianceId ~= "" then
      local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allyAllianceId)
      if data ~= nil then
        self.text:SetText(UIUtil.FormatServerAllianceName(data.createServer or data.ownerServerId, data.abbr))
      else
        self.text:SetLocalText("s6_alliance_ally_btn02")
      end
    else
      self.text:SetLocalText("s6_alliance_ally_btn02")
    end
  end
end

function UILWAlMainMidItem:SetData(params)
  self.type = params.type
  self.clickCall = params.clickCall
  local infos = LWAlMainMidBtnParam[self.type]
  if infos then
    self.icon:LoadSprite(infos.Icon)
    self.text:SetLocalText(infos.Text)
    self.icon:SetNativeSize()
  end
  if self.bg then
    local isInSeason = SeasonUtil.IsInSeason()
    local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
    if params.type == LWAlMainMidBtnType.Al_MilitaryPay and not DataCenter.AllianceMilitaryPayDataManager:IsDuringStateOpen() then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/LWAllianceMilitaryPay/mjc_lianmeng_anniu_3.png")
    elseif params.type == LWAlMainMidBtnType.Al_SeasonCity or params.type == LWAlMainMidBtnType.Al_SeasonDevote or params.type == LWAlMainMidBtnType.Al_SeasonMilestone or params.type == LWAlMainMidBtnType.Al_CityAttachment or params.type == LWAlMainMidBtnType.Al_MakeFriends or params.type == LWAlMainMidBtnType.Al_Science and isInSeason and seasonType == SeasonMapType.Desert or params.type == LWAlMainMidBtnType.Al_City and isInSeason and seasonType ~= SeasonMapType.Desert or params.type == LWAlMainMidBtnType.Al_City_Effect or params.type == LWAlMainMidBtnType.Al_SeasonStoveCenter or params.type == LWAlMainMidBtnType.Al_SeasonMilitaryCenter or params.type == LWAlMainMidBtnType.Al_Season4Center or params.type == LWAlMainMidBtnType.Al_GovernmentSkill and isInSeason and seasonType ~= SeasonMapType.Desert or params.type == LWAlMainMidBtnType.Al_Camp_Science and isInSeason or params.type == LWAlMainMidBtnType.Al_Alliance_Skill and isInSeason then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail/cfm_lianmeng_anniu_2.png")
    else
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail/cfm_lianmeng_anniu_1.png")
    end
  end
  if self.type == LWAlMainMidBtnType.Al_MakeFriends then
    self:OnFriendsUpdate()
  end
  self:RefreshFire()
  self:RefreshCd()
  self:RefreshSalaryNode()
end

function UILWAlMainMidItem:RefreshCd()
  if self.type == LWAlMainMidBtnType.Al_Achieve then
    self.countDownGo:SetActive(true)
    local isOpen, endT, isEnd = DataCenter.AllianceTaskManager:CheckIfAllianceTaskOpen()
    if isOpen then
      self.endTime = endT
      self:SetRemainTime()
      self:AddTimer()
      if isEnd then
        self.countDownTipTxt:SetActive(true)
        self.countDownTipTxt:SetLocalText(455050)
        self.countDownTxt:SetColor(Color.New(0.9764705882352941, 0.4392156862745098, 0.4666666666666667, 1))
      else
        self.countDownTipTxt:SetActive(false)
        self.countDownTxt:SetColor(Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1))
      end
    else
      self:SetActive(false)
    end
  else
    self.countDownGo:SetActive(false)
  end
end

function UILWAlMainMidItem:OnClick()
  if self.clickCall then
    self.clickCall(self.type)
  end
end

function UILWAlMainMidItem:OnRefreshRedPot()
  if self.view then
    local count = self.view.ctrl:GetRedPotCountByType(self.type)
    if self.type == LWAlMainMidBtnType.Al_Gift then
      self.commonRedPoint:SetNum(count)
    else
      self.commonRedPoint:SetDefaultVisible(0 < count)
    end
  else
    Logger.LogWarning("[OnRefreshAlActivity] \232\183\179\232\191\135\230\151\160\230\149\136 item , view \228\184\186 nil")
  end
end

function UILWAlMainMidItem:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function UILWAlMainMidItem:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.countDownTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:RefreshCd()
  end
end

function UILWAlMainMidItem:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILWAlMainMidItem:RefreshFire()
  if self.type == LWAlMainMidBtnType.Al_War then
    self.eff_ui_s1_alliance_fire_02:SetActive(DataCenter.AllianceWarEventDataManager:CheckHasReminder())
  end
end

function UILWAlMainMidItem:RefreshInactiveNode(isInit)
  if self.type == LWAlMainMidBtnType.Al_Member then
    local needSend = DataCenter.AllianceMemberDataManager:CheckOpenAlMainNeedReqAlRank()
    if needSend and isInit then
      SFSNetwork.SendMessage(MsgDefines.AlRank, LuaEntry.Player.allianceId)
    elseif DataCenter.AllianceMemberDataManager:NeedShowInactiveTag() then
      if self.inactiveReq == nil then
        self.inactiveReq = self:GameObjectInstantiateAsync(InactiveNodePath, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.transform:SetParent(self.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.transform:Set_localPosition(120 * CommonUtil.ArabicAutoMirrorFactor(), 40, ResetPosition.z)
          self.inactiveNode = self:AddComponent(UIAllianceInfoInactiveNode, go)
          self:RefreshInactiveNodeShow()
        end)
      else
        self:RefreshInactiveNodeShow()
      end
    else
      self:RefreshInactiveNodeShow()
    end
  else
    self:RefreshInactiveNodeShow()
  end
end

function UILWAlMainMidItem:RefreshInactiveNodeShow()
  if self.inactiveNode then
    if self.type == LWAlMainMidBtnType.Al_Member and DataCenter.AllianceMemberDataManager:NeedShowInactiveTag() then
      self.inactiveNode:SetActive(true)
      self.inactiveNode:SetData(true)
    else
      self.inactiveNode:SetActive(false)
    end
  end
end

function UILWAlMainMidItem:OnAllianceMember()
  self:RefreshInactiveNode(false)
end

function UILWAlMainMidItem:RefreshSalaryNode()
  if self.type == LWAlMainMidBtnType.Al_MilitaryPay then
    if self.salaryReq == nil then
      self.salaryReq = self:GameObjectInstantiateAsync(SalaryNodePrefabPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(0.7, 0.7, 0.7)
        go.transform:Set_localPosition(-127 * CommonUtil.ArabicAutoMirrorFactor(), -0.5, ResetPosition.z)
        self.salaryNode = self:AddComponent(UIAllianceDailySalaryNode, go)
        self:RefreshSalaryNodeShow()
      end)
    else
      self:RefreshSalaryNodeShow()
    end
  else
    self:RefreshSalaryNodeShow()
  end
end

function UILWAlMainMidItem:RefreshSalaryNodeShow()
  if self.salaryNode then
    if self.type == LWAlMainMidBtnType.Al_MilitaryPay then
      self.salaryNode:SetActive(true)
      self.salaryNode:SetData()
    else
      self.salaryNode:SetActive(false)
    end
  end
end

function UILWAlMainMidItem:OnAllianceMilitaryStatusChange(status)
  if self.type ~= LWAlMainMidBtnType.Al_MilitaryPay then
    return
  end
  if status == SalaryActivityState.Open then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail/cfm_lianmeng_anniu_1.png")
  end
end

return UILWAlMainMidItem
