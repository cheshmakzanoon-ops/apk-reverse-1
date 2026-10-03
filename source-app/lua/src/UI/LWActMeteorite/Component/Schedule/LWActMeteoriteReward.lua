local base = UIBaseContainer
local LWActMeteoriteReward = BaseClass("LWActMeteoriteReward", base)
local LWActMeteoriteRewardItem = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteRewardItem")
local content_path = "ViewPort/Content"
local progress_bg_path = "ViewPort/Content/progressBg"
local progress_img_path = "ViewPort/Content/progressBg/progressImg"
local item_content_path = "ViewPort/Content/itemContent"
local base_path = "Base"
local change_text_path = "ChangeText"
local reward_item_path = "RewardItem"
local tip_btn_path = "TipText/TipBtn"

function LWActMeteoriteReward:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.progress_img = self:AddComponent(UIImage, progress_img_path)
  self.item_content = self:AddComponent(UIBaseContainer, item_content_path)
  self.base = self:AddComponent(UIBaseContainer, base_path)
  self.change_text = self:AddComponent(UITextMeshProUGUIEx, change_text_path)
  self.change_text:SetActive(false)
  self.reward_item = self.transform:Find(reward_item_path).gameObject
  self.reward_item:GameObjectCreatePool()
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteAward)
  end)
  self.boxes = {}
  self.paras = {}
  local baseW = 0
  local boxesConfig = DataCenter.ActMeteoriteBattleManager:GetRewardBoxes(1)
  local cnt = #boxesConfig
  self.maxCnt = cnt
  for i = 0, cnt do
    local target = i == 0 and self.base or self.item_content
    local goItem = self.reward_item:GameObjectSpawn(target.transform)
    goItem.name = "box" .. i
    local co = target:AddComponent(LWActMeteoriteRewardItem, goItem.name)
    co:SetActive(true)
    if i == 0 then
      co:InitConfig()
      self.boxBase = co
    else
      local config = boxesConfig[i]
      co:InitConfig(config, i)
      self.boxes[i] = co
      table.insert(self.paras, toInt(config.para))
    end
    if baseW == 0 then
      baseW = co:GetSizeDelta().x
    end
  end
  self.maxW = baseW * cnt
  self.progress_bg:SetSizeDeltaX(self.maxW)
end

function LWActMeteoriteReward:OnDestroy()
  if self.scoreDelay then
    self.scoreDelay:Stop()
  end
  self.scoreDelay = nil
  self.reward_item:GameObjectRecycleAll()
  for _, v in ipairs(self.boxes) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  if self.boxBase ~= nil then
    CS.UnityEngine.GameObject.Destroy(self.boxBase.gameObject)
  end
  self.content = nil
  self.progress_bg = nil
  self.progress_img = nil
  self.item_content = nil
  self.base = nil
  self.change_text = nil
  self.reward_item = nil
  self.tip_btn = nil
  self.boxes = {}
  self.boxBase = nil
  self.maxCnt = 0
  base.OnDestroy(self)
end

function LWActMeteoriteReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MeteoriteBattleScoreUpdate, self.SetData)
  self:AddUIListener(EventId.MeteoriteBattleRewardsRefresh, self.SetData)
end

function LWActMeteoriteReward:OnRemoveListener()
  self:RemoveUIListener(EventId.MeteoriteBattleScoreUpdate, self.SetData)
  self:RemoveUIListener(EventId.MeteoriteBattleRewardsRefresh, self.SetData)
  base.OnRemoveListener(self)
end

function LWActMeteoriteReward:SetData(addScore)
  for _, v in ipairs(self.boxes) do
    v:SetData()
  end
  local mgr = DataCenter.ActMeteoriteBattleManager
  local actInfo = mgr:GetActInfo() or {}
  local stage = actInfo.stage or nil
  self.updateFlag = stage == MeteoriteState.GRAB
  local score = actInfo.count or 0
  local firstP = 0.5
  local last = 0
  local percent = 0
  for i, v in ipairs(self.paras) do
    if v <= score then
      last = v
    else
      local tmpCnt
      if 1 < i then
        tmpCnt = i - 1 + (score - last) / (v - last) - firstP
      else
        tmpCnt = firstP * (score / v)
      end
      percent = tmpCnt / self.maxCnt
      break
    end
  end
  local l = #self.paras
  local maxP = (l - firstP) / l
  if last ~= 0 and percent == 0 then
    percent = maxP
  elseif maxP < percent then
    percent = maxP
  end
  self.progress_img:SetSizeDeltaX(self.maxW * percent)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip_btn.transform.parent)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.item_content.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  self:UpdateScore(addScore)
end

function LWActMeteoriteReward:UpdateScore(addScore)
  if self.boxBase then
    self.boxBase:UpdateScore()
  end
  if addScore and 0 < addScore then
    if self.scoreDelay then
      self.scoreDelay:Stop()
    end
    self.change_text:SetText("+" .. addScore)
    self.change_text:SetActive(true)
    self.scoreDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.change_text:SetActive(false)
      self.scoreDelay = nil
    end, 2)
  end
end

function LWActMeteoriteReward:Update1000MS()
  if not self.updateFlag then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastReqTime == nil or curTime - self.lastReqTime > 5000 then
    DataCenter.ActMeteoriteBattleManager:ReqScoreCount()
    self.lastReqTime = curTime
  end
end

return LWActMeteoriteReward
