local LWUIStageSkyBattleChapterView = BaseClass("LWUIStageSkyBattleChapterView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ChapterContentComponent = require("UI.UILWStageSkyBattleChapter.Components.ChapterContentComponent")
local GrowBagContentComponent = require("UI.UILWStageSkyBattleChapter.Components.GrowBagContentComponent")
local SkyBattleDevelopContentComponent = require("UI.UILWStageSkyBattleChapter.Components.SkyBattleDevelopContentComponent")

function LWUIStageSkyBattleChapterView:OnCreate()
  base.OnCreate(self)
  local userData = self:GetUserData()
  self.growthMode = userData and userData.growMode or false
  self.tab = userData and userData.tab or 1
  self.guide = userData and userData.guideType
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIStageSkyBattleChapterView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIStageSkyBattleChapterView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textFirstTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compTopBanner = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textStrengthNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textGoodsNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnChapter = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnChapter:SetOnClick(function()
    self:OnBtnChapterClick()
  end)
  self.imgIconChapterSelected = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textBtnChapterTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnDevelop = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnDevelop:SetOnClick(function()
    self:OnBtnDevelopClick()
  end)
  self.imgIconDevelopSelected = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textBtnDevelopTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnBag = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnBag:SetOnClick(function()
    self:OnBtnBagClick()
  end)
  self.imgIconBagSelected = self.viewSkin:AddComponent(self, UIImage, 14)
  self.textBtnBagTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.compTabs = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.rawImgBgChapter = self.viewSkin:AddComponent(self, UIRawImage, 17)
  self.rawImgBgBag = self.viewSkin:AddComponent(self, UIRawImage, 18)
  self.rawImgBgDevelop = self.viewSkin:AddComponent(self, UIRawImage, 19)
  self.compChapterContent = self.viewSkin:AddComponent(self, ChapterContentComponent, 20)
  self.compGrowBagContent = self.viewSkin:AddComponent(self, GrowBagContentComponent, 21)
  self.compDevelopContent = self.viewSkin:AddComponent(self, SkyBattleDevelopContentComponent, 22)
  self.compTime = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.textTxtRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.textBtnChapterTxt:SetLocalText("plane_chapter_03")
  self.textBtnDevelopTxt:SetLocalText("plane_chapter_04")
  self.textBtnBagTxt:SetLocalText("plane_chapter_05")
  self.textFirstTitle:SetLocalText("plane_game_name_01")
end

function LWUIStageSkyBattleChapterView:ComponentDestroy()
  self.viewSkin = nil
  self.textFirstTitle = nil
  self.btnClose = nil
  self.compTopBanner = nil
  self.textPower = nil
  self.textStrengthNum = nil
  self.textGoodsNum = nil
  self.btnChapter = nil
  self.imgIconChapterSelected = nil
  self.textBtnChapterTxt = nil
  self.btnDevelop = nil
  self.imgIconDevelopSelected = nil
  self.textBtnDevelopTxt = nil
  self.btnBag = nil
  self.imgIconBagSelected = nil
  self.textBtnBagTxt = nil
  self.compTabs = nil
  self.rawImgBgChapter = nil
  self.rawImgBgBag = nil
  self.rawImgBgDevelop = nil
  self.compChapterContent = nil
  self.compGrowBagContent = nil
  self.compDevelopContent = nil
  self.compTime = nil
  self.textTxtRemainTime = nil
end

function LWUIStageSkyBattleChapterView:DataDefine()
  DataCenter.LWBattleManager:SetBattleExitEndTime(BattleExitTimeLogType.SkyBattle)
end

function LWUIStageSkyBattleChapterView:DataDestroy()
  self.growthMode = nil
  self.staminaShow = nil
  if self.delayGuideTimer then
    self.delayGuideTimer:Stop()
    self.delayGuideTimer = nil
  end
end

function LWUIStageSkyBattleChapterView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleChapterGrowthUserInfoInit, self.RefreshUserDataInfo)
  self:AddUIListener(EventId.SkyBattleChapterGrowthUserInfoRefresh, self.RefreshUserDataInfo)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleInfoInit, self.RefreshPower)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh, self.RefreshPower)
  self:AddUIListener(EventId.SkyBattleEquipSlotUpgrade, self.RefreshPower)
  self:AddUIListener(EventId.SkyBattleEquipUnInstall, self.RefreshPower)
  self:AddUIListener(EventId.SkyBattleEquipInstall, self.RefreshPower)
  self:AddUIListener(EventId.SkyBattleChapterViewRefresh, self.ReOpen)
end

function LWUIStageSkyBattleChapterView:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthUserInfoInit, self.RefreshUserDataInfo)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthUserInfoRefresh, self.RefreshUserDataInfo)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleInfoInit, self.RefreshPower)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh, self.RefreshPower)
  self:RemoveUIListener(EventId.SkyBattleEquipSlotUpgrade, self.RefreshPower)
  self:RemoveUIListener(EventId.SkyBattleEquipUnInstall, self.RefreshPower)
  self:RemoveUIListener(EventId.SkyBattleEquipInstall, self.RefreshPower)
  self:RemoveUIListener(EventId.SkyBattleChapterViewRefresh, self.ReOpen)
  base.OnRemoveListener(self)
end

function LWUIStageSkyBattleChapterView:ReOpen(data)
  local userData = data
  if not userData then
    return
  end
  self.growthMode = userData and userData.growMode or false
  self.tab = userData and userData.tab or 1
  self.guide = userData and userData.guideType
  self:ReInit()
end

function LWUIStageSkyBattleChapterView:ReInit()
  self.compGrowBagContent:SetActive(false)
  self.compDevelopContent:SetActive(false)
  self.compChapterContent:SetActive(false)
  local timeBarAnchorPosY = -182.4
  if self.growthMode then
    timeBarAnchorPosY = -182.4
  else
    timeBarAnchorPosY = -182.4
  end
  self.compTime:SetAnchoredPositionXY(-368.8, timeBarAnchorPosY)
  if self.growthMode then
    self.compTabs:SetActive(true)
    self.compTopBanner:SetActive(true)
    if not DataCenter.LWSkyBattleGrowthChapterManager:UserInfoInited() then
      SFSNetwork.SendMessage(MsgDefines.GetSkyBattleUserInfo)
    end
    if not DataCenter.LWSkyBattleGrowthChapterManager:BattleInfoInited() then
      SFSNetwork.SendMessage(MsgDefines.GetUserSkyBattleInfo)
    end
    if not DataCenter.LWSkyBattleGrowthChapterManager:ChapterInited() then
      SFSNetwork.SendMessage(MsgDefines.LwGetSkyBattleStage, -1, 1)
    end
    self:RefreshUserDataInfo()
    local guidePosition
    if self.tab == 1 then
      self:OnBtnChapterClick()
    elseif self.tab == 2 then
      guidePosition = self.compDevelopContent:GetGuidePosition(self.guide)
      self:OnBtnDevelopClick()
    elseif self.tab == 3 then
      guidePosition = self.compGrowBagContent:GetGuidePosition(self.guide)
      self:OnBtnBagClick()
    else
      self:OnBtnChapterClick()
    end
    if guidePosition then
      self.delayGuideTimer = TimerManager:GetInstance():DelayInvoke(function()
        local param = {}
        param.position = guidePosition
        param.positionType = PositionType.Screen
        if param.position ~= nil then
          DataCenter.ArrowManager:ShowArrow(param)
        end
      end, 0.5)
    end
  else
    self.compTabs:SetActive(false)
    self.compTopBanner:SetActive(false)
    if not DataCenter.LWSkyBattleChapterManager:ChapterInited() then
      SFSNetwork.SendMessage(MsgDefines.LwGetSkyBattleStage, -1, 0)
    end
    self:OnBtnChapterClick()
  end
  self:Update1000MS()
end

function LWUIStageSkyBattleChapterView:RefreshUserDataInfo()
  if not self.growthMode then
    return
  end
  local userInfo = DataCenter.LWSkyBattleGrowthChapterManager.userInfo
  if not userInfo then
    return
  end
  local targetStaminaShow = DataCenter.LWSkyBattleGrowthChapterManager:CalStaminaToShow()
  self.staminaShow = targetStaminaShow
  self.textStrengthNum:SetText(string.GetFormattedStr(targetStaminaShow))
  self.textGoodsNum:SetText(string.GetFormattedStr(userInfo.coin))
  self:RefreshPower()
end

function LWUIStageSkyBattleChapterView:RefreshPower()
  local power = DataCenter.LWSkyBattleGrowthChapterManager:GetCurTotalPower()
  self.textPower:SetText(string.GetFormattedSeperatorNum(power))
end

function LWUIStageSkyBattleChapterView:Update100MS()
  if self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager:UserInfoInited() then
    local curStaminaShow = self.staminaShow or 0
    local targetStaminaShow = DataCenter.LWSkyBattleGrowthChapterManager:CalStaminaToShow()
    if targetStaminaShow ~= curStaminaShow then
      self.textStrengthNum:SetText(string.GetFormattedStr(targetStaminaShow))
      self.staminaShow = targetStaminaShow
    end
  end
end

function LWUIStageSkyBattleChapterView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIStageSkyBattleChapterView:OnBtnChapterClick()
  self.compChapterContent:SetActive(true)
  self.compChapterContent:RefreshChapterContent()
  self.imgIconChapterSelected:SetActive(true)
  self.compGrowBagContent:SetActive(false)
  self.imgIconBagSelected:SetActive(false)
  self.compDevelopContent:SetActive(false)
  self.imgIconDevelopSelected:SetActive(false)
  self.rawImgBgChapter:SetActive(true)
  self.rawImgBgBag:SetActive(false)
  self.rawImgBgDevelop:SetActive(false)
end

function LWUIStageSkyBattleChapterView:OnBtnBagClick()
  self.compChapterContent:SetActive(false)
  self.imgIconChapterSelected:SetActive(false)
  self.compGrowBagContent:SetActive(true)
  self.imgIconBagSelected:SetActive(true)
  self.compDevelopContent:SetActive(false)
  self.imgIconDevelopSelected:SetActive(false)
  self.rawImgBgChapter:SetActive(false)
  self.rawImgBgBag:SetActive(true)
  self.rawImgBgDevelop:SetActive(false)
end

function LWUIStageSkyBattleChapterView:OnBtnDevelopClick()
  self.compChapterContent:SetActive(false)
  self.imgIconChapterSelected:SetActive(false)
  self.compGrowBagContent:SetActive(false)
  self.imgIconBagSelected:SetActive(false)
  self.compDevelopContent:SetActive(true)
  self.imgIconDevelopSelected:SetActive(true)
  self.rawImgBgChapter:SetActive(false)
  self.rawImgBgBag:SetActive(false)
  self.rawImgBgDevelop:SetActive(true)
end

function LWUIStageSkyBattleChapterView:ChangeChapterBg(bgPath)
  self.rawImgBgChapter:LoadSpriteAuto(bgPath)
end

function LWUIStageSkyBattleChapterView:Update1000MS()
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  local endTime = mgr:GetEndTime()
  if endTime == -1 then
    self.compTime:SetActive(false)
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.textTxtRemainTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    self.lastTickActNotEnd = true
  elseif self.lastTickActNotEnd then
    self.lastTickActNotEnd = false
    UIUtil.ShowTips(Localization:GetString("undo_system_toast_failed_desc003"))
    self.textTxtRemainTime:SetText("00:00:00")
  end
end

return LWUIStageSkyBattleChapterView
