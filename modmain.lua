local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
require "prefabutil"

local function CheckItems(inst)
      if not GLOBAL.TheWorld.ismastersim then
            return inst
      end
      inst:AddComponent("writeable")
      inst:DoTaskInTime(1, function(inst)
            local itemdata = inst.components.unwrappable.itemdata
            local text = ""
            if itemdata ~= nil then
                  for k,v in ipairs(itemdata) do
                        local item = GLOBAL.SpawnSaveRecord(v)
                        if item.nameoverride ~= nil then
                              text = text..(STRINGS.NAMES[string.upper(item.nameoverride)] or "What's that?'")
                        else
                              text = text..item.name
                        end
                        if item.components.perishable ~= nil then
                              text = text.." ("..math.floor(item.components.perishable:GetPercent()*100).."%)"
                        end
                        if item.components.finiteuses ~= nil then
                              text = text.." ("..math.floor(item.components.finiteuses:GetPercent()*100).."%)"
                        end
                        if item.components.stackable ~= nil then
                              text = text.." x"..item.components.stackable:StackSize()
                        end
                        if k < #itemdata then
                              text = text.."\n"
                        end
                        item:Remove()
                  end
                  inst.components.writeable:SetText(text)
            end
      end)
end

AddPrefabPostInit("bundle", CheckItems)