local ActLotteryDrawResultItem = BaseClass("ActLotteryDrawResultItem", UIBaseContainer)
local base = UIBaseContainer
local node_effect_root_1_path = "Root/NodeEffectRoot_1"
local cover_panel_path = "Root/CoverPanel"
local info_panel_path = "Root/InfoPanel"
local bg_path = "Root/InfoPanel/bg"
local normal_type_path = "Root/InfoPanel/normalType"
local normal_type_name_path = "Root/InfoPanel/normalType/normalTypeName"
local special_type_path = "Root/InfoPanel/specialType"
local special_type_name_path = "Root/InfoPanel/specialType/specialTypeName"
local reward_content_path = "Root/InfoPanel/rewardContent"
local special_type_num_path = "Root/InfoPanel/specialTypeNum"
local special_type_no_val_path = "Root/InfoPanel/specialType/specialTypeNoVal"
local item_path = "Root/Item"
local reward2_content_path = "Root/InfoPanel/reward2Content"
local item2_path = "Root/InfoPanel/reward2Content/item2Content/Item2"
local reward2_num_path = "Root/InfoPanel/reward2Content/reward2Num"
local effect1_path = "Root/Eff_UIHero100Recruit_goldcard_idolbg/effect1"
local effect2_path = "Root/UIHero100Recruit_goldcard_idol/effect2"
local effect1_res_path = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_UIHero100Recruit_goldcard_idolbg.prefab"
local effect2_res_path = "Assets/_Art_LastWar/Effect/Prefab/VX/UIHero100Recruit_goldcard_idol.prefab"
local eff_u_i_hero100_recruit_goldcard_idolbg_path = "Root/Eff_UIHero100Recruit_goldcard_idolbg"
local u_i_hero100_recruit_goldcard_idol_path = "Root/UIHero100Recruit_goldcard_idol"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearAllItem()
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
  self.rootAni = self:AddComponent(UIAnimator, "")
  self.rootAni:Enable(false)
  self.node_effect_root_1 = self:AddComponent(UIBaseContainer, node_effect_root_1_path)
  self.cover_panel = self:AddComponent(UIRawImage, cover_panel_path)
  self.info_panel = self:AddComponent(UIBaseContainer, info_panel_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.normal_type = self:AddComponent(UIBaseContainer, normal_type_path)
  self.normal_type_name = self:AddComponent(UITextMeshProUGUIEx, normal_type_name_path)
  self.special_type = self:AddComponent(UIBaseContainer, special_type_path)
  self.special_type_name = self:AddComponent(UITextMeshProUGUIEx, special_type_name_path)
  self.special_type_no_val = self:AddComponent(UITextMeshProUGUIEx, special_type_no_val_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.special_type_num = self:AddComponent(UITextMeshProUGUIEx, special_type_num_path)
  self.root = self:AddComponent(UIButton, "")
  self.root:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.item = self:AddComponent(UICanvasGroup, item_path)
  self.item:SetActive(false)
  self.item.gameObject:GameObjectCreatePool()
  self.itemList = {}
  self.reward2_content = self:AddComponent(UIBaseContainer, reward2_content_path)
  self.item2 = self:AddComponent(UICommonResItem, item2_path)
  self.reward2_num = self:AddComponent(UITextMeshProUGUIEx, reward2_num_path)
  self.effect1 = self:AddComponent(UIVfx, effect1_path, effect1_res_path, {
    lifeType = UIVfxLifeType.Stay
  })
  self.effect2 = self:AddComponent(UIVfx, effect2_path, effect2_res_path, {
    lifeType = UIVfxLifeType.Stay
  })
  self.eff_u_i_hero100_recruit_goldcard_idolbg = self:AddComponent(UICanvasGroup, eff_u_i_hero100_recruit_goldcard_idolbg_path)
  self.u_i_hero100_recruit_goldcard_idol = self:AddComponent(UICanvasGroup, u_i_hero100_recruit_goldcard_idol_path)
end

local function ComponentDestroy(self)
  self.node_effect_root_1 = nil
  self.cover_panel = nil
  self.info_panel = nil
  self.bg = nil
  self.normal_type = nil
  self.normal_type_name = nil
  self.special_type = nil
  self.special_type_name = nil
  self.special_type_no_val = nil
  self.reward_content = nil
  self.special_type_num = nil
  self.item = nil
  self.reward2_content = nil
  self.item2 = nil
  self.reward2_num = nil
  self.effect1 = nil
  self.effect2 = nil
  self.eff_u_i_hero100_recruit_goldcard_idolbg = nil
  self.u_i_hero100_recruit_goldcard_idol = nil
end

local function DataDefine(self)
  self.param = nil
  self.callBack = nil
end

local function DataDestroy(self)
  self.param = nil
  self.callBack = nil
end

local function SetData(self, index, param, callBack, isShowNum)
  self.index = index
  self.param = param
  self.callBack = callBack
  self.isShowNum = isShowNum
  local bgPath = self:GetBgImgPathByRank(param.rank)
  self.bg:LoadSprite(bgPath)
  local isNoVal = self:IsHaveNoValRank(param.rank)
  local isShowNormal = not isNoVal
  self.normal_type:SetActive(isShowNormal)
  self.special_type:SetActive(not isShowNormal)
  self.reward_content:SetActive(false)
  self.reward2_content:SetActive(not isShowNum)
  self.special_type_num:SetActive(isShowNum)
  if isNoVal then
    if isShowNum then
      self.special_type_no_val:SetLocalText("thxgiv_numberNo3")
    else
      self.special_type_no_val:SetLocalText("thxgiv_numberNo2", param.tickerNo)
    end
  end
  if isShowNum then
    self.special_type_num:SetText("x" .. param.num)
  end
  local name = DataCenter.ActLotteryDataManager:GetLotteryRankName(param.rank)
  self.normal_type_name:SetText(name)
  self.special_type_name:SetText(name)
  if param.rank == 1 and not isShowNum then
    self.effect1:SetActive(true)
    self.effect1:Replay()
    self.effect2:SetActive(true)
    self.effect2:Replay()
  else
    self.effect1:SetActive(false)
    self.effect2:SetActive(false)
  end
  self:RefreshCanGetRewardShowContent()
end

local function OnBtnClick(self)
  if self.callBack ~= nil then
    self.callBack()
  end
end

local function SetCoverView(self)
  self.rootAni:Enable(false)
  self.cover_panel:SetActive(true)
  self.info_panel:SetActive(false)
  self.eff_u_i_hero100_recruit_goldcard_idolbg:SetActive(false)
  self.u_i_hero100_recruit_goldcard_idol:SetActive(false)
end

local function SetNormalView(self)
  self.rootAni:Enable(false)
  self.cover_panel:SetActive(true)
  self.info_panel:SetActive(true)
  self.eff_u_i_hero100_recruit_goldcard_idolbg:SetActive(true)
  self.u_i_hero100_recruit_goldcard_idol:SetActive(true)
end

local function PlayOpenAni(self)
  self.rootAni:Enable(true)
  self.rootAni:Play("ActLotteryDrawRewardItemFanPai")
end

local function GetBgImgPathByRank(self, rank)
  local imgPath = "Assets/Main/TextureEx/ActLottery/lrb_ganenjiecaiquan_lan_s.png"
  if rank == 1 then
    imgPath = "Assets/Main/TextureEx/ActLottery/lrb_ganenjiecaiquan_cheng_s.png"
  elseif rank == 2 then
    imgPath = "Assets/Main/TextureEx/ActLottery/lrb_ganenjiecaiquan_zi_s.png"
  end
  return imgPath
end

local function IsHaveNoValRank(self, rank)
  if rank == 1 then
    return true
  end
  return false
end

local function RefreshCanGetRewardShowContent(self)
  self.showData = DataCenter.RewardManager:ReturnRewardParamForView(self.param.reward)
  local showData = self.showData
  if showData == nil then
    showData = {}
  end
  if 0 < #showData then
    local targetData = showData[1]
    local paramData = {
      rewardType = targetData.rewardType,
      itemId = targetData.itemId
    }
    local count = targetData.count
    self.item2:ReInit(paramData)
    self.reward2_num:SetText("x" .. count)
  end
end

local function ClearAllItem(self)
  self.reward_content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.reward_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

local function PlayShowAni(self)
  local aniNeedTime = 0.1
  local screenPos = PosConverse.UIWorldToScreenPos(self.transform.position)
  local isRepeatHeroChip = false
  return aniNeedTime, screenPos, isRepeatHeroChip
end

ActLotteryDrawResultItem.OnCreate = OnCreate
ActLotteryDrawResultItem.OnDestroy = OnDestroy
ActLotteryDrawResultItem.OnEnable = OnEnable
ActLotteryDrawResultItem.OnDisable = OnDisable
ActLotteryDrawResultItem.ComponentDefine = ComponentDefine
ActLotteryDrawResultItem.ComponentDestroy = ComponentDestroy
ActLotteryDrawResultItem.DataDefine = DataDefine
ActLotteryDrawResultItem.DataDestroy = DataDestroy
ActLotteryDrawResultItem.SetData = SetData
ActLotteryDrawResultItem.OnBtnClick = OnBtnClick
ActLotteryDrawResultItem.SetCoverView = SetCoverView
ActLotteryDrawResultItem.SetNormalView = SetNormalView
ActLotteryDrawResultItem.PlayOpenAni = PlayOpenAni
ActLotteryDrawResultItem.GetBgImgPathByRank = GetBgImgPathByRank
ActLotteryDrawResultItem.IsHaveNoValRank = IsHaveNoValRank
ActLotteryDrawResultItem.RefreshCanGetRewardShowContent = RefreshCanGetRewardShowContent
ActLotteryDrawResultItem.ClearAllItem = ClearAllItem
ActLotteryDrawResultItem.PlayShowAni = PlayShowAni
return ActLotteryDrawResultItem
