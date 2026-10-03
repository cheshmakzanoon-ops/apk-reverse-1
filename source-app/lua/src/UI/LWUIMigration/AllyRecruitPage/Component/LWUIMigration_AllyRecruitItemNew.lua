local base = UIBaseContainer
local LWUIMigration_AllyRecruitItemNew = BaseClass("LWUIMigration_AllyRecruitItemNew", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUIMigration_AllyRecruitTagNameTip = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyRecruitTagNameTip")
local LWUIMigration_AllyStars = require("UI.LWUIMigration.Component.LWUIMigration_AllyStars")
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshProUGUI)
local COLOR_BG_RED = Color.New(1, 0.8901961, 0.8745098, 1)
local COLOR_BG_GREEN = Color.New(0.8470588, 0.9686275, 0.8627451, 1)
local COLOR_LABEL_RED = Color.New(0.9607843, 0.2352941, 0.2392157, 1)
local COLOR_LABEL_GREEN = Color.New(0.03529412, 0.6078432, 0.2901961, 1)
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
local goDesertTimeRect_path = "BG/DesertTimeRect"
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
local timeRanges_path = {
  "BG/DesertTimeRect/TimeRange_1",
  "BG/DesertTimeRect/TimeRange_2"
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
  self.goDesertTimeRect = self:AddComponent(UIBaseContainer, goDesertTimeRect_path)
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
  self.timeRanges = {
    self:AddComponent(UIBaseContainer, timeRanges_path[1]),
    self:AddComponent(UIBaseContainer, timeRanges_path[2])
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
  self.desertTimes = {}
  for _, v in ipairs(self.timeRanges) do
    local tran = v.transform
    table.insert(self.desertTimes, {
      tmp = tran:Find("TmpTime"):GetComponent(UnityTextMeshPro),
      bg = tran:Find("Bg"):GetComponent(UnityImage),
      icon = tran:Find("Icon"):GetComponent(UnityImage)
    })
  end
  self.btnSeat:SetOnClick(function()
    local name = DataCenter.ActMigrationManager:GetSeatShowName(self.alData and self.alData.identify or 0)
    if not string.IsNullOrEmpty(name) then
      self:LoadNameTip(self.btnSeat, name)
    end
  end)
end

local function ComponentDestroy(self)
  self.desertTimes = nil
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
  self.goDesertTimeRect = nil
  self.btnSeat = nil
  self.imgSeatIcon = nil
  self.tagIcons = nil
  self.tagIconBgs = nil
  self.timeRanges = nil
  self.compAllStars = nil
end

local function DataDefine(self)
  self.saveClient = nil
end

local function DataDestroy(self)
  self.saveClient = nil
  self.rankIconPath = nil
end

function LWUIMigration_AllyRecruitItemNew:GetTimeComp(index)
  if not (self.desertTimes and self.desertTimes[index]) or not self.timeRanges[index] then
    return
  end
  local desertTime = self.desertTimes[index]
  local tmp = desertTime.tmp
  local icon = desertTime.icon
  local bg = desertTime.bg
  return tmp, icon, bg, self.timeRanges[index]
end

function LWUIMigration_AllyRecruitItemNew:UpdateDesertTime(allianceTimeMask, myTimeMask, filterData)
  local validTimeIndex = {}
  local validTimeSet = {}
  for i = 1, 3 do
    if 2 <= #validTimeIndex then
      break
    end
    local allyDesertTime = allianceTimeMask & 1 << i - 1 ~= 0
    local myDesertTime = myTimeMask & 1 << i - 1 ~= 0
    if allyDesertTime and myDesertTime then
      table.insert(validTimeIndex, i)
      validTimeSet[i] = true
    end
  end
  if #validTimeIndex < 2 then
    for i = 1, 3 do
      if 2 <= #validTimeIndex then
        break
      end
      local allyDesertTime = allianceTimeMask & 1 << i - 1 ~= 0
      if allyDesertTime and not validTimeSet[i] then
        table.insert(validTimeIndex, i)
      end
    end
    table.sort(validTimeIndex, function(a, b)
      return a < b
    end)
  end
  for _, i in ipairs(validTimeIndex) do
    local allyDesertTime = allianceTimeMask & 1 << i - 1 ~= 0
    if allyDesertTime then
      local time = BattleFieldUtil.GetDesertOpenTimeByIndex(i)
      local utcStart = UITimeManager:GetInstance():GetTimeFromServerToHHMMSS(time[1] or 0, not filterData or not filterData.showServerTime)
      local utcEnd = UITimeManager:GetInstance():GetTimeFromServerToHHMMSS(time[2] or 0, not filterData or not filterData.showServerTime)
      local myDesertTime = myTimeMask & 1 << i - 1 ~= 0
      local tmp, icon, bg, goTime = self:GetTimeComp(_)
      if tmp then
        tmp:SetText(string.format("%s-%s", utcStart, utcEnd))
        tmp.color = myDesertTime and COLOR_LABEL_GREEN or COLOR_LABEL_RED
      end
      if icon then
        icon:LoadSpriteAuto(myDesertTime and ICON_PATH_SEAT_GREEN or ICON_PATH_SEAT_RED)
      end
      if bg then
        bg.color = myDesertTime and COLOR_BG_GREEN or COLOR_BG_RED
      end
    end
  end
  for k, v in ipairs(self.timeRanges) do
    if IsNotNull(v) then
      v:SetActive(k <= #validTimeIndex)
    end
  end
end

function LWUIMigration_AllyRecruitItemNew:UpdateMySeat(seatId)
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
  self.compAllStars:SetStars(scoreInfo)
  self:UpdateDesertTime(self.alData.desertTime or 0, filterData and filterData.desertTime or 0, filterData)
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

function LWUIMigration_AllyRecruitItemNew:ChatClick(playerUid)
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

function LWUIMigration_AllyRecruitItemNew:OnTranslateBtnClick()
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

function LWUIMigration_AllyRecruitItemNew:OnTranslateCallback(transData, ok, data)
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

function LWUIMigration_AllyRecruitItemNew:UpdateTranslateBtnState(translateData)
  local isTranslating = translateData:GetTranslateState() == 1
  local hasTranslated = translateData:GetTranslateState() == 2
  self.translateBtn:SetActive(not isTranslating and not hasTranslated and not string.IsNullOrEmpty(self.alData.notice))
  self.translateFinishBtn:SetActive(hasTranslated)
end

function LWUIMigration_AllyRecruitItemNew:UpdateTranslateBtn()
  local translateData = DataCenter.ActMigrationManager:AddOrGetAllyRecruitTranslateDatas(self.alData.allianceId, self.alData.notice, "")
  self:UpdateTranslateBtnState(translateData)
  if translateData:GetTranslateState() == 2 then
    self.introduceTxt:SetText(translateData:GetTranslateMsg())
  end
end

function LWUIMigration_AllyRecruitItemNew:OnTranslateFinishBtnClick()
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

function LWUIMigration_AllyRecruitItemNew:OnReportBtnClick()
  local info = {
    uid = self.alData.leaderUid,
    message = self.alData.notice
  }
  DataCenter.ActMigrationManager:DoMsgReport(info, ReportType.actMigrateAlly)
end

function LWUIMigration_AllyRecruitItemNew:ClearNameTipReq()
  if self.nameTipsReq then
    self:GameObjectDestroy(self.nameTipsReq)
    self.nameTipsReq = nil
    self:RemoveComponents(LWUIMigration_AllyRecruitTagNameTip)
    self.nameTip = nil
  end
end

function LWUIMigration_AllyRecruitItemNew:LoadNameTip(parent, name)
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

function LWUIMigration_AllyRecruitItemNew:OnSetTagNameTipShow(data)
  if data == false then
    self:ClearNameTipReq()
  end
end

function LWUIMigration_AllyRecruitItemNew:OnGetNewUserInfoSucc(uid)
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

LWUIMigration_AllyRecruitItemNew.OnCreate = OnCreate
LWUIMigration_AllyRecruitItemNew.OnDestroy = OnDestroy
LWUIMigration_AllyRecruitItemNew.OnEnable = OnEnable
LWUIMigration_AllyRecruitItemNew.OnDisable = OnDisable
LWUIMigration_AllyRecruitItemNew.ComponentDefine = ComponentDefine
LWUIMigration_AllyRecruitItemNew.ComponentDestroy = ComponentDestroy
LWUIMigration_AllyRecruitItemNew.DataDefine = DataDefine
LWUIMigration_AllyRecruitItemNew.DataDestroy = DataDestroy
LWUIMigration_AllyRecruitItemNew.SetData = SetData
LWUIMigration_AllyRecruitItemNew.OnAddListener = OnAddListener
LWUIMigration_AllyRecruitItemNew.OnRemoveListener = OnRemoveListener
return LWUIMigration_AllyRecruitItemNew
