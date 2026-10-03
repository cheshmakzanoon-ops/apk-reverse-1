local UIHeroBountyTaskItem = require("UI.UIHeroBountyMain.Component.UIHeroBountyTaskItem")
local UIHeroBountyMainView = BaseClass("UIHeroBountyMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local txt_title_path = "safeArea/Panel/bg/top/Title_text"
local close_btn_path = "safeArea/BtnBack"
local content_path = "safeArea/Panel/ScrollView/Viewport/Content"
local info_btn_path = "safeArea/Panel/bg/top/Title_text/infoButton"
local refresh_btn_path = "safeArea/Panel/bg/top/refreshButton"
local refresh_btn_txt_path = "safeArea/Panel/bg/top/refreshButton/obj/Txt1"
local refresh_btn_num_path = "safeArea/Panel/bg/top/refreshButton/obj/txt2"
local extra_desc_path = "safeArea/policeObj/policeDes"
local extra_desc_intro_btn_path = "safeArea/policeObj/PoliceBtn"

local function OnCreate(self)
  base.OnCreate(self)
  SFSNetwork.SendMessage(MsgDefines.GetHeroBountyInfo)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(132201)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.refresh_btn:SetOnClick(function()
    self:OnRefreshClick()
  end)
  self.refresh_btn_txt = self:AddComponent(UIText, refresh_btn_txt_path)
  self.refresh_btn_txt:SetLocalText(110028)
  self.refresh_btn_num = self:AddComponent(UIText, refresh_btn_num_path)
  local k2 = LuaEntry.DataConfig:TryGetNum("hero_bounty", "k2")
  self.refresh_btn_num:SetText(math.floor(k2))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.extra_desc_text = self:AddComponent(UIText, extra_desc_path)
  self.extra_desc_intro_btn = self:AddComponent(UIButton, extra_desc_intro_btn_path)
  self.extra_desc_intro_btn:SetOnClick(function()
    self:OnDescInfoClick()
  end)
  self.showDatalist = {}
end

local function OnDestroy(self)
  self:ClearScroll()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
  local percent = Mathf.Round(effectValue) .. "%"
  self.extra_desc_text:SetText(percent)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnHeroBountyTaskRefresh, self.RefreshList)
  self:AddUIListener(EventId.OnHeroBountyOneTaskRefresh, self.RefreshList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnHeroBountyTaskRefresh, self.RefreshList)
  self:RemoveUIListener(EventId.OnHeroBountyOneTaskRefresh, self.RefreshList)
end

local function OnDescInfoClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.extra_desc_intro_btn.transform.position + Vector3.New(-2, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("162115")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 300
  param.pivot = 0.85
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function RefreshList(self, temp)
  self:ClearScroll()
  local showList = self.ctrl:GetTaskList()
  for k = 1, #showList do
    self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIHeroOfferRewardFirstCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local data = showList[k]
      self.taskList[data.index] = self.content:AddComponent(UIHeroBountyTaskItem, nameStr)
      self.taskList[data.index]:ReInit(data)
    end)
  end
end

local function ClearScroll(self)
  self.content:RemoveComponents(UIHeroBountyTaskItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.taskList = {}
end

local function OnInfoClick(self)
  UIUtil.ShowIntro(Localization:GetString(132200), "", Localization:GetString("132217"))
end

local function OnRefreshClick(self)
end

UIHeroBountyMainView.OnCreate = OnCreate
UIHeroBountyMainView.OnDestroy = OnDestroy
UIHeroBountyMainView.OnEnable = OnEnable
UIHeroBountyMainView.OnDisable = OnDisable
UIHeroBountyMainView.OnAddListener = OnAddListener
UIHeroBountyMainView.OnRemoveListener = OnRemoveListener
UIHeroBountyMainView.RefreshList = RefreshList
UIHeroBountyMainView.ClearScroll = ClearScroll
UIHeroBountyMainView.OnInfoClick = OnInfoClick
UIHeroBountyMainView.OnRefreshClick = OnRefreshClick
UIHeroBountyMainView.OnDescInfoClick = OnDescInfoClick
return UIHeroBountyMainView
