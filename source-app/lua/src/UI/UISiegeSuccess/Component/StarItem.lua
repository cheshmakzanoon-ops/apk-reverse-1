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
  self.floatInsts = {}
end

function StarItem:ComponentDestroy()
  self.data = nil
  self.cityId = nil
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

function StarItem:Refresh(starData, cityId)
  self.data = starData
  self.cityId = cityId
  local meta = DataCenter.SiegeEventMetaManager:GetTemplate(self.data.eventId)
  self.meta = meta
  if not meta then
    Logger.LogError("\230\152\142\230\152\159\228\186\139\228\187\182\230\137\190\228\184\141\229\136\176,id=" .. (self.data.eventId or ""))
    return
  end
  self.title:SetLocalText(meta.name)
  self.name:SetText(starData.name)
  self.head:SetHeadAndFrame(starData.uid, starData.pic, starData.picVer, nil, starData.headSkinId, starData.headSkinET)
  self.likeNum:SetText(string.format("[%s]", starData.likeNum))
  self.rewardIcon:LoadSprite(RewardUtil.GetPic(self.meta.reward_show.type, self.meta.reward_show.id))
  local count = tonumber(self.meta.reward_show.count)
  self.rewardNum:SetText(string.GetFormattedStr(count))
end

function StarItem:OnClickReward()
  if not self.data.rewardComplete then
    self:ShowFloatLike()
    SFSNetwork.SendMessage(MsgDefines.WorldAllianceCityStarReward, self.cityId, self.data.uuid)
  else
    UIUtil.ShowTips(Localization:GetString("new_city_activity_battle_tips1064"))
  end
end

function StarItem:OnClickSelf()
  if not self.meta then
    return
  end
  UIUtil.ShowBubbleTips(Localization:GetString(self.meta.desc, self.meta.condition_para), self.title.transform.position, 0, -60, -20)
end

function StarItem:ShowFloatLike()
  self.data.rewardComplete = true
  self.likeNum:SetText(string.format("[%s]", self.data.likeNum + 1))
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
