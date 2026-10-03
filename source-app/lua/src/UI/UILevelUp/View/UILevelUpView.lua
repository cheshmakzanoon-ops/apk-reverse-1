local UILevelUp = BaseClass("UILevelUp", UIBaseView)
local base = UIBaseView
local UILevelUpItem = require("UI.UILevelUp.Component.UILevelUpItem")
local LevelManager = DataCenter.PlayerLevelManager
local this_path = ""
local title_path = "Title"
local level_path = "Title/Level"
local level_up_path = "Title/LevelUp"
local grats_path = "Title/Grats"
local panel_path = "Panel"
local tap_path = "Panel/Tap"
local list_path = "Panel/List"
local close_path = "Panel/Close"
local caidai_path = "Caidai"
local FlyDuration = 1.5
local ItemDelay = 0.8
local ItemInterval = 0.167

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
  self.active = true
  self:Refresh()
end

local function OnDisable(self)
  self.active = false
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.anim = self:AddComponent(UIAnimator, this_path)
  self.title_anim = self:AddComponent(UIAnimator, title_path)
  self.panel_anim = self:AddComponent(UIAnimator, panel_path)
  self.level_text = self:AddComponent(UIText, level_path)
  self.level_up_text = self:AddComponent(UIText, level_up_path)
  self.level_up_text:SetLocalText(100091)
  self.grats_text = self:AddComponent(UIText, grats_path)
  self.grats_text:SetLocalText(104201)
  self.list_go = self:AddComponent(UIBaseContainer, list_path)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self:MoveToEndPosAnim()
  end)
  self.tap_text = self:AddComponent(UIText, tap_path)
  self.tap_text:SetLocalText(129074)
  self.caidai_particle = self.transform:Find(caidai_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
end

local function ComponentDestroy(self)
  self.anim = nil
  self.title_anim = nil
  self.panel_anim = nil
  self.level_text = nil
  self.level_up_text = nil
  self.grats_text = nil
  self.list_go = nil
  self.close_btn = nil
  self.tap_text = nil
  self.caidai_particle = nil
end

local function DataDefine(self)
  self.active = false
  self.itemList = {}
end

local function DataDestroy(self)
  self.active = nil
  self.itemList = nil
end

local function AddItems(self, level, infos)
  self.itemList = {}
  for i, info in ipairs(infos) do
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UILevelUp/UILevelUpItem.prefab", function(request)
      if not self.active then
        return
      end
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.list_go.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = tostring(level .. "_" .. i)
      local item = self.list_go:AddComponent(UILevelUpItem, go.name)
      item:SetData(info)
      item:Show(false)
      table.insert(self.itemList, item)
      TimerManager:GetInstance():DelayInvoke(function()
        if self.active then
          item:Show(true)
        end
      end, i * ItemInterval + ItemDelay)
    end)
  end
end

local function ClearItems(self)
  self.list_go:RemoveComponents(UILevelUpItem)
  self.list_go:DestroyChildNode()
end

local function Refresh(self)
  local level = LevelManager:DequeueLevelUp()
  if level == nil then
    self.ctrl:CloseSelf()
    return
  end
  local orderParam = {
    buildOrder = 1,
    farmOrder = 3,
    factoryOrder = 4,
    effectOrder = 2,
    rewardOrder = 5
  }
  local infos = LevelManager:GetContentInfoList(level, orderParam)
  self:ClearItems()
  self:AddItems(level, infos)
  self.level_text:SetText(tostring(level))
  self.close_btn:SetActive(false)
  self.tap_text:SetActive(false)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.active then
      self.close_btn:SetActive(true)
      self.tap_text:SetActive(true)
    end
  end, (#infos + 1) * ItemInterval + ItemDelay)
  self.title_anim:Play("V_ui_levelup_grats_xiaoshi", 0, 0)
  self.panel_anim:Play("V_ui_uilevelup_line", 0, 0)
  self.caidai_particle:Play()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
end

local function MoveToEndPosAnim(self)
  self.close_btn:SetActive(false)
  local needMove = false
  for _, item in pairs(self.itemList) do
    if item.data.type == LevelManager.ContentInfoType.Build or item.data.type == LevelManager.ContentInfoType.Effect and item.data.effect.key == EffectDefine.ADD_FIELD_NUM then
      item:ShowIconOnly()
      local targetPos = UIUtil.GetUIMainSavePos(UIMainSavePosType.FastBuild)
      local targetScale = 0.275
      local flyDir = Vector3.Normalize(targetPos - item.transform.position)
      local uiMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
      if uiMain == nil then
        return
      end
      local fastBuild = uiMain.View.bottom.fast_build_obj
      fastBuild:ShowUnlock(item.data.icon)
      fastBuild:SetActive(true)
      DOTween.Sequence():Append(item.transform:DOMove(item.transform.position - flyDir * 20, 0.4)):Append(item.transform:DOMove(targetPos + Vector3.New(2, 15, 0), 0.6)):Join(item.transform:DOScale(Vector3.New(targetScale, targetScale, 1), 0.6)):Join(fastBuild.root_go.transform:DOMove(targetPos, 0.3)):AppendCallback(function()
        fastBuild.glow_go:SetActive(true)
        item:Show(false)
      end):AppendInterval(0.5):Append(fastBuild.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 0.3)):AppendCallback(function()
        fastBuild.glow_go:SetActive(false)
        fastBuild:Refresh()
        EventManager:GetInstance():Broadcast(EventId.UnlockBuilding)
        if callback then
          callback()
        end
      end)
      needMove = true
    else
      item:Show(false)
    end
  end
  if needMove then
    self.title_anim:Play("V_ui_levelup_grats_fade", 0, 0)
    self.panel_anim:Play("V_ui_uilevelup_fade", 0, 0)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.active then
        self:Refresh()
      end
    end, FlyDuration)
  else
    self:Refresh()
  end
end

UILevelUp.OnCreate = OnCreate
UILevelUp.OnDestroy = OnDestroy
UILevelUp.OnEnable = OnEnable
UILevelUp.OnDisable = OnDisable
UILevelUp.ComponentDefine = ComponentDefine
UILevelUp.ComponentDestroy = ComponentDestroy
UILevelUp.DataDefine = DataDefine
UILevelUp.DataDestroy = DataDestroy
UILevelUp.AddItems = AddItems
UILevelUp.ClearItems = ClearItems
UILevelUp.Refresh = Refresh
UILevelUp.MoveToEndPosAnim = MoveToEndPosAnim
return UILevelUp
