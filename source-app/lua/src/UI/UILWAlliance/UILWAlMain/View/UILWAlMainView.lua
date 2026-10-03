local UILWAlMainView = BaseClass("UILWAlMainView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MainUp = require("UI.UILWAlliance.UILWAlMain.Component.UILWAlMainUp")
local MainMid = require("UI.UILWAlliance.UILWAlMain.Component.UILWAlMainMid")
local MainDown = require("UI.UILWAlliance.UILWAlMain.Component.UILWAlMainDown")
local AlStarTipBar = require("UI.UILWAlliance.UILWAlMain.Component.UILWAlStarTipBar")
local AlStarTipBarPrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlStarTipBar.prefab"
local title_text_path = "Root/TopBar/TextTitle"
local return_btn_path = "Root/BottomBar/BtnBack"
local up_content_path = "Root/MiddleContentContainer/Up"
local helper_path = "Root/TopBar/HelperBtn"
local mid_content_path = "Root/MiddleContentContainer/ScrollView"
local down_content_path = "Root/BottomBar/BottomBtns"
local middleContentContainer_path = "Root/MiddleContentContainer"
local p_trans_root_alliance_war_state_icon_path = "Root/TopBar/p_trans_root_alliance_war_state_icon"
local season_alliance_war_state_icon_path = "Assets/Main/SeasonRes/S5/Prefabs/UI/AllianceWarTime/SeasonAllianceWarTimeStateIconComp.prefab"
local SeasonAllianceWarTimeStateIconComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Common/SeasonAllianceWarTimeStateIconComp")
local TITLE_TXT = 390002

function UILWAlMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  if SeasonUtil.IsInSeasonSnowMode() then
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
  end
  DataCenter.AllianceStarManager:RequestActivityInfo()
end

function UILWAlMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMainView:ReInit()
  local alId = LuaEntry.Player:GetAllianceUid()
  if alId then
    Logger.LogCustom("\232\129\148\231\155\159ID\239\188\154" .. alId)
  end
  DataCenter.AllianceRallyPointDataManager:TrySendGetLongDistanceMemberNumMsg()
  self:InitAllianceWarTime()
end

function UILWAlMainView:InitAllianceWarTime()
  if DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen(true) and DataCenter.UILWSeasonAllianceWarTimeManager:CanShowOnUI() and IsNotNull(self.p_trans_root_alliance_war_state_icon) then
    self.SeasonWarTimeReq = self:GameObjectInstantiateAsync(season_alliance_war_state_icon_path, function(req)
      local go = req.gameObject
      local transform = go.transform
      local transRoot = self.p_trans_root_alliance_war_state_icon.transform
      transform:SetParent(transRoot)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 0, 0)
      local comp = self:AddComponent(SeasonAllianceWarTimeStateIconComp, go)
      local data = {}
      data.AllianceId = LuaEntry.Player:GetAllianceUid()
      comp:ReInit(data)
    end)
  end
end

function UILWAlMainView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.closeBtn = self:AddComponent(UIButton, return_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.mainUpContent = self:AddComponent(MainUp, up_content_path)
  self.mainMidContent = self:AddComponent(MainMid, mid_content_path)
  self.mainDownContent = self:AddComponent(MainDown, down_content_path)
  self.titleText:SetLocalText(TITLE_TXT)
  self.middleContentContainer = self:AddComponent(UIBaseContainer, middleContentContainer_path)
  self.p_trans_root_alliance_war_state_icon = self:AddComponent(UIBaseContainer, p_trans_root_alliance_war_state_icon_path)
end

function UILWAlMainView:ComponentDestroy()
  if self.SeasonWarTimeReq ~= nil then
    self:GameObjectDestroy(self.SeasonWarTimeReq)
    self.SeasonWarTimeReq = nil
  end
  self.titleText = nil
  self.closeBtn = nil
  self.mainUpContent = nil
  self.mainMidContent = nil
  self.mainDownContent = nil
  self.middleContentContainer = nil
  self.alStarTipBar = nil
  self.p_trans_root_alliance_war_state_icon = nil
end

function UILWAlMainView:DataDefine()
  self.ctrl:SetView(self)
end

function UILWAlMainView:DataDestroy()
  self.ctrl:ClearView()
end

function UILWAlMainView:OnEnable()
  base.OnEnable(self)
  self:RefreshContent()
end

function UILWAlMainView:OnDisable()
  base.OnDisable(self)
end

function UILWAlMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossOccupyStrongholdListUpdate, self.OnOccupyStrongholdListUpdate)
  self:AddUIListener(EventId.AlWaitMergeStatusChange, self.RefreshContent)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.RefreshContent)
  self:AddUIListener(EventId.AllianceAnnouncementTranslateFinish, self.OnAllianceAnnouncementTranslateFinish)
  self:AddUIListener(EventId.AlStarChangePlanTimeStamp, self.RefreshContent)
  self:AddUIListener(EventId.AllianceStarGainActivityInfoNewRefresh, self.RefreshContent)
  self:AddUIListener(EventId.OnPassDay, self.RefreshContent)
end

function UILWAlMainView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CrossOccupyStrongholdListUpdate, self.OnOccupyStrongholdListUpdate)
  self:RemoveUIListener(EventId.AlWaitMergeStatusChange, self.RefreshContent)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.RefreshContent)
  self:RemoveUIListener(EventId.AllianceAnnouncementTranslateFinish, self.OnAllianceAnnouncementTranslateFinish)
  self:RemoveUIListener(EventId.AlStarChangePlanTimeStamp, self.RefreshContent)
  self:RemoveUIListener(EventId.AllianceStarGainActivityInfoNewRefresh, self.RefreshContent)
  self:RemoveUIListener(EventId.OnPassDay, self.RefreshContent)
end

function UILWAlMainView:OnOccupyStrongholdListUpdate()
  self.mainMidContent:RefreshContent()
end

function UILWAlMainView:OnAllianceAnnouncementTranslateFinish(data)
  local alInfos = self.view.ctrl:GetAlInfos()
  if alInfos.uid == data.uid then
    local msg = data.translateMsg
    self.mainUpContent:OnAllianceAnnouncementTranslateFinish(msg)
  end
end

function UILWAlMainView:InitSetting()
end

function UILWAlMainView:SetSettingShow(is_show)
end

function UILWAlMainView:RefreshContent()
  self.mainUpContent:RefreshContent()
  self.mainMidContent:RefreshContent()
  self.mainDownContent:RefreshContent()
  self:RefreshAlStarTipBar()
end

function UILWAlMainView:RefreshAlStarTipBar()
  local show = DataCenter.AllianceStarManager:IsShowAlStarTipBar()
  if show and self.alStarTipBar == nil then
    self.alStarTipBar = self:LoadComponentAsync(AlStarTipBar, AlStarTipBarPrefabPath, self.middleContentContainer.transform)
  end
  if self.alStarTipBar ~= nil then
    self.alStarTipBar:SetActive(show)
  end
  if show then
    self.mainMidContent:SetScrollViewOffsetMinXY(0, 190)
    self.alStarTipBar:UpdateData()
  else
    self.mainMidContent:SetScrollViewOffsetMinXY(0, 30)
  end
end

return UILWAlMainView
