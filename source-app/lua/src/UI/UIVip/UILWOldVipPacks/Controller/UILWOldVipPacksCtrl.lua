local UILWOldVipPacksCtrl = BaseClass("UILWOldVipPacksCtrl", UIBaseCtrl)

function UILWOldVipPacksCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWOldVipPacks)
end

function UILWOldVipPacksCtrl:GetSortedPacks()
  local vipPacks = {}
  local vipPackStr = LuaEntry.DataConfig:TryGetStr("vip_old_gift_config", "k1")
  local count = 1
  local selfVipLevel = 0
  local vipData = DataCenter.VIPManager:GetVipData()
  if vipData then
    selfVipLevel = vipData.level
  end
  if not string.IsNullOrEmpty(vipPackStr) then
    local vipPackArr = string.split(vipPackStr, ";")
    for i, v in ipairs(vipPackArr) do
      local pack = string.split(v, "|")
      if 2 <= #pack then
        local packData = {}
        packData.vipLevel = tonumber(pack[1])
        packData.packId = tonumber(pack[2])
        packData.unlocked = selfVipLevel >= packData.vipLevel
        packData.bought = true
        if packData.unlocked then
          packData.bought = GiftPackageData.hasBought(tostring(packData.packId))
        else
          packData.bought = false
        end
        vipPacks[count] = packData
        count = count + 1
      end
    end
  end
  if 1 < count then
    table.sort(vipPacks, function(a, b)
      if a.bought == b.bought then
        if a.unlocked == b.unlocked then
          if a.vipLevel == b.vipLevel then
            if a.packId ~= b.packId then
              return a.packId < b.packId
            end
          else
            return a.vipLevel > b.vipLevel
          end
        elseif a.unlocked then
          return true
        else
          return false
        end
      else
        return not a.bought
      end
      return false
    end)
  end
  return vipPacks
end

return UILWOldVipPacksCtrl
