local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWUIBerserkBossMain = BaseClass("LWUIBerserkBossMain", base)
local Localization = CS.GameEntry.Localization
local LWUIBerserkBossItemRender = require("UI.UIActivityCenterTable.Component.LWUIBerserkBoss.LWUIBerserkBossItemRender")
local infoBtn_path = "TopContent/InfoBtn"
local titleText_path = "TopContent/TitleText"
local timeText_path = "TopContent/TimeText"
local rewardBtn_path = "BottomContent/BossInfoContent/RewardBtn"
local bossDesText_path = "BottomContent/BossInfoContent/BossDesText"
local hpProgress_path = "BottomContent/BossInfoContent/HpProgress"
local hpProgressValueText_path = "BottomContent/BossInfoContent/HpProgressValueText"
local rankIcon_path = "TopContent/RankContent/RankIcon"
local rankText_path = "TopContent/RankContent/RankText"
local rankTipsText_path = "TopContent/RankContent/RankTipsText"
local curDamageText_path = "TopContent/RankContent/DamageDetailContent/CurDamageContent/CurDamageText"
local curDamageValueText_path = "TopContent/RankContent/DamageDetailContent/CurDamageContent/CurDamageValueText"
local targetDamageText_path = "TopContent/RankContent/DamageDetailContent/TargetDamageContent/TargetDamageText"
local targetDamageValueText_path = "TopContent/RankContent/DamageDetailContent/TargetDamageContent/TargetDamageValueText"
local berserkBossContent_path = "BottomContent/BerserkBossContent"
local berserkBossItemRender_path = "BottomContent/BerserkBossItemRender"
local gotoBtn_path = "BottomContent/GoToBtn"
local gotoBtnText_path = "BottomContent/GoToBtn/GoToBtnText"
local bossRawImage_path = "BgMask/BossRawImage"
local bossStateDesText_path = "BottomContent/BossStateDesText"
local rankBtn_path = "TopContent/RankContent/RankBtn"
local gotoBtnRedPoint_path = "BottomContent/GoToBtn/GoToBtnRedPoint"
local damageDetailContent_path = "TopContent/RankContent/DamageDetailContent"
local bgRawImage_path = "BgMask/BgRawImage"
local bgTopRawImage_path = "BgMask/BgTopRawImage"
local bgBottomRawImage_path = "BgMask/BgBottomRawImage"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveBerserkBossItem()
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
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.bossDesText = self:AddComponent(UIText, bossDesText_path)
  self.hpProgress = self:AddComponent(UISlider, hpProgress_path)
  self.hpProgressValueText = self:AddComponent(UIText, hpProgressValueText_path)
  self.rankIcon = self:AddComponent(UIImage, rankIcon_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.rankTipsText = self:AddComponent(UIText, rankTipsText_path)
  self.curDamageText = self:AddComponent(UIText, curDamageText_path)
  self.curDamageValueText = self:AddComponent(UIText, curDamageValueText_path)
  self.targetDamageText = self:AddComponent(UIText, targetDamageText_path)
  self.targetDamageValueText = self:AddComponent(UIText, targetDamageValueText_path)
  self.berserkBossContent = self:AddComponent(UIBaseContainer, berserkBossContent_path)
  self.berserkBossItemRender = self:AddComponent(UIBaseContainer, berserkBossItemRender_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.bossRawImage = self:AddComponent(UIRawImage, bossRawImage_path)
  self.bossStateDesText = self:AddComponent(UIText, bossStateDesText_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.gotoBtnRedPoint = self:AddComponent(UIBaseContainer, gotoBtnRedPoint_path)
  self.damageDetailContent = self:AddComponent(UIBaseContainer, damageDetailContent_path)
  self.bgRawImage = self:AddComponent(UIRawImage, bgRawImage_path)
  self.bgTopRawImage = self:AddComponent(UIRawImage, bgTopRawImage_path)
  self.bgBottomRawImage = self:AddComponent(UIRawImage, bgBottomRawImage_path)
  self.infoBtn:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.gotoBtn:SetOnClick(function()
    self:GoToBtnClick()
  end)
  self.rankBtn:SetOnClick(function()
    self:RankBtnClick()
  end)
  self.rankTipsText:SetLocalText("activity_berserkboss_title_03")
  self.curDamageText:SetLocalText("activity_berserkboss_title_04")
  self.gotoBtnText:SetLocalText("110003")
  self.berserkBossItem = self.transform:Find(berserkBossItemRender_path).gameObject
  self.berserkBossItem:GameObjectCreatePool()
  self.bgRawImage:LoadSpriteAuto("Assets/Main/TextureEx/UIActivityBg/UILWBerserkBoss/FX_wordboss_BG.png")
  self.bgTopRawImage:LoadSpriteAuto("Assets/Main/TextureEx/UIActivityBg/UILWBerserkBoss/FX_wordboss_bg_jianbianshang.png")
  self.bgBottomRawImage:LoadSpriteAuto("Assets/Main/TextureEx/UIActivityBg/UILWBerserkBoss/FX_wordboss_bg_jianbianxia.png")
end

local function ComponentDestroy(self)
  self.infoBtn = nil
  self.titleText = nil
  self.timeText = nil
  self.rewardBtn = nil
  self.bossDesText = nil
  self.hpProgress = nil
  self.hpProgressValueText = nil
  self.rankIcon = nil
  self.rankText = nil
  self.rankTipsText = nil
  self.curDamageText = nil
  self.curDamageValueText = nil
  self.targetDamageText = nil
  self.targetDamageValueText = nil
  self.berserkBossContent = nil
  self.berserkBossItemRender = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.bossRawImage = nil
  self.bossStateDesText = nil
  self.rankBtn = nil
  self.gotoBtnRedPoint = nil
  self.damageDetailContent = nil
  self.bgRawImage = nil
  self.bgTopRawImage = nil
  self.bgBottomRawImage = nil
end

local function DataDefine(self)
  self.curSelectBerserkBossInfo = nil
  self.allBerserkBossList = {}
  self.berserkBossItemList = {}
  self.isSendMsg = false
end

local function DataDestroy(self)
  self.curSelectBerserkBossInfo = nil
  self.allBerserkBossList = nil
  self.berserkBossItemList = nil
  self.isSendMsg = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetAllBerserkBossInfoData, self.OnGetAllBerserkBossInfoData)
  self:AddUIListener(EventId.UpdateBerserkBossRewardAndAttackTimesData, self.RefreshBossState)
  self:AddUIListener(EventId.UpdateSingleBerserkBossInfoData, self.OnUpdateSingleBerserkBossInfoData)
  self:AddUIListener(EventId.ChangeSelectBerserkBoss, self.OnItemRenderClick)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetAllBerserkBossInfoData, self.OnGetAllBerserkBossInfoData)
  self:RemoveUIListener(EventId.UpdateBerserkBossRewardAndAttackTimesData, self.RefreshBossState)
  self:RemoveUIListener(EventId.UpdateSingleBerserkBossInfoData, self.OnUpdateSingleBerserkBossInfoData)
  self:RemoveUIListener(EventId.ChangeSelectBerserkBoss, self.OnItemRenderClick)
  base.OnRemoveListener(self)
end

local function OnGetAllBerserkBossInfoData(self)
  self:RefreshBerserkBossShow()
end

local function OnUpdateSingleBerserkBossInfoData(self, uuid)
  self:RefreshCurSelectBerserkBossView()
end

local function Update1000MS(self)
  self:RefreshActivityTime()
  if self.curSelectBerserkBossInfo and self.bossStateDesText and self.curSelectBerserkBossInfo:IsComingSoon() then
    local surplusTime = self.curSelectBerserkBossInfo.endTime - UITimeManager:GetInstance():GetServerTime()
    if 0 < surplusTime then
      self.bossStateDesText:SetLocalText("activity_berserkboss_tips_01", UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    else
      self.bossStateDesText:SetLocalText("activity_berserkboss_tips_01", UITimeManager:GetInstance():MilliSecondToFmtString(0))
      if not self.isSendMsg then
        self.isSendMsg = true
        DataCenter.LWBerserkBossManager:RequestSingleBerserkBossInfo(self.curSelectBerserkBossInfo.uuid)
      end
    end
  end
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  DataCenter.LWBerserkBossManager:RequestAllBerserkBossInfo()
  self.titleText:SetLocalText("activity_berserkboss_title_01")
  self.activityDataInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not self.activityDataInfo then
    Logger.LogError(string.format("activityId %s not found data in DataCenter.ActivityListDataManager", self.activityId))
    return
  end
  self:RefreshActivityTime()
  self:RefreshBerserkBossShow()
end

local function RefreshActivityTime(self)
  if self.activityDataInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local surplusTime = self.activityDataInfo.endTime - curTime
    if 0 < surplusTime then
      self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    else
      self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    end
  end
end

local function RefreshBerserkBossShow(self)
  self:RemoveBerserkBossItem()
  self.berserkBossItemList = {}
  self.curSelectBerserkBossInfo = nil
  self.allBerserkBossList = DataCenter.LWBerserkBossManager:GetAllBerserkBossInfoList()
  local targetBossUuid = self:GetTargetBerserkBoss()
  for i = 1, table.count(self.allBerserkBossList) do
    local berserkBossInfo = self.allBerserkBossList[i]
    local obj = self.berserkBossItem:GameObjectSpawn(self.berserkBossContent.transform)
    obj.name = "item_" .. i
    obj:SetActive(true)
    local itemRender = self.berserkBossContent:AddComponent(LWUIBerserkBossItemRender, obj.name)
    local isSelect = false
    if string.IsNullOrEmpty(targetBossUuid) then
      isSelect = i == 1
    else
      isSelect = berserkBossInfo.uuid == targetBossUuid
    end
    if isSelect then
      self.curSelectBerserkBossInfo = berserkBossInfo
    end
    itemRender:InitData(i, berserkBossInfo, isSelect)
    table.insert(self.berserkBossItemList, itemRender)
  end
  self:RefreshCurSelectBerserkBossView()
end

local function GetTargetBerserkBoss(self)
  for i = 1, table.count(self.allBerserkBossList) do
    local berserkBossInfo = self.allBerserkBossList[i]
    if not DataCenter.LWBerserkBossManager:GetBerserkBossIsDead(berserkBossInfo.uuid) then
      return berserkBossInfo.uuid
    end
  end
  return ""
end

local function RefreshCurSelectBerserkBossView(self)
  if self.curSelectBerserkBossInfo then
    self:RefreshBossInfoView()
    self:RefreshBossState()
    self:RefreshSelfRankInfoView()
  end
end

local function RefreshBossInfoView(self)
  local activityBerserkBossTemplate = DataCenter.LWActivityBerserkBossTemplateManager:GetTemplate(self.curSelectBerserkBossInfo.bossId)
  if activityBerserkBossTemplate then
    local monsterName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), activityBerserkBossTemplate.monster, "name")
    self.bossDesText:SetText(Localization:GetString(monsterName) .. " Lv." .. tostring(activityBerserkBossTemplate.level))
    if not string.IsNullOrEmpty(activityBerserkBossTemplate.img) then
      self.bossRawImage:LoadSpriteAuto(activityBerserkBossTemplate.img)
    end
  end
  local progressValue = 0
  if 0 < self.curSelectBerserkBossInfo.maxHp then
    progressValue = self.curSelectBerserkBossInfo.curHp / self.curSelectBerserkBossInfo.maxHp
  end
  progressValue = Mathf.Clamp(progressValue, 0, 1)
  self.hpProgress:SetValue(progressValue)
  local progressStr = string.formatDecimal(progressValue * 100, 1)
  self.hpProgressValueText:SetText(string.format("%s/%s", self.curSelectBerserkBossInfo.curHp, self.curSelectBerserkBossInfo.maxHp) .. "  " .. progressStr .. "%")
end

local function RefreshBossState(self)
  if self.curSelectBerserkBossInfo then
    self.gotoBtn:SetActive(true)
    self.bossStateDesText:SetLocalPositionXYZ(0, -170, 0)
    if self.curSelectBerserkBossInfo:IsComingSoon() then
      local surplusTime = self.curSelectBerserkBossInfo.endTime - UITimeManager:GetInstance():GetServerTime()
      self.bossStateDesText:SetLocalText("activity_berserkboss_tips_01", UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
      self.gotoBtnRedPoint:SetActive(false)
    elseif self.curSelectBerserkBossInfo:IsAttacking() then
      local surplusTimes = DataCenter.LWBerserkBossManager:GetBerserkBossSurplusAttackTimes(self.curSelectBerserkBossInfo.uuid)
      self.bossStateDesText:SetLocalText("activity_berserkboss_tips_02", surplusTimes)
      self.gotoBtnRedPoint:SetActive(0 < surplusTimes)
    elseif DataCenter.LWBerserkBossManager:GetBerserkBossIsReceiveReward(self.curSelectBerserkBossInfo.uuid) then
      self.bossStateDesText:SetLocalText("activity_berserkboss_tips_03")
      self.gotoBtnRedPoint:SetActive(true)
    elseif DataCenter.LWBerserkBossManager:GetBerserkBossIsDead(self.curSelectBerserkBossInfo.uuid) then
      self.gotoBtn:SetActive(false)
      self.bossStateDesText:SetLocalPositionXYZ(0, -240, 0)
      self.bossStateDesText:SetLocalText("activity_berserkboss_tips_04")
    end
  end
end

local function RefreshSelfRankInfoView(self)
  local rankIconName = "FX_wordboss_huizhang0%s"
  if self.curSelectBerserkBossInfo.selfRank == 0 then
    self.rankText:SetLocalText("activity_berserkboss_desc_03")
    self.rankIcon:LoadSprite(string.format(LoadPath.UILWBerserkBoss, string.format(rankIconName, 4)))
  else
    self.rankText:SetText(self.curSelectBerserkBossInfo.selfRank)
    local iconNum = self.curSelectBerserkBossInfo.selfRank > 3 and 4 or self.curSelectBerserkBossInfo.selfRank
    self.rankIcon:LoadSprite(string.format(LoadPath.UILWBerserkBoss, string.format(rankIconName, iconNum)))
  end
  self.damageDetailContent:SetActive(0 < self.curSelectBerserkBossInfo.targetRank)
  if 0 < self.curSelectBerserkBossInfo.targetRank then
    self.curDamageValueText:SetText(string.GetFormattedStr2(self.curSelectBerserkBossInfo.selfDamage))
    self.targetDamageText:SetLocalText("activity_berserkboss_title_05", self.curSelectBerserkBossInfo.targetRank)
    self.targetDamageValueText:SetText(string.GetFormattedStr2(self.curSelectBerserkBossInfo.targetDamage))
  end
end

local function RemoveBerserkBossItem(self)
  self.berserkBossContent:RemoveComponents(LWUIBerserkBossItemRender)
  self.berserkBossItem:GameObjectRecycleAll()
end

local function OnItemRenderClick(self, berserkBossInfo)
  if not DataCenter.LWBerserkBossManager:GetBerserkBossIsDead(berserkBossInfo.uuid) then
    DataCenter.LWBerserkBossManager:RequestSingleBerserkBossInfo(berserkBossInfo.uuid)
  end
  self.curSelectBerserkBossInfo = berserkBossInfo
  self:RefreshCurSelectBerserkBossView()
end

local function GoToBtnClick(self)
  if self.curSelectBerserkBossInfo then
    DataCenter.LWBerserkBossManager:JumpToTargetBerserkBoss(self.curSelectBerserkBossInfo.startPos, self.curSelectBerserkBossInfo.uuid)
  end
end

local function RewardBtnClick(self)
  if self.curSelectBerserkBossInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBerserkBossReward, {anim = true}, self.activityId, self.curSelectBerserkBossInfo.uuid)
  end
end

local function RankBtnClick(self)
  if self.curSelectBerserkBossInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBerserkBossRank, {anim = true}, LWUIBerserkBossRankTabType.Boss, self.curSelectBerserkBossInfo.uuid)
  end
end

local function InfoBtnClick(self)
  local param = {}
  param.title = "302027"
  param.activityRulesStr = Localization:GetString("activity_berserkboss_desc_02")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

LWUIBerserkBossMain.OnCreate = OnCreate
LWUIBerserkBossMain.OnDestroy = OnDestroy
LWUIBerserkBossMain.OnEnable = OnEnable
LWUIBerserkBossMain.OnDisable = OnDisable
LWUIBerserkBossMain.ComponentDefine = ComponentDefine
LWUIBerserkBossMain.ComponentDestroy = ComponentDestroy
LWUIBerserkBossMain.DataDefine = DataDefine
LWUIBerserkBossMain.DataDestroy = DataDestroy
LWUIBerserkBossMain.Update1000MS = Update1000MS
LWUIBerserkBossMain.OnAddListener = OnAddListener
LWUIBerserkBossMain.OnRemoveListener = OnRemoveListener
LWUIBerserkBossMain.OnGetAllBerserkBossInfoData = OnGetAllBerserkBossInfoData
LWUIBerserkBossMain.OnUpdateSingleBerserkBossInfoData = OnUpdateSingleBerserkBossInfoData
LWUIBerserkBossMain.SetData = SetData
LWUIBerserkBossMain.RefreshActivityTime = RefreshActivityTime
LWUIBerserkBossMain.RefreshBerserkBossShow = RefreshBerserkBossShow
LWUIBerserkBossMain.GetTargetBerserkBoss = GetTargetBerserkBoss
LWUIBerserkBossMain.RefreshCurSelectBerserkBossView = RefreshCurSelectBerserkBossView
LWUIBerserkBossMain.RemoveBerserkBossItem = RemoveBerserkBossItem
LWUIBerserkBossMain.OnItemRenderClick = OnItemRenderClick
LWUIBerserkBossMain.RefreshSelfRankInfoView = RefreshSelfRankInfoView
LWUIBerserkBossMain.RefreshBossInfoView = RefreshBossInfoView
LWUIBerserkBossMain.RefreshBossState = RefreshBossState
LWUIBerserkBossMain.InfoBtnClick = InfoBtnClick
LWUIBerserkBossMain.RewardBtnClick = RewardBtnClick
LWUIBerserkBossMain.GoToBtnClick = GoToBtnClick
LWUIBerserkBossMain.RankBtnClick = RankBtnClick
return LWUIBerserkBossMain
