local base = require("UI.KillZombieAlChallengeRank.Component.KillZombieAlChallengeRankContentBase")
local KillZombieAlChallengeRankContent = BaseClass("KillZombieAlChallengeRankContent", base)
local KillZombieAlChallengeRankItem = require("UI.KillZombieAlChallengeRank.Component.KillZombieAlChallengeRankItem")
local self_data_path = "SelfData"
local guarantee_des_path = "select/guaranteeDes"
local introduce_icon_path = "select/IntroduceIcon"
local tips_text_path = "TipsText"

function KillZombieAlChallengeRankContent:OnCreate()
  base.OnCreate(self)
end

function KillZombieAlChallengeRankContent:OnDestroy()
  base.OnDestroy(self)
end

function KillZombieAlChallengeRankContent:ComponentDefine()
  base.ComponentDefine(self)
  self.guarantee_des = self:AddComponent(UITextMeshProUGUIEx, guarantee_des_path)
  self.guarantee_des:SetLocalText("challenge_zombie_title_quality")
  self.introduce_icon = self:AddComponent(UIButton, introduce_icon_path)
  self.introduce_icon:SetOnClick(function()
    self:OnIntroduceIconClick()
  end)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.tips_text:SetLocalText("challenge_zombie_quality_3")
end

function KillZombieAlChallengeRankContent:ComponentDestroy()
  base.ComponentDestroy(self)
  self.guarantee_des = nil
  self.introduce_icon = nil
  self.tips_text = nil
end

function KillZombieAlChallengeRankContent:RefreshView(rankData, selfInfo)
  self.rankData = rankData
  self.selfInfo = selfInfo
  if self.self_data == nil then
    self.self_data = self:AddComponent(KillZombieAlChallengeRankItem, self_data_path)
  end
  if self.selfInfo ~= nil and #self.rankData ~= 0 then
    self.self_data:SetActive(true)
    self.self_data:SetItemShow(self.selfInfo)
  else
    self.self_data:SetActive(false)
  end
  if #self.rankData == 0 then
    self.showList:SetActive(false)
    self.empty_hint_text:SetActive(true)
  else
    self.showList:SetActive(true)
    self.empty_hint_text:SetActive(false)
    self.showList:SetListItemCount(#self.rankData, false, false)
    self.showList:RefreshAllShownItem()
  end
end

function KillZombieAlChallengeRankContent:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rankData then
    return nil
  end
  local ShowInfo = self.rankData[index]
  local scriptName = "UILWAlDmgRankItem"
  local item = loopScroll:NewListViewItem(scriptName)
  local script = self.showListContent:GetComponent(item.gameObject.name, KillZombieAlChallengeRankItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.showListContent:AddComponent(KillZombieAlChallengeRankItem, objectName)
  end
  script:SetActive(true)
  script:SetItemShow(ShowInfo)
  return item
end

function KillZombieAlChallengeRankContent:ClearScroll()
  self.showListContent:RemoveComponents(KillZombieAlChallengeRankItem)
  self.showList:ClearAllItems()
end

function KillZombieAlChallengeRankContent:OnIntroduceIconClick()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.Default)
  param.content = CS.GameEntry.Localization:GetString("challenge_zombie_quality_1")
  param.alignObject = self.introduce_icon
  param.yPosFix = 30
  param.showArrow = true
  param.preferTop = false
  param.width = 600
  param.addPosX = -15 * CommonUtil.ArabicAutoMirrorFactor()
  param.unEnableTouchThrough = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

return KillZombieAlChallengeRankContent
