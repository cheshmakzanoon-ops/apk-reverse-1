local base = UIAsyncContainer
local LLMainBattleScore = BaseClass("LLMainBattleScore", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ScoreBox = require("UI.Landlord.Main.Component.LLMainBattleScoreBox")
local RewardUtil = require("Util.RewardUtil")
local ActMgr = DataCenter.LandlordMgr

function LLMainBattleScore:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainBattleScore:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainBattleScore:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnScoreMore = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnScoreMore:SetOnClick(function()
    self:OnBtnScoreMoreClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgProgressBg = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgProgress = self.viewSkin:AddComponent(self, UIImage, 5)
  self.compItemContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.btnRewardMore = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnRewardMore:SetOnClick(function()
    self:OnBtnRewardMoreClick()
  end)
  self.compBase = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compItem = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textChange = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
end

function LLMainBattleScore:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.btnScoreMore = nil
  self.textTitle = nil
  self.imgProgressBg = nil
  self.imgProgress = nil
  self.compItemContent = nil
  self.btnRewardMore = nil
  self.compBase = nil
  self.compItem = nil
  self.textChange = nil
end

function LLMainBattleScore:DataDefine()
  self.compItem:SetActive(false)
  self.theItem = self.compItem.gameObject
  self.theItem:GameObjectCreatePool()
  self:InitNineBox()
end

function LLMainBattleScore:DataDestroy()
  if self.scoreDelay then
    self.scoreDelay:Stop()
  end
  self.scoreDelay = nil
  self.compBase:RemoveAllComponentes()
  self.compContent:RemoveAllComponentes()
  self.compItemContent:RemoveAllComponentes()
  if self.theItem then
    self.theItem:GameObjectRecycleAll()
    self.theItem = nil
  end
  self.boxes = nil
  self.boxBase = nil
  self.refreshCur = nil
end

function LLMainBattleScore:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordNineBoxRefresh, self.RefreshNineBox)
end

function LLMainBattleScore:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordNineBoxRefresh, self.RefreshNineBox)
  base.OnRemoveListener(self)
end

function LLMainBattleScore:OnBtnScoreMoreClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward)
end

function LLMainBattleScore:OnBtnRewardMoreClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLNineBox)
end

function LLMainBattleScore:RefreshCur(refreshCur)
  self.refreshCur = refreshCur
  self:SetActive(true)
  self:RefreshView()
end

function LLMainBattleScore:UpdateData()
  self.refreshCur = nil
  self:RefreshWeekReward()
  self:RefreshNineBox()
end

function LLMainBattleScore:RefreshWeekReward()
  local camp = ActMgr:GetMyGroup()
  local list = ActMgr:GetReward(LLConst.RewardType.Win, camp)
  local info = list[1]
  local rewardId = info ~= nil and info.reward or nil
  local value = info ~= nil and info.para ~= nil and info.para[1] or 0
  local bLord = camp == LLConst.LandLordGroup.LORD
  self.textTitle:SetLocalText(bLord and "zonewar_landlord_desc_1024" or "zonewar_landlord_desc_1022", value)
  local rewards = rewardId ~= nil and RewardUtil.GetRewardsById(rewardId) or {}
  self.rewardsReq = self.rewardsReq or {}
  local lReqs = #self.rewardsReq
  local lRewards = #rewards
  local cnt = math.min(math.max(lReqs, lRewards), 6)
  local scale = 0.7
  for i = 1, cnt do
    local idx = i
    local request = self.rewardsReq[idx]
    local reward = rewards[idx]
    local name = "Item_" .. i
    if reward ~= nil then
      if request == nil then
        request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
          if req == nil or IsNull(req.gameObject) then
            self.rewardsReq[idx] = nil
            return
          end
          local go = req.gameObject
          go.name = name
          go:SetActive(true)
          go.transform:SetParent(self.compContent.transform)
          go.transform:Reset()
          local comp = self.compContent:AddComponent(UICommonResItem, go.name)
          comp:SetSizeDeltaXY(COMMON_RES_ITEM_DEF_SIZE, COMMON_RES_ITEM_DEF_SIZE)
          comp:SetLocalScaleXYZ(scale, scale, scale)
          reward = rewards[idx]
          comp:SetActive(reward ~= nil)
          if reward ~= nil then
            comp:ReInit(reward)
          end
        end)
        self.rewardsReq[idx] = request
      elseif request.isDone then
        local comp = self.compContent:GetComponent(name, UICommonResItem)
        comp:SetActive(true)
        comp:ReInit(reward)
      end
    elseif request ~= nil and request.isDone then
      do
        local comp = self.compContent:GetComponent(name, UICommonResItem)
        if comp then
          comp:SetActive(false)
        end
      end
    end
  end
end

function LLMainBattleScore:InitNineBox()
  local boxList = ActMgr:GetNieBoxConfig()
  self.boxes = {}
  self.paras = {}
  local baseW = 0
  local cnt = #boxList
  self.maxCnt = cnt
  for i = 0, cnt do
    local target = i == 0 and self.compBase or self.compItemContent
    local goItem = self.theItem:GameObjectSpawn(target.transform)
    goItem.name = "box" .. i
    local co = target:AddComponent(ScoreBox, goItem.name)
    co:SetActive(true)
    if i == 0 then
      co:SetAnchorMinXY(0.5, 0.5)
      co:SetAnchorMaxXY(0.5, 0.5)
      co:SetAnchoredPositionXY(0, 0)
      co:InitConfig()
      self.boxBase = co
    else
      local config = boxList[i]
      co:InitConfig(config, i)
      self.boxes[i] = co
      table.insert(self.paras, toInt(config.target))
    end
    if baseW == 0 then
      baseW = co:GetSizeDelta().x
    end
  end
  self.maxW = baseW * cnt
  self.imgProgressBg:SetSizeDeltaX(self.maxW)
end

function LLMainBattleScore:RefreshNineBox()
  if self.boxes then
    for _, v in ipairs(self.boxes) do
      v:SetData()
    end
  end
  local score = ActMgr:GetNineBoxScore()
  local firstP = 0.25
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
  self.imgProgress:SetSizeDeltaX(self.maxW * percent)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compItemContent.transform)
  self:UpdateScore()
end

function LLMainBattleScore:UpdateScore(addScore)
  if self.boxBase then
    self.boxBase:UpdateScore()
  end
  if addScore and 0 < addScore then
    if self.scoreDelay then
      self.scoreDelay:Stop()
    end
    self.textChange:SetText("+" .. addScore)
    self.textChange:SetActive(true)
    self.scoreDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.textChange:SetActive(false)
      self.scoreDelay = nil
    end, 2)
  end
end

return LLMainBattleScore
