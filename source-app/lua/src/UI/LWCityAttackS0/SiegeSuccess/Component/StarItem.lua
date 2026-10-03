local StarItem = BaseClass("StarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")

function StarItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function StarItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function StarItem:ComponentDefine()
  self.canvasGroupComp = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.panelAnimator = self:AddComponent(UIAnimator, "")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClickSelf()
  end)
  self.title = self:AddComponent(UITextMeshProUGUIEx, "Title")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "Name")
  self.head = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.head:SetEnableClickShowInfo(true, true)
  self.reward = self:AddComponent(UIButton, "Reward")
  self.reward:SetSafeClickMode(true)
  self.reward:SetOnClick(function()
    self:OnClickReward()
  end)
  self.likeBtn = self:AddComponent(UIButton, "Like")
  self.likeBtn:SetSafeClickMode(true)
  self.likeBtn:SetOnClick(function()
    self:OnClickReward()
  end)
  self.rewardNum = self:AddComponent(UITextMeshProUGUIEx, "Reward/Num")
  self.rewardIcon = self:AddComponent(UIImage, "Reward/Icon")
  self.like = self:AddComponent(UIBaseComponent, "Like")
  self.zan = self:AddComponent(UIBaseComponent, "Like/zan")
  self.likeNum = self:AddComponent(UITextMeshProUGUIEx, "Like/likeNum")
  self.imgBg = self:AddComponent(UIImage, "bg")
  self.imgRankingBg = self:AddComponent(UIImage, "rankImage")
  self.textRanking = self:AddComponent(UITextMeshProUGUIEx, "rankImage/rankText")
  self.floatInsts = {}
end

function StarItem:ComponentDestroy()
  if self.delay ~= nil then
    self.delay:Stop()
    self.delay = nil
  end
  self.data = nil
  self.cityId = nil
  self.canvasGroupComp = nil
  if self.floatInsts then
    for _, floatInst in ipairs(self.floatInsts) do
      if not IsNull(floatInst) then
        CS.UnityEngine.GameObject.Destroy(floatInst)
      end
    end
    self.floatInsts = nil
  end
  self.meta = nil
end

function StarItem:Refresh(starData, cityId, index)
  self.panelAnimator:Enable(false)
  if self.canvasGroupComp ~= nil then
    self.canvasGroupComp.alpha = 0
  end
  self:PlayAnimator(index)
  self.data = starData
  self.cityId = cityId
  local level = GetTableData("lw_worldcity", self.cityId, "level")
  local meta = DataCenter.AttackCityS0ConfigManager:GetAttackCityThumbsUpReward(level)
  self.meta = meta
  if not meta then
    Logger.LogError("\230\159\165\230\137\190\228\184\141\229\136\176\229\175\185\229\186\148\231\173\137\231\186\167\229\159\142\229\184\130\229\165\150\229\138\177=" .. (self.cityId or "") .. "Level:" .. level)
    return
  end
  self.name:SetText(starData.roleInfo.name)
  self.head:SetHeadAndFrame(starData.roleInfo.uid, starData.roleInfo.pic, starData.roleInfo.picver)
  self.likeNum:SetText(string.format("[%s]", starData.thumbsUpCount))
  local groups = DataCenter.ChampionDuelManager:GetRewardsById(meta)
  if groups ~= nil and 1 <= #groups then
    self.rewardIcon:LoadSprite(RewardUtil.GetPic(groups[1].rewardType, groups[1].itemId))
    local count = tonumber(groups[1].count)
    self.rewardNum:SetText(string.GetFormattedStr(count))
  end
  local bgPath = "Assets/Main/Sprites/UI/UIAttackCityS0/UIAttackCityS0Main/lrb_csjs_jilu_0%s.png"
  self.imgBg:LoadSprite(string.format(bgPath, index))
  local rankPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang0%s.png"
  self.imgRankingBg:LoadSprite(string.format(rankPath, index))
  self.textRanking:SetText(index)
end

function StarItem:PlayAnimator(index)
  local time = 0
  if index == 1 then
    time = time + 0.1
  elseif index == 2 then
    time = time + 0.13
  elseif index == 3 then
    time = time + 0.15
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    if self.canvasGroupComp then
      self.canvasGroupComp.alpha = 1
      self.panelAnimator:Enable(true)
      self.panelAnimator:Play("V_ui_AttackCityS0_Success_StarItem_in", 0, 0)
    end
  end, time)
end

function StarItem:OnClickReward()
  if not self.data.isThumbsUp then
    if self.data.roleInfo.uid ~= LuaEntry.Player.uid then
      self:ShowFloatLike()
    end
    DataCenter.AttackCityS0DataManager:SendThumpsUpRewardMsg(self.cityId, self.data.roleInfo.uid)
  else
    UIUtil.ShowTipsId("new_city_activity_battle_tips1064")
  end
end

function StarItem:OnClickSelf()
  if not self.meta then
    return
  end
end

function StarItem:ShowFloatLike()
  self.data.rewardComplete = true
  self.likeNum:SetText(string.format("[%s]", self.data.thumbsUpCount + 1))
  local floatInst = CS.UnityEngine.GameObject.Instantiate(self.zan.gameObject, self.zan.transform.parent.parent)
  floatInst:SetActive(true)
  table.insert(self.floatInsts, floatInst)
  floatInst.transform.anchoredPosition = Vector2.New(-37.4, -113.1)
  floatInst.transform:DOAnchorPosY(0, 2)
  floatInst:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 2):OnComplete(function()
    CS.UnityEngine.GameObject.Destroy(floatInst)
  end)
end

return StarItem
