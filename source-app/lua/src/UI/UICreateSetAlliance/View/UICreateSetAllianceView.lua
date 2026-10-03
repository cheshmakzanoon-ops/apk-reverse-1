local base = UIBaseView
local UICreateSetAllianceView = BaseClass("UICreateSetAllianceView", base)
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local UIGray = CS.UIGray
local closeBtn_path = "CloseBtn"
local allianceFlag_path = "ImgBg/flagBg/icon/AllianceFlag"
local setAlFlagBtn_path = "ImgBg/flagBg/changeFlagBtn"
local setAlFlagBtnTxt_path = "ImgBg/flagBg/changeFlagBtn/changeFlagTxt"
local alNameTxt_path = "ImgBg/change/alNameObj/alNameTxt"
local alName_path = "ImgBg/change/alNameObj/alName"
local alNameBtn_path = "ImgBg/change/alNameObj/setAlNameBtn"
local alAbbrTxt_path = "ImgBg/change/alAbbrObj/alAbbrTxt"
local alAbbr_path = "ImgBg/change/alAbbrObj/alAbbr"
local alAbbrBtn_path = "ImgBg/change/alAbbrObj/setAlAbbrBtn"
local alLanguageTxt_path = "ImgBg/change/layout/alLanguageObj/alLanguageTxt"
local alLanguage_path = "ImgBg/change/layout/alLanguageObj/alLanguage"
local alLanguageBtn_path = "ImgBg/change/layout/alLanguageObj/setAlLanguageBtn"
local countryFlagTxt_path = "ImgBg/change/layout/countryObj/countryTxt"
local countryFlagImg_path = "ImgBg/change/layout/countryObj/countryFlag"
local countryFlagBtn_path = "ImgBg/change/layout/countryObj/setCountryBtn"
local alAnnounce_path = "ImgBg/change/alAnnounceObj/alAnnounce"
local alAnnounceTxt_path = "ImgBg/change/alAnnounceObj/alAnnounceTxt"
local alAnnounceBtn_path = "ImgBg/change/alAnnounceObj/announceBtn"
local createBtn_path = "ImgBg/change/createBtn"
local createBtnTxt_path = "ImgBg/change/createBtn/costObj/costBtnName"
local createCost_path = "ImgBg/change/createBtn/costObj/itemCount"
local changeNameEff_path = "ImgBg/change/alNameObj/setAlNameBtn/changeNameEff"
local changeAbbrEff_path = "ImgBg/change/alAbbrObj/setAlAbbrBtn/changeAbbrEff"
local changeAnnounceEff_path = "ImgBg/change/alAnnounceObj/announceBtn/changeAnnounceEff"
local npcDialogTxt_path = "ImgBg/desBg/desText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.isChooseLeader = self:GetUserData()
  self:RefreshAll()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.allianceFlagN = self:AddComponent(AllianceFlagItem, allianceFlag_path)
  self.setAlFlagBtnN = self:AddComponent(UIButton, setAlFlagBtn_path)
  self.setAlFlagBtnN:SetOnClick(function()
    self:OnClickSetAlFlag()
  end)
  self.setAlFlagBtnTxtN = self:AddComponent(UIText, setAlFlagBtnTxt_path)
  self.setAlFlagBtnTxtN:SetLocalText(110108)
  self.alNameTxtN = self:AddComponent(UIText, alNameTxt_path)
  self.alNameTxtN:SetLocalText(390288)
  self.alNameN = self:AddComponent(UIText, alName_path)
  self.alNameBtnN = self:AddComponent(UIButton, alNameBtn_path)
  self.alNameBtnN:SetOnClick(function()
    self:OnClickSetAlNameBtn()
  end)
  self.alAbbrTxt = self:AddComponent(UIText, alAbbrTxt_path)
  self.alAbbrTxt:SetLocalText(100548)
  self.alAbbrN = self:AddComponent(UIText, alAbbr_path)
  self.alAbbrBtnN = self:AddComponent(UIButton, alAbbrBtn_path)
  self.alAbbrBtnN:SetOnClick(function()
    self:OnClickSetAlAbbrBtn()
  end)
  self.alLanguageTxtN = self:AddComponent(UIText, alLanguageTxt_path)
  self.alLanguageTxtN:SetLocalText(100101)
  self.alLanguageN = self:AddComponent(UIText, alLanguage_path)
  self.alLanguageBtnN = self:AddComponent(UIButton, alLanguageBtn_path)
  self.alLanguageBtnN:SetOnClick(function()
    self:OnClickLanguageBtn()
  end)
  self.countryFlagTxtN = self:AddComponent(UIText, countryFlagTxt_path)
  self.countryFlagTxtN:SetLocalText(143589)
  self.countryFlagN = self:AddComponent(UIImage, countryFlagImg_path)
  self.countryFlagBtnN = self:AddComponent(UIButton, countryFlagBtn_path)
  self.countryFlagBtnN:SetOnClick(function()
    self:OnClickCountryFlagBtn()
  end)
  self.alAnnounceN = self:AddComponent(UIText, alAnnounce_path)
  self.alAnnounceTxtN = self:AddComponent(UIText, alAnnounceTxt_path)
  self.alAnnounceTxtN:SetLocalText(390513)
  self.alAnnounceBtnN = self:AddComponent(UIButton, alAnnounceBtn_path)
  self.alAnnounceBtnN:SetOnClick(function()
    self:OnClickSetAnnounceBtn()
  end)
  self.createBtnN = self:AddComponent(UIButton, createBtn_path)
  self.createBtnN:SetOnClick(function()
    self:OnClickCreateBtn()
  end)
  self.createBtnTxtN = self:AddComponent(UIText, createBtnTxt_path)
  self.createBtnTxtN:SetLocalText(110006)
  self.createCostN = self:AddComponent(UIText, createCost_path)
  self.changeNameEffN = self:AddComponent(UIBaseContainer, changeNameEff_path)
  self.changeAbbrEffN = self:AddComponent(UIBaseContainer, changeAbbrEff_path)
  self.changeAnnounceEffN = self:AddComponent(UIBaseContainer, changeAnnounceEff_path)
  self.npcDialogTxtN = self:AddComponent(UIText, npcDialogTxt_path)
  self.npcDialogTxtN:SetLocalText(330264)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.allianceFlagN = nil
  self.setAlFlagBtnN = nil
  self.setAlFlagBtnTxtN = nil
  self.alNameTxtN = nil
  self.alNameN = nil
  self.alNameBtnN = nil
  self.alAbbrTxt = nil
  self.alAbbrN = nil
  self.alAbbrBtnN = nil
  self.alLanguageTxtN = nil
  self.alLanguageN = nil
  self.alLanguageBtnN = nil
  self.countryFlagTxtN = nil
  self.countryFlagN = nil
  self.countryFlagBtnN = nil
  self.alAnnounceN = nil
  self.alAnnounceBtnN = nil
  self.createBtnN = nil
  self.createBtnTxtN = nil
  self.createCostN = nil
  self.changeNameEffN = nil
  self.changeAbbrEffN = nil
  self.changeAnnounceEffN = nil
end

local function DataDefine(self)
  self.cacheAlName = ""
  self.cacheAlAbbr = ""
  self.cacheAlAnnounce = ""
  self.cacheAlLanguage = SuportedLanguagesLocalName[Language.English]
  self.cacheCountryFlag = LuaEntry.Player.countryFlag
  self.cacheAlFlag = "1;1;1;1"
  self.isChooseLeader = 0
  self.nameChanged = false
  self.abbrChanged = false
  self.announceChanged = false
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function RefreshAll(self)
  self.alNameN:SetText(self.cacheAlName)
  self.alAbbrN:SetText(self.cacheAlAbbr)
  self.alAnnounceN:SetText(self.cacheAlAnnounce)
  self.alLanguageN:SetLocalText(self.cacheAlLanguage)
  self.allianceFlagN:SetData(self.cacheAlFlag)
  if not LuaEntry.GlobalData:IsChina() then
    self.countryFlagN:SetActive(true)
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(self.cacheCountryFlag)
    self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.countryFlagN:SetActive(false)
  end
  local cost = 0
  if self.isChooseLeader then
    cost = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k13")
  else
    cost = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k5")
  end
  self.isCostEnough = cost <= LuaEntry.Player.gold
  local strCost = self.isCostEnough and cost or string.format("<color=#ff0000>%s</color>", cost)
  self.createCostN:SetText(strCost)
  if not (self.abbrChanged and self.nameChanged) or not self.announceChanged then
    UIGray.SetGray(self.createBtnN.transform, true, false)
  else
    UIGray.SetGray(self.createBtnN.transform, false, true)
  end
  self.changeNameEffN:SetActive(not self.nameChanged)
  self.changeAbbrEffN:SetActive(not self.abbrChanged)
  self.changeAnnounceEffN:SetActive(not self.announceChanged)
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickSetAlFlag(self)
  local param = {}
  param.curFlag = "1;1;1;1"
  param.cost = 0
  
  function param.callback(strNew)
    self.cacheAlFlag = strNew
    self:RefreshAll()
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceFlag, {anim = true}, param)
end

local function OnClickSetAlNameBtn(self)
  local param = {}
  param.curName = ""
  param.cost = 0
  param.btnName = 110006
  
  function param.callback(value)
    self.cacheAlName = value
    self.nameChanged = true
    self:RefreshAll()
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeName, {anim = true}, param)
end

local function OnClickSetAlAbbrBtn(self)
  local param = {}
  param.curAbbr = ""
  param.cost = 0
  param.btnName = 110006
  
  function param.callback(value)
    self.cacheAlAbbr = value
    self.abbrChanged = true
    self:RefreshAll()
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeAbbr, {anim = true}, param)
end

local function OnClickLanguageBtn(self)
  local param = {}
  param.curLanguage = self.cacheAlLanguage
  
  function param.callback(value)
    self.cacheAlLanguage = value
    self:RefreshAll()
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeLanguage, {anim = true}, param)
end

local function OnClickCountryFlagBtn(self)
  local tempNation = self.cacheCountryFlag
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISetPlayerNation, {anim = true}, {
    nation = tempNation,
    callback = function(tempSelected)
      self.cacheCountryFlag = tempSelected
      self:RefreshAll()
    end
  })
end

local function OnClickSetAnnounceBtn(self)
  local function callback(value)
    self.cacheAlAnnounce = value
    
    self.announceChanged = true
    self:RefreshAll()
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeAnnounce, {anim = true}, 4, "", callback)
end

local function OnClickCreateBtn(self)
  if self.isCostEnough then
    if self.isChooseLeader == 1 then
      self:CheckDoNext()
      SFSNetwork.SendMessage(MsgDefines.AlCreate, self.cacheAlName, self.cacheAlAnnounce, self.cacheAlFlag, self.cacheAlLanguage, self.cacheAlAbbr, self.cacheCountryFlag, self.isChooseLeader)
    else
      UIUtil.ShowMessage(Localization:GetString("390864"), 2, nil, nil, function()
        EventManager:GetInstance():Broadcast(EventId.SetMovingUI, UIMovingType.Open)
        SFSNetwork.SendMessage(MsgDefines.AlCreate, self.cacheAlName, self.cacheAlAnnounce, self.cacheAlFlag, self.cacheAlLanguage, self.cacheAlAbbr, self.cacheCountryFlag, self.isChooseLeader)
      end, nil, nil)
    end
    self.ctrl:Close()
  else
    GoToUtil.GotoPayTips()
  end
end

local function CheckDoNext(self)
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and template.type == GuideType.WaitQuestionEnd then
    DataCenter.GuideManager:SetCurGuideId(tonumber(template.para1))
    DataCenter.GuideManager:DoGuide()
  end
end

UICreateSetAllianceView.OnCreate = OnCreate
UICreateSetAllianceView.OnDestroy = OnDestroy
UICreateSetAllianceView.OnAddListener = OnAddListener
UICreateSetAllianceView.OnRemoveListener = OnRemoveListener
UICreateSetAllianceView.ComponentDefine = ComponentDefine
UICreateSetAllianceView.ComponentDestroy = ComponentDestroy
UICreateSetAllianceView.DataDefine = DataDefine
UICreateSetAllianceView.DataDestroy = DataDestroy
UICreateSetAllianceView.RefreshAll = RefreshAll
UICreateSetAllianceView.OnClickCloseBtn = OnClickCloseBtn
UICreateSetAllianceView.OnClickSetAlFlag = OnClickSetAlFlag
UICreateSetAllianceView.OnClickSetAlNameBtn = OnClickSetAlNameBtn
UICreateSetAllianceView.OnClickSetAlAbbrBtn = OnClickSetAlAbbrBtn
UICreateSetAllianceView.OnClickLanguageBtn = OnClickLanguageBtn
UICreateSetAllianceView.OnClickCountryFlagBtn = OnClickCountryFlagBtn
UICreateSetAllianceView.OnClickSetAnnounceBtn = OnClickSetAnnounceBtn
UICreateSetAllianceView.OnClickCreateBtn = OnClickCreateBtn
UICreateSetAllianceView.CheckDoNext = CheckDoNext
return UICreateSetAllianceView
