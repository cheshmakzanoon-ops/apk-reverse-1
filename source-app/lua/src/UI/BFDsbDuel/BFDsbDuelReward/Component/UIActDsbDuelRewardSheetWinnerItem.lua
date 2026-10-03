local UIActDsbDuelRewardSheetWinnerItem = BaseClass("UIActDsbDuelRewardSheetWinnerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.scrollRectScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 1)
  self.imgImtTitleLeft = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textRankText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.scrollRectScrollView = nil
  self.imgImtTitleLeft = nil
  self.textRankText2 = nil
  self.compContent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActDsbDuelRewardSheetWinnerItem:SetAllRewardsDestroy()
  self.compContent:RemoveComponents(UICommonResItem)
  if self.rewardModels ~= nil then
    for _, v in pairs(self.rewardModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModels = {}
  self.rewardItemsList = {}
end

function UIActDsbDuelRewardSheetWinnerItem:GetKey(index)
  if index == BattlefieldDsbConst.GroupRewardType.G1 then
    return Localization:GetString("dsb_duel_interface_1046", 1)
  elseif index == BattlefieldDsbConst.GroupRewardType.G2 then
    return Localization:GetString("dsb_duel_interface_1046", 2)
  elseif index == BattlefieldDsbConst.GroupRewardType.G3 then
    return Localization:GetString("dsb_duel_interface_1046", 3)
  elseif index == BattlefieldDsbConst.GroupRewardType.G4 then
    return Localization:GetString("dsb_duel_interface_1046", 4)
  end
end

function UIActDsbDuelRewardSheetWinnerItem:GetBg(index)
  if index == BattlefieldDsbConst.GroupRewardType.G1 then
    return "Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_1.png"
  elseif index == BattlefieldDsbConst.GroupRewardType.G2 then
    return "Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_2.png"
  elseif index == BattlefieldDsbConst.GroupRewardType.G3 then
    return "Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_3.png"
  elseif index == BattlefieldDsbConst.GroupRewardType.G4 then
    return "Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_4.png"
  end
end

function UIActDsbDuelRewardSheetWinnerItem:ReInit(index, data)
  self:SetAllRewardsDestroy()
  local list = DataCenter.ActMeteoriteBattleManager:GetRewardsById(data.rewardId)
  self.rewardModelCount = 0
  local key = self:GetKey(index)
  local bg = self:GetBg(index)
  self.textRankText2:SetText(key)
  self.imgImtTitleLeft:LoadSpriteAuto(bg)
  for i, v in ipairs(list) do
    self.rewardModelCount = self.rewardModelCount + 1
    self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compContent.transform)
      go.transform.localScale = Vector3.New(1, 1, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.compContent:AddComponent(UICommonResItem, nameStr)
      cell:ReInit(list[i])
      cell:SetSizeDelta(Vector2.New(150, 150))
      table.insert(self.rewardItemsList, cell)
    end)
  end
end

UIActDsbDuelRewardSheetWinnerItem.OnCreate = OnCreate
UIActDsbDuelRewardSheetWinnerItem.OnDestroy = OnDestroy
UIActDsbDuelRewardSheetWinnerItem.OnEnable = OnEnable
UIActDsbDuelRewardSheetWinnerItem.OnDisable = OnDisable
UIActDsbDuelRewardSheetWinnerItem.ComponentDefine = ComponentDefine
UIActDsbDuelRewardSheetWinnerItem.ComponentDestroy = ComponentDestroy
UIActDsbDuelRewardSheetWinnerItem.DataDefine = DataDefine
UIActDsbDuelRewardSheetWinnerItem.DataDestroy = DataDestroy
UIActDsbDuelRewardSheetWinnerItem.OnAddListener = OnAddListener
UIActDsbDuelRewardSheetWinnerItem.OnRemoveListener = OnRemoveListener
return UIActDsbDuelRewardSheetWinnerItem
