local base = UIBaseContainer
local LWUIMigration_AllyRecruitItem = BaseClass("LWUIMigration_AllyRecruitItem", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUIMigration_AllyRecruitTagNameTip = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyRecruitTagNameTip")
local LWUIMigration_AllyStars = require("UI.LWUIMigration.Component.LWUIMigration_AllyStars")
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshProUGUI)
local ICON_PATH_SEAT_RED = "Assets/Main/Sprites/UI/LWUIMigration/lrb_rumengtiaojian_cha.png"
local ICON_PATH_SEAT_GREEN = "Assets/Main/Sprites/UI/LWUIMigration/lrb_rumengtiaojian_duihao.png"
local SeatIconPath = {
  [0] = "Assets/Main/Sprites/UI/LWUIMigration/mjc_yimin_fenlei_shenfen_lan.png",
  [1] = "Assets/Main/Sprites/UI/LWUIMigration/mjc_yimin_fenlei_shenfen_zi.png",
  [2] = "Assets/Main/Sprites/UI/LWUIMigration/mjc_yimin_fenlei_shenfen_huang.png",
  [3] = "Assets/Main/Sprites/UI/LWUIMigration/mjc_yimin_fenlei_shenfen_bai.png"
}
local introduceTxt_path = "BG/IntroduceText"
local itemFlagIcon_path = "BG/TopContent/ItemFlag/ItemFlagIcon"
local itemNameInfoTxt_path = "BG/TopContent/ItemInfos/ItemNameInfo"
local countryImg_path = "BG/TopContent/ItemInfos/ItemLanguageInfo/CountryImg"
local languageTxt_path = "BG/TopContent/ItemInfos/ItemLanguageInfo/LanguageTxt"
local itemMemberInfoTxt_path = "BG/TopContent/ItemInfos/MemberGroup/ItemMemberInfo"
local itemPowerInfoTxt_path = "BG/TopContent/ItemInfos/PowerGroup/ItemPowerInfo"
local serverTxt_path = "BG/TopContent/ItemInfos/ServerRankGroup/ServerTxt"
local rankImage_path = "BG/TopContent/ItemInfos/ServerRankGroup/Image"
local rankTxt_path = "BG/TopContent/ItemInfos/ServerRankGroup/Image/ServerRankTxt"
local leaderBtn_path = "BG/LeaderBtn"
local presidentBtn_path = "BG/PresidentBtn"
local markBtn_path = "BG/Btn_mark"
local markBtnImg_path = "BG/Btn_mark"
local allianceDetailBtn_path = "BG"
local transBtnRoot_path = "BG/TranslateBtnRoot"
local translateFinishBtn_path = "BG/TranslateBtnRoot/TranslateFinishBtn"
local translateBtn_path = "BG/TranslateBtnRoot/TranslateBtn"
local reportBtn_path = "BG/BtnInfo"
local notMarkIcon_path = "BG/Btn_mark/NotMarkIcon"
local markedIcon_path = "BG/Btn_mark/MarkedIcon"
local goAllyStars_path = "BG/LWUIMigration_AllyStars"
local btnSeat_path = "BG/TagContent/SeatBg"
local imgSeatIcon_path = "BG/TagContent/SeatBg/IconSeat"
local tagIcons_path = {
  "BG/TagContent/IconBg1/Icon1",
  "BG/TagContent/IconBg2/Icon2",
  "BG/TagContent/IconBg3/Icon3"
}
local tagIconBgs_path = {
  "BG/TagContent/IconBg1",
  "BG/TagContent/IconBg2",
  "BG/TagContent/IconBg3"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.introduceTxt = self:AddComponent(UIText, introduceTxt_path)
  self.itemFlagIcon = self:AddComponent(UIImage, itemFlagIcon_path)
  self.itemNameInfoTxt = self:AddComponent(UIText, itemNameInfoTxt_path)
  self.countryImg = self:AddComponent(UIImage, countryImg_path)
  self.languageTxt = self:AddComponent(UIText, languageTxt_path)
  self.itemMemberInfoTxt = self:AddComponent(UIText, itemMemberInfoTxt_path)
  self.itemPowerInfoTxt = self:AddComponent(UIText, itemPowerInfoTxt_path)
  self.serverTxt = self:AddComponent(UIText, serverTxt_path)
  self.rankImage = self:AddComponent(UIImage, rankImage_path)
  self.rankTxt = self:AddComponent(UIText, rankTxt_path)
  self.leaderBtn = self:AddComponent(UIButton, leaderBtn_path)
  self.presidentBtn = self:AddComponent(UIButton, presidentBtn_path)
  self.markBtn = self:AddComponent(UIButton, markBtn_path)
  self.markBtnImg = self:AddComponent(UIImage, markBtnImg_path)
  self.allianceDetailBtn = self:AddComponent(UIButton, allianceDetailBtn_path)
  self.transBtnRoot = self:AddComponent(UIBaseContainer, transBtnRoot_path)
  self.translateFinishBtn = self:AddComponent(UIButton, translateFinishBtn_path)
  self.translateBtn = self:AddComponent(UIButton, translateBtn_path)
  self.reportBtn = self:AddComponent(UIButton, reportBtn_path)
  self.notMarkIcon = self:AddComponent(UIImage, notMarkIcon_path)
  self.markedIcon = self:AddComponent(UIImage, markedIcon_path)
  self.goAllyStars = self:AddComponent(UIBaseContainer, goAllyStars_path)
  self.btnSeat = self:AddComponent(UIButton, btnSeat_path)
  self.imgSeatIcon = self:AddComponent(UIImage, imgSeatIcon_path)
  self.tagIcons = {
    self:AddComponent(UIImage, tagIcons_path[1]),
    self:AddComponent(UIImage, tagIcons_path[2]),
    self:AddComponent(UIImage, tagIcons_path[3])
  }
  self.tagIconBgs = {
    self:AddComponent(UIButton, tagIconBgs_path[1]),
    self:AddComponent(UIButton, tagIconBgs_path[2]),
    self:AddComponent(UIButton, tagIconBgs_path[3])
  }
  for k, v in ipairs(self.tagIconBgs) do
    v:SetOnClick(function()
      local name = GetTableData(TableName.LW_Migration_Alliance_Tag, self.tagIdList[k], "name") or ""
      self:LoadNameTip(v, name)
    end)
  end
  self.markBtn:SetOnClick(function()
    if self.alData.save then
      self.saveClient = 1 - self.alData.save
      self.notMarkIcon:SetActive(self.saveClient == 0)
      self.markedIcon:SetActive(self.saveClient == 1)
      DataCenter.ActMigrationManager:SendSaveAllianceMarket(self.alData.allianceId, 1 - self.alData.save)
    end
  end)
  self.leaderBtn:SetOnClick(function()
    local isLeaderBtnGray = string.IsNullOrEmpty(self.alData.leaderUid) or self.alData.leaderUid == LuaEntry.Player.uid or LuaEntry.Player.allianceId == self.alData.allianceId
    if isLeaderBtnGray then
      UIUtil.ShowTipsId("migration_activity_tips_20052")
    else
      PostEventLog.Track(PostEventLog.Defines.c_migrate_ad_connect, {
        allianceid = self.alData.allianceId
      })
      self:ChatClick(self.alData.leaderUid)
    end
  end)
  self.presidentBtn:SetOnClick(function()
    local isPresidentInSameAlliance = false
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.alData.presidentUid)
    if info then
      isPresidentInSameAlliance = info.allianceId == LuaEntry.Player.allianceId
    end
    local isPresidentBtnGray = self.alData.presidentUid == LuaEntry.Player.uid or string.IsNullOrEmpty(self.alData.presidentUid) or isPresidentInSameAlliance
    if string.IsNullOrEmpty(self.alData.presidentUid) then
      UIUtil.ShowTipsId("migration_activity_tips_20054")
    elseif isPresidentBtnGray then
      UIUtil.ShowTipsId("migration_activity_tips_20053")
    else
      PostEventLog.Track(PostEventLog.Defines.c_migrate_ad_connect, {
        targetuid = self.alData.presidentUid
      })
      self:ChatClick(self.alData.presidentUid)
    end
  end)
  self.allianceDetailBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, nil, self.alData.allianceId)
  end)
  self.translateBtn:SetOnClick(function()
    self:OnTranslateBtnClick()
  end)
  self.translateFinishBtn:SetOnClick(function()
    self:OnTranslateFinishBtnClick()
  end)
  self.reportBtn:SetOnClick(function()
    self:OnReportBtnClick()
  end)
  self.compAllStars = self:AddComponent(LWUIMigration_AllyStars, self.goAllyStars.gameObject)
end

local function ComponentDestroy(self)
  self:ClearNameTipReq()
  self.introduceTxt = nil
  self.itemFlagIcon = nil
  self.itemNameInfoTxt = nil
  self.countryImg = nil
  self.languageTxt = nil
  self.itemMemberInfoTxt = nil
  self.itemPowerInfoTxt = nil
  self.serverTxt = nil
  self.rankImage = nil
  self.rankTxt = nil
  self.leaderBtn = nil
  self.presidentBtn = nil
  self.markBtn = nil
  self.markBtnImg = nil
  self.allianceDetailBtn = nil
  self.transBtnRoot = nil
  self.translateFinishBtn = nil
  self.translateBtn = nil
  self.reportBtn = nil
  self.notMarkIcon = nil
  self.markedIcon = nil
  self.goAllyStars = nil
  self.btnSeat = nil
  self.imgSeatIcon = nil
  self.tagIcons = nil
  self.tagIconBgs = nil
  self.compAllStars = nil
end

local function DataDefine(self)
  self.saveClient = nil
end

local function DataDestroy(self)
  self.saveClient = nil
  self.rankIconPath = nil
end

function LWUIMigration_AllyRecruitItem:UpdateMySeat(seatId)
  local seatPath = SeatIconPath[seatId]
  if not seatPath then
    self.btnSeat:SetActive(false)
  else
    self.btnSeat:SetActive(true)
    self.imgSeatIcon:LoadSpriteAuto(seatPath)
  end
end

local function SetData(self, data, filterData)
  self.alData = data
  self.itemFlagIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, self.alData.icon))
  self.itemNameInfoTxt:SetText("[" .. self.alData.abbr .. "]" .. self.alData.allianceName)
  self.itemPowerInfoTxt:SetText(string.GetFormattedGiga2(tonumber(self.alData.power)))
  self.itemMemberInfoTxt:SetText(self.alData.curMember .. "/" .. self.alData.maxMember)
  if not string.IsNullOrEmpty(self.alData.language) then
    local text = Localization:GetString(self.alData.language)
    self.languageTxt:SetText(text)
  else
    self.languageTxt:SetText(Localization:GetString(390254))
  end
  if not LuaEntry.GlobalData:IsChina() and not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
    self.countryImg:SetActive(true)
    local country = string.IsNullOrEmpty(self.alData.country) and DefaultNation or self.alData.country
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(country)
    self.countryImg:LoadSpriteAuto(nationTemplate:GetNationFlagPath())
  else
    self.countryImg:SetActive(false)
  end
  self.serverTxt:SetText("#" .. self.alData.serverId)
  self.rankTxt:SetText(self.alData.rank)
  local path
  if self.alData.rank == 1 then
    path = "FX_wordboss_paihangbang_icon_huizhang01.png"
  elseif self.alData.rank == 2 then
    path = "FX_wordboss_paihangbang_icon_huizhang02.png"
  elseif self.alData.rank >= 3 then
    path = "FX_wordboss_paihangbang_icon_huizhang03.png"
  end
  if not string.IsNullOrEmpty(path) and path ~= self.rankIconPath then
    self.rankIconPath = path
    self.rankImage:LoadSpriteAsyncWithCallback(string.format(LoadPath.CommonNewPath, path), function()
      if self.rankImage then
        self.rankImage:SetNativeSize()
      end
    end)
  end
  local scoreInfo = self.alData.scoreInfo
  local stars = scoreInfo and scoreInfo.comprehensiveScore or 0
  if stars <= 0 then
    self.compAllStars:SetActive(false)
  else
    self.compAllStars:SetActive(true)
    self.compAllStars:SetStars(scoreInfo)
  end
  self:UpdateMySeat(self.alData.identify or 0)
  if not string.IsNullOrEmpty(self.alData.tags) then
    self.tagIdList = string.split(self.alData.tags, "|")
    for i = 1, math.min(#self.tagIdList, #self.tagIcons) do
      local icon = GetTableData(TableName.LW_Migration_Alliance_Tag, self.tagIdList[i], "icon") or ""
      self.tagIcons[i]:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon))
      self.tagIcons[i]:SetActive(true)
      local icon_bg = GetTableData(TableName.LW_Migration_Alliance_Tag, self.tagIdList[i], "icon_bg") or ""
      self.tagIconBgs[i]:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon_bg))
      self.tagIconBgs[i]:SetActive(true)
    end
    for i = #self.tagIdList + 1, #self.tagIcons do
      self.tagIcons[i]:SetActive(false)
      self.tagIconBgs[i]:SetActive(false)
    end
  else
    for i = 1, #self.tagIcons do
      self.tagIcons[i]:SetActive(false)
      self.tagIconBgs[i]:SetActive(false)
    end
  end
  if string.IsNullOrEmpty(self.alData.notice) then
    self.introduceTxt:SetLocalText("migration_activity_interface_10153")
  else
    self.introduceTxt:SetText(self.alData.notice)
  end
  self.notMarkIcon:SetActive(self.alData.save == 0)
  self.markedIcon:SetActive(self.alData.save == 1)
  self.reportBtn:SetActive(self.alData.leaderUid ~= LuaEntry.Player.uid and not string.IsNullOrEmpty(self.alData.notice))
  local isLeaderBtnGray = string.IsNullOrEmpty(self.alData.leaderUid) or self.alData.leaderUid == LuaEntry.Player.uid or LuaEntry.Player.allianceId == self.alData.allianceId
  UIGray.SetGray(self.leaderBtn.transform, isLeaderBtnGray, true)
  local isPresidentInSameAlliance = false
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.alData.presidentUid)
  if info then
    isPresidentInSameAlliance = info.allianceId == LuaEntry.Player.allianceId
  end
  local isPresidentBtnGray = self.alData.presidentUid == LuaEntry.Player.uid or string.IsNullOrEmpty(self.alData.presidentUid) or isPresidentInSameAlliance
  UIGray.SetGray(self.presidentBtn.transform, isPresidentBtnGray, true)
  self:UpdateTranslateBtn()
end

function LWUIMigration_AllyRecruitItem:ChatClick(playerUid)
  if not string.IsNullOrEmpty(playerUid) and playerUid ~= LuaEntry.Player.uid then
    local userInfo = {}
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(playerUid, true)
    if info then
      local name = UIUtil.FormatServerAllianceName(info.serverId, info.alAbbr, info.name, playerUid)
      UIUtil.ShowTips(Localization:GetString("migration_activity_tips_20051", name))
      userInfo.userName = name
    else
      self.needOpenChatWithPlayerUid = playerUid
      SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, playerUid)
      return
    end
    userInfo.uid = playerUid
    local data = {}
    data.privateUserInfo = userInfo
    GoToUtil.OpenChatView(false, {anim = false}, data)
  end
end

function LWUIMigration_AllyRecruitItem:OnTranslateBtnClick()
  local transData = DataCenter.ActMigrationManager:GetAllyRecruitTranslateDatas(self.alData.allianceId)
  if transData == nil then
    return
  end
  transData:SetTranslateState(1)
  local transType = transData:GetTranslateType()
  if transType == nil then
    transType = 1
  elseif transType == 0 then
    transType = 1
  elseif transType == 1 then
    transType = 0
  end
  transData:SetTranslateType(transType)
  if string.IsNullOrEmpty(transData:GetTranslateMsg()) or transData:GetTranslateType() ~= nil or transData:GetTranslatedLang() ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    ChatManager2:GetInstance().Translate:Translate(transData:GetSourceMsg(), "", "", function(ok, data)
      self:OnTranslateCallback(transData, ok, data)
    end, transData:GetSourceLang(), transData:GetTranslateType())
  end
end

function LWUIMigration_AllyRecruitItem:OnTranslateCallback(transData, ok, data)
  local ret = false
  if not data or data.code ~= 0 then
  else
    transData:SetTranslateMsg(data.translateMsg)
    transData:SetTranslatedLang(data.targetLang)
    transData:SetCanRefreshTranslate(data.disableRefresh or 0)
    ret = true
  end
  local transState = -1
  if ret == true then
    transState = 2
    transData:SetTranslateMsg(data.translateMsg)
  else
    transState = -1
  end
  transData:SetTranslateState(transState)
  self:UpdateTranslateBtn()
end

function LWUIMigration_AllyRecruitItem:UpdateTranslateBtnState(translateData)
  local isTranslating = translateData:GetTranslateState() == 1
  local hasTranslated = translateData:GetTranslateState() == 2
  self.translateBtn:SetActive(not isTranslating and not hasTranslated and not string.IsNullOrEmpty(self.alData.notice))
  self.translateFinishBtn:SetActive(hasTranslated)
end

function LWUIMigration_AllyRecruitItem:UpdateTranslateBtn()
  local translateData = DataCenter.ActMigrationManager:AddOrGetAllyRecruitTranslateDatas(self.alData.allianceId, self.alData.notice, "")
  self:UpdateTranslateBtnState(translateData)
  if translateData:GetTranslateState() == 2 then
    self.introduceTxt:SetText(translateData:GetTranslateMsg())
  end
end

function LWUIMigration_AllyRecruitItem:OnTranslateFinishBtnClick()
  local translateData = DataCenter.ActMigrationManager:GetAllyRecruitTranslateDatas(self.alData.allianceId)
  if translateData == nil then
    return
  end
  if translateData:GetTranslateState() == 2 then
    self.introduceTxt:SetText(translateData:GetSourceMsg())
    self.translateBtn:SetActive(true)
    self.translateFinishBtn:SetActive(false)
  end
end

function LWUIMigration_AllyRecruitItem:OnReportBtnClick()
  local info = {
    uid = self.alData.leaderUid,
    message = self.alData.notice
  }
  DataCenter.ActMigrationManager:DoMsgReport(info, ReportType.actMigrateAlly)
end

function LWUIMigration_AllyRecruitItem:ClearNameTipReq()
  if self.nameTipsReq then
    self:GameObjectDestroy(self.nameTipsReq)
    self.nameTipsReq = nil
    self:RemoveComponents(LWUIMigration_AllyRecruitTagNameTip)
    self.nameTip = nil
  end
end

function LWUIMigration_AllyRecruitItem:LoadNameTip(parent, name)
  self:ClearNameTipReq()
  if not self.nameTipsReq then
    self.nameTipsReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigration_AllyRecruitTagNameTip.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(parent.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      self.nameTip = self:AddComponent(LWUIMigration_AllyRecruitTagNameTip, parent.__var_arg .. "/" .. go.name)
      self.nameTip:ReInit(name)
      EventManager:GetInstance():Broadcast(EventId.ActMigrationUISetTagNameTipShow, true)
    end)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationUISetTagNameTipShow, self.OnSetTagNameTipShow)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActMigrationUISetTagNameTipShow, self.OnSetTagNameTipShow)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  base.OnRemoveListener(self)
end

function LWUIMigration_AllyRecruitItem:OnSetTagNameTipShow(data)
  if data == false then
    self:ClearNameTipReq()
  end
end

function LWUIMigration_AllyRecruitItem:OnGetNewUserInfoSucc(uid)
  if self.needOpenChatWithPlayerUid == uid then
    local userInfo = {}
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid, true)
    if info then
      local name = UIUtil.FormatServerAllianceName(info.serverId, info.alAbbr, info.name, uid)
      UIUtil.ShowTips(Localization:GetString("migration_activity_tips_20051", name))
      userInfo.userName = name
      userInfo.uid = uid
      local data = {}
      data.privateUserInfo = userInfo
      GoToUtil.OpenChatView(false, {anim = false}, data)
    end
    self.needOpenChatWithPlayerUid = nil
  end
end

LWUIMigration_AllyRecruitItem.OnCreate = OnCreate
LWUIMigration_AllyRecruitItem.OnDestroy = OnDestroy
LWUIMigration_AllyRecruitItem.OnEnable = OnEnable
LWUIMigration_AllyRecruitItem.OnDisable = OnDisable
LWUIMigration_AllyRecruitItem.ComponentDefine = ComponentDefine
LWUIMigration_AllyRecruitItem.ComponentDestroy = ComponentDestroy
LWUIMigration_AllyRecruitItem.DataDefine = DataDefine
LWUIMigration_AllyRecruitItem.DataDestroy = DataDestroy
LWUIMigration_AllyRecruitItem.SetData = SetData
LWUIMigration_AllyRecruitItem.OnAddListener = OnAddListener
LWUIMigration_AllyRecruitItem.OnRemoveListener = OnRemoveListener
return LWUIMigration_AllyRecruitItem
