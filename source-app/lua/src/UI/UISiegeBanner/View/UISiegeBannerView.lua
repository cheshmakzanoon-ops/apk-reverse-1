local base = UIBaseView
local UISiegeBannerView = BaseClass("UISiegeBannerView", base)
local title_path = "title"
local subtitle_path = "subtitle"
local u_i_player_head_path = "UIPlayerHead"
local name_path = "name"
local flower_num_path = "flowerNum"
local flower_btn_path = "flowerBtn"
local flower_path = "flowerBtn/flower"

function UISiegeBannerView:OnCreate()
  base.OnCreate(self)
  self:AutoClose()
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UISiegeBannerView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISiegeBannerView:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.subtitle = self:AddComponent(UIText, subtitle_path)
  self.head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.name = self:AddComponent(UIText, name_path)
  self.flower_num = self:AddComponent(UIText, flower_num_path)
  self.flower_num:SetText("X" .. 0)
  self.flower = self:AddComponent(UIBaseComponent, flower_path)
  self.flower_btn = self:AddComponent(UIButton, flower_btn_path)
  self.flower_btn:SetOnClick(function()
    self:ClickFlower()
  end)
  self.floatInsts = {}
end

function UISiegeBannerView:ComponentDestroy()
  self.title = nil
  self.subtitle = nil
  self.head = nil
  self.name = nil
  self.flower_num = nil
  self.flower_btn = nil
  if self.floatInsts then
    for _, floatInst in ipairs(self.floatInsts) do
      if not IsNull(floatInst) then
        CS.UnityEngine.GameObject.Destroy(floatInst)
      end
    end
    self.floatInsts = nil
  end
  if self.autoCloseTimer then
    self.autoCloseTimer:Stop()
    self.autoCloseTimer = nil
  end
end

function UISiegeBannerView:DataDefine()
  self.data = self:GetUserData()
  self.time = 0
  self.likeNum = 0
end

function UISiegeBannerView:DataDestroy()
  self.data = nil
end

function UISiegeBannerView:OnAddListener()
  base.OnAddListener(self)
end

function UISiegeBannerView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISiegeBannerView:Refresh()
  if not self.data then
    return
  end
  local meta = DataCenter.SiegeEventMetaManager:GetTemplate(self.data.eventId)
  self.title:SetLocalText(meta.name)
  self.subtitle:SetLocalText(meta.desc, meta.condition_para)
  self.name:SetText(self.data.name)
  self.head:SetHeadAndFrame(self.data.uid, self.data.pic, self.data.picVer, nil, self.data.headSkinId, self.headSkinET)
end

function UISiegeBannerView:AutoClose()
  if self.autoCloseTimer then
    self.autoCloseTimer:Stop()
    self.autoCloseTimer = nil
  end
  self.autoCloseTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self and self.ctrl then
      self.ctrl:CloseSelf()
    end
  end, 5)
  TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.SiegeDataManager:ShowSiegeEvent()
  end, 6)
end

function UISiegeBannerView:Update100MS()
  local like = math.random() < 0.2
  if like then
    self.likeNum = self.likeNum + math.random(4)
    self:ShowFloatLike()
  end
end

function UISiegeBannerView:ClickFlower()
  if self.data then
    if self.data.isLiked then
      UIUtil.ShowTipsId(801142)
    else
      self.likeNum = self.likeNum + 1
      self:ShowFloatLike()
    end
    self.data.isLiked = true
  end
end

function UISiegeBannerView:ShowFloatLike()
  if not self.flower_num then
    return
  end
  self.flower_num:SetText("\195\151" .. self.likeNum)
  local floatInst = CS.UnityEngine.GameObject.Instantiate(self.flower.gameObject, self.flower.transform.parent)
  floatInst:SetActive(true)
  table.insert(self.floatInsts, floatInst)
  floatInst.transform.anchoredPosition = Vector2.New(0, 0)
  floatInst.transform:DOAnchorPosY(100, 2)
  floatInst:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 2):OnComplete(function()
    CS.UnityEngine.GameObject.Destroy(floatInst)
  end)
end

return UISiegeBannerView
