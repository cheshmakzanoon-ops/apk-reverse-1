local base = UIBaseContainer
local LWUIPlayerPackageRewardChangeDetailItemComponent = BaseClass("LWUIPlayerPackageRewardChangeDetailItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LWUIPlayerPackageRewardChangeRewardItemComponent = require("UI/LWUIPlayerLevelPackageRewardChange/Component/LWUIPlayerPackageRewardChangeRewardItemComponent")

function LWUIPlayerPackageRewardChangeDetailItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIPlayerPackageRewardChangeDetailItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIPlayerPackageRewardChangeDetailItemComponent:ComponentDefine()
  self.textTip = self:AddComponent(UITextMeshProUGUIEx, "Tip/TipText")
  self.textTip2 = self:AddComponent(UITextMeshProUGUIEx, "Tip/TipText2")
  self.compReward = self:AddComponent(UIBaseContainer, "Reward")
  self.animator = self:AddComponent(UIAnimator, "")
  self.textBoxText02 = self:AddComponent(UITextMeshProUGUIEx, "BoxContent/Second/BoxText02")
  self.textNew = self:AddComponent(UITextMeshProUGUIEx, "new/icon/NewText")
  self.compUICommonResItem02 = self:AddComponent(UICommonResItem, "BoxContent/First/BoxIcon02/UICommonResItem02")
  self.compLockedImage = self:AddComponent(UIBaseComponent, "BoxContent/First/arrow/LockedImage")
  self.compNew = self:AddComponent(UIBaseComponent, "new")
  self.imgSeason = self:AddComponent(UIImage, "Title/Layout/SeasonImg")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Title/Layout/TitleText")
  self.compCoverBase = self:AddComponent(UIBaseComponent, "CoverBase")
  self.textNew:SetText("NEW")
end

function LWUIPlayerPackageRewardChangeDetailItemComponent:ComponentDestroy()
  self.textTip = nil
  self.textTip2 = nil
  self.compReward = nil
  self.animator = nil
  self.textBoxText02 = nil
  self.textNew = nil
  self.compUICommonResItem02 = nil
  self.compLockedImage = nil
  self.compNew = nil
  self.imgSeason = nil
  self.textTitle = nil
  self.compCoverBase = nil
end

function LWUIPlayerPackageRewardChangeDetailItemComponent:DataDefine()
  self.template = nil
end

function LWUIPlayerPackageRewardChangeDetailItemComponent:DataDestroy()
  self.template = nil
end

function LWUIPlayerPackageRewardChangeDetailItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIPlayerPackageRewardChangeDetailItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIPlayerPackageRewardChangeDetailItemComponent:ReInit(template, callback, isNext, season, day)
  self.template = template
  self.callback = callback
  if self.template == nil then
    return
  end
  local preReward = self.template:GetPreReward()
  local curReward = self.template:GetCurReward()
  if preReward == nil or curReward == nil then
    return
  end
  self.compUICommonResItem02:ReInit(curReward)
  self.compUICommonResItem02:SetItemCountActive(false)
  self.compUICommonResItem02:SetImgQuailtyShow(false)
  self.textBoxText02:SetLocalText("gift_preview_desc5")
  self.compLockedImage:SetActive(isNext)
  self.compCoverBase:SetActive(isNext)
  self.compNew:SetActive(not isNext)
  if not isNext then
    self.textTip:SetLocalText("gift_preview_desc6")
  else
    self.textTip:SetLocalText("gift_preview_desc7")
  end
  self.textTip2:SetLocalText("gift_preview_desc8")
  self.rewardShowData = self.template:GetRewardShowData()
  if not table.IsNullOrEmpty(self.rewardShowData) then
    local totalCount = #self.rewardShowData
    for i, v in ipairs(self.rewardShowData) do
      self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIPlayerLevelPackageRewardChange/LWUIPlayerPackageRewardChangeRewardItem.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compReward.transform)
        local nameStr = tostring(i)
        go.name = nameStr
        local cell = self.compReward:AddComponent(LWUIPlayerPackageRewardChangeRewardItemComponent, nameStr)
        cell:ReInit(v, 0.3 + (i - 1) * 0.04)
        if i == totalCount and callback then
          callback()
        end
      end)
    end
  end
  local showSeason = season ~= nil and 0 < season
  self.imgSeason:SetActive(showSeason)
  if showSeason then
    local iconPath = string.format("Assets/Main/Sprites/UI/LWUIResource/cfm_tianxiadashi_S%s.png", season)
    self.imgSeason:LoadSprite(iconPath)
  end
  self.textTitle:SetLocalText("gift_preview_time2", tostring(day))
end

return LWUIPlayerPackageRewardChangeDetailItemComponent
