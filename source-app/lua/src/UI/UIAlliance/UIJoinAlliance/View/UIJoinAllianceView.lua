local AllianceItem = require("UI.UIAlliance.UIJoinAlliance.Component.AllianceItem")
local UIJoinAllianceView = BaseClass("UIJoinAllianceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local alliance_name_path = "ImgBg/Join/select/allianceName"
local power_path = "ImgBg/Join/select/power"
local people_path = "ImgBg/Join/select/people"
local language_path = "ImgBg/Join/select/language"
local level_path = "ImgBg/Join/select/level"
local scroll_path = "ImgBg/Join/ScrollView"
local input_path = "ImgBg/Join/InputField"
local place_holder_txt_path = "ImgBg/Join/InputField/Placeholder"
local search_btn_path = "ImgBg/Join/BtnSearch"
local change_btn_path = "ImgBg/Join/changeBtn"
local select1_path = "ImgBg/Join/changeBtn/select1"
local select2_path = "ImgBg/Join/changeBtn/select2"
local create_btn_path = "ImgBg/Join/createBtn"
local create_btn_txt_path = "ImgBg/Join/createBtn/createBtnTxt"
local des_obj_path = "ImgBg/Join/desObj"
local noleader_icon_path = "ImgBg/Join/desObj/noleaderhead"
local leader_icon_path = "ImgBg/Join/desObj/head"
local leaderHead_path = "ImgBg/Join/desObj/head/UIPlayerHead/HeadIcon"
local leaderHeadFg_path = "ImgBg/Join/desObj/head/UIPlayerHead/Foreground"
local leader_txt_path = "ImgBg/Join/desObj/leaderTxt"
local leader_name_path = "ImgBg/Join/desObj/leaderName"
local des_title_path = "ImgBg/Join/desObj/desTitle"
local des_txt_path = "ImgBg/Join/desObj/ScrollView/Viewport/Content/desTxt"
local join_btn_path = "ImgBg/Join/desObj/JoinButton"
local join_txt_path = "ImgBg/Join/desObj/JoinButton/joinText"
local apply_btn_path = "ImgBg/Join/desObj/ApplyButton"
local apply_txt_path = "ImgBg/Join/desObj/ApplyButton/applyText"
local cancel_btn_path = "ImgBg/Join/desObj/CancelButton"
local cancel_txt_path = "ImgBg/Join/desObj/CancelButton/cancelText"
local mail_btn_path = "ImgBg/Join/desObj/MailButton"
local mail_txt_path = "ImgBg/Join/desObj/MailButton/mailText"
local chat_btn_path = "ImgBg/Join/desObj/chatBtn"
local info_btn_path = "ImgBg/Join/desObj/infoBtn"
local info_btn_txt_path = "ImgBg/Join/desObj/infoBtn/infoBtnTxt"
local set_txt_node_path = "ImgBg/Join/desObj/joinSet"
local set_txt_path = "ImgBg/Join/desObj/joinSet/SetTxt"
local level_set_txt_path = "ImgBg/Join/desObj/joinSet/levelSetTxt"
local power_set_txt_path = "ImgBg/Join/desObj/joinSet/powerSetTxt"
local state_set_txt_path = "ImgBg/Join/desObj/joinSet/stateSetTxt"
local career_set_node_path = "ImgBg/Join/desObj/careerSet"
local career_set_title_path = "ImgBg/Join/desObj/careerSet/careerSetTitleTxt"
local career_set_content_path = "ImgBg/Join/desObj/careerSet/careerSetContentTxt"
local emptyTxt_path = "ImgBg/TxtEmpty"
local joinNode_path = "ImgBg/Join"

local function OnCreate(self)
  base.OnCreate(self)
  self.hasAlliance = self.ctrl:CheckIfHasAlliance()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(390079)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.search_btn = self:AddComponent(UIButton, search_btn_path)
  self.search_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickSearch()
  end)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetActive(not self.hasAlliance)
  self.join_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickJoin()
  end)
  self.join_txt = self:AddComponent(UIText, join_txt_path)
  self.join_txt:SetLocalText(110037)
  self.apply_btn = self:AddComponent(UIButton, apply_btn_path)
  self.apply_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickApply()
  end)
  self.apply_txt = self:AddComponent(UIText, apply_txt_path)
  self.apply_txt:SetLocalText(110090)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancel_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickCancel()
  end)
  self.cancel_txt = self:AddComponent(UIText, cancel_txt_path)
  self.cancel_txt:SetLocalText(GameDialogDefine.CANCEL)
  self.mail_btn = self:AddComponent(UIButton, mail_btn_path)
  self.mail_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickMail()
  end)
  self.mail_txt = self:AddComponent(UIText, mail_txt_path)
  self.mail_txt:SetLocalText(390086)
  self.alliance_name = self:AddComponent(UIText, alliance_name_path)
  self.alliance_name:SetLocalText(390288)
  self.power = self:AddComponent(UIText, power_path)
  self.power:SetLocalText(100644)
  self.people = self:AddComponent(UIText, people_path)
  self.people:SetLocalText(390098)
  self.language = self:AddComponent(UIText, language_path)
  self.language:SetLocalText(391095)
  self.level = self:AddComponent(UIText, level_path)
  self.level:SetLocalText(143589)
  self.level:SetActive(not LuaEntry.GlobalData:IsChina())
  self.noleaderIcon = self:AddComponent(UIImage, noleader_icon_path)
  self.leaderIcon = self:AddComponent(UIImage, leader_icon_path)
  self.leaderHeadN = self:AddComponent(UIPlayerHead, leaderHead_path)
  self.leaderHeadFgN = self:AddComponent(UIImage, leaderHeadFg_path)
  self.leader_txt = self:AddComponent(UIText, leader_txt_path)
  self.leader_txt:SetLocalText(390006)
  self.des_title = self:AddComponent(UIText, des_title_path)
  self.des_title:SetLocalText(390513)
  self.place_holder_txt = self:AddComponent(UIText, place_holder_txt_path)
  self.place_holder_txt:SetLocalText(120177)
  self.create_btn = self:AddComponent(UIButton, create_btn_path)
  self.create_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnClickCreate()
  end)
  self.create_btn_txt = self:AddComponent(UIText, create_btn_txt_path)
  self.create_btn_txt:SetLocalText(390080)
  self.create_btn:SetActive(false)
  self.change_btn = self:AddComponent(UIButton, change_btn_path)
  self.change_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeClick()
  end)
  self.change_btn:SetActive(false)
  self.chat_btn = self:AddComponent(UIButton, chat_btn_path)
  self.chat_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnChatClick()
  end)
  self.chat_btn:SetActive(false)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnInfoClick()
  end)
  self.info_btn_txt = self:AddComponent(UIText, info_btn_txt_path)
  self.info_btn_txt:SetLocalText(110036)
  self.info_btn:SetActive(self.hasAlliance)
  self.set_txt_node = self:AddComponent(UIBaseContainer, set_txt_node_path)
  self.set_txt_node:SetActive(false)
  self.set_txt = self:AddComponent(UIText, set_txt_path)
  self.set_txt:SetLocalText(390095)
  self.level_set_txt = self:AddComponent(UIText, level_set_txt_path)
  self.power_set_txt = self:AddComponent(UIText, power_set_txt_path)
  self.state_set_txt = self:AddComponent(UIText, state_set_txt_path)
  self.career_set_node = self:AddComponent(UIBaseContainer, career_set_node_path)
  self.career_set_title_txt = self:AddComponent(UIText, career_set_title_path)
  self.career_set_title_txt:SetLocalText(395405)
  self.career_set_content_txt = self:AddComponent(UIText, career_set_content_path)
  self.select1 = self:AddComponent(UIBaseContainer, select1_path)
  self.select2 = self:AddComponent(UIBaseContainer, select2_path)
  self.leader_name = self:AddComponent(UIText, leader_name_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.des_obj = self:AddComponent(UIBaseContainer, des_obj_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnAllianceItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnAllianceItemMoveOut(itemObj, index)
  end)
  self.EmptyTxt = self:AddComponent(UIText, emptyTxt_path)
  self.EmptyTxt:SetLocalText(390856)
  self.joinNode = self:AddComponent(UIBaseContainer, joinNode_path)
  self.inputValue = ""
  self.alliance_list = {}
  self.select = 1
end

local function OnDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.input = nil
  self.search_btn = nil
  self.join_btn = nil
  self.join_txt = nil
  self.apply_btn = nil
  self.apply_txt = nil
  self.cancel_btn = nil
  self.cancel_txt = nil
  self.alliance_name = nil
  self.power = nil
  self.people = nil
  self.language = nil
  self.leader_txt = nil
  self.des_title = nil
  self.leader_name = nil
  self.des_txt = nil
  self.set_txt_node = nil
  self.career_set_node = nil
  self.career_set_title_txt = nil
  self.career_set_content_txt = nil
  self.des_obj = nil
  self.ScrollView = nil
  self.inputValue = nil
  self.alliance_list = nil
  base.OnDestroy(self)
end

local function RefreshAllianceList(self)
  self:ClearScroll()
  self.alliance_list = self.ctrl:GetAllianceIdList()
  if #self.alliance_list <= 0 then
    self.EmptyTxt:SetActive(true)
    self.des_obj:SetActive(false)
    return
  end
  self.EmptyTxt:SetActive(false)
  self.des_obj:SetActive(true)
  if #self.alliance_list > 0 then
    self.ScrollView:SetTotalCount(#self.alliance_list)
    self.ScrollView:RefillCells()
  end
  self.select1:SetActive(self.select == 1)
  self.select2:SetActive(self.select == 2)
  self:RefreshAllianceContent()
end

local function OnChangeClick(self)
  if self.select == 1 then
    self.ctrl:SendSearchMessageToServer(1, 1, self.inputValue, 2)
    self.select = 2
  elseif self.select == 2 then
    self.ctrl:SendSearchMessageToServer(1, 1, self.inputValue, 1)
    self.select = 1
  end
end

local function RefreshAllianceContent(self)
  local currentAlliance = self.ctrl:GetCurrentAlliance()
  if currentAlliance ~= nil then
    self.des_obj:SetActive(true)
    local leaderName = currentAlliance:CheckIfIsVirtualLeader() and Localization:GetString("390863") or currentAlliance.leaderName
    self.leader_name:SetText(leaderName)
    if currentAlliance:CheckIfIsVirtualLeader() then
      self.leaderIcon:SetActive(true)
      self.noleaderIcon:SetActive(false)
    else
      self.leaderIcon:SetActive(true)
      self.noleaderIcon:SetActive(false)
      self.leaderHeadN:SetData(currentAlliance.leaderUid, currentAlliance.leaderPic, currentAlliance.leaderPicVer)
      local tempFg = currentAlliance:GetHeadBgImg_Leader()
      if tempFg then
        self.leaderHeadFgN:SetActive(true)
      else
        self.leaderHeadFgN:SetActive(false)
      end
    end
    if currentAlliance.intro and currentAlliance.intro ~= "" then
      self.des_txt:SetText(currentAlliance.intro)
    else
      self.des_txt:SetLocalText(390799)
    end
    if currentAlliance.applied == 1 then
      self.join_btn:SetActive(false)
      self.apply_btn:SetActive(false)
      self.mail_btn:SetActive(false)
      self.cancel_btn:SetActive(true)
    else
      self.cancel_btn:SetActive(false)
      if DataCenter.PlayerCareerManager:GetCareerType() == CareerType.Admiral and currentAlliance.admiralNum >= DataCenter.AllianceCareerManager:GetCareerMaxNum(1) then
        self.join_btn:SetActive(false)
        self.apply_btn:SetActive(false)
        self.mail_btn:SetActive(true)
      else
        self.mail_btn:SetActive(false)
        self.join_btn:SetActive(currentAlliance.recruitTotal == 0 and not self.hasAlliance)
        self.apply_btn:SetActive(currentAlliance.recruitTotal == 1 and not self.hasAlliance)
      end
    end
    if DataCenter.PlayerCareerManager:Enabled() and not table.IsNullOrEmpty(currentAlliance.lookForCareers) then
      self.career_set_node:SetActive(true)
      self.career_set_content_txt:SetText(DataCenter.PlayerCareerManager:ConvertCareerName(currentAlliance.lookForCareers))
    else
      self.career_set_node:SetActive(false)
    end
  else
    self.des_obj:SetActive(false)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.ctrl:InitData()
end

local function OnDisable(self)
  self:ClearScroll()
  base.OnDisable(self)
end

local function OnAllianceItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(AllianceItem, itemObj)
  cellItem:SetItemShow(self.alliance_list[index])
end

local function OnAllianceItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, AllianceItem)
end

local function ClearScroll(self)
  if self.ScrollView then
    self.ScrollView:RemoveComponents(AllianceItem)
    self.ScrollView:ClearCells()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.RefreshAllianceList)
  self:AddUIListener(EventId.CLICK_ALLIANCE_ITEM, self.RefreshAllianceContent)
  self:AddUIListener(EventId.AllianceApplySuccess, self.OnJoinAllianceBack)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.RefreshAllianceList)
  self:RemoveUIListener(EventId.CLICK_ALLIANCE_ITEM, self.RefreshAllianceContent)
  self:RemoveUIListener(EventId.AllianceApplySuccess, self.OnJoinAllianceBack)
end

local function IptOnValueChange(self, value)
  self.inputValue = value
  if string.IsNullOrEmpty(self.input:GetText()) then
    self.ctrl:SendSearchMessageToServer(1, 1, self.inputValue, 0)
  end
end

local function OnClickApply(self)
  local currentAlliance = self.ctrl:GetCurrentAlliance()
  self.ctrl:SendApplyMessageToServer(currentAlliance.uid, 1, currentAlliance.language)
end

local function OnClickSearch(self)
  if self.inputValue == nil or self.inputValue == "" then
    self.currentAllianceId = ""
    self.ctrl:SendSearchMessageToServer(1, 1, "", 0, true)
  else
    self.ctrl:SendSearchMessageToServer(1, 1, self.inputValue, 0)
  end
end

local function OnClickCancel(self)
  local currentAlliance = self.ctrl:GetCurrentAlliance()
  self.ctrl:SendCancelApplyMessageToServer(currentAlliance.uid)
end

local function OnClickMail(self)
  local currentAlliance = self.ctrl:GetCurrentAlliance()
  local name = "[" .. currentAlliance.abbr .. "]" .. currentAlliance.allianceName
  local careerNames = DataCenter.PlayerCareerManager:ConvertCareerName(currentAlliance.lookForCareers)
  local tip = Localization:GetString(395406, name) .. "\n" .. careerNames .. "\n" .. Localization:GetString(395407, currentAlliance.admiralNum)
  UIUtil.ShowMessage(tip, 2, GameDialogDefine.CANCEL, 390086, nil, function()
    self.ctrl:OnLeaderMailClick(currentAlliance.leaderUid, currentAlliance.leaderName)
  end)
end

local function OnClickJoin(self)
  local currentAlliance = self.ctrl:GetCurrentAlliance()
  self.ctrl:SendApplyMessageToServer(currentAlliance.uid, 0, currentAlliance.language)
end

local function OnJoinAllianceBack(self)
  self.ctrl:CloseSelf()
end

UIJoinAllianceView.OnCreate = OnCreate
UIJoinAllianceView.OnDestroy = OnDestroy
UIJoinAllianceView.RefreshAllianceList = RefreshAllianceList
UIJoinAllianceView.RefreshAllianceContent = RefreshAllianceContent
UIJoinAllianceView.OnEnable = OnEnable
UIJoinAllianceView.OnDisable = OnDisable
UIJoinAllianceView.OnAllianceItemMoveIn = OnAllianceItemMoveIn
UIJoinAllianceView.OnAllianceItemMoveOut = OnAllianceItemMoveOut
UIJoinAllianceView.ClearScroll = ClearScroll
UIJoinAllianceView.OnAddListener = OnAddListener
UIJoinAllianceView.OnRemoveListener = OnRemoveListener
UIJoinAllianceView.IptOnValueChange = IptOnValueChange
UIJoinAllianceView.OnClickApply = OnClickApply
UIJoinAllianceView.OnClickSearch = OnClickSearch
UIJoinAllianceView.OnClickCancel = OnClickCancel
UIJoinAllianceView.OnClickMail = OnClickMail
UIJoinAllianceView.OnClickJoin = OnClickJoin
UIJoinAllianceView.OnJoinAllianceBack = OnJoinAllianceBack
UIJoinAllianceView.OnChangeClick = OnChangeClick
return UIJoinAllianceView
