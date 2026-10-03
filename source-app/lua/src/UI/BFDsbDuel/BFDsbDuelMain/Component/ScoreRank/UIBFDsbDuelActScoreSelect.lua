local base = UIBaseContainer
local UIBFDsbDuelActScoreSelect = BaseClass("UIBFDsbDuelActScoreSelect", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local IMG_UP_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png"
local IMG_DOWN_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png"
local UIBFDsbDuelActScoreSelectItem = require("UI.BFDsbDuel.BFDsbDuelMain.Component.ScoreRank.UIBFDsbDuelActScoreSelectItem")

function UIBFDsbDuelActScoreSelect:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActScoreSelect:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActScoreSelect:ComponentDefine()
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

function UIBFDsbDuelActScoreSelect:ComponentDestroy()
  self:ClearGroupItem()
  self.viewSkin = nil
  self.imgGroupArr = nil
  self.textGroup = nil
  self.btnGroup = nil
  self.compGroupContent = nil
  self.group_cell = nil
end

function UIBFDsbDuelActScoreSelect:DataDefine()
  self.groupShow = false
  self.group = BattlefieldDsbConst.BF_DSB_GROUP_TYPE.ALL
  self.myGroup = BattlefieldDsbDuelUtils.ActInfo:GetSelfGroup()
  self.groupCells = {}
end

function UIBFDsbDuelActScoreSelect:DataDestroy()
  self.groupShow = nil
  self.group = nil
  self.myGroup = nil
  self.groupCells = nil
end

function UIBFDsbDuelActScoreSelect:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActScoreSelect:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActScoreSelect:OnBtnGroupClick()
  self.groupShow = not self.groupShow
  self:RefreshGroupCell()
end

function UIBFDsbDuelActScoreSelect:OnGroupItemClick(group)
  if self.myGroup == nil then
    return
  end
  if self.group ~= group then
    BattlefieldDsbDuelUtils.ActInfo:SendActGroupListMsg(group)
  end
  self.group = group
  self.holder.curShowGroupIndex = group
  self.groupShow = false
  self:RefreshTxt()
  self:RefreshGroupCell()
end

function UIBFDsbDuelActScoreSelect:RefreshTxt()
  local groupChar = BattlefieldDsbDuelUtils.GetGroupLetter(self.group)
  self.textGroup:SetText(groupChar)
end

function UIBFDsbDuelActScoreSelect:ClearGroupItem()
  self.compGroupContent:RemoveComponents(UIBFDsbDuelActScoreSelectItem)
  self.group_cell:GameObjectRecycleAll()
  self.groupCells = {}
end

function UIBFDsbDuelActScoreSelect:RefreshGroupCell()
  self.imgGroupArr:LoadSpriteAuto(self.groupShow and IMG_UP_PATH or IMG_DOWN_PATH)
  self.imgGroupArr:SetActive(true)
  self.compGroupContent:SetActive(self.groupShow)
  if not self.groupShow then
    return
  end
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  local groupCount = 5
  if groupCount == 0 then
    self:ClearGroupItem()
    return
  end
  local max = math.max(#self.groupCells, groupCount)
  for i = 0, max - 1 do
    local obj = self.groupCells[i + 1]
    if i < groupCount then
      if obj then
        obj:SetActive(true)
      else
        local item = self.group_cell:GameObjectSpawn(self.compGroupContent.transform)
        item.name = "item" .. i
        obj = self.compGroupContent:AddComponent(UIBFDsbDuelActScoreSelectItem, item.name)
        table.insert(self.groupCells, obj)
      end
      local data = {
        text = BattlefieldDsbDuelUtils.GetGroupLetter(i),
        isSelect = self.group == i,
        groupIndex = i,
        lastIndex = max - 1,
        callback = BindCallback(self, self.OnGroupItemClick)
      }
      obj:SetData(data)
    elseif obj then
      obj:SetActive(false)
    end
  end
end

function UIBFDsbDuelActScoreSelect:SetData()
  self:RefreshTxt()
  self:RefreshGroupCell()
end

return UIBFDsbDuelActScoreSelect
