local base = UIBaseContainer
local CampScienceDonateInfo = BaseClass("CampScienceDonateInfo", base)
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local CampScienceDonateFishLogic = require("UI.LWSeason6.UILWSeasonDonateFish.Logic.CampScienceDonateFishLogic")
local bgImgN_path = ""
local techPoint_slider_path = "Slider"
local techPoint_slider_text_path = "Slider/Num"
local slider_tip_txt_path = "Slider/SliderTip"
local techPoint_Info_btn_path = "TechPointBtn"
local btnGo_path = "BtnGo"
local maxLevelGo_path = "MaxLevelGo"
local MaxLevelText_path = "MaxLevelGo/MaxLevelText"
local donate_reward_path = "donateReward"
local donate_tip_txt_path = "donateReward/donate_tip_txt"
local donate_txt_path = "donateReward/donate_txt"
local exp_txt_path = "donateReward/exp_txt"
local btn_donate_img_path = "donateReward/donate_img"
local btn_resBtn_path = "BtnGo/ResBtn"
local resNum_path = "BtnGo/ResBtn/OriginalTimeLayOut/OriginalTimeText"
local resBtnRedN_path = "BtnGo/ResBtn/red"
local img_exp_img1_path = "TechPointBtn/Image"
local img_exp_img_path = "donateReward/exp_img"
local go_CampFirstBtnGo_path = "CampFirstBtnGo"
local btn_RecommendBtn_path = "CampFirstBtnGo/RecommendBtn"
local btn_CancelRecommendBtn_path = "CampFirstBtnGo/CancelRecommendBtn"
local txt_cdText_path = "BtnGo/ResBtn/OriginalTimeLayOut/cdText"

function CampScienceDonateInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.recoverReqPending = nil
end

function CampScienceDonateInfo:OnDestroy()
  self.recoverReqPending = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CampScienceDonateInfo:ComponentDefine()
  self.bgImgN = self:AddComponent(UICanvasGroup, bgImgN_path)
  self.techPoint_slider = self:AddComponent(UISlider, techPoint_slider_path)
  self.techPoint_slider_text = self:AddComponent(UIText, techPoint_slider_text_path)
  self.slider_tip_txt = self:AddComponent(UIText, slider_tip_txt_path)
  self.techPoint_Info_btn = self:AddComponent(UIButton, techPoint_Info_btn_path)
  self.btnGo = self:AddComponent(UIBaseContainer, btnGo_path)
  self.maxLevelGo = self:AddComponent(UIBaseContainer, maxLevelGo_path)
  self.MaxLevelText = self:AddComponent(UIText, MaxLevelText_path)
  self.donate_reward = self:AddComponent(UIBaseContainer, donate_reward_path)
  self.donate_tip_txt = self:AddComponent(UIText, donate_tip_txt_path)
  self.donate_txt = self:AddComponent(UIText, donate_txt_path)
  self.exp_txt = self:AddComponent(UIText, exp_txt_path)
  self.btn_donate_img = self:AddComponent(UIButton, btn_donate_img_path)
  self.btn_resBtn = self:AddComponent(UIButton, btn_resBtn_path)
  self.resNum = self:AddComponent(UIText, resNum_path)
  self.resBtnRedN = self:AddComponent(UIImage, resBtnRedN_path)
  self.img_exp_img1 = self:AddComponent(UIImage, img_exp_img1_path)
  self.img_exp_img = self:AddComponent(UIImage, img_exp_img_path)
  self.go_CampFirstBtnGo = self:AddComponent(UIBaseContainer, go_CampFirstBtnGo_path)
  self.btn_RecommendBtn = self:AddComponent(UIButton, btn_RecommendBtn_path)
  self.btn_CancelRecommendBtn = self:AddComponent(UIButton, btn_CancelRecommendBtn_path)
  self.txt_cdText = self:AddComponent(UIText, txt_cdText_path)
  self.slider_tip_txt:SetLocalText(454104)
  self.donate_tip_txt:SetLocalText(454105)
  self.btn_donate_img:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShowDonateTip()
  end)
  self.btn_resBtn:SetOnClick(BindCallback(self, self.ClickRes))
  self.btn_RecommendBtn:SetOnClick(function()
    if not SeasonUtil.IsInSeason() then
      UIUtil.ShowTipsId("season_tips147")
      return
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChanceRecommendStateClick(1)
  end)
  self.btn_CancelRecommendBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChanceRecommendStateClick(0)
  end)
end

function CampScienceDonateInfo:ComponentDestroy()
  self.bgImgN = nil
  self.techPoint_slider = nil
  self.techPoint_slider_text = nil
  self.slider_tip_txt = nil
  self.techPoint_Info_btn = nil
  self.btnGo = nil
  self.maxLevelGo = nil
  self.MaxLevelText = nil
  self.donate_reward = nil
  self.donate_tip_txt = nil
  self.donate_txt = nil
  self.exp_txt = nil
  self.btn_donate_img = nil
  self.btn_resBtn = nil
  self.resNum = nil
  self.resBtnRedN = nil
  self.img_exp_img1 = nil
  self.img_exp_img = nil
  self.go_CampFirstBtnGo = nil
  self.btn_RecommendBtn = nil
  self.btn_CancelRecommendBtn = nil
  self.txt_cdText = nil
end

function CampScienceDonateInfo:OnAddListener()
  self:AddUIListener(EventId.UpdateCampRecommendScience, self.UpdateCampRecommendScienceHandle)
  self:AddUIListener(EventId.UpdateSelfCampScienceInfo, self.UpdateUpdateSelfCampScienceInfo)
end

function CampScienceDonateInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateCampRecommendScience, self.UpdateCampRecommendScienceHandle)
  self:RemoveUIListener(EventId.UpdateSelfCampScienceInfo, self.UpdateUpdateSelfCampScienceInfo)
end

function CampScienceDonateInfo:RefreshData(data)
  self.scienceData = data
  if self.scienceData == nil then
    return
  end
  local militaryItemId = DataCenter.SeasonMilitaryManager:GetMilitaryItemId()
  self.btn_donate_img:LoadSpriteAuto(DataCenter.ItemTemplateManager:GetIconPath(militaryItemId))
  local group = DataCenter.CampScienceDataManager:GetCampScienceGroupTemplate()
  self.img_exp_img:LoadSprite(group.icon)
  self.img_exp_img1:LoadSprite(group.icon)
  local isMax = self.scienceData.maxLevel == self.scienceData.curLevel
  self.img_exp_img1:SetActive(not isMax)
  self:UpdateCampRecommendScienceHandle()
  if not isMax then
    self.bgImgN:SetAlpha(1)
    self.techPoint_slider:SetActive(true)
    self.btnGo:SetActive(true)
    local currentPro = self.scienceData.currentPro
    local needPro = self.scienceData.needPro
    if currentPro > needPro then
      currentPro = needPro
    end
    local pro = currentPro / needPro
    if self.scienceData:GetIsOO() then
      self.techPoint_slider:SetValue(1)
      self.techPoint_slider_text:SetLocalText("season_camp_science_ui_25")
    else
      self.techPoint_slider:SetValue(math.min(1, pro))
      self.techPoint_slider_text:SetText(string.GetFormattedStr(currentPro) .. "/" .. string.GetFormattedStr(needPro))
    end
    local selfCampScienceData = DataCenter.CampScienceDataManager:GetSelfCampScienceInfo()
    local canDonate = selfCampScienceData:CanDonate()
    self.txt_cdText:SetActive(false)
    if selfCampScienceData.num == 0 or not canDonate then
      self.resBtnRedN:SetActive(false)
      self.isUpgradeBtnGray = true
      CS.UIGray.SetGray(self.btn_resBtn.transform, true, false)
      self.resNum:SetLocalText(454107)
      local curServerTime = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = selfCampScienceData.timePoint + selfCampScienceData:GetRefreshTime() - curServerTime
      self.txt_cdText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      self.txt_cdText:SetActive(true)
    else
      self.isUpgradeBtnGray = false
      CS.UIGray.SetGray(self.btn_resBtn.transform, false, true)
      self.resNum:SetLocalText(141114, selfCampScienceData.num .. "/" .. selfCampScienceData:GetAllDonateCount())
      self.resBtnRedN:SetActive(selfCampScienceData.num >= selfCampScienceData:GetAllDonateCount() / 2)
    end
    self.techPoint_slider:SetActive(true)
  else
    self.techPoint_slider:SetActive(false)
    self.btnGo:SetActive(false)
  end
  if SeasonUtil.GetSeason() == 6 then
    self.donate_txt:SetActive(false)
    self.exp_txt:SetActive(false)
    self.btn_donate_img:SetAnchoredPositionXY(294, 0)
    self.img_exp_img:SetAnchoredPositionXY(231, 3)
  else
    self.donate_txt:SetActive(true)
    self.exp_txt:SetActive(true)
    self.btn_donate_img:SetAnchoredPositionXY(243, 0)
    self.img_exp_img:SetAnchoredPositionXY(119, 3)
  end
end

function CampScienceDonateInfo:OnShowDonateTip()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.btn_donate_img.transform.position + Vector3.New(-20, 0, 0) * scaleFactor
  local strContent = Localization:GetString("season_military_merit_goods_desc")
  local goods = DataCenter.SeasonMilitaryManager:GetMilitaryItemId()
  if goods ~= 0 then
    strContent = DataCenter.ItemTemplateManager:GetDes(goods)
  end
  local param = UIHeroTipView.Param.New()
  param.title = nil
  param.content = strContent
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function CampScienceDonateInfo:ClickRes()
  local logic = CampScienceDonateFishLogic.New(self.scienceData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonDonateFish, {anim = true}, logic)
  self.holder.view.ctrl:CloseSelf()
end

function CampScienceDonateInfo:OnChanceRecommendStateClick(state)
  SFSNetwork.SendMessage(MsgDefines.CampScienceRecommend, self.scienceData.scienceId, state == 0)
end

function CampScienceDonateInfo:UpdateCampRecommendScienceHandle()
  local isFirstCampAllianceMaster = DataCenter.CampScienceDataManager:IsFirstCampAllianceR5()
  local canShowRecommend = self.scienceData.maxLevel ~= self.scienceData.curLevel and isFirstCampAllianceMaster
  self.go_CampFirstBtnGo:SetActive(canShowRecommend)
  if canShowRecommend then
    local alreadyRecommend = DataCenter.CampScienceDataManager:GetRecommendScienceId() == self.scienceData.scienceId
    self.btn_CancelRecommendBtn:SetActive(alreadyRecommend)
    self.btn_RecommendBtn:SetActive(not alreadyRecommend)
  end
end

function CampScienceDonateInfo:UpdateUpdateSelfCampScienceInfo()
  self.recoverReqPending = nil
end

function CampScienceDonateInfo:Update1000MS()
  local selfCampScienceData = DataCenter.CampScienceDataManager:GetSelfCampScienceInfo()
  local curServerTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = selfCampScienceData.timePoint + selfCampScienceData:GetRefreshTime() - curServerTime
  local canDonate = selfCampScienceData:CanDonate()
  if selfCampScienceData.num == 0 or not canDonate then
    self.txt_cdText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    if not self.recoverReqPending and deltaTime <= -1000 then
      SFSNetwork.SendMessage(MsgDefines.CampScienceView)
      self.recoverReqPending = true
    end
  end
end

return CampScienceDonateInfo
