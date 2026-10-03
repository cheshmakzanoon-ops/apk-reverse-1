local base = UIBaseView
local LWUIMigration_SetAllyRecruitView = BaseClass("LWUIMigration_SetAllyRecruitView", base)
local LWUIMigration_AllyTagItem = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyTagItem")
local Localization = CS.GameEntry.Localization
local LWUIMigration_DesertTimeSelection = require("UI.LWUIMigration.Component.LWUIMigration_DesertTimeSelection")
local LWUIMigration_AllyStars = require("UI.LWUIMigration.Component.LWUIMigration_AllyStars")
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local COLOR_SEAT_RED = Color.New(0.9843137, 0.8509804, 0.8431373, 1)
local COLOR_SEAT_GREEN = Color.New(0.8352941, 0.9411765, 0.7686275, 1)
local ICON_PATH_SEAT_RED = "Assets/Main/Sprites/UI/LWUIMigration/lrb_rumengtiaojian_cha.png"
local ICON_PATH_SEAT_GREEN = "Assets/Main/Sprites/UI/LWUIMigration/lrb_rumengtiaojian_duihao.png"
local MAX_TXT_NUM = 80
local titleText_path = "UICommonPopUpTitle/Common_img_title/titleText"
local panelBtn_path = "UICommonPopUpTitle/panel"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local itemFlagIcon_path = "TopContent/TopContent/ItemFlag/ItemFlagIcon"
local itemNameInfoTxt_path = "TopContent/TopContent/ItemInfos/ItemNameInfo"
local countryImg_path = "TopContent/TopContent/ItemInfos/ItemLanguageInfo/CountryImg"
local languageTxt_path = "TopContent/TopContent/ItemInfos/ItemLanguageInfo/LanguageTxt"
local itemMemberInfoTxt_path = "TopContent/TopContent/ItemInfos/MemberGroup/ItemMemberInfo"
local itemPowerInfoTxt_path = "TopContent/TopContent/ItemInfos/PowerGroup/ItemPowerInfo"
local serverRankImage_path = "TopContent/TopContent/ItemInfos/ServerRankGroup/Image"
local serverRankText_path = "TopContent/TopContent/ItemInfos/ServerRankGroup/Image/ServerRankTxt"
local serverTxt_path = "TopContent/TopContent/ItemInfos/ServerRankGroup/ServerTxt"
local introduceTipTxt_path = "IntroduceTip"
local inputField_path = "IntroduceBg/Input/InputField"
local inputField_placeholder_path = "IntroduceBg/Input/InputField/Placeholder"
local labelTipTxt_path = "BottomRect/Rect/BottomContent/LabelRect/LabelTip"
local tagContent_path = "BottomRect/Rect/BottomContent/LabelRect/TagContent"
local tipsTxt_path = "BottomRect/Rect/BottomContent/LabelRect/TagContent/Tips"
local setupBtn_path = "BtnList/SetUpBtn"
local cancelBtn_path = "BtnList/CancelBtn"
local timeLimit_path = "IntroduceTimeLimit"
local timeLimitTxt_path = "IntroduceTimeLimit/IntroduceTimeLimitTxt"
local limitTxt_path = "IntroduceBg/Input/limitText"
local imgDrop_path = "BottomRect/Rect/BottomContent/LabelRect/ImgDrop"
local btnDrop_path = "BottomRect/Rect/BottomContent/LabelRect/BtnDrop"
local goDesertTimeSelection_path = "BottomRect/Rect/BottomContent/LWUIMigration_DesertTimeSelection"
local seatRect_path = "BottomRect/Rect/BottomContent/SeatRect"
local tmpSeatTip_path = "BottomRect/Rect/BottomContent/SeatRect/SeatTip"
local goAllyStars_path = "TopContent/AllyStars"
local rtMaskRect_path = "BottomRect/Rect"
local rtBottomContent_path = "BottomRect/Rect/BottomContent"
local tagIconList_path = {
  "BottomRect/Rect/BottomContent/LabelRect/LabelContent/IconBg1/Icon1",
  "BottomRect/Rect/BottomContent/LabelRect/LabelContent/IconBg2/Icon2",
  "BottomRect/Rect/BottomContent/LabelRect/LabelContent/IconBg3/Icon3"
}
local tagIconBgList_path = {
  "BottomRect/Rect/BottomContent/LabelRect/LabelContent/IconBg1",
  "BottomRect/Rect/BottomContent/LabelRect/LabelContent/IconBg2",
  "BottomRect/Rect/BottomContent/LabelRect/LabelContent/IconBg3"
}
local seatBtns_path = {
  "BottomRect/Rect/BottomContent/SeatRect/Seats/ItemSeat_1",
  "BottomRect/Rect/BottomContent/SeatRect/Seats/ItemSeat_2",
  "BottomRect/Rect/BottomContent/SeatRect/Seats/ItemSeat_3",
  "BottomRect/Rect/BottomContent/SeatRect/Seats/ItemSeat_4"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  DataCenter.ActMigrationManager:ReqSelfAllianceMarketData()
end

local function OnDestroy(self)
  self.seats = nil
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
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.itemFlagIcon = self:AddComponent(UIImage, itemFlagIcon_path)
  self.itemNameInfoTxt = self:AddComponent(UIText, itemNameInfoTxt_path)
  self.countryImg = self:AddComponent(UIImage, countryImg_path)
  self.languageTxt = self:AddComponent(UIText, languageTxt_path)
  self.itemMemberInfoTxt = self:AddComponent(UIText, itemMemberInfoTxt_path)
  self.itemPowerInfoTxt = self:AddComponent(UIText, itemPowerInfoTxt_path)
  self.serverRankImage = self:AddComponent(UIImage, serverRankImage_path)
  self.serverRankText = self:AddComponent(UIText, serverRankText_path)
  self.serverTxt = self:AddComponent(UIText, serverTxt_path)
  self.introduceTipTxt = self:AddComponent(UIText, introduceTipTxt_path)
  self.inputField = self:AddComponent(UIInput, inputField_path)
  self.inputField_placeholder = self:AddComponent(UIText, inputField_placeholder_path)
  self.labelTipTxt = self:AddComponent(UIText, labelTipTxt_path)
  self.tagContent = self:AddComponent(UIBaseContainer, tagContent_path)
  self.tipsTxt = self:AddComponent(UIText, tipsTxt_path)
  self.setupBtn = self:AddComponent(UIButton, setupBtn_path)
  self.cancelBtn = self:AddComponent(UIButton, cancelBtn_path)
  self.timeLimit = self:AddComponent(UIBaseContainer, timeLimit_path)
  self.timeLimitTxt = self:AddComponent(UIText, timeLimitTxt_path)
  self.limitTxt = self:AddComponent(UIText, limitTxt_path)
  self.imgDrop = self:AddComponent(UIImage, imgDrop_path)
  self.btnDrop = self:AddComponent(UIButton, btnDrop_path)
  self.goDesertTimeSelection = self:AddComponent(UIBaseContainer, goDesertTimeSelection_path)
  self.seatRect = self:AddComponent(UIBaseContainer, seatRect_path)
  self.tmpSeatTip = self:AddComponent(UIText, tmpSeatTip_path)
  self.goAllyStars = self:AddComponent(UIBaseContainer, goAllyStars_path)
  self.rtMaskRect = self:AddComponent(UIBaseContainer, rtMaskRect_path)
  self.rtBottomContent = self:AddComponent(UIBaseContainer, rtBottomContent_path)
  self.tagIconList = {
    self:AddComponent(UIImage, tagIconList_path[1]),
    self:AddComponent(UIImage, tagIconList_path[2]),
    self:AddComponent(UIImage, tagIconList_path[3])
  }
  self.tagIconBgList = {
    self:AddComponent(UIImage, tagIconBgList_path[1]),
    self:AddComponent(UIImage, tagIconBgList_path[2]),
    self:AddComponent(UIImage, tagIconBgList_path[3])
  }
  self.seatBtns = {
    self:AddComponent(UIButton, seatBtns_path[1]),
    self:AddComponent(UIButton, seatBtns_path[2]),
    self:AddComponent(UIButton, seatBtns_path[3]),
    self:AddComponent(UIButton, seatBtns_path[4])
  }
  self.inputField:SetOnValueChange(function(value)
    self:OnInputFieldValueChange(value)
  end)
  self.inputField:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.inputField:SetCharacterLimit(MAX_TXT_NUM)
  self.setupBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:PublishSelfAllyRecruitData()
  end)
  self.cancelBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:CancelPublishSelfAllyRecruitData()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnDrop:SetOnClick(function()
    self:OnClickDropBtn()
  end)
  self.cbClickedTagRectTransform = Bind(self, self.OnClickedTagRectTransform)
  local newChooseEnable = DataCenter.ActMigrationManager:NewChooseCompEnable()
  if newChooseEnable then
    self.imgDrop:SetActive(true)
    self.btnDrop:SetActive(true)
    self.seatRect:SetActive(false)
    self.goDesertTimeSelection:SetActive(false)
    self.goAllyStars:SetActive(false)
    self.compLWUIMigrationDesertTimeSelection = self:AddComponent(LWUIMigration_DesertTimeSelection, self.goDesertTimeSelection.gameObject)
    self.compAllStars = self:AddComponent(LWUIMigration_AllyStars, self.goAllyStars.gameObject)
    self.tmpSeatTip:SetLocalText("migration_activity_recommend_limit10_1008")
    self:HideTags()
  else
    self.imgDrop:SetActive(false)
    self.btnDrop:SetActive(false)
    self.goAllyStars:SetActive(false)
    self.seatRect:SetActive(false)
    self.goDesertTimeSelection:SetActive(false)
    self:ShowTags()
  end
  local _ = self.rtMaskRect:GetSizeDelta()
  if _ then
    self.halfMaskHeight = _.y * 0.5
  end
end

local function ComponentDestroy(self)
  self:ClearTags()
  self.titleText = nil
  self.panelBtn = nil
  self.closeBtn = nil
  self.itemFlagIcon = nil
  self.itemNameInfoTxt = nil
  self.countryImg = nil
  self.languageTxt = nil
  self.itemMemberInfoTxt = nil
  self.itemPowerInfoTxt = nil
  self.serverRankImage = nil
  self.serverRankText = nil
  self.serverTxt = nil
  self.introduceTipTxt = nil
  self.inputField = nil
  self.inputField_placeholder = nil
  self.labelTipTxt = nil
  self.tagContent = nil
  self.tipsTxt = nil
  self.setupBtn = nil
  self.cancelBtn = nil
  self.timeLimit = nil
  self.timeLimitTxt = nil
  self.limitTxt = nil
  self.imgDrop = nil
  self.btnDrop = nil
  self.goDesertTimeSelection = nil
  self.seatRect = nil
  self.tmpSeatTip = nil
  self.goAllyStars = nil
  self.rtMaskRect = nil
  self.rtBottomContent = nil
  self.tagIconList = nil
  self.tagIconBgList = nil
  self.seatBtns = nil
  self.compAllStars = nil
end

local function DataDefine(self)
  local args = self:GetUserData()
  self.showServerTime = args and args.showServerTime
  self.tagItemReq = {}
  self.viewTagsData = {
    [1] = 0,
    [2] = 0,
    [3] = 0
  }
end

local function DataDestroy(self)
  self.viewTagsData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationOnHandleSelfAllianceMarket, self.OnHandleSelfAllianceMarket)
  self:AddUIListener(EventId.ActMigrationOnHandlePublishAllianceMarket, self.OnHandlePublishAllianceMarket)
  self:AddUIListener(EventId.ActMigrationSetAllyTagToggle, self.OnSetAllyTagToggle)
  self:AddUIListener(EventId.ActMigrationOnHandleDeleteAllianceMarket, self.OnHandleDeleteAllianceMarket)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActMigrationOnHandleSelfAllianceMarket, self.OnHandleSelfAllianceMarket)
  self:RemoveUIListener(EventId.ActMigrationOnHandlePublishAllianceMarket, self.OnHandlePublishAllianceMarket)
  self:RemoveUIListener(EventId.ActMigrationSetAllyTagToggle, self.OnSetAllyTagToggle)
  self:RemoveUIListener(EventId.ActMigrationOnHandleDeleteAllianceMarket, self.OnHandleDeleteAllianceMarket)
end

function LWUIMigration_SetAllyRecruitView:Update1000MS()
  local cdTimeDelta = DataCenter.ActMigrationManager:GetRemainPublishTextCDTime()
  self.timeLimit:SetActive(cdTimeDelta and 0 < cdTimeDelta)
  if cdTimeDelta and 0 < cdTimeDelta then
    self.timeLimitTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(cdTimeDelta))
  end
end

function LWUIMigration_SetAllyRecruitView:OnHandleSelfAllianceMarket()
  self.alData = DeepCopy(DataCenter.ActMigrationManager.selfAllianceMarketData)
  if self.alData.tags then
    for i = 1, #self.alData.tags do
      self.viewTagsData[i] = self.alData.tags[i]
    end
  end
  self.alData.identifyFlag = self:CheckIdentifyFlag(self.alData.identifyFlag)
  self.tagTableDatas = {}
  LocalController:instance():visitTable(TableName.LW_Migration_Alliance_Tag, function(id, lineData)
    local isOn = table.hasvalue(self.alData.tags, id)
    local data = {
      id = id,
      searchTag = self.alData.tags,
      isOn = isOn,
      type = ActMigrationAllianceTagType.Normal,
      afterClicked = self.cbClickedTagRectTransform
    }
    table.insert(self.tagTableDatas, data)
  end)
  self:SetTopData()
  self:SetTags()
  local newChooseEnable = DataCenter.ActMigrationManager:NewChooseCompEnable()
  if newChooseEnable then
    self:InitSeats()
    self:RefreshSeats(self.alData.identifyFlag or 0)
    self.seatRect:SetActive(true)
    self.compLWUIMigrationDesertTimeSelection:SetActive(true)
    self.compLWUIMigrationDesertTimeSelection:Init({
      defaultDesertTime = self.alData.desertTime or 0,
      onClickedCallback = Bind(self, self.OnClickedDesertTime),
      showServerTime = self.showServerTime
    })
    self.goAllyStars:SetActive(true)
    self.compAllStars:SetStars(self.alData.scoreInfo)
  end
end

function LWUIMigration_SetAllyRecruitView:OnHandlePublishAllianceMarket()
  self.ctrl:CloseSelf()
end

function LWUIMigration_SetAllyRecruitView:OnSetAllyTagToggle(data)
  local id = data.id
  if self.alData.tags then
    if data.isChoose then
      table.insert(self.alData.tags, id)
      for i = 1, #self.viewTagsData do
        if self.viewTagsData[i] == 0 then
          self.viewTagsData[i] = id
          break
        end
      end
    else
      table.removebyvalue(self.alData.tags, id)
      for i = 1, #self.viewTagsData do
        if self.viewTagsData[i] == id then
          self.viewTagsData[i] = 0
          break
        end
      end
    end
  end
  self:RefreshTopTags()
end

function LWUIMigration_SetAllyRecruitView:OnHandleDeleteAllianceMarket()
  self.ctrl:CloseSelf()
end

function LWUIMigration_SetAllyRecruitView:SetTopData()
  self.itemFlagIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, self.alData.icon))
  self.itemNameInfoTxt:SetText("[" .. self.alData.abbr .. "]" .. self.alData.allianceName)
  self.itemPowerInfoTxt:SetText(string.GetFormattedGiga2(tonumber(self.alData.power)))
  self.itemMemberInfoTxt:SetText(self.alData.curMember .. "/" .. self.alData.maxMember)
  if not string.IsNullOrEmpty(self.alData.language) then
    local text
    local languageId = SuportedLanguagesLocalName[Localization:GetLanguage()] or ""
    if languageId == self.alData.language then
      text = "<color=#099b4a>" .. Localization:GetString(self.alData.language) .. "</color>"
    else
      text = Localization:GetString(self.alData.language)
    end
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
  local rank = self.alData.rank or 0
  self.serverRankText:SetText(rank)
  local rankStr = Mathf.Clamp(rank, 1, 3)
  local path = string.format("FX_wordboss_paihangbang_icon_huizhang0%s.png", rankStr)
  self.serverRankImage:LoadSpriteAsyncWithCallback(string.format(LoadPath.CommonNewPath, path), function()
    if self.serverRankImage then
      self.serverRankImage:SetNativeSize()
    end
  end)
  if self.alData.tags then
    local tagIdList = self.alData.tags
    for i = 1, math.min(#tagIdList, #self.tagIconList) do
      local icon = GetTableData(TableName.LW_Migration_Alliance_Tag, tagIdList[i], "icon") or ""
      self.tagIconList[i]:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon))
    end
    for i = #tagIdList + 1, #self.tagIconList do
      self.tagIconList[i]:LoadSpriteAuto("Assets/Main/Sprites/UI/LWUIMigration/lrb_kuafutongmeng_biaoqiankong.png")
    end
  end
  self.inputField:SetText(self.alData.notice or "")
  local bNull = string.IsNullOrEmpty(self.alData.notice)
  local len = bNull and 0 or #self.alData.notice
  self.limitTxt:SetText(len .. "/" .. MAX_TXT_NUM)
  self.cancelBtn:SetActive(self.alData.exist)
end

function LWUIMigration_SetAllyRecruitView:RefreshTopTags()
  for i = 1, #self.viewTagsData do
    if self.viewTagsData[i] ~= 0 then
      local icon = GetTableData(TableName.LW_Migration_Alliance_Tag, self.viewTagsData[i], "icon") or ""
      self.tagIconList[i]:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon))
      self.tagIconList[i]:SetActive(true)
      local icon_bg = GetTableData(TableName.LW_Migration_Alliance_Tag, self.viewTagsData[i], "icon_bg") or ""
      self.tagIconBgList[i]:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, icon_bg))
    else
      self.tagIconBgList[i]:LoadSpriteAuto("Assets/Main/Sprites/UI/LWUIMigration/lrb_kuafutongmeng_biaoqiankong.png")
      self.tagIconList[i]:SetActive(false)
    end
  end
end

function LWUIMigration_SetAllyRecruitView:ShowTags()
  self.tagContent:SetActive(true)
  self.showTags = true
  self.imgDrop:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png")
end

function LWUIMigration_SetAllyRecruitView:HideTags()
  self.tagContent:SetActive(false)
  self.showTags = false
  self.imgDrop:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
end

function LWUIMigration_SetAllyRecruitView:SetTags()
  self:RefreshTopTags()
  if #self.tagTableDatas > 0 then
    if 0 >= #self.tagItemReq then
      for k, v in ipairs(self.tagTableDatas) do
        local req = self:GameObjectInstantiateAsync(UIAssets.UIMigrationAllianceTagItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.tagContent.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = k
          local cell = self.tagContent:AddComponent(LWUIMigration_AllyTagItem, go.name)
          cell:SetData(self.tagTableDatas[k])
        end)
        table.insert(self.tagItemReq, req)
      end
    end
  else
    self:ClearTags()
  end
end

function LWUIMigration_SetAllyRecruitView:OnInputFieldValueChange(_)
  local value = self.inputField:GetText()
  local bNull = string.IsNullOrEmpty(value)
  local len = bNull and 0 or #value
  self.inputField_placeholder:SetActive(value == "")
  self.limitTxt:SetText(len .. "/" .. MAX_TXT_NUM)
  if #value > MAX_TXT_NUM then
    UIUtil.ShowTipsId("Max")
    return
  end
end

function LWUIMigration_SetAllyRecruitView:IptOnValueChange(_)
end

function LWUIMigration_SetAllyRecruitView:OnItemMoveIn(itemObj, index)
end

function LWUIMigration_SetAllyRecruitView:OnItemMoveOut(itemObj, index)
end

function LWUIMigration_SetAllyRecruitView:ClearTags()
  if self.tagItemReq then
    for k, v in ipairs(self.tagItemReq) do
      self:GameObjectDestroy(v)
    end
  end
  self.tagItemReq = {}
  self.tagContent:RemoveComponents(LWUIMigration_AllyTagItem)
end

function LWUIMigration_SetAllyRecruitView:PublishSelfAllyRecruitData()
  if DataCenter.ActMigrationManager:NewChooseCompEnable() then
    if not self.alData.desertTime or self.alData.desertTime <= 0 then
      UIUtil.ShowTipsId("migration_activity_recommend_tips_1003")
      return
    end
    if not self.alData.identifyFlag or 0 >= self.alData.identifyFlag then
      UIUtil.ShowTipsId("migration_activity_recommend_tips_1002")
      return
    end
  end
  local cdTimeDelta = DataCenter.ActMigrationManager:GetRemainPublishTextCDTime()
  if cdTimeDelta and 0 < cdTimeDelta then
    local tipText = CS.GameEntry.Localization:GetString("migration_activity_tips_20048", math.ceil(cdTimeDelta / 1000))
    UIUtil.ShowTips(tipText)
    return
  end
  local data = {
    notice = self.inputField:GetText(),
    tags = table.concat(self.alData.tags, "|")
  }
  if DataCenter.ActMigrationManager:NewChooseCompEnable() then
    data.identifyFlag = self:CheckIdentifyFlag(self.alData.identifyFlag)
    data.desertTime = self.alData.desertTime
  end
  DataCenter.ActMigrationManager:SendPublishSelfAllianceMarketData(data)
  self.ctrl:CloseSelf()
end

function LWUIMigration_SetAllyRecruitView:OnClickDropBtn()
  local enable = DataCenter.ActMigrationManager:NewChooseCompEnable()
  if not enable then
    self:ShowTags()
    return
  end
  if self.showTags then
    self:HideTags()
  else
    self:ShowTags()
  end
end

function LWUIMigration_SetAllyRecruitView:OnClickedDesertTime(desertTime)
  local enable = DataCenter.ActMigrationManager:NewChooseCompEnable()
  if not enable then
    return
  end
  if not (self.alData and self.alData.desertTime) or self.alData.desertTime == desertTime then
    return
  end
  if desertTime <= 0 then
    UIUtil.ShowTipsId("migration_activity_recommend_tips_1001")
    return
  end
  if 7 <= desertTime then
    UIUtil.ShowTipsId("migration_activity_recommend_tips_1004")
    return
  end
  self.alData.desertTime = desertTime
  self:RefreshDesertTimeSelection()
end

local uiIdx2SeatIdx = {
  [1] = ActMigrationIdentity.SuperLow,
  [2] = ActMigrationIdentity.Low,
  [3] = ActMigrationIdentity.Normal,
  [4] = ActMigrationIdentity.High
}

function LWUIMigration_SetAllyRecruitView:InitSeats()
  local enable = DataCenter.ActMigrationManager:NewChooseCompEnable()
  if not enable then
    return
  end
  self.seats = {}
  for k, v in ipairs(self.seatBtns) do
    local seatIndex = uiIdx2SeatIdx[k]
    v:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnSeatClicked(seatIndex)
    end)
    local btnTran = v.transform
    local imgBg = btnTran:Find("ImgBg"):GetComponent(UnityImage)
    local imgArrow = btnTran:Find("ImgArrow"):GetComponent(UnityImage)
    self.seats[k] = {
      imgBg = imgBg,
      imgArrow = imgArrow,
      seatIndex = seatIndex
    }
  end
end

function LWUIMigration_SetAllyRecruitView:GetSeat(index)
  if not self.seats or not self.seats[index] then
    return
  end
  local _ = self.seats[index]
  return _.imgBg, _.imgArrow
end

function LWUIMigration_SetAllyRecruitView:RefreshSeats(seatMask)
  if not self.seats then
    return
  end
  for i = 1, 4 do
    local bg, arrow = self:GetSeat(i)
    if bg then
      local seatIndex = uiIdx2SeatIdx[i]
      local bitMask = 1 << seatIndex
      local emptyCt, totalCt = DataCenter.ActMigrationManager:GetMyServerSeatState(seatIndex)
      local validState = 0 < emptyCt
      if validState then
        bg.color = COLOR_SEAT_GREEN
      else
        bg.color = COLOR_SEAT_RED
      end
      local showState = seatMask & bitMask ~= 0
      if showState and validState then
        arrow:LoadSpriteAuto(ICON_PATH_SEAT_GREEN)
      else
        arrow:LoadSpriteAuto(ICON_PATH_SEAT_RED)
      end
    end
  end
end

function LWUIMigration_SetAllyRecruitView:RefreshDesertTimeSelection()
  if self.compLWUIMigrationDesertTimeSelection then
    self.compLWUIMigrationDesertTimeSelection:Refresh(self.alData.desertTime)
  end
end

function LWUIMigration_SetAllyRecruitView:CheckIdentifyFlag(flag)
  local newIdentifyFlag = flag
  for seatIndex = 0, 3 do
    local emptyCt, totalCt = DataCenter.ActMigrationManager:GetMyServerSeatState(seatIndex)
    if emptyCt <= 0 then
      newIdentifyFlag = newIdentifyFlag & ~(1 << seatIndex)
    end
  end
  return newIdentifyFlag
end

function LWUIMigration_SetAllyRecruitView:CancelPublishSelfAllyRecruitData()
  DataCenter.ActMigrationManager:SendCancelPublishSelfAllianceMarketData()
end

function LWUIMigration_SetAllyRecruitView:OnSeatClicked(seatIndex)
  if not self.alData or not self.alData.identifyFlag then
    return
  end
  local emptyCt, totalCt = DataCenter.ActMigrationManager:GetMyServerSeatState(seatIndex)
  if emptyCt <= 0 then
    UIUtil.ShowTipsId("migration_activity_recommend_tips_1005")
    return
  end
  local newIdentify = self.alData.identifyFlag
  local bitMask = 1 << seatIndex
  if self.alData.identifyFlag & bitMask ~= 0 then
    if self.alData.identifyFlag == bitMask then
      UIUtil.ShowTipsId("migration_activity_recommend_tips_1002")
      return
    else
      newIdentify = self.alData.identifyFlag & ~bitMask
    end
  else
    newIdentify = self.alData.identifyFlag | bitMask
  end
  if newIdentify ~= self.alData.identifyFlag then
    self.alData.identifyFlag = newIdentify
    self:RefreshSeats(newIdentify)
  end
end

function LWUIMigration_SetAllyRecruitView:OnClickedTagRectTransform(rectTransform)
  if not rectTransform then
    return
  end
  if not self.rtMaskRect then
    return
  end
  if not self.halfMaskHeight then
    return
  end
  local bounds = CS.UnityEngine.RectTransformUtility.CalculateRelativeRectTransformBounds(self.rtMaskRect.rectTransform, rectTransform)
  local minY = bounds.min.y
  local maxY = bounds.max.y
  local offset
  if maxY > self.halfMaskHeight + 5 then
    offset = -(maxY - self.halfMaskHeight) - 5
  elseif minY < -self.halfMaskHeight - 5 then
    offset = -self.halfMaskHeight - minY + 5
  end
  if offset then
    local rawAnchorPos = self.rtBottomContent:GetAnchoredPosition()
    rawAnchorPos.y = rawAnchorPos.y + offset
    self.rtBottomContent:SetAnchoredPosition(rawAnchorPos)
  end
end

LWUIMigration_SetAllyRecruitView.OnCreate = OnCreate
LWUIMigration_SetAllyRecruitView.OnDestroy = OnDestroy
LWUIMigration_SetAllyRecruitView.OnEnable = OnEnable
LWUIMigration_SetAllyRecruitView.OnDisable = OnDisable
LWUIMigration_SetAllyRecruitView.ComponentDefine = ComponentDefine
LWUIMigration_SetAllyRecruitView.ComponentDestroy = ComponentDestroy
LWUIMigration_SetAllyRecruitView.DataDefine = DataDefine
LWUIMigration_SetAllyRecruitView.DataDestroy = DataDestroy
LWUIMigration_SetAllyRecruitView.OnAddListener = OnAddListener
LWUIMigration_SetAllyRecruitView.OnRemoveListener = OnRemoveListener
return LWUIMigration_SetAllyRecruitView
