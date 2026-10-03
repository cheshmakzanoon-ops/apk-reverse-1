local base = UIBaseContainer
local UIActDsbDuelRewardSheetPersonalPtSelect = BaseClass("UIActDsbDuelRewardSheetPersonalPtSelect", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local IMG_UP_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png"
local IMG_DOWN_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png"
local UIActDsbDuelRewardSheetPersonalPtSelectItem = require("UI.BFDsbDuel.BFDsbDuelReward.Component.UIActDsbDuelRewardSheetPersonalPtSelectItem")

function UIActDsbDuelRewardSheetPersonalPtSelect:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActDsbDuelRewardSheetPersonalPtSelect:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActDsbDuelRewardSheetPersonalPtSelect:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgGroupArr = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnGroup = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnGroup:SetOnClick(function()
    self:OnBtnGroupClick()
  end)
  self.compGroupContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.group_cell = self.transform:Find("GroupCell").gameObject
  self.group_cell:GameObjectCreatePool()
end

function UIActDsbDuelRewardSheetPersonalPtSelect:ComponentDestroy()
  self:ClearGroupItem()
  self.viewSkin = nil
  self.imgGroupArr = nil
  self.textGroup = nil
  self.btnGroup = nil
  self.compGroupContent = nil
  self.group_cell = nil
end

function UIActDsbDuelRewardSheetPersonalPtSelect:DataDefine()
  self.groupShow = false
  self.groupCells = {}
end

function UIActDsbDuelRewardSheetPersonalPtSelect:DataDestroy()
  self.groupShow = nil
  self.group = nil
  self.groupCells = nil
end

function UIActDsbDuelRewardSheetPersonalPtSelect:OnAddListener()
  base.OnAddListener(self)
end

function UIActDsbDuelRewardSheetPersonalPtSelect:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActDsbDuelRewardSheetPersonalPtSelect:OnBtnGroupClick()
  self.groupShow = not self.groupShow
  self:RefreshGroupCell()
end

function UIActDsbDuelRewardSheetPersonalPtSelect:OnGroupItemClick(group)
  if self.group == group then
    return
  end
  self.group = group
  self.holder.curShowRankIndex = group
  self.groupShow = false
  self:RefreshTxt()
  self:RefreshGroupCell()
  self.holder:RefreshRewardList()
end

function UIActDsbDuelRewardSheetPersonalPtSelect:RefreshTxt()
  local groupChar = Localization:GetString("city_war_main_UI_09") .. self.group
  if self.group == BattlefieldDsbDuelUtils.GetMyAllianceRankInBattle() then
    groupChar = string.format("%s (%s)", groupChar, Localization:GetString("100354"))
  end
  self.textGroup:SetText(groupChar)
end

function UIActDsbDuelRewardSheetPersonalPtSelect:ClearGroupItem()
  self.compGroupContent:RemoveComponents(UIActDsbDuelRewardSheetPersonalPtSelectItem)
  self.group_cell:GameObjectRecycleAll()
  self.groupCells = {}
end

function UIActDsbDuelRewardSheetPersonalPtSelect:RefreshGroupCell()
  self.imgGroupArr:LoadSpriteAuto(self.groupShow and IMG_UP_PATH or IMG_DOWN_PATH)
  self.imgGroupArr:SetActive(true)
  self.compGroupContent:SetActive(self.groupShow)
  if not self.groupShow then
    return
  end
  local groupCount = BattlefieldDsbConst.BF_DSB_REWARD_RANK.Max
  local max = math.max(#self.groupCells, groupCount)
  for i = 1, max do
    local obj = self.groupCells[i]
    if i <= groupCount then
      if obj then
        obj:SetActive(true)
      else
        local item = self.group_cell:GameObjectSpawn(self.compGroupContent.transform)
        item.name = "item" .. i
        obj = self.compGroupContent:AddComponent(UIActDsbDuelRewardSheetPersonalPtSelectItem, item.name)
        table.insert(self.groupCells, obj)
      end
      local data = {
        text = Localization:GetString("city_war_main_UI_09") .. i,
        isSelect = self.group == i,
        groupIndex = i,
        callback = BindCallback(self, self.OnGroupItemClick)
      }
      obj:SetData(data)
    elseif obj then
      obj:SetActive(false)
    end
  end
end

function UIActDsbDuelRewardSheetPersonalPtSelect:SetData(curRank)
  self.group = curRank or BattlefieldDsbConst.BF_DSB_REWARD_RANK.Rank1
  self:RefreshTxt()
  self:RefreshGroupCell()
end

return UIActDsbDuelRewardSheetPersonalPtSelect
