local base = UIBaseView
local LWSeasonVirusResearchLevelUp = BaseClass("LWSeasonVirusResearchLevelUp", base)
local RewardUtil = require("Util.RewardUtil")
local btn_mask_path = "Content/btn_mask"
local img_slider_path = "Content/Top/ImgBg/img_slider"
local txt_level_path = "Content/Top/ImgBg/txt_level"
local txt_lastLevel_path = "Content/Bottom/txt_lastLevel"
local txt_newLevel_path = "Content/Bottom/txt_newLevel"
local go_content_path = "Content/Bottom/content"
local go_rewardItem_path = "Content/Bottom/content/rewardItem"
local sim_Content_path = "Content"
local go_ExtraBg_path = "Content/Bg/ExtraBg"

function LWSeasonVirusResearchLevelUp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.parent = self:GetUserData()
  self:RefreshView()
end

function LWSeasonVirusResearchLevelUp:OnDestroy()
  self:ComponentDestroy()
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
  end
  base.OnDestroy(self)
end

function LWSeasonVirusResearchLevelUp:ComponentDefine()
  self.btn_mask = self:AddComponent(UIButton, btn_mask_path)
  self.img_slider = self:AddComponent(UIImage, img_slider_path)
  self.txt_level = self:AddComponent(UIText, txt_level_path)
  self.txt_lastLevel = self:AddComponent(UIText, txt_lastLevel_path)
  self.txt_newLevel = self:AddComponent(UIText, txt_newLevel_path)
  self.go_content = self:AddComponent(UIBaseContainer, go_content_path)
  self.go_rewardItem = self:AddComponent(UIBaseContainer, go_rewardItem_path)
  self.sim_Content = self:AddComponent(UISimpleAnimation, sim_Content_path)
  self.go_ExtraBg = self:AddComponent(UIBaseContainer, go_ExtraBg_path)
  self.btn_mask:SetOnClick(BindCallback(self, self.ClickMask))
  self.go_reward = self.go_rewardItem.gameObject
  self.go_reward:GameObjectCreatePool()
end

function LWSeasonVirusResearchLevelUp:ComponentDestroy()
  self.btn_mask = nil
  self.img_slider = nil
  self.txt_level = nil
  self.txt_lastLevel = nil
  self.txt_newLevel = nil
  self.go_content = nil
  self.go_rewardItem = nil
  self.sim_Content = nil
  self.go_ExtraBg = nil
  self.go_reward:GameObjectRecycleAll()
  self.go_reward = nil
end

function LWSeasonVirusResearchLevelUp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonResearchLevelUpEcs, self.ClickMask)
end

function LWSeasonVirusResearchLevelUp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonResearchLevelUpEcs, self.ClickMask)
  base.OnRemoveListener(self)
end

function LWSeasonVirusResearchLevelUp:OnEnable()
  base.OnEnable(self)
  self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.parent ~= nil and self.parent.go_BgTop ~= nil then
      local origObj = self.parent.go_BgTop.transform
      local originPos = origObj.position
      local originLossyScale = origObj.lossyScale
      local parent = self.go_ExtraBg.transform
      local parentLossyScale = parent.lossyScale
      self.origObj = CS.UnityEngine.GameObject.Instantiate(origObj, parent)
      CS.UnityEngine.GameObject.Destroy(self.origObj.transform:GetChild(1).gameObject)
      self.origObj.position = originPos
      self.origObj.localScale = Vector3.New(originLossyScale.x / parentLossyScale.x, originLossyScale.y / parentLossyScale.y, originLossyScale.z / parentLossyScale.z)
    end
    self.animTimer = nil
  end, 0.35)
  self.sim_Content:Play("in")
end

function LWSeasonVirusResearchLevelUp:OnDisable()
  base.OnDisable(self)
  if self.animTimer ~= nil then
    self.animTimer:Stop()
    self.animTimer = nil
  end
  if self.origObj ~= nil then
    CS.UnityEngine.GameObject.DestroyImmediate(self.origObj.gameObject)
    self.origObj = nil
  end
end

function LWSeasonVirusResearchLevelUp:ClickMask()
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  local ok, time = self.sim_Content:PlayAnimationReturnTime("out")
  EventManager:GetInstance():Broadcast(EventId.SeasonResearchLevelUpClose)
  if ok then
    self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.closeTimer = nil
      self.ctrl:CloseSelf()
    end, time)
  else
    self.ctrl:CloseSelf()
  end
end

function LWSeasonVirusResearchLevelUp:RefreshView()
  local currentConfig = DataCenter.LWSpreadResearchDataManager:GetCurrentLevelConfig()
  local currentLevel = DataCenter.LWSpreadResearchDataManager:GetCurrentLevel()
  local maxLevel = DataCenter.LWSpreadResearchDataManager:GetMaxLevel()
  local isMax = DataCenter.LWSpreadResearchDataManager:IsMax()
  if isMax then
    self.img_slider:SetFillAmount(1)
  else
    self.img_slider:SetFillAmount(currentLevel / maxLevel)
  end
  self.txt_level:SetText(currentLevel)
  local lastConfig = DataCenter.LWSpreadResearchDataManager:GetLastLevelConfig()
  self.txt_lastLevel:SetText(tostring(lastConfig.resistance))
  self.txt_newLevel:SetText(tostring(currentConfig.resistance))
  self.go_reward:GameObjectRecycleAll()
  local rewardList = RewardUtil.GetRewardItem(lastConfig.level_up_reward)
  if rewardList then
    for i, paramInfo in ipairs(rewardList) do
      local levelName = "go_reward" .. i
      local goItem = self.go_reward:GameObjectSpawn(self.go_content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      local theItem = self.go_content:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(paramInfo)
    end
  end
end

return LWSeasonVirusResearchLevelUp
