local base = require("UI.Landlord.Reward.Component.LLRewardBaseItem")
local LLRewardTaskItem = BaseClass("LLRewardTaskItem", base)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLRewardTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRewardTaskItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRewardTaskItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compLock = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textLockTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compFinish = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.imgBgLight = self.viewSkin:AddComponent(self, UIImage, 6)
end

function LLRewardTaskItem:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.textName = nil
  self.compLock = nil
  self.textLockTip = nil
  self.compFinish = nil
  self.imgBgLight = nil
end

function LLRewardTaskItem:DataDefine()
  self.imgBgLight:SetActive(false)
end

function LLRewardTaskItem:DataDestroy()
  self:CleanFade()
  self.config = nil
end

function LLRewardTaskItem:OnAddListener()
  base.OnAddListener(self)
end

function LLRewardTaskItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRewardTaskItem:SetData(config, camp, curStage)
  self.config = config
  local para = config.para or {}
  local week = para[1] or 0
  local score = para[2] or 0
  local bLord = camp == LLConst.LandLordGroup.LORD
  local key = bLord and "zonewar_landlord_desc_1055" or "zonewar_landlord_desc_1054"
  self:RefreshIcons(config.reward)
  local state = ActMgr:CheckWeekRewardState(config, camp)
  self.compFinish:SetActive(state == 2)
  self.compLock:SetActive(state == 0)
  local curScore = ActMgr:GetDestroyScore()
  if bLord then
    local curWeek = ActMgr:GetCurWeek()
    local curMax = ActMgr:GetCityDestroyScoreMax(curWeek)
    curScore = curMax - curScore
  end
  curScore = math.min(curScore, score)
  local color = "#2A2830"
  if state == 0 then
    self.textLockTip:SetLocalText("zonewar_landlord_limit_1015", week + 1)
  elseif state == 1 then
    if curScore == score then
      color = "#099b4a"
    else
      color = "#f53c3d"
    end
  elseif state == 2 then
    color = "#099b4a"
  end
  self.textName:SetLocalText(key, "<color=" .. color .. ">" .. curScore, score .. "</color>")
end

function LLRewardTaskItem:CleanFade()
  if self.fadeTween then
    self.fadeTween:Kill()
  end
  self.fadeTween = nil
  if self.imgBgLight ~= nil then
    self.imgBgLight:SetActive(false)
  end
end

function LLRewardTaskItem:ShowHigh()
  self:CleanFade()
  self.imgBgLight:SetActive(true)
  self.imgBgLight:SetAlpha(1)
  local seq = DOTween.Sequence()
  self.fadeTween = seq
  local time = 0.5
  for i = 1, 3 do
    seq:Append(self.imgBgLight:DOFade(0, time))
    seq:Append(self.imgBgLight:DOFade(1, time))
  end
  
  function seq.onComplete()
    self.fadeTween = nil
    self.imgBgLight:SetActive(false)
  end
end

return LLRewardTaskItem
