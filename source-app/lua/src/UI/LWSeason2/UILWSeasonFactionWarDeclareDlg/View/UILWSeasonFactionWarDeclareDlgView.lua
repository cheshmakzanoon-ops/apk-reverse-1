local UILWSeasonFactionWarDeclareDlgView = BaseClass("UILWSeasonFactionWarDeclareDlgView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonFactionWarAliList = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarAliList")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local player_btn_path = "PopUpTitle/PlayerBtn"
local icon_path = "PopUpTitle/PlayerBtn/icon"
local name_text_path = "PopUpTitle/NameText"
local power_text_path = "PopUpTitle/InfoRoot/PowerText"
local xitu_text_path = "PopUpTitle/InfoRoot/XituText"
local do_btn_path = "PopUpTitle/DoBtn"
local do_btn_text_path = "PopUpTitle/DoBtn/DoBtnText"
local res_text_path = "PopUpTitle/InfoRoot/ResBg/ResRoot/ResText"
local rank_text_path = "PopUpTitle/PlayerBtn/RankText"
local faction_war_ali_list_path = "PopUpTitle/FactionWarAliList"
local xitu_icon_path = "PopUpTitle/InfoRoot/XituText/XituIcon"
local res_tip_path = "PopUpTitle/InfoRoot/ResBg/ResRoot/resTip"
local res_icon_path = "PopUpTitle/InfoRoot/ResBg/ResRoot/ResIcon"
local res_root_path = "PopUpTitle/InfoRoot/ResBg/ResRoot"
local res_tip2_path = "PopUpTitle/InfoRoot/ResBg/resTip2"

function UILWSeasonFactionWarDeclareDlgView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  if self.param and self.param.allianceId then
    self.allianceId = self.param.allianceId
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareEnemyInfo, self.param.allianceId)
    self.enemyList = self.param.enemy or {}
  end
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonFactionWarDeclareDlgView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionWarDeclareDlgView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionDoWarDeclare, self.OnDeclareFinish)
  self:AddUIListener(EventId.LWSeasonFactionGroupInfoUpdate, self.OnGroupInfoUpdate)
  self:AddUIListener(EventId.LWSeasonFactionWarEnemyInfoUpdate, self.OnEnemyInfoUpdate)
end

function UILWSeasonFactionWarDeclareDlgView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionWarEnemyInfoUpdate, self.OnEnemyInfoUpdate)
  self:RemoveUIListener(EventId.LWSeasonFactionDoWarDeclare, self.OnDeclareFinish)
  self:RemoveUIListener(EventId.LWSeasonFactionGroupInfoUpdate, self.OnGroupInfoUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonFactionWarDeclareDlgView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_s2_faction_war_20")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.xitu_icon = self:AddComponent(UIImage, xitu_icon_path)
  self.res_tip = self:AddComponent(UITextMeshProUGUIEx, res_tip_path)
  self.res_icon = self:AddComponent(UIImage, res_icon_path)
  self.rank_text = self:AddComponent(UITextMeshProUGUIEx, rank_text_path)
  self.player_btn = self:AddComponent(UIButton, player_btn_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.power_text = self:AddComponent(UITextMeshProUGUIEx, power_text_path)
  self.xitu_text = self:AddComponent(UITextMeshProUGUIEx, xitu_text_path)
  self.res_text = self:AddComponent(UITextMeshProUGUIEx, res_text_path)
  self.do_btn = self:AddComponent(UIButton, do_btn_path)
  self.do_btn_text = self:AddComponent(UITextMeshProUGUIEx, do_btn_text_path)
  self.faction_war_ali_list = self:AddComponent(SeasonFactionWarAliList, faction_war_ali_list_path)
  self.player_btn:SetOnClick(function()
    if self.param and self.param.allianceId then
      UIUtil.TryShowAllianceInfo(self.param.serverId, self.param.allianceId, self.param.name)
    end
  end)
  self.do_btn:SetOnClick(function()
    if self.viewMode then
      self.ctrl:CloseSelf()
      return
    end
    local targetAllianceId = self.targetAllianceId
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId("season_s2_faction_war_82")
      return
    end
    if self.hasDeclareData then
      UIUtil.ShowMessage(Localization:GetString("season_s2_faction_war_84"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.CancelSeasonFactionDeclareWar, targetAllianceId)
      end)
    else
      local enemyCount = table.count(self.param.enemy)
      if enemyCount == 3 then
        UIUtil.ShowTipsId("season_s2_faction_war_75")
      elseif enemyCount ~= 0 then
        UIUtil.ShowMessage(Localization:GetString("season_s2_faction_war_25", enemyCount), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          SFSNetwork.SendMessage(MsgDefines.CreateSeasonFactionDeclareWar, targetAllianceId)
        end)
      else
        UIUtil.ShowMessage(Localization:GetString("season_s2_faction_war_24"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          SFSNetwork.SendMessage(MsgDefines.CreateSeasonFactionDeclareWar, targetAllianceId)
        end)
      end
    end
  end)
  self.res_root = self:AddComponent(UIBaseContainer, res_root_path)
  self.res_tip2 = self:AddComponent(UITextMeshProUGUIEx, res_tip2_path)
  local isMaster = true
  if self.param.defence and self.allianceId then
    local firstOne = self.param.defence[1]
    if firstOne and firstOne.allianceId and firstOne.allianceId ~= self.allianceId then
      isMaster = false
    end
  end
  if isMaster then
    local seasonType = SeasonUtil.GetSeasonType()
    self.xitu_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
    if SeasonUtil.SeasonHasMilitaryCenterAttachment(seasonType) then
      self.res_tip:SetLocalText("season_s3_activity_1000064_desc01")
    else
      self.res_tip:SetLocalText("season_s2_faction_war_53")
    end
    self.res_root:SetActive(true)
    self.res_tip2:SetActive(false)
  else
    self.res_root:SetActive(false)
    self.res_tip2:SetActive(true)
    self.res_tip2:SetLocalText("season_s4_copper_plunder_desc")
  end
end

function UILWSeasonFactionWarDeclareDlgView:ComponentDestroy()
  self.btn_back = nil
  self.player_btn = nil
  self.icon = nil
  self.name_text = nil
  self.power_text = nil
  self.xitu_text = nil
  self.res_text = nil
  self.do_btn = nil
  self.do_btn_text = nil
  self.faction_war_ali_list = nil
end

function UILWSeasonFactionWarDeclareDlgView:OnEnemyInfoUpdate(data)
  if data and data.targetAllianceId == self.targetAllianceId then
    self.param.enemy = data.enemy
    self.enemyList = data.enemy or {}
    if data.defence and #data.defence > 0 then
      self.param.defence = data.defence
    else
      self.param.defence = nil
    end
    self:UpdateData()
  end
end

function UILWSeasonFactionWarDeclareDlgView:OnDeclareFinish(data)
  if data and data.targetAllianceId == self.targetAllianceId then
    self.param.enemy = data.enemy
    self.enemyList = data.enemy or {}
    self:UpdateData()
  end
end

function UILWSeasonFactionWarDeclareDlgView:OnGroupInfoUpdate()
  local dataList = DataCenter.SeasonFactionWarDataManager.dataList1
  if dataList and self.targetAllianceId then
    for _, rankData in ipairs(dataList) do
      if rankData.allianceId == self.targetAllianceId then
        self.param = rankData
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareEnemyInfo, rankData.allianceId)
        self:UpdateData()
        return
      end
    end
  end
  dataList = DataCenter.SeasonFactionWarDataManager.dataList2
  if dataList and self.targetAllianceId then
    for _, rankData in ipairs(dataList) do
      if rankData.allianceId == self.targetAllianceId then
        self.param = rankData
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareEnemyInfo, rankData.allianceId)
        self:UpdateData()
        break
      end
    end
  end
end

function UILWSeasonFactionWarDeclareDlgView:UpdateData()
  local myAllianceId = LuaEntry.Player.allianceId
  local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
  if actInfo then
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    self.viewMode = actInfo.currStep ~= SeasonFactionDeclareWarStep.declare or myCampId ~= actInfo.attackCampId
  else
    self.viewMode = true
  end
  self.targetAllianceId = self.param.allianceId
  self.hasDeclareData = false
  if self.param.rank then
    self.rank_text:SetActive(true)
    self.rank_text:SetLocalText("801140", self.param.rank)
  else
    self.rank_text:SetActive(false)
  end
  self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.param.icon)))
  self.name_text:SetText(UIUtil.FormatServerAllianceName(self.param.serverId, self.param.abbr, self.param.name))
  self.power_text:SetText(string.GetFormattedStr(self.param.power))
  self.xitu_text:SetText(string.GetFormattedStr(self.param.resourceNum))
  local canRobNum = toInt(self.param.canRobNum)
  if canRobNum <= 0 then
    local ratio = DataCenter.SeasonFactionWarDataManager:GetPlunderRatio()
    self.res_text:SetText(string.GetFormattedStr(self.param.resourceNum * ratio))
  else
    self.res_text:SetText(string.GetFormattedStr(canRobNum))
  end
  if DataCenter.SeasonFactionWarDataManager.targetAllianceId == self.targetAllianceId then
    self.hasDeclareData = true
  end
  if self.enemyList and not self.hasDeclareData then
    for k, v in ipairs(self.enemyList) do
      if v and v.allianceId == myAllianceId then
        self.hasDeclareData = true
      end
    end
  end
  self.faction_war_ali_list:SetAutoSizeEnable(false)
  self.faction_war_ali_list:CanShowInviteWhenEmpty(false)
  self.faction_war_ali_list:ShowEmptyIcon(false)
  self.faction_war_ali_list:ReInit(self.param.defence or {
    self.param
  }, self.enemyList, self.param.serverId, self.param.allianceId)
  if self.hasDeclareData then
    self.viewMode = false
    self.do_btn:SetActive(true)
    self.do_btn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_3.png")
    self.do_btn_text:SetLocalText("season_s2_faction_war_22")
  elseif self.targetAllianceId == myAllianceId then
    self.viewMode = true
  elseif self.viewMode ~= true then
    self.do_btn:SetActive(true)
    self.do_btn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_5.png")
    self.do_btn_text:SetLocalText("season_s2_faction_war_23")
  end
  if self.viewMode or actInfo and actInfo.currStep ~= SeasonFactionDeclareWarStep.declare then
    self.do_btn:SetActive(true)
    self.dialog_title_text:SetLocalText("302326")
    self.do_btn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_5.png")
    self.do_btn_text:SetLocalText("100178")
    self.viewMode = true
  end
end

return UILWSeasonFactionWarDeclareDlgView
