local UILWAlCreateJoinView = BaseClass("UILWAlCreateJoinView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWAlJoin = require("UI.UILWAlliance.UILWAlCreateJoin.Component.UILWAlJoin")
local UILWAlCreate = require("UI.UILWAlliance.UILWAlCreateJoin.Component.UILWAlCreate")
local close_btn_path = "Root/BottomBar/BtnBack"
local title_text_path = "Root/TopBar/TextTitle"
local join_title_text_path = "Root/Content/TitleHolder/TitleJoinHolder/JoinTitleText"
local join_select_bg_path = "Root/Content/TitleHolder/TitleJoinHolder/JoinSelectBg"
local join_btn_path = "Root/Content/TitleHolder/TitleJoinHolder/JoinClickBtn"
local join_content_path = "Root/Content/ContentHolder/ContentJoinHolder"
local create_title_text_path = "Root/Content/TitleHolder/TitleCreateHolder/CreateTitleText"
local create_select_bg_path = "Root/Content/TitleHolder/TitleCreateHolder/CreateSelectBg"
local create_btn_path = "Root/Content/TitleHolder/TitleCreateHolder/CreateClickBtn"
local create_content_path = "Root/Content/ContentHolder/ContentCreateHolder"
local ALLIANCE_TITLE_TXT = 390002
local JOIN_TITLE_TXT = 110037
local CREATE_TITLE_TXT = 100645
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")

function UILWAlCreateJoinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.joinSelectBg:SetActive(false)
  self.joinContent:SetActive(false)
  self.createSelectBg:SetActive(false)
  self.createContent:SetActive(false)
  SFSNetwork.SendMessage(MsgDefines.AlSearch, 1, 1, "", 0, true)
  SFSNetwork.SendMessage(MsgDefines.AlJoinCd)
end

function UILWAlCreateJoinView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlCreateJoinView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    if self.joinContent:GetActive() then
      AlPostEventLog.PostEventLog_ListJoin_Action(AlPostEventLog.JoinAction.Close)
    elseif self.createContent:GetActive() then
      AlPostEventLog.PostEventLog_ListCreat_Action(AlPostEventLog.CreatAction.Close)
    end
    if self.al_lose_callback then
      self.al_lose_callback()
    end
    self.ctrl:CloseSelf()
  end)
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.titleText:SetLocalText(ALLIANCE_TITLE_TXT)
  self.joinTitleText = self:AddComponent(UIText, join_title_text_path)
  self.joinTitleText:SetLocalText(JOIN_TITLE_TXT)
  self.joinSelectBg = self:AddComponent(UIBaseContainer, join_select_bg_path)
  self.joinBtn = self:AddComponent(UIButton, join_btn_path)
  self.joinContent = self:AddComponent(UILWAlJoin, join_content_path)
  self.joinBtn:SetOnClick(function()
    self:ContentTrans(true)
    AlPostEventLog.PostEventLog_ListCreat_Action(AlPostEventLog.CreatAction.Join)
  end)
  self.createTitleText = self:AddComponent(UIText, create_title_text_path)
  self.createTitleText:SetLocalText(CREATE_TITLE_TXT)
  self.createSelectBg = self:AddComponent(UIBaseContainer, create_select_bg_path)
  self.createBtn = self:AddComponent(UIButton, create_btn_path)
  self.createContent = self:AddComponent(UILWAlCreate, create_content_path)
  self.createBtn:SetOnClick(function()
    self:ContentTrans(false)
    AlPostEventLog.PostEventLog_ListJoin_Action(AlPostEventLog.JoinAction.Creat)
  end)
end

function UILWAlCreateJoinView:ComponentDestroy()
  self.closeBtn = nil
  self.titleText = nil
  self.joinTitleText = nil
  self.joinSelectBg = nil
  self.joinBtn = nil
  self.joinContent = nil
  self.createTitleText = nil
  self.createSelectBg = nil
  self.createBtn = nil
  self.createContent = nil
end

function UILWAlCreateJoinView:DataDefine()
  self.curShowContent = 0
  self.showJoin = true
  self.isFirstSendMessage = true
end

function UILWAlCreateJoinView:DataDestroy()
  self.curShowContent = nil
  self.showJoin = nil
  self.isFirstSendMessage = nil
end

function UILWAlCreateJoinView:OnEnable()
  base.OnEnable(self)
end

function UILWAlCreateJoinView:OnDisable()
  base.OnDisable(self)
end

function UILWAlCreateJoinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.ReInit)
  self:AddUIListener(EventId.AlCreateJoinViewJumpCreatePage, self.JumpCreatePage)
end

function UILWAlCreateJoinView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.ReInit)
  self:RemoveUIListener(EventId.AlCreateJoinViewJumpCreatePage, self.JumpCreatePage)
end

function UILWAlCreateJoinView:ReInit()
  local search_al_id_list = DataCenter.AllianceTempListManager:GetSearchAllianceIdList()
  if self.isFirstSendMessage then
    self.showJoin = table.count(search_al_id_list) > 0
    self.isFirstSendMessage = false
  end
  local params = self:GetUserData()
  if params.showJoin ~= nil then
    self.showJoin = params.showJoin
  end
  self.al_success_callback = params.al_success_callback
  self.al_lose_callback = params.al_lose_callback
  self.tipStr = params.tipStr
  self:ContentTrans(self.showJoin, params.tipStr)
end

function UILWAlCreateJoinView:ContentTrans(show_join)
  local nextShowContent = show_join and 1 or 2
  if self.curShowContent and self.curShowContent == nextShowContent then
    return
  end
  self.curShowContent = nextShowContent
  self.joinSelectBg:SetActive(false)
  self.joinContent:SetActive(false)
  self.createSelectBg:SetActive(false)
  self.createContent:SetActive(false)
  if self.curShowContent == 1 then
    self.joinSelectBg:SetActive(true)
    self.joinContent:SetActive(true)
    self.joinContent:RefreshTipText(self.tipStr)
    self.joinContent:RefreshSearchAlList()
    self.joinContent:RefreshJoinAllianceCdTimeState()
    AlPostEventLog.PostEventLog_ListJoin_Action(AlPostEventLog.JoinAction.Open)
  elseif self.curShowContent == 2 then
    self.createSelectBg:SetActive(true)
    self.createContent:SetActive(true)
    self.createContent:RefreshTipText(self.tipStr)
    self.createContent:RefreshAll()
    AlPostEventLog.PostEventLog_ListCreat_Action(AlPostEventLog.CreatAction.Open)
  end
end

function UILWAlCreateJoinView:JumpCreatePage()
  self:ContentTrans(false)
end

return UILWAlCreateJoinView
