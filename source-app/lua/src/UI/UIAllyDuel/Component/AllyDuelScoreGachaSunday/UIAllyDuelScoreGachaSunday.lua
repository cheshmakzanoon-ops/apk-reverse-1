local base = UIBaseView
local UIAllyDuelScoreSundayGacha = BaseClass("UIAllyDuelScoreSundayGacha", UIBaseView)
local Localization = CS.GameEntry.Localization
local UIFireworkPreviewRT = require("UI.Firework.UIFireworkPreviewWindow.Component.UIFireworkPreviewRT")
local AllyDuelScoreGachaWheelComponent = require("UI/UIAllyDuel/Component/AllyDuelScoreGacha/AllyDuelScoreGacha/Component/UIAllyDuelWheelContentComponent")
local AllyDuelScoreGachaWishComponent = require("UI/UIAllyDuel/Component/AllyDuelScoreGacha/AllyDuelScoreGacha/Component/UIAllyDuelWishContentComponent")
UIAllyDuelScoreSundayGacha.AnimName = {Enter = "Join", Normal = "changtai"}

function UIAllyDuelScoreSundayGacha:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllyDuelScoreSundayGacha:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelScoreSundayGacha:OnEnable()
  base.OnEnable(self)
end

function UIAllyDuelScoreSundayGacha:OnDisable()
  base.OnDisable(self)
  self:ClearDelayShowGachaResultTimer()
  self:StopMainTimer()
end

function UIAllyDuelScoreSundayGacha:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compMainContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.anim = self.viewSkin:AddComponent(self, UIAnimator, 2)
  self.compBlockBtn = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compWheelContent = self.viewSkin:AddComponent(self, AllyDuelScoreGachaWheelComponent, 4)
  self.compWishContent = self.viewSkin:AddComponent(self, AllyDuelScoreGachaWishComponent, 5)
  self.btnOne = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnOne:SetOnClick(function()
    self:OnBtnOneClick()
  end)
  self.textOne = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compOneBtnLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.imgOneBtnIcon = self.viewSkin:AddComponent(self, UIImage, 9)
  self.textOneNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textOneFreeRefreshTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnTen = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnTen:SetOnClick(function()
    self:OnBtnTenClick()
  end)
  self.textTen = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compTenBtnLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.imgTenBtnIcon = self.viewSkin:AddComponent(self, UIImage, 15)
  self.textTenNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.btnSkip = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.compSkipBtnBeSelect = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.textSkipTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textWheelDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textActName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textTimes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.imgResourceIcon = self.viewSkin:AddComponent(self, UIImage, 23)
  self.textResourceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.btnAdd = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.compAddRedPoint = self.viewSkin:AddComponent(self, UIBaseContainer, 26)
  self.textProgressTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 27)
  self.sliderProgress = self.viewSkin:AddComponent(self, UISlider, 28)
  self.btnRules = self.viewSkin:AddComponent(self, UIButton, 29)
  self.btnRules:SetOnClick(function()
    self:OnBtnRulesClick()
  end)
  self.textRules = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 30)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 31)
  self.compLockScoreContent = self.viewSkin:AddComponent(self, UIBaseContainer, 32)
  self.imgScienceIcon = self.viewSkin:AddComponent(self, UIImage, 33)
  self.textUnlockTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 34)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 35)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textGoBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.textProgressTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 37)
  self.compProgressDetailContent = self.viewSkin:AddComponent(self, UIBaseContainer, 38)
  self.rawImgRT = self.viewSkin:AddComponent(self, UIFireworkPreviewRT, 39)
  self.textUnlockTips:SetLocalText("alliance_duel_gacha_tips_1001")
  self.textGoBtn:SetLocalText("110003")
  self:Update1000MS()
end

function UIAllyDuelScoreSundayGacha:ComponentDestroy()
  self.viewSkin = nil
  self.compMainContent = nil
  self.anim = nil
  self.compBlockBtn = nil
  self.compWheelContent = nil
  self.compWishContent = nil
  self.btnOne = nil
  self.textOne = nil
  self.compOneBtnLayout = nil
  self.imgOneBtnIcon = nil
  self.textOneNum = nil
  self.textOneFreeRefreshTime = nil
  self.btnTen = nil
  self.textTen = nil
  self.compTenBtnLayout = nil
  self.imgTenBtnIcon = nil
  self.textTenNum = nil
  self.btnSkip = nil
  self.compSkipBtnBeSelect = nil
  self.textSkipTip = nil
  self.textWheelDes = nil
  self.textActName = nil
  self.textTimes = nil
  self.imgResourceIcon = nil
  self.textResourceNum = nil
  self.btnAdd = nil
  self.compAddRedPoint = nil
  self.textProgressTitleTxt = nil
  self.sliderProgress = nil
  self.btnRules = nil
  self.textRules = nil
  self.imgIcon = nil
  self.compLockScoreContent = nil
  self.imgScienceIcon = nil
  self.textUnlockTips = nil
  self.btnGo = nil
  self.textGoBtn = nil
  self.textProgressTxt = nil
  self.compProgressDetailContent = nil
  self.rawImgRT = nil
end

function UIAllyDuelScoreSundayGacha:DataDefine()
  self.mainAnimTimer = nil
end

function UIAllyDuelScoreSundayGacha:DataDestroy()
  self:ClearDelayShowGachaResultTimer()
  self:StopMainTimer()
end

function UIAllyDuelScoreSundayGacha:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllyDuelScoreGachaStartGacha, self.OnGachaStart)
  self:AddUIListener(EventId.AllyDuelScoreGachaEndGacha, self.OnGachaEnd)
  self:AddUIListener(EventId.AllyDuelScoreGachaWishClaim, self.OnClaimWish)
  self:AddUIListener(EventId.AllyDuelScoreGachaShowGachaAnim, self.OnShowGachaAnim)
  self:AddUIListener(EventId.AllyDuelScoreGachaGotData, self.SetData)
end

function UIAllyDuelScoreSundayGacha:OnRemoveListener()
  self:RemoveUIListener(EventId.AllyDuelScoreGachaStartGacha, self.OnGachaStart)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaEndGacha, self.OnGachaEnd)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaWishClaim, self.OnClaimWish)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaShowGachaAnim, self.OnShowGachaAnim)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaGotData, self.SetData)
  base.OnRemoveListener(self)
end

function UIAllyDuelScoreSundayGacha:ShowPanel()
  DataCenter.AllyDuelScoreGachaManager:SendGetGachaInfoMessage()
end

function UIAllyDuelScoreSundayGacha:SetData(configId)
  self.configId = configId
  self:UpdateMain(true)
end

function UIAllyDuelScoreSundayGacha:StopMainTimer()
  if self.mainAnimTimer ~= nil then
    self.mainAnimTimer:Stop()
    self.mainAnimTimer = nil
  end
end

function UIAllyDuelScoreSundayGacha:UpdateMain(isEnter)
  self.textActName:SetLocalText("alliance_duel_gacha_tech_name")
  self:UpdateResBar()
  self:UpdateProgress()
  self:UpdateSkipBtn()
  self:UpdateGachaBtns()
  self:UpdateUnlockContent()
  self.compBlockBtn:SetActive(false)
  if self.configId then
    self.compWheelContent:ReInit(self.configId, isEnter)
    self.compWishContent:ReInit(self.configId)
  end
end

function UIAllyDuelScoreSundayGacha:UpdateResBar()
  if self.configId == nil then
    self.textResourceNum:SetText(0)
    return
  end
  local infoTemplate = DataCenter.AllyDuelScoreGachaManager:GetConfigInfo(self.configId)
  if infoTemplate == nil then
    return
  end
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  local curNum = configData.data.score // DataCenter.AllyDuelScoreGachaManager.gachaOnceCost
  self.textResourceNum:SetText(string.GetFormattedStr(curNum))
end

function UIAllyDuelScoreSundayGacha:UpdateProgress()
  self.textProgressTitleTxt:SetLocalText("alliance_duel_gacha_tips_1014")
  local maxScore = DataCenter.AllyDuelScoreGachaManager.gachaOnceCost
  if self.configId == nil then
    self.textProgressTxt:SetText(string.format("%s/%s", 0, maxScore))
    self.sliderProgress:SetValue(0)
    return
  end
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData then
    local curScore = configData.data.score
    local availableGachaCount = curScore // maxScore
    self.textProgressTxt:SetText(string.format("%s/%s", curScore, maxScore))
    self.sliderProgress:SetValue(curScore / maxScore)
  end
end

function UIAllyDuelScoreSundayGacha:UpdateSkipBtn()
  local isSkip = DataCenter.AllyDuelScoreGachaManager:IsSkipGachaAnim()
  self.compSkipBtnBeSelect:SetActive(isSkip)
end

function UIAllyDuelScoreSundayGacha:UpdateGachaBtns()
  self.textOne:SetLocalText("alliance_duel_gacha_tips_1004")
  self.textTen:SetLocalText("alliance_duel_gacha_tips_1005")
  if self.configId == nil then
    return
  end
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData == nil then
    return
  end
  local configInfo = DataCenter.AllyDuelScoreGachaManager:GetConfigInfo(self.configId)
  if configInfo == nil then
    return
  end
  self.textOneFreeRefreshTime:SetActive(false)
  self.compOneBtnLayout:SetActive(true)
  self.textOneNum:SetText(tostring(configInfo.costNum))
  if DataCenter.AllyDuelScoreGachaManager:IsGachaCostItemEnough(self.configId, 1) then
    self.textOneNum:SetColor(WhiteColor)
  else
    self.textOneNum:SetColor(RedColor)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compOneBtnLayout.transform)
  self.textTenNum:SetText(tostring(configInfo.costNum * configInfo.buttonPara))
  if DataCenter.AllyDuelScoreGachaManager:IsGachaCostItemEnough(self.configId, configInfo.buttonPara) then
    self.textTenNum:SetColor(WhiteColor)
  else
    self.textTenNum:SetColor(RedColor)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compTenBtnLayout.transform)
  local pity = configData:GetPity()
  local pityStr = string.format("<color=#00ff00>%s</color>", tostring(pity))
  self.textWheelDes:SetLocalText("decoration_recruit_desc48", pityStr)
end

function UIAllyDuelScoreSundayGacha:UpdateUnlockContent()
  local isUnlock = DataCenter.AllyDuelScoreGachaManager:IsUnlock()
  self.compLockScoreContent:SetActive(not isUnlock)
  self.compProgressDetailContent:SetActive(isUnlock)
  if isUnlock then
    return
  end
  local scienceTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(DataCenter.AllyDuelScoreGachaManager.unlockScienceId)
  if scienceTemplate then
    self.imgScienceIcon:LoadSpriteAuto(string.format(LoadPath.ScienceIcons, scienceTemplate.icon))
  end
end

function UIAllyDuelScoreSundayGacha:OnBtnOneClick()
  if self.configId == nil or not DataCenter.AllyDuelScoreGachaManager:IsUnlock() then
    return
  end
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData == nil then
    return
  end
  if not DataCenter.AllyDuelScoreGachaManager:IsGachaCostItemEnough(self.configId, 1) then
    UIUtil.ShowTipsId("alliance_duel_gacha_tips_1015")
    return
  end
  DataCenter.AllyDuelScoreGachaManager:SendGachaMessage(self.configId, 1)
end

function UIAllyDuelScoreSundayGacha:OnBtnTenClick()
  if self.configId == nil or not DataCenter.AllyDuelScoreGachaManager:IsUnlock() then
    return
  end
  local configInfo = DataCenter.AllyDuelScoreGachaManager:GetConfigInfo(self.configId)
  if configInfo == nil then
    return
  end
  local num = tonumber(configInfo.buttonPara)
  if not DataCenter.AllyDuelScoreGachaManager:IsGachaCostItemEnough(self.configId, num) then
    UIUtil.ShowTipsId("alliance_duel_gacha_tips_1015")
    return
  end
  DataCenter.AllyDuelScoreGachaManager:SendGachaMessage(self.configId, num)
end

function UIAllyDuelScoreSundayGacha:OnBtnSkipClick()
  DataCenter.AllyDuelScoreGachaManager:SetIsSkipGachaAnim(not DataCenter.AllyDuelScoreGachaManager:IsSkipGachaAnim())
  self:UpdateSkipBtn()
end

function UIAllyDuelScoreSundayGacha:OnBtnAddClick()
  if self.configId ~= nil then
    EventManager:GetInstance():Broadcast(EventId.AllyDuelChangeTabInView, LeagueMatchTab.Activity)
  end
end

function UIAllyDuelScoreSundayGacha:OnBtnCollectionClick()
  if self.configId ~= nil then
    DataCenter.AllyDuelScoreGachaManager:OpenDecorationBook(self.configId)
  end
end

function UIAllyDuelScoreSundayGacha:OnBtnRulesClick()
  if self.configId ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.AllyDuelScoreGachaRules, {anim = true}, self.configId)
  end
end

function UIAllyDuelScoreSundayGacha:OnBtnGoClick()
  GoToUtil.GotoScience(DataCenter.AllyDuelScoreGachaManager.unlockScienceId // 100 * 100)
end

function UIAllyDuelScoreSundayGacha:OnGachaStart()
  self.compBlockBtn:SetActive(true)
end

function UIAllyDuelScoreSundayGacha:OnGachaEnd()
  self.compBlockBtn:SetActive(false)
  self:UpdateMain(DataCenter.AllyDuelScoreGachaManager:IsSkipGachaAnim())
end

function UIAllyDuelScoreSundayGacha:OnSelectWish()
  self:UpdateMain(false)
end

function UIAllyDuelScoreSundayGacha:OnClaimWish()
  self:UpdateMain(false)
end

function UIAllyDuelScoreSundayGacha:ClearDelayShowGachaResultTimer()
  if self.delayShowGachaResultTimer ~= nil then
    self.delayShowGachaResultTimer:Stop()
    self.delayShowGachaResultTimer = nil
  end
end

function UIAllyDuelScoreSundayGacha:OnShowGachaAnim(evtData)
  self:UpdateProgress()
  local delayTime = DataCenter.AllyDuelScoreGachaManager:GetShowResultDelayTime(evtData)
  if 0 < delayTime then
    self.compWheelContent:PlayGachaAnim(evtData, function()
      if self.activeSelf then
        self.delayShowGachaResultTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:ClearDelayShowGachaResultTimer()
          DataCenter.AllyDuelScoreGachaManager:ShowGachaResult()
        end, delayTime)
      end
    end)
  end
end

function UIAllyDuelScoreSundayGacha:RefreshRT(fireworkId, width, height)
  self.rawImgRT:SetData(fireworkId, width, height)
end

function UIAllyDuelScoreSundayGacha:Update1000MS()
  local remainTimeS = UITimeManager:GetInstance():GetResSeoncdsToNextMonday()
  local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(remainTimeS * 1000)
  self.textTimes:SetText(showTime)
end

return UIAllyDuelScoreSundayGacha
