local base = UIBaseView
local UIAllyDuelScoreGacha = BaseClass("UIAllyDuelScoreGacha", UIBaseView)
local Localization = CS.GameEntry.Localization
local UIFireworkPreviewRT = require("UI.Firework.UIFireworkPreviewWindow.Component.UIFireworkPreviewRT")
local AllyDuelScoreGachaWheelComponent = require("UI/UIAllyDuel/Component/AllyDuelScoreGacha/AllyDuelScoreGacha/Component/UIAllyDuelWheelContentComponent")
local AllyDuelScoreGachaWishComponent = require("UI/UIAllyDuel/Component/AllyDuelScoreGacha/AllyDuelScoreGacha/Component/UIAllyDuelWishContentComponent")
UIAllyDuelScoreGacha.AnimName = {Enter = "Join", Normal = "changtai"}

function UIAllyDuelScoreGacha:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ShowPanel()
end

function UIAllyDuelScoreGacha:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelScoreGacha:OnEnable()
  base.OnEnable(self)
end

function UIAllyDuelScoreGacha:OnDisable()
  base.OnDisable(self)
  self:ClearDelayShowGachaResultTimer()
  self:StopMainTimer()
end

function UIAllyDuelScoreGacha:ComponentDefine()
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
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 22)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 23)
  self.rawImgRT = self.viewSkin:AddComponent(self, UIFireworkPreviewRT, 24)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textRemainNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
end

function UIAllyDuelScoreGacha:ComponentDestroy()
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
  self.textTitle = nil
  self.btnClose = nil
  self.imgIcon = nil
  self.rawImgRT = nil
  self.btn = nil
  self.textRemainNum = nil
end

function UIAllyDuelScoreGacha:DataDefine()
  self.mainAnimTimer = nil
end

function UIAllyDuelScoreGacha:DataDestroy()
  self:RecordRedPoint()
  self:ClearDelayShowGachaResultTimer()
  self:StopMainTimer()
end

function UIAllyDuelScoreGacha:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllyDuelScoreGachaStartGacha, self.OnGachaStart)
  self:AddUIListener(EventId.AllyDuelScoreGachaEndGacha, self.OnGachaEnd)
  self:AddUIListener(EventId.AllyDuelScoreGachaWishClaim, self.OnClaimWish)
  self:AddUIListener(EventId.AllyDuelScoreGachaShowGachaAnim, self.OnShowGachaAnim)
  self:AddUIListener(EventId.AllyDuelScoreGachaGotData, self.SetData)
end

function UIAllyDuelScoreGacha:OnRemoveListener()
  self:RemoveUIListener(EventId.AllyDuelScoreGachaStartGacha, self.OnGachaStart)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaEndGacha, self.OnGachaEnd)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaWishClaim, self.OnClaimWish)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaShowGachaAnim, self.OnShowGachaAnim)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaGotData, self.SetData)
  base.OnRemoveListener(self)
end

function UIAllyDuelScoreGacha:ShowPanel()
  DataCenter.AllyDuelScoreGachaManager:SendGetGachaInfoMessage()
end

function UIAllyDuelScoreGacha:SetData(configId)
  self.configId = configId
  self:UpdateMain(true)
end

function UIAllyDuelScoreGacha:StopMainTimer()
  if self.mainAnimTimer ~= nil then
    self.mainAnimTimer:Stop()
    self.mainAnimTimer = nil
  end
end

function UIAllyDuelScoreGacha:UpdateMain(isEnter)
  self.textTitle:SetLocalText("alliance_duel_gacha_tech_name")
  self:UpdateSkipBtn()
  self:UpdateGachaBtns()
  self:UpdateRemainNum()
  self.compBlockBtn:SetActive(false)
  if self.configId then
    self.compWheelContent:ReInit(self.configId, isEnter)
    self.compWishContent:ReInit(self.configId)
  end
end

function UIAllyDuelScoreGacha:UpdateSkipBtn()
  local isSkip = DataCenter.AllyDuelScoreGachaManager:IsSkipGachaAnim()
  self.compSkipBtnBeSelect:SetActive(isSkip)
end

function UIAllyDuelScoreGacha:UpdateGachaBtns()
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

function UIAllyDuelScoreGacha:UpdateRemainNum()
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData == nil then
    return
  end
  local curHaveScore = configData.data.score
  local remainNum = DataCenter.AllyDuelScoreGachaManager.gachaOnceCost > 0 and curHaveScore // DataCenter.AllyDuelScoreGachaManager.gachaOnceCost or 0
  self.textRemainNum:SetText(tostring(remainNum))
end

function UIAllyDuelScoreGacha:OnBtnOneClick()
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

function UIAllyDuelScoreGacha:OnBtnTenClick()
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

function UIAllyDuelScoreGacha:OnBtnSkipClick()
  DataCenter.AllyDuelScoreGachaManager:SetIsSkipGachaAnim(not DataCenter.AllyDuelScoreGachaManager:IsSkipGachaAnim())
  self:UpdateSkipBtn()
end

function UIAllyDuelScoreGacha:OnGachaStart()
  self.compBlockBtn:SetActive(true)
end

function UIAllyDuelScoreGacha:OnGachaEnd()
  self.compBlockBtn:SetActive(false)
  self:UpdateMain(DataCenter.AllyDuelScoreGachaManager:IsSkipGachaAnim())
end

function UIAllyDuelScoreGacha:OnSelectWish()
  self:UpdateMain(false)
end

function UIAllyDuelScoreGacha:OnClaimWish()
  self:UpdateMain(false)
end

function UIAllyDuelScoreGacha:ClearDelayShowGachaResultTimer()
  if self.delayShowGachaResultTimer ~= nil then
    self.delayShowGachaResultTimer:Stop()
    self.delayShowGachaResultTimer = nil
  end
end

function UIAllyDuelScoreGacha:OnShowGachaAnim(evtData)
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

function UIAllyDuelScoreGacha:RefreshRT(fireworkId, width, height)
  self.rawImgRT:SetData(fireworkId, width, height)
end

function UIAllyDuelScoreGacha:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIAllyDuelScoreGacha:OnBtnClick()
  self.ctrl:CloseSelf()
end

function UIAllyDuelScoreGacha:RecordRedPoint()
  local gachaRedNum = DataCenter.AllyDuelScoreGachaManager:GetTotalRedDotNum()
  local nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
  CommonUtil.PlayerPrefsSetInt(SettingKeys.ALLY_DUEL_GACHA_BTN_LAST_RED .. nextWeekDayTime, gachaRedNum)
  EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreGachaRedPointUpdate)
end

return UIAllyDuelScoreGacha
