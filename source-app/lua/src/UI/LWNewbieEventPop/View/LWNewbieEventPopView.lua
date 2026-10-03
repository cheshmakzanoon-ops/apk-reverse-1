local LWNewbieEventPopView = BaseClass("LWNewbieEventPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
  self:InitReward()
  DataCenter.LWSoundManager:PlaySound(62263, false)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bgBtn = self:AddComponent(UIButton, "bg")
  self.bgBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, "bg/LW_Btn_Close")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.goBtn = self:AddComponent(UIButton, "bg/LW_Btn_Common_New")
  self.goBtn:SetOnClick(function()
    self:GoButtonOnClick()
  end)
  self.descText = self:AddComponent(UIText, "bg/descText")
  self.nameText = self:AddComponent(UIText, "bg/bg_name/nameText")
  self.heroIcon = self:AddComponent(UIBaseContainer, "bg/bg_green/HeroIconMask/heroIcon")
  self.scroll = self:AddComponent(UIScrollRect, "bg/Scroll")
  self.content = self:AddComponent(UIBaseContainer, "bg/Scroll/Viewport/Content")
end

local function ComponentDestroy(self)
  self.bgBtn = nil
  self.closeBtn = nil
  self.goBtn = nil
  self.descText = nil
  self.nameText = nil
  self.heroIcon = nil
end

local function DataDefine(self)
  self.param = self:GetUserData()
  self.NameCount = 1
end

local function DataDestroy(self)
  self:SetAllCellDestroy()
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.param = nil
  self.NameCount = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitData(self)
  self.descText:SetLocalText(self.param.textKey)
  self:ReloadHeroSpine()
end

local function ReloadHeroSpine(self)
  if not self.param.headPath then
    return
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.param.headPath)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if self.lastSpinePath ~= spinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    self.lastSpinePath = spinePath
    local request = ResourceManager:InstantiateAsync(spinePath)
    if string.IsNullOrEmpty(spinePath) then
      return
    end
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      self:ResetSpineTransform(request.gameObject)
    end)
  elseif self.heroSpineLoadRequest then
    self:RResetSpineTransform(self.heroSpineLoadRequest.gameObject)
  end
end

local function ResetSpineTransform(self, obj)
  if not obj then
    return
  end
  local parent = self.heroIcon
  if not parent then
    obj:SetActive(false)
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(0.4, 0.4, 1)
    rectTransform:Set_anchoredPosition(0, 150, 0)
  end
end

local function GoButtonOnClick(self)
  self.param.func()
  self.ctrl:CloseSelf()
end

function LWNewbieEventPopView:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function LWNewbieEventPopView:InitReward()
  self:SetAllCellDestroy()
  local rewardStr = self.param.reward_show
  if string.IsNullOrEmpty(rewardStr) then
    self.scroll:SetActive(false)
    return
  end
  local rewardStrVec = string.split_ss_array(rewardStr, "|")
  local rewardList = {}
  table.walk(rewardStrVec, function(k, v)
    local str = v
    local item = DataCenter.RewardManager:ParseOneRewardStr(str)
    if item then
      table.insert(rewardList, item)
    end
  end)
  if 0 < #rewardList then
    self.scroll:SetActive(true)
    self:AddRewardToContainer(rewardList, self.content)
  else
    self.scroll:SetActive(false)
  end
end

function LWNewbieEventPopView:AddRewardToContainer(list, container)
  if list ~= nil and container then
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(1, 1, 1)
        local nameStr = tostring(self.NameCount)
        go.name = nameStr
        self.NameCount = self.NameCount + 1
        local cell = container:AddComponent(UICommonResItem, nameStr)
        cell:ReInit(list[i], self.view.ctrl.type)
      end)
    end
  end
end

LWNewbieEventPopView.OnCreate = OnCreate
LWNewbieEventPopView.OnDestroy = OnDestroy
LWNewbieEventPopView.OnEnable = OnEnable
LWNewbieEventPopView.OnDisable = OnDisable
LWNewbieEventPopView.ComponentDefine = ComponentDefine
LWNewbieEventPopView.ComponentDestroy = ComponentDestroy
LWNewbieEventPopView.DataDefine = DataDefine
LWNewbieEventPopView.DataDestroy = DataDestroy
LWNewbieEventPopView.OnAddListener = OnAddListener
LWNewbieEventPopView.OnRemoveListener = OnRemoveListener
LWNewbieEventPopView.InitData = InitData
LWNewbieEventPopView.GoButtonOnClick = GoButtonOnClick
LWNewbieEventPopView.ReloadHeroSpine = ReloadHeroSpine
LWNewbieEventPopView.ResetSpineTransform = ResetSpineTransform
return LWNewbieEventPopView
