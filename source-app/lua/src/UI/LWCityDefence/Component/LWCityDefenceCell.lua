local LWCityDefenceCell = BaseClass("LWCityDefenceCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local order_text_path = "TopBg2/Order"
local name_text_path = "TopBg2/NameObj/Name"
local state_icon_path = "TopBg2/NameObj/State"
local up_btn_path = "TopBg2/UpBtn"
local down_btn_path = "TopBg2/DownBtn"
local power_txt_path = "Middle/PowerText"
local join_def_btn_path = "Middle/JoinDefBtn"
local join_def_txt_path = "Middle/JoinDefBtn/JoinDefBtnText"
local join_def_mark_path = "Middle/JoinDefBtn/mark"
local content_path = "ScrollView/Viewport/HeroContent"

function LWCityDefenceCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWCityDefenceCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWCityDefenceCell:OnEnable()
  base.OnEnable(self)
end

function LWCityDefenceCell:OnDisable()
  base.OnDisable(self)
end

function LWCityDefenceCell:ComponentDefine()
  self.order_text = self:AddComponent(UIText, order_text_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.state_icon = self:AddComponent(UIImage, state_icon_path)
  self.up_btn = self:AddComponent(UIButton, up_btn_path)
  self.down_btn = self:AddComponent(UIButton, down_btn_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.join_def_btn = self:AddComponent(UIButton, join_def_btn_path)
  self.join_def_txt = self:AddComponent(UIText, join_def_txt_path)
  self.join_def_mark = self:AddComponent(UIBaseContainer, join_def_mark_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.join_def_txt:SetLocalText(457568)
  self.heroCells = {}
  self.join_def_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.info then
      if self.info.defencePriority > 0 then
        SFSNetwork.SendMessage(MsgDefines.ModifyDefenceFormation, self.info.uuid, 0)
      else
        SFSNetwork.SendMessage(MsgDefines.ModifyDefenceFormation, self.info.uuid, 1)
      end
    end
  end)
  self.up_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    SFSNetwork.SendMessage(MsgDefines.ModifyDefenceFormation, self.info.uuid, 3)
  end)
  self.down_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    SFSNetwork.SendMessage(MsgDefines.ModifyDefenceFormation, self.info.uuid, 2)
  end)
end

function LWCityDefenceCell:ComponentDestroy()
  self.content:RemoveComponents(UIHeroCell)
  self.heroCells = {}
end

function LWCityDefenceCell:DataDefine()
end

function LWCityDefenceCell:DataDestroy()
end

function LWCityDefenceCell:RefreshData(param)
  self.info = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(param.uuid)
  local state_img
  if self.info.state == 1 then
    local Player = LuaEntry.Player
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, param.uuid, Player.allianceId)
    state_img = MarchUtil.GetMarchStateIconByType(march)
  end
  if string.IsNullOrEmpty(state_img) then
    state_img = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_kongxian.png"
  end
  self.state_icon:LoadSprite(state_img)
  self.state_icon:SetNativeSize()
  local prefab = param.heroCell.gameObject
  if table.count(self.heroCells) > 0 then
    for k, v in pairs(self.heroCells) do
      prefab.GameObjectRecycle(v.gameObject)
    end
    self.content:RemoveComponents(UIHeroCell)
    self.heroCells = {}
  end
  local heroes = {}
  for k, v in pairs(self.info.heroes) do
    heroes[v] = k
  end
  local dominatorUuid = self.info:GetLocalDominatorUuid()
  if dominatorUuid and 0 < dominatorUuid then
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    if dominatorInfo then
      local item = prefab:GameObjectSpawn(self.content.transform)
      item.name = "item6"
      local obj = self.content:AddComponent(UIHeroCell, item.name)
      obj:SetActive(true)
      obj:InitWithConfigId(dominatorInfo.dominatorId, nil, nil, dominatorInfo:GetCurRankLv())
      self.heroCells[6] = obj
    end
  end
  for i = 1, 5 do
    local item = prefab:GameObjectSpawn(self.content.transform)
    item.name = "item" .. i
    local obj = self.content:AddComponent(UIHeroCell, item.name)
    obj:SetActive(true)
    obj:SetData(heroes[i])
    self.heroCells[i] = obj
  end
  self.power_txt:SetText(string.GetFormattedSeperatorNum(math.floor(self.info:GetParkingTotalCapacity())))
  local squadName = DataCenter.BuildManager:GetBuildingNameByUuid(self.info.buildingUuid)
  self.name_text:SetText(squadName)
  local isJoin = 0 < self.info.defencePriority
  self.up_btn:SetActive(isJoin)
  self.down_btn:SetActive(isJoin)
  self.join_def_mark:SetActive(isJoin)
end

function LWCityDefenceCell:RefreshPriority(order, maxOrder)
  self.order_text:SetText(order)
  local isJoin = self.info.defencePriority > 0
  self.up_btn:SetActive(isJoin)
  self.down_btn:SetActive(isJoin)
  self.join_def_mark:SetActive(isJoin)
  local canUp = 1 < order
  local canDown = order < maxOrder
  CS.UIGray.SetGray(self.up_btn.transform, not canUp, canUp)
  CS.UIGray.SetGray(self.down_btn.transform, not canDown, canDown)
end

return LWCityDefenceCell
