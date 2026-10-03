local UIItemCell = BaseClass("UIItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local icon_path = "UICommonResItem/clickBtn/ItemIcon"
local extra_text_path = "UICommonResItem/clickBtn/FlagGo/FlagText"
local extra_path = "UICommonResItem/clickBtn/FlagGo"
local item_quality_path = "UICommonResItem/clickBtn/ImgQuality"
local name_text_path = "layout/NameText"
local des_text_path = "layout/DesText"
local own_text_path = "layout/OwnText"
local buy_btn_path = "BuyBtn"
local buy_btn_name_path = "BuyBtn/BuyBtnLabel/BuyBtnName"
local buy_btn_count_path = "BuyBtn/BuyBtnLabel/BuyBtnValue"
local buy_btn_icon_path = "BuyBtn/BuyBtnLabel/BuyBtnValue/SpendIcon"
local use_btn_path = "UseBtn"
local use_btn_name_path = "UseBtn/UseBtnName"
local use_btn_lock_path = "UseBtn/Img_lock"
local use_btn_bg_path = "UseBtn/useBtnBg"
local more_btn_go_path = "MoreBtnGo"
local vfx_free_path = "UseBtn/VFX_Free"
local StateType = {Own = 1, Buy = 2}
local Param = DataClass("Param", ParamData)
local ParamData = {
  callBack,
  itemId,
  index,
  template,
  stateType,
  count,
  goldImage
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.extra_text = self:AddComponent(UIText, extra_text_path)
  self.extra = self:AddComponent(UIText, extra_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.own_text = self:AddComponent(UIText, own_text_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn_name = self:AddComponent(UIText, buy_btn_name_path)
  self.buy_btn_count = self:AddComponent(UIText, buy_btn_count_path)
  self.buy_btn_icon = self:AddComponent(UIImage, buy_btn_icon_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn_name = self:AddComponent(UIText, use_btn_name_path)
  self.use_btn_lock = self:AddComponent(UIImage, use_btn_lock_path)
  self.use_btn_bg = self:AddComponent(UIImage, use_btn_bg_path)
  self.anim = self:AddComponent(UISimpleAnimation, "UseBtn")
  self.more_btn_go = self:AddComponent(UIBaseContainer, more_btn_go_path)
  self.item_quality_img = self:AddComponent(UIImage, item_quality_path)
  self.vfx_free = self:AddComponent(UIBaseContainer, vfx_free_path)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyBtnClick()
  end)
  self.use_btn:SetOnClick(function()
    self:OnUseBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.extra_text = nil
  self.extra = nil
  self.name_text = nil
  self.des_text = nil
  self.own_text = nil
  self.buy_btn = nil
  self.buy_btn_name = nil
  self.buy_btn_count = nil
  self.buy_btn_icon = nil
  self.use_btn = nil
  self.use_btn_name = nil
  self.use_btn_lock = nil
  self.more_btn_go = nil
  self.item_quality_img = nil
end

local function DataDefine(self)
  self.param = {}
  self.callUse = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.vfx_free:SetActive(false)
  self.icon:SetSizeDelta(Vector2.New(100, 100))
  self.anim:Play("def", 0, 0)
  if param.template ~= nil then
    local nId = tonumber(param.template.id)
    self.extra:SetActive(false)
    if param.template.para1 ~= nil and param.template.para1 ~= "" then
      local para1 = param.template.para1
      local temp = string.split(para1, ";")
      if temp ~= nil and 1 < #temp then
        self.extra:SetActive(true)
        self.extra_text:SetText(temp[1] .. temp[2])
      end
    end
    if param.template.icon then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, param.template.icon))
    end
    if nId then
      self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(nId))
      self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(nId))
    end
    self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(param.template.color))
    self.use_btn_bg:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_5"))
    if param.stateType == StateType.Own then
      self.own_text:SetActive(true)
      self.own_text:SetLocalText(130128, param.count)
      self.buy_btn:SetActive(false)
      self.use_btn:SetActive(true)
      self.use_btn_name:SetLocalText(110046)
    elseif param.stateType == StateType.Buy then
      self.own_text:SetActive(false)
      self.buy_btn:SetActive(true)
      self.use_btn:SetActive(false)
      self.buy_btn_name:SetLocalText(110001)
      self.buy_btn_icon:LoadSprite(param.goldImage)
      self.buy_btn_count:SetText(string.GetFormattedSeperatorNum(param.template.price))
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buy_btn.rectTransform)
      self:RefreshColor(LuaEntry.Player.gold)
    end
  elseif param.itemId == "GolloesFreeTime" then
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, "gollo_speedup"))
    self.name_text:SetLocalText(320263)
    self.des_text:SetLocalText(320264)
    self.item_quality_img:LoadSprite("Assets/Main/Sprites/ItemIcons/Common_img_quality_blue")
    self.own_text:SetActive(true)
    if 0 < param.count then
      self.own_text:SetText(Localization:GetString("100238") .. UITimeManager:GetInstance():MilliSecondToFmtString(param.count))
      self.use_btn_name:SetLocalText(110046)
    else
      self.use_btn_name:SetLocalText(110003)
      self.own_text:SetLocalText(140042)
    end
    self.buy_btn:SetActive(false)
    self.use_btn:SetActive(true)
    self.extra:SetActive(false)
  elseif param.itemId == "Speedup_FederalCop" or param.itemId == "Speedup_Consigliere" or param.itemId == "Speedup_kongzhitai" then
    self.name_text:SetLocalText(110193)
    local freeTime = LuaEntry.Effect:GetGameEffect(self.view.speedType == ItemSpdMenu.ItemSpdMenu_City and EffectDefine.BUILD_TIME_REDUCE or EffectDefine.RESEARCH_TIME_REDUCE)
    local name = ""
    local queue
    if self.view.speedType == ItemSpdMenu.ItemSpdMenu_City then
      queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(self.view.uuid, self.view.speedType == ItemSpdMenu.ItemSpdMenu_City, self.view.speedType == ItemSpdMenu.ItemSpdMenu_Science)
    elseif self.view.speedType == ItemSpdMenu.ItemSpdMenu_Science then
      local queueInfo = DataCenter.QueueDataManager:GetQueueByUuid(self.view.uuid)
      queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(queueInfo.funcUuid, false, true)
    end
    if queue then
      name = Localization:GetString(GetTableData(TableName.Robot, queue.robotId, "name"))
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, "Speedup_robot_" .. queue.robotId))
    end
    self.des_text:SetText(Localization:GetString("110194", name, UITimeManager:GetInstance():MilliSecondToFmtString(freeTime * SecToMilSec)))
    self.item_quality_img:LoadSprite("Assets/Main/Sprites/ItemIcons/Common_img_quality_purple")
    self.own_text:SetActive(false)
    self.buy_btn:SetActive(false)
    self.use_btn:SetActive(true)
    self.use_btn_name:SetLocalText(130126)
    self.extra:SetActive(false)
  end
  if param.itemId == "UseSpeedUp" then
    self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/item200.png")
    self.item_quality_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_daojukuang_2.png")
    self.name_text:SetLocalText(100834)
    self.des_text:SetLocalText(100835, UITimeManager:GetInstance():MilliSecondToFmtString(self.param.speedUpTime * 1000))
    self.use_btn_name:SetLocalText(100834)
    self.buy_btn:SetActive(false)
    self.use_btn:SetActive(true)
    self.own_text:SetActive(false)
    self.extra:SetActive(false)
    self.anim:Play("changeBtnSize", 0, 0)
    self.use_btn_bg:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_1"))
  elseif param.itemId == "UseSpeedUpBuy" then
    self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/item200.png")
    self.item_quality_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_daojukuang_2.png")
    self.name_text:SetLocalText(110013)
    self.des_text:SetLocalText(100837, UITimeManager:GetInstance():MilliSecondToFmtString(self.param.template.speedUpTime * 1000))
    self.buy_btn_name:SetLocalText(110001)
    self.buy_btn:SetActive(true)
    self.use_btn:SetActive(false)
    self.own_text:SetActive(false)
    self.extra:SetActive(false)
    if LuaEntry.Player.gold >= param.template.price then
      self.buy_btn_count:SetText(string.GetFormattedSeperatorNum(param.template.price))
    else
      self.buy_btn_count:SetText("<color=#E84242>" .. string.GetFormattedSeperatorNum(param.template.price) .. "</color>")
    end
    self.buy_btn_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png")
  end
  if param.itemId == "Speedup_FederalCop" or param.itemId == "Speedup_kongzhitai" or param.itemId == "Speedup_Consigliere" then
    self:RefreshState(param.isSignHeroFreeTIme)
  elseif param.itemId == "GolloesFreeTime" and 0 >= param.count then
    self.use_btn_lock:SetActive(false)
    self.use_btn_name:SetActive(true)
    self.use_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_3"))
  else
    self.use_btn_lock:SetActive(false)
    self.use_btn_name:SetActive(true)
    self.use_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_5"))
    self:RefreshState(param.isSignHeroFreeTIme)
  end
end

local function OnBuyBtnClick(self)
  if self.param.callBack ~= nil then
    local isBuy = true
    if self.view.isSignHeroFreeTIme and self.param.index ~= 1 then
      UIUtil.ShowMessage(Localization:GetString("110195"), 2, nil, nil, function()
        self.param.callBack(self.param.index, self.param.template, isBuy)
      end)
      return
    end
    self.param.callBack(self.param.index, self.param.template, isBuy)
  end
end

local function OnUseBtnClick(self)
  if self.param.callBack ~= nil then
    local isBuy = false
    if self.view.isSignHeroFreeTIme and self.param.index ~= 1 then
      UIUtil.ShowMessage(Localization:GetString("110195"), 2, nil, nil, function()
        self.param.callBack(self.param.index, self.param.template, isBuy)
      end)
      return
    elseif self.view.isHeroFreeTime and not self.view.isSignHeroFreeTIme and self.param.index == 1 then
      local freeTime = LuaEntry.Effect:GetGameEffect(self.param.itemId == "Speedup_FederalCop" and EffectDefine.RESEARCH_TIME_REDUCE or EffectDefine.BUILD_TIME_REDUCE)
      UIUtil.ShowTips(Localization:GetString("110196", UITimeManager:GetInstance():MilliSecondToFmtString(freeTime * SecToMilSec)))
      return
    elseif self.param.itemId == "GolloesFreeTime" and self.param.count <= 0 then
      if DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_GROCERY_STORE, WorldTileBtnType.GolloesCamp)
      else
        GoToUtil.GoToMonthCard()
      end
      return
    elseif self.param.itemId == "UseSpeedUp" then
      self.param.template = {
        id = self.param.itemId
      }
    end
    self.param.callBack(self.param.index, self.param.template, isBuy)
  end
end

local function RefreshOwnCount(self, count)
  if self.param then
    self.param.count = count
  end
  if self.own_text then
    self.own_text:SetLocalText(130128, count)
  end
end

local function RefreshColor(self, gold)
  if self.param and self.param.stateType == StateType.Buy then
    if gold < self.param.template.price then
      self.buy_btn_count:SetColor(RedColor)
    else
      self.buy_btn_count:SetColor(WhiteColor)
    end
  end
end

local function GetMoreBtnParent(self)
  return self.more_btn_go.transform
end

local function IsHeroFreeTimeCell(self)
  if self.param.itemId == "Speedup_FederalCop" or self.param.itemId == "Speedup_Consigliere" or self.param.itemId == "Speedup_kongzhitai" or self.param.stateType == StateType.Own then
    return true
  end
  return false
end

local function RefreshState(self, callUse)
  self.callUse = callUse
  if self.param.itemId == "Speedup_FederalCop" or self.param.itemId == "Speedup_Consigliere" or self.param.itemId == "Speedup_kongzhitai" then
    if callUse then
      self.use_btn_lock:SetActive(false)
      self.use_btn_name:SetActive(true)
      self.use_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_5"))
      self.vfx_free:SetActive(true)
    else
      self.use_btn_lock:SetActive(true)
      self.use_btn_name:SetActive(false)
      self.use_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_3"))
      self.vfx_free:SetActive(false)
    end
    UIGray.SetGray(self.use_btn.transform, false, true)
  elseif self.param.itemId == "GolloesFreeTime" then
    UIGray.SetGray(self.use_btn.transform, false, true)
  elseif self.param.itemId ~= "GolloesFreeTime" then
    UIGray.SetGray(self.use_btn.transform, callUse, not callUse)
  end
end

UIItemCell.OnCreate = OnCreate
UIItemCell.OnDestroy = OnDestroy
UIItemCell.Param = Param
UIItemCell.OnEnable = OnEnable
UIItemCell.OnDisable = OnDisable
UIItemCell.ComponentDefine = ComponentDefine
UIItemCell.ComponentDestroy = ComponentDestroy
UIItemCell.DataDefine = DataDefine
UIItemCell.DataDestroy = DataDestroy
UIItemCell.ReInit = ReInit
UIItemCell.StateType = StateType
UIItemCell.OnBuyBtnClick = OnBuyBtnClick
UIItemCell.OnUseBtnClick = OnUseBtnClick
UIItemCell.RefreshOwnCount = RefreshOwnCount
UIItemCell.RefreshColor = RefreshColor
UIItemCell.GetMoreBtnParent = GetMoreBtnParent
UIItemCell.IsHeroFreeTimeCell = IsHeroFreeTimeCell
UIItemCell.RefreshState = RefreshState
return UIItemCell
