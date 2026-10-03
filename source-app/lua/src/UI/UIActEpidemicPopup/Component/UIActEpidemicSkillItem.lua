local UIActEpidemicSkillItem = BaseClass("UIActEpidemicSkillItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local PREFAB = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicSkillDescDetailItem.prefab"
local CLS = "UI.UIActEpidemicPopup.Component.UIActEpidemicSkillDescDetailItem"

local function OnCreate(self)
  base.OnCreate(self)
  self.onClickedCallback = nil
  self.beforeClickedCallback = nil
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.onClickedCallback = nil
  self.beforeClickedCallback = nil
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
  self.imgBackground = self:AddComponent(UIImage, "Background")
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.btnUIActEpidemicSkillItem = self:AddComponent(UIButton, "")
  self.btnUIActEpidemicSkillItem:SetOnClick(function()
    self:OnBtnUIActEpidemicSkillItemClick()
  end)
end

local function ComponentDestroy(self)
  self.imgBackground = nil
  self.imgIcon = nil
  self.btnUIActEpidemicSkillItem = nil
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

local function OnBtnUIActEpidemicSkillItemClick(self)
  if self.beforeClickedCallback then
    self.beforeClickedCallback(self)
  end
  if self.onClickedCallback then
    self.onClickedCallback(self)
    return
  end
  if not self.skillData then
    local tips = Localization:GetString("YiBianJinQu_trivial_tips_2")
    UIUtil.ShowBubbleTips(tips, self.transform.position, 0, -30, 0)
    return
  else
    if self.skillData.iType == EpidemicZoneSkillType.GodOfWar then
      UIUtil.ShowBubbleTips(nil, self.transform.position, 0, -30, 0, nil, nil, {
        layoutShow = true,
        datalist = {
          Localization:GetString("YiBianJinQu_camp_desc_1")
        },
        prefab = PREFAB,
        cls = CLS
      })
      return
    end
    local descList = DataCenter.ActEpidemicZoneManager:GetSkillDesc(self.skillData, true)
    UIUtil.ShowBubbleTips(nil, self.transform.position, 0, -30, 0, nil, nil, {
      layoutShow = true,
      datalist = descList,
      prefab = PREFAB,
      cls = CLS
    })
  end
end

function UIActEpidemicSkillItem:Setup(skillID)
  self.skillID = skillID or -1
  self.skillData = DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(skillID)
  self:RefreshIcon()
end

function UIActEpidemicSkillItem:RefreshIcon()
  if not self.skillData then
    self.imgIcon:LoadSprite(string.format(LoadPath.LWCommonPath, "wxy_denglu_wenhao.png"))
  else
    self.imgIcon:LoadSprite(self.skillData.icon)
  end
end

UIActEpidemicSkillItem.OnCreate = OnCreate
UIActEpidemicSkillItem.OnDestroy = OnDestroy
UIActEpidemicSkillItem.OnEnable = OnEnable
UIActEpidemicSkillItem.OnDisable = OnDisable
UIActEpidemicSkillItem.ComponentDefine = ComponentDefine
UIActEpidemicSkillItem.ComponentDestroy = ComponentDestroy
UIActEpidemicSkillItem.DataDefine = DataDefine
UIActEpidemicSkillItem.DataDestroy = DataDestroy
UIActEpidemicSkillItem.OnAddListener = OnAddListener
UIActEpidemicSkillItem.OnRemoveListener = OnRemoveListener
UIActEpidemicSkillItem.OnBtnUIActEpidemicSkillItemClick = OnBtnUIActEpidemicSkillItemClick
return UIActEpidemicSkillItem
