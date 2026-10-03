local UIMainTroops = BaseClass("UIMainTroops", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local march_troop_num_txt_path = "MarchQueueContent/headObj/BgBtn1/troopNum1"
local detect_troop_num_txt_path = "DetectQueueContent/headObj/BgBtn2/troopNum2"
local march_txt_path = "MarchQueueContent/headObj/BgBtn1/MarchText"
local detect_txt_path = "DetectQueueContent/headObj/BgBtn2/DetectText"
local open_btn1_path = "MarchQueueContent/headObj/BgBtn1"
local open_btn2_path = "DetectQueueContent/headObj/BgBtn2"
local open_img1_path = "MarchQueueContent/headObj/BgBtn1/openBtn1"
local open_img2_path = "DetectQueueContent/headObj/BgBtn2/openBtn2"
local reward_obj_path = "MarchQueueContent/headObj/RewardBag"
local red_dot_path = "MarchQueueContent/headObj/RewardBag/Img/RedDot"
local reward_num_path = "MarchQueueContent/headObj/RewardBag/Img/RedDot/num"
local detect_obj_path = "DetectQueueContent/headObj/InfoLayout/DetectBag"
local detect_num_path = "DetectQueueContent/headObj/InfoLayout/DetectBag/Img/RedDot/num_detect"
local bank_obj_path = "DetectQueueContent/headObj/InfoLayout/BankBag"
local bank_num_path = "DetectQueueContent/headObj/InfoLayout/BankBag/Img/RedDot/num_bank"
local march_queue_content_path = "MarchQueueContent"
local detect_queue_content_path = "DetectQueueContent"
local special_tip_path = "MarchQueueContent/headObj/RewardBag/SpecialTip"
local special_tip_icon_path = "MarchQueueContent/headObj/RewardBag/SpecialTip/SpecialTipIcon"
local ShowRewardType = {
  None = 0,
  LandLock = 1,
  Monster = 2,
  MonsterLock = 3,
  SpecialTip = 999
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.march_troop_num_txt = self:AddComponent(UIText, march_troop_num_txt_path)
  self.detect_troop_num_txt = self:AddComponent(UIText, detect_troop_num_txt_path)
  self.march_txt = self:AddComponent(UIText, march_txt_path)
  self.detect_txt = self:AddComponent(UIText, detect_txt_path)
  self.march_txt:SetText(Localization:GetString(457590))
  self.detect_txt:SetText(Localization:GetString(457591))
  self.reward_obj = self:AddComponent(UIButton, reward_obj_path)
  self.reward_obj:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickReward()
  end)
  self.redDotObj = self:AddComponent(UIBaseComponent, red_dot_path)
  self.reward_num = self:AddComponent(UIText, reward_num_path)
  self.detect_obj = self:AddComponent(UIButton, detect_obj_path)
  self.detect_obj:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickDetectReward()
  end)
  self.detect_num = self:AddComponent(UIText, detect_num_path)
  self.bank_obj = self:AddComponent(UIButton, bank_obj_path)
  self.bank_obj:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankReport)
  end)
  self.bank_num = self:AddComponent(UIText, bank_num_path)
  self.open_btn1 = self:AddComponent(UIButton, open_btn1_path)
  self.open_btn2 = self:AddComponent(UIButton, open_btn2_path)
  self.open_img1 = self:AddComponent(UIBaseContainer, open_img1_path)
  self.open_img2 = self:AddComponent(UIBaseContainer, open_img2_path)
  self.march_queue_content = self:AddComponent(UIBaseContainer, march_queue_content_path)
  self.detect_queue_content = self:AddComponent(UIBaseContainer, detect_queue_content_path)
  self.open_btn1:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickOpenOrCloseBtn(1)
  end)
  self.open_btn2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickOpenOrCloseBtn(2)
  end)
  self.specialTipObj = self:AddComponent(UIBaseContainer, special_tip_path)
  self.specialTipIconImg = self:AddComponent(UIImage, special_tip_icon_path)
  if self.specialTipIconImg and not IsNull(self.specialTipIconImg.transform) then
    self.specialTipIconImg.transform:Set_localScale(1.5, 1.5, 1.5)
  end
  self.timer = nil
  self:RefreshReward()
  self:CheckShowDetectResult()
  self:CheckShowBankReport()
  self.isMarchListOpen = false
  self.isDetectListOpen = false
  self.isDetectListActive = false
  self.isMarchListActive = false
  self:SetBtnState()
end

local function ComponentDestroy(self)
  self:DeleteTimer()
  self.timer_action = nil
  self.march_troop_num_txt = nil
  self.detect_troop_num_txt = nil
  self.march_txt = nil
  self.detect_txt = nil
  self.open_btn1 = nil
  self.open_btn2 = nil
  self.open_img1 = nil
  self.open_img2 = nil
  self.reward_obj = nil
  self.detect_obj = nil
  self.reward_num = nil
  self.detect_num = nil
  self.bank_obj = nil
  self.bank_num = nil
  self.redDotObj = nil
  self.specialTipObj = nil
  self.specialTipIconImg = nil
end

local function DataDefine(self)
  self.showTipsDeltaTime = 0
  self.curList = {}
  self.inBattleList = {}
  self.curShowUuid = 0
  self.currentHead = nil
  self.detectCount = 0
end

local function DataDestroy(self)
  self.showTipsDeltaTime = nil
  self.curList = nil
  self.inBattleList = nil
  self.curShowUuid = nil
  self.currentHead = nil
  self.detectCount = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.AddCurMarchList)
  self:AddUIListener(EventId.ArmyFormatUpdate, self.AddCurMarchList)
  self:AddUIListener(EventId.ShowTroopAction, self.ShowTroopAction)
  self:AddUIListener(EventId.HideTroopAction, self.HideTroopAction)
  self:AddUIListener(EventId.RefreshMonsterRewardBag, self.RefreshReward)
  self:AddUIListener(EventId.OnEnterCrossServer, self.RefreshReward)
  self:AddUIListener(EventId.OnQuitCrossServer, self.RefreshReward)
  self:AddUIListener(EventId.MarchBtnStateChange, self.SetMarchBtnState)
  self:AddUIListener(EventId.DetectBtnStateChange, self.SetDetectBtnState)
  self:AddUIListener(EventId.DetectResultDataUpdate, self.OnDetectResultDataUpdate)
  self:AddUIListener(EventId.BankReportDataUpdate, self.OnBankReportDataUpdate)
  self:AddUIListener(EventId.CollectRewardDataUpdate, self.OnCollectRewardData)
  self:AddUIListener(EventId.FlowerTrainSelfDataUpdate, self.RefreshReward)
  self:AddUIListener(EventId.FlowerTrainGetFinishReward, self.RefreshReward)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.AddCurMarchList)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, self.AddCurMarchList)
  self:RemoveUIListener(EventId.ShowTroopAction, self.ShowTroopAction)
  self:RemoveUIListener(EventId.HideTroopAction, self.HideTroopAction)
  self:RemoveUIListener(EventId.RefreshMonsterRewardBag, self.RefreshReward)
  self:RemoveUIListener(EventId.OnEnterCrossServer, self.RefreshReward)
  self:RemoveUIListener(EventId.OnQuitCrossServer, self.RefreshReward)
  self:RemoveUIListener(EventId.MarchBtnStateChange, self.SetMarchBtnState)
  self:RemoveUIListener(EventId.DetectBtnStateChange, self.SetDetectBtnState)
  self:RemoveUIListener(EventId.DetectResultDataUpdate, self.OnDetectResultDataUpdate)
  self:RemoveUIListener(EventId.BankReportDataUpdate, self.OnBankReportDataUpdate)
  self:RemoveUIListener(EventId.CollectRewardDataUpdate, self.OnCollectRewardData)
  self:RemoveUIListener(EventId.FlowerTrainSelfDataUpdate, self.RefreshReward)
  self:RemoveUIListener(EventId.FlowerTrainGetFinishReward, self.RefreshReward)
end

local function SetMarchBtnState(self, isMarchListOpen)
  if BattleFieldUtil.InBattleField() then
    isMarchListOpen = true
  end
  self.isMarchListOpen = isMarchListOpen
  self.isMarchListActive = isMarchListOpen
  self.march_queue_content:SetActive(self.isMarchListActive)
  self:SetBtnState()
end

local function SetDetectBtnState(self, isDetectListActive)
  if BattleFieldUtil.InBattleField() then
    isDetectListActive = true
  end
  self.isDetectListActive = isDetectListActive
  self.detect_queue_content:SetActive(self.isDetectListActive)
  if self.isDetectListActive == false then
    self.isDetectListOpen = false
  end
end

local function ShowTroopAction(self)
  self:AddCurMarchList()
end

local function HideTroopAction(self)
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshTime(self)
end

local function MarchBackHome(self, marchUuid)
end

local function AddCurMarchList(self)
  local march = self.view.ctrl:GetAllMarch()
  local troopNum = DataCenter.ArmyFormationDataManager:GetAlreadySetCountInArmyFormation()
  local scoutNum = 0
  for k, v in pairs(march) do
    if v:IsScoutMarch() then
      scoutNum = scoutNum + 1
    end
  end
  local allInvesFormations = self.view.ctrl:GetAllScoutFormations()
  local scoutFormationNum = allInvesFormations and #allInvesFormations or 0
  self.detect_troop_num_txt:SetText(scoutNum .. "/" .. scoutFormationNum)
  local list = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
  local marchFormationNum = list and #list or 0
  self.march_troop_num_txt:SetText(troopNum .. "/" .. marchFormationNum)
end

local function StartShowTip(self)
end

local function OnClickOpenOrCloseBtn(self, btnIndex)
  if btnIndex == 1 then
    self.isMarchListOpen = not self.isMarchListOpen
    self.view:SetTroopListShow(self.isMarchListOpen, btnIndex)
  elseif btnIndex == 2 then
    self.isDetectListOpen = not self.isDetectListOpen
    self.view:SetTroopListShow(self.isDetectListOpen, btnIndex)
  end
  self:SetBtnState()
end

local function OnClickReward(self)
  if self.rewardPointId ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICollectReward, {anim = true})
  end
end

local function OnClickDetectReward(self)
  if DataCenter.DetectResultDataManager:IsDataEmptyOrUnavailable() then
    UIUtil.ShowTipsId("season_oasis_UI_4")
    DataCenter.DetectResultDataManager:ClearAllNewScoutData()
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectReward, {anim = true})
end

local function SetBtnState(self)
  if self.isMarchListOpen then
    self.open_img1.transform:DOLocalRotate(Vector3(0, 0, 90), 0.5)
  else
    self.open_img1.transform:DOLocalRotate(Vector3(0, 0, 0), 0.5)
  end
  if self.isDetectListOpen then
    self.open_img2.transform:DOLocalRotate(Vector3(0, 0, 90), 0.5)
  else
    self.open_img2.transform:DOLocalRotate(Vector3(0, 0, 0), 0.5)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.detectCount = DataCenter.DetectResultDataManager:GetUnreadCountNoRepeat()
  self:CheckShowDetectResult()
  self.bankCount = DataCenter.SeasonBankReportManager:GetUnreadCountNoRepeat()
  self:CheckShowBankReport()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self:AddCurMarchList()
end

local function CheckShowReward(self, show)
  if show then
    if self.showRewardType ~= ShowRewardType.None then
      self.reward_obj:SetActive(true)
      if self.showRewardType == ShowRewardType.SpecialTip then
        self.redDotObj:SetActive(false)
        self.specialTipObj:SetActive(true)
        if self.specialTipIconPath and self.specialTipIconPath ~= nil then
          self.specialTipIconImg:LoadSpriteAsyncWithCallback(self.specialTipIconPath, function()
            self.specialTipIconImg:SetNativeSize()
          end)
        end
        self.specialTipObj:SetLocalScaleXYZ(CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1, 1, 1)
      else
        self.redDotObj:SetActive(true)
        self.reward_num:SetText(self.rewardCount)
        self.specialTipObj:SetActive(false)
      end
    else
      self.reward_obj:SetActive(false)
    end
  else
    self.rewardCount = 0
    self.rewardPointId = nil
    self.showRewardType = ShowRewardType.None
    self.reward_obj:SetActive(false)
    self.specialTipObj:SetActive(false)
  end
end

local function CheckShowDetectResult(self)
  self.detectCount = self.detectCount or 0
  self.detect_obj:SetActive(self.detectCount > 0)
  self.detect_num:SetText(self.detectCount > 99 and "99+" or self.detectCount)
end

local function CheckShowBankReport(self)
  self.bankCount = self.bankCount or 0
  self.bank_obj:SetActive(self.bankCount > 0)
  self.bank_num:SetText(self.bankCount > 99 and "99+" or self.bankCount)
end

local function RefreshReward(self, data)
  self.rewardCount = 0
  self.rewardPointId = nil
  self.showRewardType = ShowRewardType.None
  if self.showRewardType == ShowRewardType.None then
    local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
    if not table.IsNullOrEmpty(list) and UITimeManager:GetInstance():GetServerTime() <= list[1].expireTime then
      self.rewardPointId = list[1].pointId
      self.rewardCount = #list
      self.showRewardType = ShowRewardType.Monster
    end
  end
  if self.showRewardType == ShowRewardType.None then
    local cardBoxList = DataCenter.SeasonDataManager.cardBoxList
    if cardBoxList ~= nil and 0 < table.count(cardBoxList) then
      self.rewardPointId = 1
      self.rewardCount = ""
      self.showRewardType = ShowRewardType.Monster
    end
  end
  if self.showRewardType == ShowRewardType.None then
    local iconPath = self:CheckIsExistSpecialTipIcon()
    if iconPath then
      self.rewardPointId = 1
      self.specialTipIconPath = iconPath
      self.showRewardType = ShowRewardType.SpecialTip
    end
  end
  self:CheckShowReward(true)
end

function UIMainTroops:CheckIsExistSpecialTipIcon()
  local flowerTipIconPath = FlowerTrainUtils.GetNeedShowFlowerTrainBubbleIconPath()
  if flowerTipIconPath and not BattleFieldUtil.InBattleField() then
    return flowerTipIconPath
  end
  return nil
end

local function PlayCollectRewardFlyEff(self, rewards)
  for i, v in ipairs(rewards) do
    local rewardType = v.rewardType
    local itemId = v.itemId
    local pic = RewardUtil.GetPic(rewardType, itemId)
    if pic ~= "" and IsNumber(v.count) then
      UIUtil.DoFly(v.rewardType, math.min(v.count, 3), pic, self.reward_obj.transform.position, Vector3.New(0, 0, 0))
    end
  end
end

function UIMainTroops:OnCollectRewardData(info)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  if info.type == CollectRewardType.ICE_SUPPLIES then
    local mainWorldPos = SceneUtils.TileIndexToWorld(info.pointId, ForceChangeScene.World)
    local world = CS.SceneManager.World
    local mainScreenPos = world:WorldToScreenPoint(mainWorldPos)
    local pos = CS.GameEntry.UICamera:ScreenToWorldPoint(mainScreenPos)
    local effectPath = "Assets/_Art/Effect/prefab/ui/VFX_leida_trail.prefab"
    local startPos = pos
    local endPos = self.reward_obj.transform.position
    UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 1, nil, nil)
  end
end

function UIMainTroops:OnDetectResultDataUpdate(newDataCount)
  self.detectCount = newDataCount
  self:CheckShowDetectResult()
end

function UIMainTroops:OnBankReportDataUpdate(newDataCount)
  self.bankCount = newDataCount
  self:CheckShowBankReport()
end

UIMainTroops.OnDestroy = OnDestroy
UIMainTroops.OnCreate = OnCreate
UIMainTroops.AddTimer = AddTimer
UIMainTroops.StartShowTip = StartShowTip
UIMainTroops.ComponentDefine = ComponentDefine
UIMainTroops.DataDestroy = DataDestroy
UIMainTroops.ComponentDestroy = ComponentDestroy
UIMainTroops.DataDefine = DataDefine
UIMainTroops.AddCurMarchList = AddCurMarchList
UIMainTroops.OnEnable = OnEnable
UIMainTroops.OnDisable = OnDisable
UIMainTroops.OnClickOpenOrCloseBtn = OnClickOpenOrCloseBtn
UIMainTroops.OnClickReward = OnClickReward
UIMainTroops.OnClickDetectReward = OnClickDetectReward
UIMainTroops.MarchBackHome = MarchBackHome
UIMainTroops.RefreshTime = RefreshTime
UIMainTroops.DeleteTimer = DeleteTimer
UIMainTroops.ReInit = ReInit
UIMainTroops.OnAddListener = OnAddListener
UIMainTroops.OnRemoveListener = OnRemoveListener
UIMainTroops.ShowTroopAction = ShowTroopAction
UIMainTroops.HideTroopAction = HideTroopAction
UIMainTroops.CheckShowReward = CheckShowReward
UIMainTroops.CheckShowDetectResult = CheckShowDetectResult
UIMainTroops.CheckShowBankReport = CheckShowBankReport
UIMainTroops.RefreshReward = RefreshReward
UIMainTroops.PlayCollectRewardFlyEff = PlayCollectRewardFlyEff
UIMainTroops.SetBtnState = SetBtnState
UIMainTroops.SetMarchBtnState = SetMarchBtnState
UIMainTroops.SetDetectBtnState = SetDetectBtnState
return UIMainTroops
