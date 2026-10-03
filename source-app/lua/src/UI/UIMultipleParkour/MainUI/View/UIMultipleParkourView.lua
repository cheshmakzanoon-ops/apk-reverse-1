local UIMultipleParkourView = BaseClass("UIMultipleParkourView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RankItem = require("UI.UIMultipleParkour.MainUI.Component.UIMultipleParkourRankItem")
local compBook = {
  {
    path = "SafeArea/BackBtn",
    name = "btnBack",
    type = UIButton
  },
  {
    path = "SafeArea/roomId",
    name = "roomId",
    type = UITextMeshProUGUIEx
  },
  {
    path = "SafeArea/readyTipContent",
    name = "readyTipContent",
    type = UIBaseContainer
  },
  {
    path = "SafeArea/readyTipContent/readyBg",
    name = "readyBg",
    type = UIBaseContainer
  },
  {
    path = "SafeArea/readyTipContent/readyBg/readyTxt",
    name = "readyTxt",
    type = UITextMeshProUGUIEx
  },
  {
    path = "SafeArea/readyTipContent/readyTitle",
    name = "readyTitle",
    type = UITextMeshProUGUIEx
  },
  {
    path = "SafeArea/readyTipContent/readyValue",
    name = "readyValue",
    type = UITextMeshProUGUIEx
  },
  {
    path = "SafeArea/readyTipContent/topScore",
    name = "topScore",
    type = UITextMeshProUGUIEx
  },
  {
    path = "SafeArea/marchTimerBg/marchTimerTxt",
    name = "marchTimerTxt",
    type = UITextMeshProUGUIEx
  },
  {
    path = "SafeArea/marchTimerBg",
    name = "marchTimerBg",
    type = UIBaseContainer
  },
  {
    path = "BossComing",
    name = "bossComing",
    type = UIBaseContainer
  },
  {
    path = "SafeArea/rankBg/rankTitle",
    name = "rankTitle",
    type = UITextMeshProUGUIEx
  },
  {
    path = "SafeArea/rankBg",
    name = "rankBg",
    type = UIBaseContainer
  }
}
local level_content_path = "SafeArea/levelContent"
local level_txt_path = "SafeArea/levelContent/levelTxt"
local level_title_path = "SafeArea/levelContent/levelTitle"
local rt_level_content_path = "SafeArea/rtLevelContent"
local rt_level_title_path = "SafeArea/rtLevelContent/rtLevelTitle"
local rt_level_path = "SafeArea/rtLevelContent/rtLevel"
local BossNoticeCD = 5
local RankCount = 4

function UIMultipleParkourView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIMultipleParkourView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MultipleParkourReadyChanged, self.OnMultipleParkourReadyChanged)
  self:AddUIListener(EventId.MultipleParkourMarchSubStageChanged, self.OnMultipleParkourMarchSubStageChanged)
  self:AddUIListener(EventId.MultipleParkourBossEnter, self.OnBossEnter)
  self:AddUIListener(EventId.MultipleParkourRankChanged, self.OnRankChanged)
  self:AddUIListener(EventId.MultipleParkourLevelChanged, self.OnLevelChanged)
  self:AddUIListener(EventId.MultipleParkourDoorPassed, self.OnDoorPassed)
end

function UIMultipleParkourView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MultipleParkourReadyChanged, self.OnMultipleParkourReadyChanged)
  self:RemoveUIListener(EventId.MultipleParkourMarchSubStageChanged, self.OnMultipleParkourMarchSubStageChanged)
  self:RemoveUIListener(EventId.MultipleParkourBossEnter, self.OnBossEnter)
  self:RemoveUIListener(EventId.MultipleParkourRankChanged, self.OnRankChanged)
  self:RemoveUIListener(EventId.MultipleParkourLevelChanged, self.OnLevelChanged)
  self:RemoveUIListener(EventId.MultipleParkourDoorPassed, self.OnDoorPassed)
end

function UIMultipleParkourView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.level_content = self:AddComponent(UIBaseContainer, level_content_path)
  self.level_txt = self:AddComponent(UITextMeshProUGUIEx, level_txt_path)
  self.level_title = self:AddComponent(UITextMeshProUGUIEx, level_title_path)
  self.rt_level_content = self:AddComponent(UIBaseContainer, rt_level_content_path)
  self.rt_level_title = self:AddComponent(UITextMeshProUGUIEx, rt_level_title_path)
  self.rt_level = self:AddComponent(UITextMeshProUGUIEx, rt_level_path)
  self.level_content:SetActive(false)
  self.rt_level_content:SetActive(false)
  self.level_title:SetText(Localization:GetString("multiply_door_tips_001"))
  self.rt_level_title:SetText(Localization:GetString("multiply_door_tips_001"))
  self.rankItem = self.transform:Find("SafeArea/rankItem").gameObject
  self.rankItem:GameObjectCreatePool()
  self.btnBack:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.readyTitle:SetText(Localization:GetString("dev_multiple_stage_04"))
  self.readyValue:SetText(Localization:GetString(372617))
  self:RefreshRoomId()
  self.readyTipContent:SetActive(false)
  self.marchTimerTxt:SetText("")
  self.marchTimerBg:SetActive(false)
  self.bossNotice = self:AddComponent(UIAnimator, "BossComing")
  self.bossNotice.gameObject:SetActive(false)
  self.bossNoticeText = self.bossComing:AddComponent(UITextMeshProUGUIEx, "Text_0")
  self.lastBossNoticeTime = 0
  self.bossNoticeText:SetLocalText("dev_multiple_stage_13")
  self.rankItemList = {}
  for i = 1, RankCount do
    local itemName = "item" .. i
    local go = self.rankItem:GameObjectSpawn(self.rankBg.transform)
    go.name = itemName
    go:SetActive(true)
    local ran = self.rankBg:AddComponent(RankItem, itemName)
    table.insert(self.rankItemList, ran)
  end
  self.rankBg:SetActive(false)
  self.rankTitle:SetText(Localization:GetString("dev_multiple_stage_23"))
  self.animator = self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
  if self.animator then
    self.animator.enabled = false
  end
end

function UIMultipleParkourView:RefreshRoomId()
  if CS.CommonUtils.IsDebug() then
    self.roomId:SetText(DataCenter.MultipleParkourManager.roomId or "")
  else
    self.roomId:SetText("")
  end
end

function UIMultipleParkourView:DataDefine()
end

function UIMultipleParkourView:ComponentDestroy()
  self.rankBg:RemoveComponents(RankItem)
  self.rankItem:GameObjectRecycleAll()
  self:ClearCompsByBook(compBook)
  self.level_content = nil
  self.level_txt = nil
  self.level_title = nil
  self.rt_level_content = nil
  self.rt_level_title = nil
  self.rt_level = nil
end

function UIMultipleParkourView:DataDestroy()
  if self.levelChangeTimer then
    self.levelChangeTimer:Stop()
    self.levelChangeTimer = nil
  end
  self.levelChangeTimerFunc = nil
end

function UIMultipleParkourView:ReInit()
  local isEndless = DataCenter.MultipleParkourManager:IsEndless()
  if isEndless then
    self.topScore:SetText("")
    self.rt_level_content:SetActive(true)
    self.rt_level:SetText("1")
  else
    local score = DataCenter.MultipleParkourManager:GetTopScore()
    self.topScore:SetText(Localization:GetString("dev_multiple_stage_07", score))
  end
  self:CheckReady()
end

function UIMultipleParkourView:CheckReady()
  local ready = DataCenter.MultipleParkourManager:GetReadyTimer()
  if 0 < ready then
    self.readyTxt:SetText(ready)
    self.readyTipContent:SetActive(true)
  else
    self.readyTipContent:SetActive(false)
  end
end

function UIMultipleParkourView:OnMultipleParkourReadyChanged()
  self:CheckReady()
end

function UIMultipleParkourView:OnMultipleParkourMarchSubStageChanged()
  local timer = DataCenter.MultipleParkourManager:GetMarchSubStateTimer()
  if 0 < timer then
    self.marchTimerTxt:SetText(timer)
    self.marchTimerBg:SetActive(true)
  else
    self.marchTimerBg:SetActive(false)
  end
end

function UIMultipleParkourView:OnBossEnter()
  local time = Time.realtimeSinceStartup
  if time - self.lastBossNoticeTime < BossNoticeCD then
    return
  end
  self.lastBossNoticeTime = time
  self.bossNotice.gameObject:SetActive(false)
  self.bossNotice.gameObject:SetActive(true)
  self.bossNoticeText:SetLocalText(800328)
end

function UIMultipleParkourView:OnLevelChanged()
  local isEndless = DataCenter.MultipleParkourManager:IsEndless()
  if not isEndless then
    return
  end
  local level = DataCenter.MultipleParkourManager.runningTotalLevel or 1
  self.rt_level:SetText(level)
  if self.levelChangeTimer then
    self.levelChangeTimer:Stop()
    self.levelChangeTimer = nil
  end
  if self.levelChangeTimerFunc == nil then
    function self.levelChangeTimerFunc()
      self:OnLevelChangeEnd()
    end
  end
  self.level_txt:SetText(level)
  self.level_content:SetActive(true)
  self.levelChangeTimer = TimerManager:GetInstance():DelayInvoke(self.levelChangeTimerFunc, 2)
  if self.animator then
    self.animator.enabled = false
    self.animator.enabled = true
    self.animator:Play("Eff_ui_UIMultiplelevelContent_Show", 0, 0)
  end
end

function UIMultipleParkourView:OnLevelChangeEnd()
  self.levelChangeTimer = nil
  self.level_content:SetActive(false)
end

function UIMultipleParkourView:OnDoorPassed()
  if CS.CommonUtils.IsDebug() then
    local right = DataCenter.MultipleParkourManager:GetRightOption()
    local cont = (DataCenter.MultipleParkourManager.roomId or "") .. [[
 


 ]] .. right
    self.roomId:SetText(cont)
  else
    self.roomId:SetText("")
  end
end

function UIMultipleParkourView:OnRankChanged()
  local players = DataCenter.MultipleParkourManager:GetAllPlayers()
  self.rankBg:SetActive(true)
  local hasSelf = false
  local showIndex = 0
  for i, v in ipairs(players) do
    if i <= 3 then
      if v.mySelf then
        hasSelf = true
      end
      self.rankItemList[i]:Refresh(i, v)
      showIndex = i
    else
      if hasSelf then
        break
      end
      if v.mySelf then
        showIndex = showIndex + 1
        self.rankItemList[showIndex]:Refresh(i, v)
        break
      end
    end
  end
  for i = showIndex + 1, RankCount do
    self.rankItemList[i]:SetActive(false)
  end
end

function UIMultipleParkourView:OnBackBtnClick()
  local message = Localization:GetString("dev_multiple_stage_20")
  UIUtil.ShowMessage(message, 2, "110106", "110006", function()
  end, function()
    self:Exit()
  end, nil, "100378")
end

function UIMultipleParkourView:Exit()
  DataCenter.MultipleParkourManager:TryExit()
end

return UIMultipleParkourView
