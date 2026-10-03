local RechargeTemplate = BaseClass("RechargeTemplate")

function RechargeTemplate:__init()
  self.id = 0
  self.type = 0
  self.order = 0
  self.hot = 0
  self.name = ""
  self.image = ""
  self.image1 = ""
  self.icon = ""
  self.banner = ""
  self.icon_order = 0
  self.entry_type = 0
  self.para1 = ""
  self.para2 = ""
  self.unlock_lv = 0
  self.show_icon = 0
  self.onoff = 0
  self.login_open_forbid = ""
  self.banner_bg_new = ""
  self.banner_pic_new = {}
  self.banner_pic_init_size = {}
  self.bg_pic_init_size = {}
  self.board_color = 0
  self.column_type = 0
  self.resource_config1_list = {}
  self.resource_config2_list = {}
  self.bg_effect_name = ""
  self.for_effect_name = ""
  self.icon_ani = ""
  self.gift_show_list = ""
end

function RechargeTemplate:__delete()
  self.id = nil
  self.type = nil
  self.order = nil
  self.hot = nil
  self.name = nil
  self.image = nil
  self.image1 = nil
  self.icon = nil
  self.banner = nil
  self.icon_order = nil
  self.entry_type = nil
  self.para1 = nil
  self.para2 = nil
  self.unlock_lv = nil
  self.show_icon = nil
  self.onoff = nil
  self.login_open_forbid = nil
  self.banner_bg_new = nil
  self.banner_pic_new = nil
  self.banner_pic_init_size = nil
  self.bg_pic_init_size = nil
  self.board_color = nil
  self.column_type = nil
  self.resource_config1_list = nil
  self.resource_config2_list = nil
  self.bg_effect_name = nil
  self.for_effect_name = nil
  self.icon_ani = nil
  self.gift_show_list = nil
end

function RechargeTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.order = tonumber(row:getValue("order")) or 0
  self.hot = tonumber(row:getValue("hot")) or 0
  self.name = row:getValue("name") or ""
  self.image = row:getValue("image") or ""
  self.image1 = row:getValue("image1") or ""
  self.icon = row:getValue("icon") or ""
  self.banner = row:getValue("banner") or ""
  self.icon_order = tonumber(row:getValue("icon_order")) or 0
  self.entry_type = tonumber(row:getValue("entry_type")) or 0
  self.para1 = row:getValue("para1") or ""
  self.para2 = row:getValue("para2") or ""
  self.unlock_lv = tonumber(row:getValue("unlock_lv")) or 0
  self.show_icon = tonumber(row:getValue("show_icon")) or 0
  self.onoff = tonumber(row:getValue("onoff")) or 0
  self.login_open_forbid = row:getValue("login_open_forbid") or ""
  self.banner_bg_new = row:getValue("banner_bg_new") or ""
  self.banner_pic_new = row:getValue("banner_pic_new") or {}
  if CommonUtil.IsJapanABTest() then
    if not string.IsNullOrEmpty(row:getValue("image1_B")) then
      self.image1 = row:getValue("image1_B")
    end
    if not string.IsNullOrEmpty(row:getValue("icon_B")) then
      self.icon = row:getValue("icon_B")
    end
    if not string.IsNullOrEmpty(row:getValue("banner_B")) then
      self.banner = row:getValue("banner_B")
    end
    local banner_pic_new_B = row:getValue("banner_pic_new_B")
    if banner_pic_new_B ~= "" and not table.IsNullOrEmpty(banner_pic_new_B) then
      self.banner_pic_new = row:getValue("banner_pic_new_B")
    end
  end
  self.banner_pic_init_size = row:getValue("banner_pic_init_size") or {}
  self.bg_pic_init_size = row:getValue("bg_pic_init_size") or {}
  self.board_color = tonumber(row:getValue("board_color")) or 0
  self.column_type = tonumber(row:getValue("column_type")) or 0
  self.bg_effect_name = row:getValue("bg_effect_name") or ""
  self.for_effect_name = row:getValue("for_effect_name") or ""
  self.icon_ani = row:getValue("icon_ani") or ""
  local resource_config1 = row:getValue("resource_config1")
  if not string.IsNullOrEmpty(resource_config1) then
    self.resource_config1_list = string.split(resource_config1, "|")
  end
  local resource_config2 = row:getValue("resource_config2")
  if not string.IsNullOrEmpty(resource_config2) then
    self.resource_config2_list = string.string2array_num(resource_config2, ",", "|")
  end
  self.showTimes = row:getValue("showTimes")
  self.gift_show_list = row:getValue("gift_show_list") or ""
end

function RechargeTemplate:GetRechargeGiftShowIdByPackageId(packageId)
  if string.IsNullOrEmpty(self.gift_show_list) then
    return 0
  end
  local giftShowIds
  local giftShowListType = DataCenter.RechargeManager.GiftShowListType.Single
  local giftShowList = string.split(self.gift_show_list, ";")
  if #giftShowList == 2 then
    giftShowListType = tonumber(giftShowList[1])
    giftShowIds = string.split(giftShowList[2], "|")
  else
    giftShowIds = string.split(self.gift_show_list, "|")
  end
  if giftShowListType == DataCenter.RechargeManager.GiftShowListType.Single then
    if not table.IsNullOrEmpty(giftShowIds) then
      local packageIds = DataCenter.RechargeManager:GetSplitedPara1(self.id)
      local packageIdNum = table.count(packageIds)
      local giftShowIdNum = table.count(giftShowIds)
      if packageIdNum ~= giftShowIdNum then
        Logger.LogError("\231\164\188\229\140\133\229\160\134\229\143\160\228\188\152\229\140\150\233\156\128\230\177\130: recharge\232\161\168\233\133\141\231\189\174\233\148\153\232\175\175, id:" .. self.id .. ", gift_show_list\231\154\132id\228\184\170\230\149\176:" .. giftShowIdNum .. ", \228\184\142para1\229\136\151\233\133\141\231\154\132\230\137\128\230\156\137\231\164\188\229\140\133\231\154\132\228\184\170\230\149\176:" .. packageIdNum .. " \228\184\141\228\184\128\232\135\180")
      end
      local packageIdIndex = self:GetPackageIdIndex(packageId)
      if 0 < packageIdIndex and packageIdIndex <= #giftShowIds then
        return tonumber(giftShowIds[packageIdIndex])
      end
    else
      Logger.LogError("\231\164\188\229\140\133\229\160\134\229\143\160\228\188\152\229\140\150\233\156\128\230\177\130: recharge\232\161\168\233\133\141\231\189\174\233\148\153\232\175\175, id:" .. self.id .. ", giftShowIds\230\152\175\231\169\186\231\154\132")
    end
  elseif giftShowListType == DataCenter.RechargeManager.GiftShowListType.Multiple then
    local groupIdIndex = self:__getRechargeGiftShowTypeGroupIndex(packageId)
    if 0 < groupIdIndex and groupIdIndex <= #giftShowIds then
      return tonumber(giftShowIds[groupIdIndex])
    else
      Logger.LogError("\231\164\188\229\140\133\229\160\134\229\143\160\228\188\152\229\140\150\233\156\128\230\177\130: recharge\232\161\168\233\133\141\231\189\174\233\148\153\232\175\175, id:" .. self.id .. ", \233\156\128\232\166\129\230\152\190\231\164\186\231\154\132exchangeId:" .. packageId .. ", \230\137\128\229\177\158group\228\189\141\228\186\142para1\229\136\151\231\154\132\231\172\172\229\135\160\228\184\170:" .. groupIdIndex .. " \228\184\141\229\173\152\229\156\168\228\186\142gift_show_list\231\154\132\233\133\141\231\189\174\228\184\173")
    end
  end
  return 0
end

function RechargeTemplate:__getRechargeGiftShowTypeGroupIndex(packageId)
  local packageIds = DataCenter.RechargeManager:GetSplitedPara1(self.id)
  if not table.IsNullOrEmpty(packageIds) then
    local tmpDict = {}
    local tmpIndex = 1
    for _, _packageId in ipairs(packageIds) do
      local _giftPackTemplate = DataCenter.GiftPackTemplateManager:GetGiftPackInfo(_packageId)
      if _giftPackTemplate and tmpDict[_giftPackTemplate.group] == nil then
        tmpDict[_giftPackTemplate.group] = tmpIndex
        tmpIndex = tmpIndex + 1
      end
    end
    local giftPackTemplate = DataCenter.GiftPackTemplateManager:GetGiftPackInfo(packageId)
    if giftPackTemplate then
      if tmpDict[giftPackTemplate.group] ~= nil then
        local groupIndex = tmpDict[giftPackTemplate.group]
        return groupIndex
      else
        Logger.LogError("\231\164\188\229\140\133\229\160\134\229\143\160\228\188\152\229\140\150\233\156\128\230\177\130: recharge\232\161\168\233\133\141\231\189\174\233\148\153\232\175\175, id:" .. self.id .. ", \233\156\128\232\166\129\230\152\190\231\164\186\231\154\132exchangeId:" .. packageId .. ", \230\137\128\229\177\158group:" .. giftPackTemplate.group .. " \228\184\141\229\173\152\229\156\168\228\186\142para1\229\136\151\233\133\141\231\154\132\230\137\128\230\156\137\231\164\188\229\140\133\231\154\132\228\187\187\228\189\149\228\184\128\228\184\170group")
      end
    end
  end
  return 0
end

function RechargeTemplate:GetPackageIdIndex(packageId)
  local packageIds = DataCenter.RechargeManager:GetSplitedPara1(self.id)
  if not table.IsNullOrEmpty(packageIds) then
    for i, v in ipairs(packageIds) do
      if v == packageId then
        return i
      end
    end
  end
  return 0
end

return RechargeTemplate
